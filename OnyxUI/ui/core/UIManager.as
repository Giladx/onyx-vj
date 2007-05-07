/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
	import flash.events.EventDispatcher;
	
	import onyx.constants.*;
	import onyx.core.Onyx;
	import onyx.display.Display;
	import onyx.events.*;
	import onyx.file.*;
	import onyx.layer.*;
	import onyx.plugin.Plugin;
	import onyx.states.StateManager;
	import onyx.transition.Transition;
	
	import ui.assets.*;
	import ui.layer.UILayer;
	import ui.settings.*;
	import ui.states.*;
	import ui.window.*;
	import flash.events.Event;

	/**
	 * 	Class that handles top-level management of all ui objects
	 */
	public class UIManager {
		
		/**
		 * 	Stores our transition we'll pass in with files
		 */
		public static var transition:Transition;

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
		public static function initialize(root:DisplayObjectContainer, adapter:FileAdapter, ... states:Array):void {
			
			// initializes onyx
			var engine:EventDispatcher = Onyx.initialize(root, adapter);

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
			
			StateManager.removeState(displayState);
			displayState = null;
		}
	}
}