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

	import ui.text.TextFieldCenter;
	
	/**
	 * 	Slider
	 */
	public class SliderV extends UIControl {
		
		/**
		 * 	@private
		 */
		protected var _multiplier:Number;
		
		/**
		 * 	@private
		 */
		protected var _factor:Number;
		
		/**
		 * 	@private
		 */
		protected var _toFixed:int;
		
		/**
		 * 	@private
		 */
		protected var _tempY:Number;

		/**
		 * 	@private
		 */
		protected var _button:ButtonClear;
		
		/**
		 * 	@private
		 */
		protected var _value:TextFieldCenter;
		
		/**
		 * 	@private
		 */
		protected var _mouseY:int;
		
		/**
		 * 	@constructor
		 */
		public function SliderV(options:UIOptions, input:Control):void {

			var control:ControlNumber	= input as ControlNumber;

			super(options, control, true, control.display);
			
			var width:int				= options.width;
			var height:int				= options.height;
			var multiplier:Number		= control.multiplier;
			var factor:Number			= control.factor;
			var toFixed:Number			= 0;

			_button = new ButtonClear(width,	height);
			_value	= new TextFieldCenter(width + 3,	height, 0, 1);

			_multiplier			= multiplier;
			_factor				= factor;
			_toFixed			= toFixed;
			
			addChild(_value);
			addChild(_button);
			
			doubleClickEnabled	= true;

			addEventListener(MouseEvent.MOUSE_DOWN,		_mouseDown);
			addEventListener(MouseEvent.DOUBLE_CLICK,	_doubleClick);
			addEventListener(MouseEvent.MOUSE_WHEEL,	_onMouseWheel);
			
			if (_toFixed > 0) {
				_control.addEventListener(ControlEvent.CHANGE, _onControlChangeFixed);
				_onControlChangeFixed();
			} else {
				_control.addEventListener(ControlEvent.CHANGE, _onControlChange);
				_onControlChange();
			}
		}
		
		/**
		 * 	@private
		 */
		protected function _onMouseWheel(event:MouseEvent):void {
			_control.value = _control.value + ((event.delta * 3) / _multiplier);
		}
		
		/**
		 * 	@private
		 */
		protected function _doubleClick(event:MouseEvent):void {
			_control.reset();
		}

		/**
		 * 	@private
		 */
		protected function _mouseDown(event:MouseEvent):void {
			
			_mouseY = mouseY;
			_tempY = _control.value * _multiplier;
			
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);

		}
		
		/**
		 * 	@private
		 */
		protected function _mouseMove(event:MouseEvent):void {
			
			var diff:Number = (_mouseY - mouseY) / _factor;
			
			_control.value = (diff + _tempY) / _multiplier;
			
		}
		
		/**
		 * 	@private
		 */
		protected function _mouseUp(event:MouseEvent):void {

			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);

		}
		
		/**
		 * 	@private
		 */
		protected function _onControlChange(event:ControlEvent = null):void {
			value	= String((((event) ? event.value : _control.value) * _multiplier) >> 0);
		}
		
		/**
		 * 	@private
		 */
		protected function _onControlChangeFixed(event:ControlEvent = null):void {
			value	= String(Number(((event) ? event.value : _control.value) * _multiplier).toFixed(_toFixed));
		}
		
		/**
		 * 	Value
		 */
		protected function set value(value:String):void {
			_value.text = value;
		}

		/**
		 * 	@method		cleans up references
		 */
		override public function dispose():void {

			// clean up event handlers
			removeEventListener(MouseEvent.MOUSE_DOWN,		_mouseDown);
			removeEventListener(MouseEvent.DOUBLE_CLICK,	_doubleClick);
			removeEventListener(MouseEvent.MOUSE_WHEEL,		_onMouseWheel);
			
			// remove listeners
			_control.removeEventListener(ControlEvent.CHANGE, _onControlChange);
			_control.removeEventListener(ControlEvent.CHANGE, _onControlChangeFixed);

			// remove display objects

			removeChild(_value);
			removeChild(_button);
			
			_button	= null,
			_value	= null;
			
			super.dispose();
		}
	}
}