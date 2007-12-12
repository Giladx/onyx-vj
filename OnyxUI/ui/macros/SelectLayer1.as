package ui.macros {
	
	import onyx.plugin.*;
	import ui.core.*;
	import ui.layer.*;

	/**
	 * 
	 */
	public final class SelectLayer1 extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			UILayer.selectLayer(1);
		}
		
		/**
		 * 
		 */
		override public function keyUp():void {
			
		}
	}
}