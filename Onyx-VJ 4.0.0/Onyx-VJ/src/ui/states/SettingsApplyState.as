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
	
	import flash.display.Screen;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.utils.file.*;
	
	import ui.controls.*;
	import ui.window.*;

	/**
	 * 
	 */
	public final class SettingsApplyState extends ApplicationState {
		
		/**
		 * 
		 */
		override public function initialize():void {

			// register
			registerModuleWindows();

			// apply settings
			applySettings();
			
		}
		
		/**
		 * 	@private
		 */
		private function applySettings():void {
			
			const xml:XML			= SettingsLoadState.SETTINGS_XML;
			const uiXML:XMLList	= xml.ui;

			var list:XMLList;
			
			if (uiXML.hasOwnProperty('swatch')) {
				list = uiXML.swatch;
				
				try {
					var colors:Array = [];
					for each (var color:uint in list.*) {
						colors.push(color);
					}
					ColorPicker.registerSwatch(colors);
				} catch (e:Error) {
					Console.error(e);
				}
				
			}
			
			// stored keys
			if (uiXML.hasOwnProperty('keys')) {
				
				list = uiXML.keys;
				
				// map keys
				for each (var key:XML in list.*) {
					
					try {
						KeyListenerState.registerKey(key.@code, PluginManager.getMacroDefinition(key.toString()));
					} catch (e:Error) {
						Console.error(e);
					}

				}
			}
			
			// parse states
			if (uiXML.hasOwnProperty('windows')) {

				// set the startup window state
				
				list = uiXML.windows;
				for each (var stateXML:XML in list.*) {
					var state:WindowState = WindowState.getState(String(stateXML.@name));
					if (state) {
						for each (var windowXML:XML in stateXML.*) {
							// find the window
							for each (var window:WindowStateReg in state.windows) {
								if (window.name == windowXML.@name) {
									window.x		= windowXML.@x;
									window.y		= windowXML.@y;
									window.enabled	= String(windowXML.@enabled) == 'true';
									break;
								}
							}
						}
					}
				}
				
			}

			// done
			StateManager.removeState(this);
		}
		
		/**
		 * 
		 */
		public function registerModuleWindows():void {
			
			// get the default state
			const windows:Array = WindowState.getState().windows;
			
			// initialize modules
			for each (var module:Module in PluginManager.modules) {
				
				// if it has a ui definition
				if (module.interfaceOptions) {
					
					var options:ModuleInterfaceOptions	= module.interfaceOptions;
					var name:String							= module.name;
					
					// register a new window registration
					WindowRegistration.register(
						new WindowRegistration(name, ModuleWindow)
					);
					
					// add it to the default state
					windows.push(
						new WindowStateReg(name, options.x, options.y, false)
					);
				}
			}
		}
		
		/**
		 * 	@private
		 */
		override public function terminate():void {
			
			// check screens
			if (Screen.screens.length === 1) {
				Console.output('NO OUTPUT Display DETECTED.  PLEASE ENABLE THE SECOND SCREEN AND RESTART');
			}
			
			PluginManager.macros.sortOn('description')
			
			// output
			Console.output('\n*  MAKE ART  *\n');

		}
	}
}