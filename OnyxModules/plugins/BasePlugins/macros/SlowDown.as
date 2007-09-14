package macros {
	
	import flash.utils.Dictionary;
	
	import onyx.constants.*;
	import onyx.display.IDisplay;
	import onyx.plugin.*;
	import onyx.display.Layer;

	public final class SlowDown extends Macro {
		
		private var hash:Dictionary;
		
		override public function keyDown():void {
			
			var display:IDisplay = AVAILABLE_DISPLAYS[0];
			
			hash = new Dictionary(true);
			
			for each (var layer:Layer in display.layers) {
				hash[layer]		= layer.framerate;
				layer.framerate = .5;
			}
		}
		
		override public function keyUp():void {
			
			var display:IDisplay = AVAILABLE_DISPLAYS[0];
			
			for each (var layer:Layer in display.layers) {
				layer.framerate = hash[layer] || 1;
				delete hash[layer];
			}
			hash = null;
		}
	}
}