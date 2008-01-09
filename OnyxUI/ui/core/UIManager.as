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
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.file.*;
	import onyx.plugin.*;
	import onyx.states.*;
	import onyx.system.*;
	
	import ui.assets.*;
	import ui.controls.*;
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
		private var displayState:DisplayStartState;
		
		/**
		 * 	initialize
		 */
		public function initialize(stage:Stage, displayRoot:DisplayObjectContainer, adapter:FileAdapter, systemAdapter:SystemAdapter, pluginPath:String):void {

			// store stage
			STAGE = stage;

			// create the system adapter			
			SystemAdapter.adapter			= systemAdapter;

			// create the loading window
			displayState					= new DisplayStartState();
			
			// store the displayRoot
			ROOT							= displayRoot;
			
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
			Onyx.initialize(stage, adapter, pluginPath);
			
			// load plugins
			var engine:EventDispatcher = Onyx.loadPlugins();

			// show startup image
			engine.addEventListener(ApplicationEvent.ONYX_STARTUP_START, _onInitializeStart);
			
			// wait til we're done initializing
			engine.addEventListener(ApplicationEvent.ONYX_STARTUP_END, _onInitializeEnd);
		}
		
		/**
		 * 
		 */
		public function registerModuleWindows():void {
			
			// get the default state
			var windows:Array = WindowState.getState('DEFAULT').windows;
			
			// initialize modules
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
		private function _onInitializeStart(event:ApplicationEvent):void {
			
			// load state
			StateManager.loadState(displayState);
		}
		
		/**
		 * 	@private
		 */
		private function _onInitializeEnd(event:ApplicationEvent):void {
			
			// start-up
			var engine:EventDispatcher = event.currentTarget as EventDispatcher;

			// listen for windows created
			engine.removeEventListener(ApplicationEvent.ONYX_STARTUP_START, _onInitializeStart);
			engine.removeEventListener(ApplicationEvent.ONYX_STARTUP_END, _onInitializeEnd);
			
			// parse the xml
			Settings.apply();

			// create
			DISPLAY = new Display();
			DISPLAY.createLayers(5);
			ROOT.addChild(DISPLAY as DisplayObject);
			
			// kill the display state
			StateManager.removeState(displayState);
		}
	}
}