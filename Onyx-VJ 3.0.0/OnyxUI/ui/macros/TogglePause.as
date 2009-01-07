package ui.macros {
	
	import onyx.display.ILayer;
	import onyx.plugin.Macro;
	
	import ui.core.*;
	import ui.layer.*;

	public final class TogglePause extends Macro {
		
		override public function keyDown():void {
			var layer:ILayer = (UIObject.selection as UILayer).layer;
			layer.pause(true);
		}
	}
}