package ui.macros {
	
	import onyx.plugin.*;
	
	import ui.core.*;
	import ui.layer.*;

	/**
	 * 
	 */
	public final class SelectPage1 extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			var layer:UILayer = UIObject.selection as UILayer;
			layer.selectPage(1);
		}
		
		/**
		 * 
		 */
		override public function keyUp():void {
			
		}
	}
}