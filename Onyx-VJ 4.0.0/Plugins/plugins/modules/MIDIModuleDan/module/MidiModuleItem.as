package module {
	
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.net.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;

	/**
	 * 
	 */
	public final class MidiModuleItem extends Module {
		
		/**
		 * 	@private
		 */
		private const controls:Dictionary	= UserInterface.getAllControls();
		
		/**
		 * 	@constructor
		 */		
		public function MidiModuleItem():void {

			// init			
			super(new ModuleInterfaceOptions(null, 140, 110));
			
			// add parameters
			parameters.addParameters(
				new ParameterExecuteFunction('highlight', 'highlight'),
				new ParameterExecuteFunction('highlight2', 'highlight2'),
				new ParameterExecuteFunction('paramsave', 'paramsave')
			);
			
		}
		
		/**
		 * 
		 */
		public function paramsave():void {
			for (var i:String in Parameters.getGlobalRegisteredParameters()) {
				trace(i);
			}
		}
		
		/**
		 * 	@public
		 */
		public function highlight():void {
			for (var i:Object in UserInterface.getAllControls()) {
				(i as UserInterfaceControl).addEventListener(MouseEvent.MOUSE_DOWN, handler);
			}
		}
		
		/**
		 * 	@private
		 */
		private function handler(event:MouseEvent):void {
			trace(event.currentTarget);
		}
		
		/**
		 * 
		 */
		override public function initialize():void {
			// trace('initialized');
		}
		
		/**
		 * 
		 */
		public function highlight2():void {
			for (var i:Object in UserInterface.getAllControls()) {
				(i as UserInterfaceControl).transform.colorTransform = new ColorTransform(2,2,2,1);
			}
		}
	}
}