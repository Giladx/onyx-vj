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
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.states.*;
	
	import ui.policy.*;
	import ui.text.*;
	import ui.states.KeyListenerState;
	
	use namespace onyx_ns;
	
	/**
	 * 	Console window
	 */
	public final class ConsoleWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var _text:TextField;
		
		/**
		 * 	@private
		 */
		private var _input:TextInput;
		
		/**
		 * 	@private
		 */
		private var _commandStack:Array;

		/**
		 * 	@constructor
		 */
		public function ConsoleWindow():void {
			
			super('console', 190, 161);

			Console.getInstance().addEventListener(ConsoleEvent.OUTPUT, _onMessage);
			
			_draw();
			
			// add listeners
			_input.addEventListener(FocusEvent.FOCUS_IN, _focusHandler);
			_input.addEventListener(FocusEvent.FOCUS_OUT, _focusHandler);
			_input.addEventListener(MouseEvent.MOUSE_DOWN, _onClick);
			
			// add a scroller
			Policy.addPolicy(_input, new TextScrollPolicy());
			
			// get the start-up motd
			Command.help();
			Command.help('plugins');
		}
		
		/**
		 * 	@private
		 * 	Pauses global keylistener state, as well as listens for the enter button
		 */
		private function _focusHandler(event:FocusEvent):void {
			
			if (event.type === FocusEvent.FOCUS_IN) {
				_input.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				
				StateManager.pauseStates(KeyListenerState);
				
			} else {
				_input.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				
				StateManager.resumeStates(KeyListenerState);
			}
		}
		
		/**
		 * 	@private
		 * 	Handler when onyx console outputs a message
		 */
		private function _onMessage(event:ConsoleEvent):void {
			
			_text.htmlText += '<TEXTFORMAT LEADING="3"><FONT FACE="Pixel" SIZE="7" COLOR="#e4eaef" KERNING="0">' + event.message + '</font></textformat><br/><br/>';
			_text.scrollV = _text.maxScrollV;

		}
		
		/**
		 * 	@private
		 * 	Draw
		 */
		private function _draw():void {

			_text						= new TextField(187, 141);
			_text.multiline				= true;
			_text.wordWrap				= true;
			_text.x						= 2;
			_text.y						= 12;
			_text.selectable			= true;
			
			_input						= new TextInput(187, 10);
			_input.x  					= 2;
			_input.y  					= super.height - 12;
			_input.text					= 'enter command here';
			_input.background			= true;
			_input.backgroundColor		= 0x000000;
			_input.doubleClickEnabled	= true;

			addChild(_text);
			addChild(_input)
			
		}
		
		/**
		 * 	@private
		 * 	Handler for when a key is pressed
		 */
		private function _onKeyDown(event:KeyboardEvent):void {
			switch (event.keyCode) {
				// execute
				case 13:
					executeCommand(_input.text);
					_input.setSelection(0,_input.text.length);
					break;
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onClick(event:MouseEvent):void {
			
			_input.setSelection(0,_input.text.length);
		}
		
		/**
		 * 	@private
		 */
		private function executeCommand(command:String):void {
			
			var command:String = command.toLowerCase();
			
			switch (command) {
				case 'clear':
				case 'cls':
				case 'motd':
					_text.text = '';
				
					break;
				default:
					Console.executeCommand(command);
					break;
			}
		}
		
	}
}