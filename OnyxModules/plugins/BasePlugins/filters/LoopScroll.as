package filters {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.constants.POINT;
	import onyx.controls.Control;
	import onyx.controls.ControlInt;
	import onyx.controls.IControlObject;
	import onyx.plugin.*;
	import onyx.plugin.IBitmapFilter;
	import onyx.layer.LayerProperties;
	import onyx.controls.ControlOverride;

	public final class LoopScroll extends Filter implements IBitmapFilter {
		
		private var _x:int;
		private var xOverride:ControlOverride;
		
		public function LoopScroll():void {
			super(false);
		}
		
		/**
		 * 
		 */
		override public function initialize():void {
			var properties:LayerProperties	= content.properties as LayerProperties;
			var xControl:Control			= properties.getControl('x');
			
			// override the control target
			xOverride						= xControl.override(this, 0);
			_x = xOverride.value;
		}
		
		/**
		 * 
		 */
		public function set x(value:int):void {
			_x = value;
		}
		
		/**
		 * 
		 */
		public function get x():int {
			return 0;
		}
		
		public function applyFilter(source:BitmapData):void {
			
			var x:int = _x % BITMAP_WIDTH;
			
			if (x > 0) {
				
				var leftRect:BitmapData = new BitmapData(x, source.height - 0, true, 0x000000);
				leftRect.copyPixels(source, new Rectangle(source.width - x, 0, x, source.height), POINT);
				
				source.scroll(x, 0);
				source.copyPixels(leftRect, leftRect.rect, POINT);
				leftRect.dispose();
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			if (content) {
				var control:Control = content.properties.getControl('x');
				control.override(xOverride.target, xOverride.value);
			}
			xOverride = null;
		}
	}
}