package macros {
	
	import onyx.constants.*;
	import onyx.display.IDisplay;
	import onyx.display.ILayer;
	import onyx.plugin.Macro;

	public final class FrameRateIncrease extends Macro {
		
		override public function keyDown():void {
			
			var display:IDisplay = AVAILABLE_DISPLAYS[0];
			for each (var layer:ILayer in display.layers) {
				layer.framerate += .5;
			}
			
		}
	}
}