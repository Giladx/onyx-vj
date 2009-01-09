package ui.core {
	
	import flash.display.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	
	import ui.controls.*;
	import ui.styles.*;
	
	public final class ModuleInterfaceAPI implements IModuleInterfaceAPI {
		
		public function createControl(param:Parameter, options:Object = null):DisplayObject {
			var controlClass:Class	= PARAM_MAP[param.reflect()];
			
			if (options) {
				var newoptions:UIOptions	= new UIOptions();
				for (var i:String in options) {
					if (newoptions.hasOwnProperty(i)) {
						newoptions[i] = options[i]
					}
				}
			}

			var control:UIControl		= new controlClass();
			control.initialize(param, newoptions || UI_OPTIONS);
			
			return control as DisplayObject;
		}
		
	}
}