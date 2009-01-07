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
	
	import flash.events.*;
	import flash.ui.Keyboard;
	
	import onyx.constants.*;
	import onyx.states.*;
	
	import ui.controls.Popup;
	import ui.core.KeyDefinition;

	public final class KeyLearnState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var _definition:KeyDefinition;
		
		/**
		 * 	@private
		 */
		private var _popup:Popup;
		
		/**
		 * 	@private
		 */
		private var _state:KeyListenerState;
		
		/**
		 * 	@constructor
		 */
		public function KeyLearnState(definition:KeyDefinition, listener:KeyListenerState):void {

			// store definitions
			_definition = definition;
			_state	= listener;
			
			super(KeyLearnState);
		}
		
		/**
		 * 	Start listening and override mouse events
		 */
		override public function initialize():void {
			
			// display a pop-up
			_popup = new Popup(100,50,'Press a key for: ' + _definition.desc);
			_popup.addToStage();
			
			// listen for a key
			STAGE.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, true, 9999);
			STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown, true, 9999);
			
			// pause the keylistener
			_state.pause();

		}
		
		/**
		 * 	@private
		 * 	The user pressed a button
		 */
		private function _onKeyDown(event:KeyboardEvent):void {
			
			// save the button
			_state[_definition.prop] = event.keyCode;
			
			// don't let the event through
			event.stopPropagation();

			// remove the learn state
			StateManager.removeState(this);
		}
		
		/**
		 * 	@private
		 * 	Captures mouse events (to cancel the state if a mouse press is detected)
		 */
		private function _mouseDown(event:MouseEvent):void {

			// don't let the event through
			event.stopPropagation();

			// remove the state
			StateManager.removeState(this);
		}
		
		/**
		 * 	Terminate the key learn state
		 */
		override public function terminate():void {
			
			// remove keyboard listener
			STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, true);
			STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown, true);
			
			// remove the popup
			if (_popup) {
				STAGE.removeChild(_popup);
			}
			
			// tell the keylistener to turn back on
			_state.initialize();
			
			// remove references
			_state	= null;
			_definition = null;
			_popup		= null;
		}

	}
}