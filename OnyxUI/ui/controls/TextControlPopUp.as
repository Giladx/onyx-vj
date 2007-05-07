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
package ui.controls {

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.controls.*;
	
	import ui.core.UIObject;
	import ui.text.TextInput;
	
	public final class TextControlPopUp extends UIObject {

		/**
		 * 	@private
		 */
		private var _input:TextInput;

		/**
		 * 	@private
		 */
		private var _control:Control;

		/**
		 * 	@constructor
		 */
		public function TextControlPopUp(parent:DisplayObjectContainer, width:int, height:int, text:String, control:Control = null):void {
			
			if (parent) {
				
				_control		= control;

				var bounds:Rectangle	= parent.getBounds(parent.stage);
				x						= bounds.x;
				y						= bounds.y;
				
				STAGE.addChildAt(this, STAGE.numChildren);
				STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _captureMouse);

				displayBackground(width, height);
				
				_input				= new TextInput(width - 4, height - 4);
				_input.multiline	= true;
				_input.x			= 2;
				_input.y			= 2;
				_input.text			= text;
				addChild(_input);

				_input.setSelection(0, text.length - 1);
			}
			
			mouseEnabled = true;
			mouseChildren = true;
			
		}
		
		/**
		 * 	@private
		 */
		private function _captureMouse(event:MouseEvent):void {
			
			if (!hitTestPoint(STAGE.mouseX, STAGE.mouseY)) {
				
				if (_control) {
					_control.value = _input.text;
					_control = null;
				}
				
				STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _captureMouse, false);
				STAGE.removeChild(this);
				
				dispose();
			}
			
			event.stopPropagation();
		}
	}
}