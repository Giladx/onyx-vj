package filters {
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.plugin.*;
	import onyx.utils.math.*;
	
	public final class SlitScan extends Filter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var _slices:Array;
		
		/**
		 * 	@private
		 */
		private var _numSlices:int;
		
		/**
		 * 	@private
		 */
		private var _transform:ColorTransform;
		
		/**
		 * 	@private
		 */
		private var _delay:int;
		
		/**
		 * 	@constructor
		 */
		public function SlitScan():void {
			
			_slices		= [],
			_transform	= new ColorTransform(),
			_delay		= 2,
			_numSlices	= 13;
			
			this.slices	= _numSlices;
			
			super(true, 
				new ControlInt('slices', 'slices', 2, 50, 12),
				new ControlNumber('alpha', 'alpha', 0, 1, 1),
				new ControlInt('delay', 'frame delay', 1, 15, 2)
			);
			
		}
		
		public function set delay(value:int):void {
			_delay = value
			this.slices = _numSlices;
		}
		
		public function get delay():int {
			return _delay;
		}
		
		public function set alpha(value:Number):void {
			_transform.alphaMultiplier = value;
		}
		
		public function get alpha():Number {
			return _transform.alphaMultiplier;
		}
		
		public function set slices(value:int):void {
			
			_disposeSlices();
			
			for (var count:int = 1; count < value; count++) {
				_slices.push(new SlitSlice(count * _delay));
			}
			
			_numSlices = value;
		}
		
		public function get slices():int {
			return _slices.length + 1;
		}
		
		public function applyFilter(source:BitmapData):void {
			
			var height:int, rect:Rectangle;
			
			rect		= BITMAP_RECT.clone();
			rect.height = height = ceil(rect.height / _numSlices);
			
			for (var count:int = 1; count < _numSlices; count++) {
				var slice:SlitSlice = _slices[count - 1];
				
				var bmp:BitmapData = new BitmapData(BITMAP_WIDTH, height, true, 0x00000000);
				rect.y	+= height;
				bmp.copyPixels(source, rect, POINT);
				
				var drawBmp:BitmapData = slice.add(bmp);
				
				if (drawBmp) {
					if (_transform.alphaMultiplier === 1) {
						source.copyPixels(drawBmp, drawBmp.rect, new Point(0, height * count));
					} else if (_transform.alphaMultiplier > 0) {
						var matrix:Matrix = new Matrix();
						matrix.translate(0, -height * count);
						source.draw(drawBmp, null, _transform, null, rect);
					}
				}
				
			}
		}
		
		/**
		 * 
		 */
		private function _disposeSlices():void {
			
			var slice:SlitSlice = _slices.shift() as SlitSlice;
			
			while (slice) {
				for each (var bmp:BitmapData in slice) {
					bmp.dispose();
				}
				slice = _slices.shift() as SlitSlice;
			}

		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			_disposeSlices();
		}
	}
}
	import flash.display.BitmapData;
	

dynamic class SlitSlice extends Array{
	
	public var max:int;
	public var currentIndex:int;
	
	public function SlitSlice(max:int):void {
		this.max = max;
		super();
	}
	
	public function add(bitmap:BitmapData):BitmapData {
		
		if (super.length === max) {
			var old:BitmapData = super.shift() as BitmapData;
			old.dispose();
		}
		
		super.push(bitmap);
		
		return (old) ? this[0] : null;
	}
}