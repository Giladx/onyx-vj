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
package ui.controls {
	
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.text.TextFieldCenter;
	
	final public class SliderV2 extends UIControl {
		
		private var _controlY:Parameter;
		private var _controlX:Parameter;
		
		private var _tempY:Number;
		private var _tempX:Number;
		
		private var _mouseY:int;
		private var _mouseX:int;

		private var _multiplier:Number;
		private var _factor:Number;

		private var _button:ButtonClear;
		private var _value:TextFieldCenter;
		
		/**
		 * 
		 */
		public function SliderV2():void {
			this.setMovesToTop(true);
		}
				
		/**
		 * 
		 */
		override public function initialize(control:Parameter, options:UIOptions = null, label:String=null):void {
			
			var proxy:ParameterProxy			= control as ParameterProxy;
			var controlY:ParameterNumber		= proxy.controlY;
			var width:int					= options.width;
			var height:int					= options.height;
			var invert:Boolean				= proxy.invert;
			
			super.initialize(control, options, proxy.display);
			
			_button = new ButtonClear(width,	height);
			_value	= Factory.getNewInstance(TextFieldCenter);
			_value.width	= width + 3,
			_value.height	= height,
			_value.x		= 0,
			_value.y		= 2;

			_controlY	= proxy.controlY,
			_controlX	= proxy.controlX,
			_multiplier = controlY.multiplier,
			_factor		= controlY.factor;

			_value.text		= ((_controlY.value * _multiplier) >> 0) + ':' + ((_controlX.value * _multiplier) >> 0);	
			
			addChild(_value);
			addChild(_button);

			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClick);

			_controlY.addEventListener(ParameterEvent.CHANGE, _onControlChange);
			_controlX.addEventListener(ParameterEvent.CHANGE, _onControlChange);
			
			addEventListener(MouseEvent.MOUSE_DOWN, (invert) ? mouseDownInvert : mouseDownNormal);
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
		private function mouseDownNormal(event:MouseEvent):void {
			
			_mouseY = mouseY;
			_mouseX = mouseX;
			
			_tempY = (_controlY.value * _multiplier);
			_tempX = (_controlX.value * _multiplier);
			
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveNormal);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
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
		private function mouseDownInvert(event:MouseEvent):void {
			
			_mouseY = mouseY;
			_mouseX = mouseX;
			
			_tempY = (_controlY.value * _multiplier);
			_tempX = (_controlX.value * _multiplier);
			
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveInvert);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);

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
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveInvert);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveNormal);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		}
		
		/**
		 * 	@private
		 */
		private function _onControlChange(event:ParameterEvent):void {
			
			var control:Parameter = event.currentTarget as Parameter;
			
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
		override public function reflect():Class {
			return SliderV2;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {

			_controlY.removeEventListener(ParameterEvent.CHANGE, _onControlChange);
			_controlX.removeEventListener(ParameterEvent.CHANGE, _onControlChange);
			
			super.dispose();
		}

	}
}