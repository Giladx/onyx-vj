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
package ui.controls {
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	
	import onyx.controls.*;
	
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.*;
	
	/**
	 * 	Relates to ControlExecute
	 */
	public final class ButtonControl extends UIControl {
		
		/**
		 * 	@private
		 */
		private var _label:TextFieldCenter;
		
		/**
		 * 	@private
		 */
		private var _button:ButtonClear;
		
		/**
		 * 	@constructor
		 */
		public function ButtonControl(options:UIOptions, control:Control):void {
			
			super(options, control, true, control.display);

			_button		= new ButtonClear(options.width, options.height),
			_label		= new TextFieldCenter(options.width + 3, options.height, 0, 1);
			
			addChild(_label);
			addChild(_button);
				
			_label.textColor	= 0x999999,
			_label.text			= 'execute';
				
			addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);	
		}

		/**
		 * 	@private
		 */
		private function _mouseDown(event:MouseEvent):void {
			
			var f:ControlExecute = _control as ControlExecute;
			f.execute();

			event.stopPropagation();
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			_control	= null,
			_label		= null;
			
			super.dispose();
		}
	}
}