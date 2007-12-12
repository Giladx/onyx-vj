/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package ui.core {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.file.*;
	import onyx.plugin.*;
	import onyx.states.StateManager;
	
	import ui.assets.*;
	import ui.macros.*;
	import ui.settings.*;
	import ui.states.*;
	import ui.window.*;
	
	use namespace onyx_ns;

	/**
	 * 	Class that handles top-level management of all ui objects
	 */
	public class UIManager {

		/**
		 * 	@private
		 * 	The displaystart state
		 */
		private static var displayState:DisplayStartState;
		
		/**
		 * 	@private
		 * 	The states to load when starting up
		 */
		private static var states:Array;
		
		/**
		 * 	initialize
		 */
		public static function initialize(root:DisplayObjectContainer, startupFolder:String, adapter:FileAdapter, ... states:Array):void {
			
			File.startupFolder = startupFolder;
			
			// initialize key actions
			Onyx.registerPlugin(
				new Plugin('SelectLayer0',			SelectLayer0, 'Selects Layer 0'),
				new Plugin('SelectLayer1',			SelectLayer1, 'Selects Layer 1'),
				new Plugin('SelectLayer2',			SelectLayer2, 'Selects Layer 2'),
				new Plugin('SelectLayer3',			SelectLayer3, 'Selects Layer 3'),
				new Plugin('SelectLayer4',			SelectLayer4, 'Selects Layer 4'),
				new Plugin('SelectLayerNext',		SelectLayerNext, 'Selects Next Layer'),
				new Plugin('SelectLayerPrevious',	SelectLayerPrevious, 'Selects Previous Layer'),
				new Plugin('SelectPage0',			SelectPage0, 'Selects Layer 0'),
				new Plugin('SelectPage1',			SelectPage1, 'Selects Layer 1'),
				new Plugin('SelectPage2',			SelectPage2, 'Selects Layer 2'),
				new Plugin('MuteLayer0',			MuteLayer0, 'Mutes Layer 1'),
				new Plugin('MuteLayer1',			MuteLayer1, 'Mutes Layer 2'),
				new Plugin('MuteLayer2',			MuteLayer2, 'Mutes Layer 3'),
				new Plugin('MuteLayer3',			MuteLayer3, 'Mutes Layer 4'),
				new Plugin('MuteLayer4',			MuteLayer4, 'Mutes Layer 5'),
				new Plugin('CycleBlendUp',			CycleBlendModeUp,	''),
				new Plugin('CycleBlendDown',		CycleBlendModeDown,	''),
				new Plugin('ResetLayer',			ResetLayer,	'')
			);
			
			// initializes onyx
			Onyx.initialize(root, adapter);
			
			// load plugins
			var engine:EventDispatcher = Onyx.loadPlugins();

			// show startup image
			engine.addEventListener(ApplicationEvent.ONYX_STARTUP_START, _onInitializeStart);
			
			// wait til we're done initializing
			engine.addEventListener(ApplicationEvent.ONYX_STARTUP_END, _onInitializeEnd);
			
			// store states
			UIManager.states = states;
		}
		
		/**
		 * 
		 */
		public static function registerModuleWindows():void {
			
			// get the default state
			var windows:Array = WindowState.getState('DEFAULT').windows;
			
			for each (var module:Module in Module.modules) {
				
				// if it has a ui definition
				if (module.uiOptions) {
					
					var options:InterfaceOptions	= module.uiOptions;
					var name:String					= module.name;
					
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
		private static function _onInitializeStart(event:ApplicationEvent):void {
			
			// create the loading window
			displayState = new DisplayStartState(states);
			
			// load state
			StateManager.loadState(displayState);
			
			// remove the states
			states = null;
		}
		
		/**
		 * 	@private
		 */
		private static function _onInitializeEnd(event:ApplicationEvent):void {
			
			// start-up
			var engine:EventDispatcher = event.currentTarget as EventDispatcher;

			// listen for windows created
			engine.removeEventListener(ApplicationEvent.ONYX_STARTUP_START, _onInitializeStart);
			engine.removeEventListener(ApplicationEvent.ONYX_STARTUP_END, _onInitializeEnd);
		
			// load settings
			var state:SettingsLoadState = new SettingsLoadState();
			state.addEventListener(Event.COMPLETE, _onSettingsComplete);
			StateManager.loadState(state);
		}
		
		/**
		 * 
		 */
		private static function _onSettingsComplete(event:Event):void {
			var state:SettingsLoadState = event.currentTarget as SettingsLoadState;
			state.removeEventListener(Event.COMPLETE, _onSettingsComplete);
			
			// set the startup state value from the settings startup value;
			displayState.startupWindowState = state.startupWindowState;
			
			StateManager.removeState(displayState);
			displayState = null;
		}
	}
}