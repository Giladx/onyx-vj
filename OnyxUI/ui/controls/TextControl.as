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
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	
	import onyx.controls.*;
	
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.TextField;
	
	public final class TextControl extends UIControl {
		
		/**
		 * 	@private
		 */
		private var _label:TextField;
		
		/**
		 * 	@constructor
		 */
		public function TextControl(options:UIOptions, control:Control):void {
			
			super(options, control, true, control.display);
			
			_label = new TextField(options.width + 3, options.height, TEXT_DEFAULT_CENTER);
			addChild(_label);
			
			_label.y			= 1;
			_label.textColor	= 0x999999;
			_label.text			= 'EDIT';
				
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);	
		}

		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			
			var popup:TextControlPopUp	= new TextControlPopUp(this, 200, 200, _control.value, _control);
			event.stopPropagation();
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			_control	= null,
			_label		= null;
			
			super.dispose();
		}
	}
}