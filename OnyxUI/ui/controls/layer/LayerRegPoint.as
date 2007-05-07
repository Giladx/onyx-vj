package ui.controls.layer {
	
	import onyx.controls.Control;
	import onyx.controls.ControlProxy;
	import onyx.events.ControlEvent;
	
	import ui.assets.AssetLayerRegPoint;
	import ui.controls.ButtonClear;
	import ui.controls.UIControl;
	import ui.controls.page.ControlPage;
	import flash.events.Event;
	import onyx.controls.ControlInt;
	import flash.display.DisplayObject;

	public final class LayerRegPoint extends UIControl {
		
		/**
		 * 	@private
		 */
		private static const OFFSET_X:int	= -4;

		/**
		 * 	@private
		 */
		private static const OFFSET_Y:int	= -4;
		
		/**
		 * 	
		 */
		public static const SCALE:Number	= .6;
		
		/**
		 * 
		 */
		public var controlX:ControlInt;
		
		/**
		 * 
		 */
		public var controlY:ControlInt;
		
		/**
		 * 	@constructor
		 */
		public function LayerRegPoint(control:ControlProxy, mask:DisplayObject):void {
			super(null, control);
			
			addChild(new AssetLayerRegPoint());
			
			// store controls
			controlX = control.controlX as ControlInt,
			controlY = control.controlY as ControlInt;
			
			// add listeners
			controlX.addEventListener(ControlEvent.CHANGE, _onControlXChange);
			controlY.addEventListener(ControlEvent.CHANGE, _onControlYChange);
			
			this.mask = mask;
		}
		
		/**
		 * 	@private
		 */
		private function _onControlXChange(event:ControlEvent):void {
			x = event.value * SCALE + OFFSET_X;
		}
		
		/**
		 * 	@private
		 */
		private function _onControlYChange(event:ControlEvent):void {
			y = event.value * SCALE + OFFSET_Y;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			super.dispose();
		}
	}
}