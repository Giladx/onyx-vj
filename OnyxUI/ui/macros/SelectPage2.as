package ui.macros {
	
	import onyx.plugin.*;
	
	import ui.core.*;
	import ui.layer.*;

	/**
	 * 
	 */
	public final class SelectPage2 extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			var layer:UILayer = UIObject.selection as UILayer;
			layer.selectPage(2);
		}
		
		/**
		 * 
		 */
		override public function keyUp():void {
			
		}
	}
}