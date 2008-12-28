/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package ui.states {

	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.media.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;
	import onyx.utils.*;
	import onyx.utils.file.*;
	
	import ui.macros.*;
	import ui.window.*;
	
	use namespace onyx_ns;

	/**
	 * 	State that loads external plugins and registers them
	 */	
	public final class InitializationState extends ApplicationState {
		
		/**
		 * 
		 */
		private static const INSECURE_CONTEXT:LoaderContext	= new LoaderContext(false);
		INSECURE_CONTEXT.allowLoadBytesCodeExecution		= true;
		
		/**
		 * 	@private
		 */
		private var filters:Array;
		
		/**
		 * 	@private
		 */
		private var currentFile:File;
		
		/**
		 * 	@private
		 */
		private var pluginPath:File;
		
		/**
		 * 	Initializes
		 */
		override public function initialize():void {
			
			Console.output('\n*  INITIALIZING PLUGINS  *\n');
			
			// register default plugins that are UI related
			registerPlugin([
				new Plugin('SelectLayer0',			SelectLayer0, 'Selects Layer 0'),
				new Plugin('SelectLayer1',			SelectLayer1, 'Selects Layer 1'),
				new Plugin('SelectLayer2',			SelectLayer2, 'Selects Layer 2'),
				new Plugin('SelectLayer3',			SelectLayer3, 'Selects Layer 3'),
				new Plugin('SelectLayer4',			SelectLayer4, 'Selects Layer 4'),
				new Plugin('SelectLayerNext',		SelectLayerNext, 'Selects Next Layer'),
				new Plugin('SelectLayerPrevious',	SelectLayerPrevious, 'Selects Previous Layer'),
				new Plugin('SelectPage0',			SelectPage0, 'Selects Basic Control'),
				new Plugin('SelectPage1',			SelectPage1, 'Selects Filters'),
				new Plugin('SelectPage2',			SelectPage2, 'Selects Custom Tab'),
				new Plugin('MuteLayer0',			MuteLayer0, 'Mutes Layer 1'),
				new Plugin('MuteLayer1',			MuteLayer1, 'Mutes Layer 2'),
				new Plugin('MuteLayer2',			MuteLayer2, 'Mutes Layer 3'),
				new Plugin('MuteLayer3',			MuteLayer3, 'Mutes Layer 4'),
				new Plugin('MuteLayer4',			MuteLayer4, 'Mutes Layer 5'),
				new Plugin('CycleBlendUp',			CycleBlendModeUp,	'Cycles BlendMode Up'),
				new Plugin('CycleBlendDown',		CycleBlendModeDown,	'Cycle BlendMode Down'),
				new Plugin('ResetLayer',			ResetLayer,			'Resets a Layer'),
				new Plugin('ToggleTransition',		ToggleTransition,	'Toggles the cross fader')]
			);

			// store the plugin path
			pluginPath	= AIR_ROOT.resolvePath('plugins');
			
			// get all the plugins
			filters = getDirectoryTree(pluginPath, filter);
			
			// stuff to load?
			if (filters && filters.length) {
				
				DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, queueNext);
				
			// kill this state
			} else {

				StateManager.removeState(this);
				
			}
		}
		
		/**
		 * 	@private
		 */
		private function registerPlugin(registrations:Array, info:LoaderInfo = null):void {
			
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
		 *  @private
		 */
		private function queueNext(event:Event):void {
			
			// remove the listener
			DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, queueNext);
			
			// grab the last file
			currentFile = filters.pop() as File;
			
			// there's a file left
			if (currentFile) {
				
				switch (currentFile.extension) {
					
					// actionscript plugin
					case 'swf':
				
						var loader:Loader	= new Loader();
						var info:LoaderInfo	= loader.contentLoaderInfo;
						
						info.addEventListener(Event.COMPLETE,			pluginLoaded);
						info.addEventListener(IOErrorEvent.IO_ERROR,	pluginLoaded);
						
						// read the bytes
						loader.loadBytes(readBinaryFile(currentFile),	INSECURE_CONTEXT);
						
						break;
						
					// pixel blender
					case 'pbj':
					
						var bytes:ByteArray		= readBinaryFile(currentFile);
						var shader:Shader		= new Shader(bytes);
						var data:ShaderData		= shader.data;
						var input:ShaderInput	= null;
						var valid:Boolean		= true;
						
						// check to see we only have one input source, if it's multiple, it should be a transition
						// trace('---------------' + data.name, currentFile.name);
						for (var i:Object in data) {
							
							if (data[i] is ShaderInput) {
							
								if (input !== null) {
									valid = false;	
								}
								
								input = data[i];
							}
						}
						
						// only allow single input pixel blender filters
						if (valid) {
							
							var plugin:Plugin = new Plugin(shader.data.name.toUpperCase(), PixelBlenderFilter, shader.data.description, null);
							plugin.registerData('bytes', bytes);
							plugin.registerData('bitmap', true);
							
							// register the filter
							PluginManager.registerFilter(plugin);

						}

						// wait a frame to load the next one
						DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, queueNext);
					
						break;

				}
				
				// output to the screen
				Console.output(currentFile.name.replace(currentFile.type, '').toUpperCase());
				
			} else {
				
				// kill state
				// wait a second before terminating
				StateManager.removeState(this);
			}
		}
		
		/**
		 * 	@private
		 */
		private function pluginLoaded(event:Event):void {
			var info:LoaderInfo	= event.currentTarget as LoaderInfo;
			
			// remove listeners
			info.removeEventListener(Event.COMPLETE,		pluginLoaded);
			info.removeEventListener(IOErrorEvent.IO_ERROR,	pluginLoaded);
			
			// initialize the plugin
			if (!(event is ErrorEvent)) {
				
				var loader:PluginLoader = info.content as PluginLoader;
				
				if (loader) {
					
					var plugins:Array = loader.getPlugins();
					registerPlugin(plugins, info);
					
				}
			}
			
			// unload
			info.loader.unload();
			
			// wait a frame to load the next one
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, queueNext);
		}
		
		/**
		 * 	@private
		 */
		private function filter(file:File):Boolean {
			return (file.extension === 'swf' || file.extension === 'pbj') && (file.name.indexOf('-disabled') === -1 && file.nativePath.indexOf('.svn') === -1);
		}
	}
}