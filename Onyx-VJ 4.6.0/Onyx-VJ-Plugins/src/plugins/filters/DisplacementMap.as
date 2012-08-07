package plugins.filters {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public final class DisplacementMap extends Filter implements IBitmapFilter {
		
		/**
		 * 
		 */
		private const pointA:Point		= new Point(1,1);
		
		/**
		 * 
		 */
		private const pointB:Point		= new Point(2,2);
		
		/**
		 * 
		 */
		private const pointArr:Array	= [pointA, pointB];
		
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
		private var _layer:Content;
		
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

			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterProxy('scale', 'scale',
					new ParameterInteger('scaleX', 'scaleX', 0, 1000, 1),
					new ParameterInteger('scaleX', 'scaleY', 0, 1000, 1)
				)
			);
			
			layer = null;
		}
		
		override public function initialize():void {
		}
		
		/**
		 * 
		 */
		public function set layer(value:Content):void {
			_layer = value;
			
			if (value) {
				if (_bmp) {
					_bmp.dispose();
					_bmp = null;
				}
			} else {
				_bmp = createDefaultBitmap();
			}
		}
		
		/**
		 * 	@public
		 */
		public function get layer():Content {
			return _layer;
		}
		
		/**
		 * 
		 */
		public function applyFilter(source:BitmapData):void {
			
			var filter:DisplacementMapFilter;
			
			if (_layer) {
				filter = new DisplacementMapFilter(_layer.source, ONYX_POINT_IDENTITY, 4, 4, scaleX, scaleY);
			} else {
				filter = new DisplacementMapFilter(_bmp, ONYX_POINT_IDENTITY, 2, 4, scaleX, scaleY);
			}
			
			source.applyFilter(
					source, 
					DISPLAY_RECT, 
					ONYX_POINT_IDENTITY,
					filter
			);
			
		}
		
		override public function dispose():void {
			super.dispose();
		}
		
	}
}