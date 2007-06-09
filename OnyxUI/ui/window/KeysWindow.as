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
package ui.window {
	
	import flash.events.*;
	import flash.ui.*;
	
	import onyx.states.*;
	import onyx.utils.math.*;
	import onyx.utils.string.*;
	
	import ui.controls.*;
	import ui.core.DragManager;
	import ui.core.KeyDefinition;
	import ui.core.UIManager;
	import ui.policy.*;
	import ui.states.KeyLearnState;
	import ui.states.KeyListenerState;
	import ui.styles.UI_OPTIONS;
	import ui.text.TextField;
	
	/**
	 * 	Key Mapping Window
	 */
	public final class KeysWindow extends Window {

		/**
		 * 	@private
		 */
		private var _text:TextField	= new TextField(195, 187);
		
		/**
		 * 	@private
		 */
		private var _state:KeyListenerState;
		
		/**
		 * 	@private
		 */
		private var _lookup:Object	= {};

		/**
		 * 	@Constructor
		 */
		public function KeysWindow():void {

			// position and create			
			super('KEY MAPPING', 192, 200);
			
			// set draggable
			DragManager.setDraggable(this);
			
			// add the textfield
			_text.x = 4;
			_text.y = 14;
			addChild(_text);

			// add a text scroll policy
			Policy.addPolicy(_text, new TextScrollPolicy());
			
			// listen for clicks
			_text.addEventListener(TextEvent.LINK, _onClick);

			// check for application state			
			var states:Array = StateManager.getStates(KeyListenerState);
			if (states.length === 1) {
				_state = states[0];
				
				_initText();
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onClick(event:TextEvent):void {
			
			trace(x,y);
			
			var definition:KeyDefinition = _lookup[event.text];
			var state:KeyLearnState = new KeyLearnState(definition, _state);
			state.addEventListener(Event.COMPLETE, _onLearnComplete);

			// load the key learn state
			StateManager.loadState(state);
		}
		
		/**
		 * 	@private
		 * 	Handler for when the application state is complete
		 */
		private function _onLearnComplete(event:Event):void {
			var state:KeyLearnState = event.currentTarget as KeyLearnState;
			state.removeEventListener(Event.COMPLETE, _onLearnComplete);
			
			_initText();
		}
		
		/**
		 * 	@private
		 */
		private function _initText():void {
			
			var htmlText:String = '';
			
			for each (var def:KeyDefinition in _state.definitions) {
				var prop:String = def.prop;
				
				_lookup[def.prop] = def;
				
				htmlText += '<a href="event:' + prop + '">' + prop;
				htmlText += repeatString('\t', max(10 - floor(prop.length / 4), 0));
				htmlText += getKeyName(_state[prop]) + '</a>\n';
			}
			
			_text.htmlText = htmlText;
		}
		
		/**
		 * 	@private
		 * 	Returns the string representation of a keyboard item
		 */
		private function getKeyName(value:int):String {
			switch (value) {
				case Keyboard.UP:
					return 'UP';
				case Keyboard.DOWN:
					return 'DOWN';
				case Keyboard.LEFT:
					return 'LEFT';
				case Keyboard.RIGHT:
					return 'RIGHT';
				case Keyboard.F1:
				case Keyboard.F2:
				case Keyboard.F3:
				case Keyboard.F4:
				case Keyboard.F5:
				case Keyboard.F6:
				case Keyboard.F7:
				case Keyboard.F8:
				case Keyboard.F9:
				case Keyboard.F10:
				case Keyboard.F11:
				case Keyboard.F12:
					return 'F' + (value - 111);
				case Keyboard.BACKSPACE:
					return 'BACKSPACE';
				case Keyboard.CAPS_LOCK:
					return 'CAPSLOCK';
				case Keyboard.DELETE:
					return 'DEL';
				case Keyboard.HOME:
					return 'HOME';
				default:
					return String.fromCharCode(value);
			}
		}
	}
}