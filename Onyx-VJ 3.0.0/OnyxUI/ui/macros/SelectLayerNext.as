package ui.macros {
	
	import onyx.plugin.*;
	
	import ui.core.*;
	import ui.layer.*;

	/**
	 * 
	 */
	public final class SelectLayerNext extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			var layer:UILayer = UILayer.layers[layer.index - 1];
			if (layer) {
				UIObject.select(layer);
			}
		}
		
		/**
		 * 
		 */
		override public function keyUp():void {
			
		}
	}
}