package ui.macros {
	
	import onyx.plugin.*;
	import ui.core.*;
	import ui.layer.*;

	/**
	 * 
	 */
	public final class SelectLayer4 extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			UILayer.selectLayer(4);
		}
		
		/**
		 * 
		 */
		override public function keyUp():void {
			
		}
	}
}