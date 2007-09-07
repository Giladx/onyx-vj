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
	import flash.geom.ColorTransform;
	
	import onyx.controls.Control;
	import onyx.events.ControlEvent;
	
	import ui.styles.*;
	import ui.text.TextField;
	import onyx.controls.ControlBoolean;
	import flash.display.DisplayObject;
	import onyx.controls.ControlRange;
	import ui.text.TextFieldCenter;
	
	/**
	 * 	Checkbox
	 */
	public class CheckBox extends UIControl {

		/**
		 * 	@private
		 */
		private var _value:*;

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
		public function CheckBox(options:UIOptions, control:ControlRange):void {
			
			super(options, control, true, control.display);

			_label			= new TextFieldCenter(options.width + 3, options.height, 0, 0);
			_button			= new ButtonClear(options.width, options.height);
			_value			= control.value;
			
			_label.text		= _value;
			
			addChild(_label);
			addChild(_button);

			_onChanged();
			
			control.addEventListener(ControlEvent.CHANGE, _onChanged);
			_button.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			
		}
		
		/**
		 * 	@private
		 */
		private function _mouseDown(event:MouseEvent):void {
			var range:ControlRange	= super.control as ControlRange;
			var data:Array			= range.data;
			var index:int			= data.indexOf(_value) + 1;
			control.value			= (index >= data.length) ? data[0] : data[index];
		}
		
		/**
		 * 	@private
		 */
		private function _onChanged(event:ControlEvent = null):void {
			
			var background:DisplayObject = super.getBackground();

			_value		= event ? event.value : _value;
			_label.text	= _value;
			
			if (background) {
				background.transform.colorTransform = _value ? LAYER_HIGHLIGHT : DEFAULT;
			}
			
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			control.removeEventListener(ControlEvent.CHANGE, _onChanged);
			_button.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			
			_label	= null;
			_button = null;
			
			removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);

			super.dispose();
		}
	}
}