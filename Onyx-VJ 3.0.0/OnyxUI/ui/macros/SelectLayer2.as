package ui.macros {
	
	import onyx.plugin.*;
	import ui.core.*;
	import ui.layer.*;

	/**
	 * 
	 */
	public final class SelectLayer2 extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			UILayer.selectLayer(2);
		}
		
		/**
		 * 
		 */
		override public function keyUp():void {
			
		}
	}
}