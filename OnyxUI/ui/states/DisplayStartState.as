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
package ui.states {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.midi.Midi;
	import onyx.states.*;
	
	import ui.assets.*;
	import ui.core.*;
	import ui.layer.UILayer;
	import ui.settings.*;
	import ui.text.*;
	import ui.window.*;
	
	/**
	 * 	The state that shows the loading screen
	 */
	public final class DisplayStartState extends ApplicationState {

		/**
		 * 	@private
		 */
		private var _image:DisplayObject;
		
		/**
		 * 	@private
		 */
		private var _label:TextField		= new TextField(400,425);
		
		/**
		 * 	@private
		 */
		private var _states:Array;
		
		/**
		 * 	The window state to start up
		 */
		public var startupWindowState:String	= 'DEFAULT';
		
		/**
		 * 
		 */
		public function DisplayStartState(states:Array):void {
			
			// save states to run
			_states = states;
			
			super(DisplayStartState);
		}

		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			// create the image and a label
			_image = new OnyxStartUpImage();
			
			// add the children
			ROOT.addChild(_image);
			ROOT.addChild(_label);
			
			// listen for mouse clicks
			ROOT.addEventListener(MouseEvent.MOUSE_DOWN,	_captureEvents,	true, -1);
			ROOT.addEventListener(MouseEvent.MOUSE_UP,		_captureEvents,	true, -1);
			
			ROOT.addEventListener(Event.ADDED,				_onItemAdded);
			
			// listen for updates
			var console:Console = Console.getInstance();
			console.addEventListener(ConsoleEvent.OUTPUT, _onOutput);
			
			// set the label type
			_label.selectable		= false;
			_label.x				= 683;
			_label.y				= 137;
		}
		
		/**
		 * 	@private
		 */
		private function _onOutput(event:ConsoleEvent):void {
			_label.appendText(event.message + '\n');
			_label.scrollV = _label.maxScrollV;
		}
		
		/**
		 * 	@private
		 * 	Traps all mouse events
		 */
		private function _captureEvents(event:MouseEvent):void {
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 * 	When an item is added, make sure it is below the startup image
		 */
		private function _onItemAdded(event:Event):void {
			
			var stage:DisplayObjectContainer = ROOT;
			STAGE.setChildIndex(_image, STAGE.numChildren - 2);
			STAGE.setChildIndex(_label, STAGE.numChildren - 1);
			
		}

		/**
		 * 	Terminate
		 */		
		override public function terminate():void {

			var console:Console = Console.getInstance();
			console.removeEventListener(ConsoleEvent.OUTPUT, _onOutput);
			
			// remove listener to the stage
			ROOT.removeEventListener(Event.ADDED, _onItemAdded);
			
			// remove listener for mouse clicks
			ROOT.removeEventListener(MouseEvent.MOUSE_DOWN,		_captureEvents,	true);
			ROOT.removeEventListener(MouseEvent.MOUSE_UP,		_captureEvents,	true);

			// remove items
			ROOT.removeChild(_image);
			ROOT.removeChild(_label);
			
			// clear references
			_image = null;
			_label = null;
			
			// loop through and load states			
			if (_states) {
				for each (var state:ApplicationState in _states) {
					StateManager.loadState(state);
				}
			}
			
			// add a display, but only make it visible if the stagewidth is greater than > 1024
			var display:IDisplay = Onyx.createDisplay(STAGE.stageWidth - 640, 0, 640 / BITMAP_WIDTH, 480 / BITMAP_HEIGHT);
			display.createLayers(5);
			display.visible = STAGE.stageWidth >= 1664;
			
			// add menu buttons to modules that have interface states
			UIManager.registerModuleWindows();

			// register the default state
			WindowState.load(
				WindowState.getState(startupWindowState)
			);
			
			// create the bottom buttons
			var window:MenuWindow = new MenuWindow(null);
			window.createButtons(2, 728);
			
			// load menu bar
			ROOT.addChild(window);
			
			// TBD -- midi should automatically listen to layer creations / deletions?
			// MIDI.registerLayers(display.layers);

			// remove references
			_states = null;
		}
	}
}