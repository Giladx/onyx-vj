package filters {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.plugin.*;
	import onyx.utils.math.*;

	public final class DisplacementMap extends Filter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var _filter:DisplacementMapFilter;
		
		/**
		 * 	@private
		 */
		private var _bmp:BitmapData;
		
		/**
		 * 
		 */
		private var pointA:Point	= new Point(1,1);
		
		/**
		 * 
		 */
		private var pointB:Point	= new Point(2,2);
		
		/**
		 * 
		 */
		private var pointArr:Array	= [pointA, pointB];
		
		/**
		 * 	Shows map
		 */
		public var showMap:String;
		
		/**
		 * 	SpeedX
		 */
		public var speedX:int		= 1;
		
		/**
		 * 	SpeedY
		 */
		public var speedY:int		= 1;
		
		/**
		 * 
		 */
		public var seed:Number		= random() * 100;
		
		/**
		 * 	@constructor
		 */
		public function DisplacementMap():void {

			_filter		= new DisplacementMapFilter(_bmp, POINT, 1|2|4, 4, 15.55, 2.55, 'wrap');
						
			super(false,
				new ControlInt('speedX', 'speedX', 0, 100, 1),
				new ControlInt('speedY', 'speedY', 0, 100, 1),
				new ControlRange('showMap', 'debug map', [null, 'all', 'red', 'green'])
			);
			
		}
		
		override public function initialize():void {
			_bmp		= BASE_BITMAP();
		}
		
		public function applyFilter(source:BitmapData):void {
			
			pointA.x += speedX;

			_bmp.perlinNoise(40, 40, 2, seed, false, true, 1|2|4|8, false, pointArr);
			
			switch (showMap) {
				case 'red':
					source.fillRect(BITMAP_RECT, 0xFF000000);
					source.copyChannel(_bmp, BITMAP_RECT, POINT, 1, 1);
					break;
				case 'green':
					source.fillRect(BITMAP_RECT, 0xFF000000);
					source.copyChannel(_bmp, BITMAP_RECT, POINT, 2, 2);
					break;
				case 'all':
					source.copyPixels(_bmp, BITMAP_RECT, POINT);
					break;
				default:
					source.applyFilter(source, BITMAP_RECT, POINT, _filter);
					break;
				
			}
		}
		
		override public function dispose():void {
			if (_bmp) {
				_bmp.dispose();
			}
			super.dispose();
		}
		
	}
}