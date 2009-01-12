package onyx.core {
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	public final class Onyx {
		
		/**
		 * 
		 */
		public static function initialize(stage:Stage, width:int, height:int, display:Class, adapter:IAssetAdapter):DisplayObject {
			
			// store stage
			DISPLAY_STAGE		= stage;
			
			// set width and height
			setDisplayDimensions(width, height);
			
			// create tempo
			Tempo				= new TempoImplementer();
			
			// create display
			Display				= new display();
			
			return Display as DisplayObject;
		}
		
		/**
		 * 
		 */
		public static function registerPlugin(registrations:Array, info:LoaderInfo = null):void {
			
			var registration:Object = registrations.shift();
			
			while (registration) {
				
				if (registration is Font) {
					
					var c:Class	= (info ? info.applicationDomain.getDefinition(getQualifiedClassName(registration)) : getDefinitionByName(getQualifiedClassName(registration))) as Class;
					if (c) {
						Font.registerFont(c);
						PluginManager.registerFont(registration as Font);
					}
				
				// if it's a plugin
				} else if (registration is Plugin) {
					
					var plugin:Plugin = registration as Plugin;
					
					if (plugin.definition) {
						
						// make sure it's uppercase
						plugin.name = plugin.name.toUpperCase();
		
						var object:IDisposable = plugin.createNewInstance() as IDisposable;
						if (object) {
							
							// test the type of object
							if (object is Filter) {
								
								plugin.registerData('bitmap', object is IBitmapFilter);
								plugin.registerData('tempo', object is TempoFilter);

								PluginManager.registerFilter(plugin);
																
							// register transition
							} else if (object is Transition) {
								
								PluginManager.registerTransition(plugin);
								
							// register visualizer
							} else if (object is Visualizer) {
								
								PluginManager.registerVisualizer(plugin);
								
							// register macro
							} else if (object is Macro) {
								
								PluginManager.registerMacro(plugin);
								
							// register module
							} else if (object is Module) {
								
								PluginManager.registerModule(plugin);
								
							}
						}						
					}
				}
				
				registration = registrations.shift();
			}
			
		}
		
		/**
		 * 	Sets the display dimensions
		 */
		public static function setDisplayDimensions(width:int, height:int):void {
			DISPLAY_RECT.width	= DISPLAY_WIDTH		= width;
			DISPLAY_RECT.height	= DISPLAY_HEIGHT	= height
		}
	}
}