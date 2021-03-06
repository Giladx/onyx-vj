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
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.events.ControlEvent;
	import onyx.net.Stream;

	import ui.text.TextFieldCenter;
	
	final public class SliderV2 extends UIControl {
		
		private var _controlY:Control;
		private var _controlX:Control;
		
		private var _tempY:Number;
		private var _tempX:Number;
		
		private var _mouseY:int;
		private var _mouseX:int;

		private var _multiplier:Number;
		private var _factor:Number;

		private var _button:ButtonClear;
		private var _value:TextFieldCenter;
		
		/**
		 * 	@constructor
		 */
		public function SliderV2(options:UIOptions, control:Control):void {
			
			var proxy:ControlProxy			= control as ControlProxy;
			var controlY:ControlNumber		= proxy.controlY;
			var width:int					= options.width;
			var height:int					= options.height;
			var invert:Boolean				= proxy.invert;
			
			super(options, control, true, proxy.display);

			_button = new ButtonClear(width,	height);
			_value	= new TextFieldCenter(width + 3,	height,	0, 1);

			_controlY	= proxy.controlY,
			_controlX	= proxy.controlX,
			_multiplier = controlY.multiplier,
			_factor		= controlY.factor;

			_value.text		= ((_controlY.value * _multiplier) >> 0) + ':' + ((_controlX.value * _multiplier) >> 0);	
			
			addChild(_value);
			addChild(_button);

			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClick);

			_controlY.addEventListener(ControlEvent.CHANGE, _onControlChange);
			_controlX.addEventListener(ControlEvent.CHANGE, _onControlChange);
			
			addEventListener(MouseEvent.MOUSE_DOWN, (invert) ? _mouseDownInvert : _mouseDownNormal);

		}
		
		/**
		 * 	@private
		 */
		private function _doubleClick(event:MouseEvent):void {
			_controlY.reset();
			_controlX.reset();
		}

		/**
		 * 	@private
		 */
		private function _mouseDownNormal(event:MouseEvent):void {
			
			_mouseY = mouseY;
			_mouseX = mouseX;
			
			_tempY = (_controlY.value * _multiplier);
			_tempX = (_controlX.value * _multiplier);
			
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveNormal);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
		}
		
		/**
		 * 	@private
		 */
		private function _mouseMoveNormal(event:MouseEvent):void {


			var x:Number = (_tempX + ((_mouseX - mouseX) / _factor));
			var y:Number = (_tempY + ((_mouseY - mouseY) / _factor));

			if (event.shiftKey) {
				x = y = (x + y) >> 1;
			}
			
			_controlX.value = x / _multiplier;
			_controlY.value = y / _multiplier;

		}

		/**
		 * 	@private
		 */
		private function _mouseDownInvert(event:MouseEvent):void {
			
			_mouseY = mouseY;
			_mouseX = mouseX;
			
			_tempY = (_controlY.value * _multiplier);
			_tempX = (_controlX.value * _multiplier);
			
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveInvert);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);

		}
		
		/**
		 * 	@private
		 */
		private function _mouseMoveInvert(event:MouseEvent):void {

			var x:Number = _tempX - ((_mouseX - mouseX) / _factor);
			var y:Number = _tempY - ((_mouseY - mouseY) / _factor);

			if (event.shiftKey) {
				x = y = (x + y) >> 1;
			}
			
			_controlX.value = x / _multiplier;
			_controlY.value = y / _multiplier;
			
		}
		
		/**
		 * 	@private
		 */
		private function _mouseUp(event:MouseEvent):void {
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveInvert);
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveNormal);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		}
		
		/**
		 * 	@private
		 */
		private function _onControlChange(event:ControlEvent):void {
			
			var control:Control = event.currentTarget as Control;
			
			if (control === _controlY) {
				var x:Number = _controlX.value;
				var y:Number = event.value;
			} else {
				x = event.value;
				y = _controlY.value;
			}
			
			_value.text = String((x * _multiplier) >> 0) + ':' + String((y * _multiplier) >> 0);
		}
		
		/**
		 * 
		 */
		override public function dispose():void {

			_controlY.removeEventListener(ControlEvent.CHANGE, _onControlChange);
			_controlX.removeEventListener(ControlEvent.CHANGE, _onControlChange);
			
			_controlY = null;
			_controlX = null;
		}

	}
}