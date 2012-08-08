package plugins.filters {
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import onyx.core.Console;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class VerticalSlices extends Filter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private const _slices:Array				= [];
		
		/**
		 * 	@private
		 */
		private var _numSlices:int				= 2;
		
		/**
		 * 	@private
		 */
		private var _transform:ColorTransform	= new ColorTransform();
		
		/**
		 * 	@private
		 */
		private var _delay:int					= 2;
		
		private var _mx:int = 0; 
		private var _my:int = -DISPLAY_HEIGHT; 
		
		/**
		 * 	@constructor
		 */
		public function VerticalSlices():void {
			Console.output("VerticalSlices v0.1");
			parameters.addParameters(
				new ParameterInteger('slices', 'slices', 2, 125, _numSlices),
				new ParameterNumber('alpha', 'alpha', 0, 1, 1),
				new ParameterInteger('delay', 'frame delay', 1, 15, 2),
				new ParameterInteger('mx', 'mx', -DISPLAY_WIDTH, DISPLAY_WIDTH * 2, _mx),
				new ParameterInteger('my', 'my', -DISPLAY_HEIGHT, DISPLAY_HEIGHT * 2, _my)
			);
			
			this.slices	= _numSlices;
			
		}
		
		public function get mx():int {
			return _mx;
		}
		
		public function set mx(value:int):void {
			_mx = value;
		}
		
		public function get my():int {
			return _my;
		}
		
		public function set my(value:int):void {
			_my = value;
		}
	
		public function set delay(value:int):void {
			_delay = value;
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
			
			for (var count:int = 1; count < value + 1; count++) {
				_slices.push(new SlitSlice(count * _delay));
			}
			
			_numSlices = value;
		}
		
		public function get slices():int {
			return _slices.length + 1;
		}
		
		public function applyFilter(source:BitmapData):void {
			
			var width:int, rect:Rectangle;
			
			rect		= DISPLAY_RECT.clone();
			rect.width = width = Math.ceil(rect.width / _numSlices);
			rect.x = mx;
			rect.y = my;
			
			for (var count:int = 0; count < _numSlices; count++) {
				var slice:SlitSlice = _slices[count];
				
				var bmp:BitmapData = new BitmapData(width, DISPLAY_HEIGHT, true, 0x00000000);
				bmp.copyPixels(source, rect, ONYX_POINT_IDENTITY);
				
				var drawBmp:BitmapData = slice.add(bmp);
				
				if (drawBmp) {
					if (_transform.alphaMultiplier === 1) {
						source.copyPixels(drawBmp, drawBmp.rect, new Point(width * count, 0));
					} else if (_transform.alphaMultiplier > 0) {
						var matrix:Matrix = new Matrix();
						matrix.translate(-width * count, 0);
						source.draw(drawBmp, null, _transform, null, rect);
					}
				}
				rect.x	+= width + mx;
				rect.y = my;
				
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


dynamic class SlitSlice extends Array {
	
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