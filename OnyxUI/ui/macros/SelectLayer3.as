package ui.macros {
	
	import onyx.plugin.*;
	import ui.core.*;
	import ui.layer.*;

	/**
	 * 
	 */
	public final class SelectLayer3 extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			UILayer.selectLayer(3);
		}
		
		/**
		 * 
		 */
		override public function keyUp():void {
			
		}
	}
}