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
package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.System;
	import flash.text.TextFieldType;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.utils.*;
	
	import services.videopong.VideoPong;
	
	import ui.core.DragManager;
	import ui.core.Settings;
	import ui.policy.*;
	import ui.states.*;
	import ui.text.*;
	
			
	use namespace onyx_ns;
	
	/**
	 * 	Console window
	 */
	public final class ConsoleWindow extends Window {
		
		/**
		 * 	singleton instance of Videopong class
		 */
		private const vp:VideoPong = VideoPong.getInstance();
		
		/**
		 * 	@private
		 */
		private var _border:Graphics;
		
		/**
		 * 	@private
		 */
		private var _text:TextField;
		
		/**
		 * 	@private
		 */
		private var _input:TextField;
		
		/**
		 * 	@private
		 */
		private var _commandStack:Array;
		
		/**
		 * 	@constructor
		 */
		public function ConsoleWindow(reg:WindowRegistration):void {
			
			super(reg, true, 160, 145);

			Console.getInstance().addEventListener(ConsoleEvent.OUTPUT, _onMessage);
			
			_draw();
			
			_input.addEventListener(FocusEvent.FOCUS_IN, _focusHandler);
			_input.addEventListener(FocusEvent.FOCUS_OUT, _focusHandler);
			_input.addEventListener(MouseEvent.MOUSE_DOWN, _onClick);
			
			// add a scroller
			Policy.addPolicy(_input, new TextScrollPolicy());
			
			// make draggable
			DragManager.setDraggable(this);
			
			// get the start-up motd
			Console.executeCommand('help commands');
			
		}
			
		/**
		 * 	@private
		 * 	Pauses global keylistener state, as well as listens for the enter button
		 */
		private function _focusHandler(event:FocusEvent):void {
			
			if (event.type === FocusEvent.FOCUS_IN) {
				_input.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				
				// remove keyboard listening
				StateManager.pauseStates(ApplicationState.KEYBOARD);
				
			} else {
				_input.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				
				// remove keyboard
				StateManager.resumeStates(ApplicationState.KEYBOARD);
			}
		}
		
		/**
		 * 	@private
		 * 	Handler when onyx console outputs a message
		 */
		private function _onMessage(event:ConsoleEvent):void {
			
			//_text.htmlText = '<font size="7" color="#DCC697" face="DefaultFont"><b>ONYX ' + VERSION + '</b></font><br>';
			_text.htmlText += '<TEXTFORMAT LEADING="3"><FONT FACE="DefaultFont" SIZE="7" COLOR="#e4eaef" KERNING="0">' + event.message + '</font></textformat><br/>';
			_text.scrollV = _text.maxScrollV;
			
		}
		
		/**
		 * 	@private
		 * 	Draw
		 */
		private function _draw():void {
			
			_border						= this.graphics;
						
			_text						= Factory.getNewInstance(TextField);
			_text.width					= 155,
			_text.height				= 120,
			_text.multiline				= true,
			_text.wordWrap				= true,
			_text.x						= 2,
			_text.y						= 17,
			_text.selectable			= true;
			
			_input						= Factory.getNewInstance(TextField);
			_input.width				= 157,
			_input.height				= 10;
			_input.x  					= 2;
			_input.y  					= super.height - 11;
			_input.text					= 'enter command here';
			_input.background			= true;
			_input.backgroundColor		= 0x252727;
			_input.doubleClickEnabled	= true;
			_input.selectable			= true;
			_input.mouseEnabled			= true;
			_input.maxChars				= 25;
			_input.type					= TextFieldType.INPUT;

			addChild(_text);
			addChild(_input);
			
		}
		
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
				case 'copy':
					System.setClipboard(_text.text);
				
					break;
					
				case 'clear':
				case 'cls':
					_text.text = '';
				
					break;
				case 'settings':
					_text.text = Settings.toXML();
				
					break;
				case 'vpsettings':
					_text.text = Settings.toXML()..videopong;
				
					break;
				case 'vpdomain':
					_text.text = 'Videopong domain: ' + vp.domain;
				
					break;
				case 'vpsessiontoken':
					_text.text = 'Videopong sessiontoken: ' + vp.sessiontoken;
					
					break;
				case 'fullscreen':
					_text.text = 'Fullscreen mode';
					stage.displayState = 'fullScreen';
					break;
				default:
					Console.executeCommand(command);
					_input.setSelection(0, _input.length);
					break;
			}
		}
		
	}
}