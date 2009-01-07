package filters {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.display.*;
	import onyx.plugin.*;

	public final class DisplacementMap extends Filter implements IBitmapFilter {
		
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
		public var seed:Number		= Math.random() * 100;
		
		/**
		 * 	@private
		 */
		private var _layer:IContent;
		
		/**
		 * 	@private
		 */
		private var _bmp:BitmapData;
		
		/**
		 * 
		 */
		public var scaleX:Number	= 2;
		public var scaleY:Number	= 2;
		
		/**
		 * 	@constructor
		 */
		public function DisplacementMap():void {

			super(false,
				new ControlLayer('layer', 'layer'),
				new ControlProxy('scale', 'scale',
					new ControlInt('scaleX', 'scaleX', 0, 1000, 1),
					new ControlInt('scaleX', 'scaleY', 0, 1000, 1)
				)
			);
			
			layer = null;
		}
		
		override public function initialize():void {
		}
		
		/**
		 * 
		 */
		public function set layer(value:IContent):void {
			_layer = value;
			
			if (value) {
				if (_bmp) {
					_bmp.dispose();
					_bmp = null;
				}
			} else {
				_bmp = BASE_BITMAP();
			}
		}
		
		/**
		 * 	@public
		 */
		public function get layer():IContent {
			return _layer;
		}
		
		/**
		 * 
		 */
		public function applyFilter(source:BitmapData):void {
			
			var filter:DisplacementMapFilter;
			
			if (_layer) {
				filter = new DisplacementMapFilter(_layer.source, POINT, 4, 4, scaleX, scaleY);
			} else {
				filter = new DisplacementMapFilter(_bmp, POINT, 2, 4, scaleX, scaleY);
			}
			
			source.applyFilter(
					source, 
					BITMAP_RECT, 
					POINT,
					filter
			);
			
		}
		
		override public function dispose():void {
			super.dispose();
		}
		
	}
}