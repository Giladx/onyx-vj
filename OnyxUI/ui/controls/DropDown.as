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
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.events.ControlEvent;
	import onyx.utils.math.*;
	
	import ui.styles.*;
	import ui.text.TextField;
	
	/**
	 * 	Drop down control (relates to ControlRange)
	 */
	public final class DropDown extends UIControl {
		
		/**
		 * 	Option heights
		 */
		public static const ITEM_HEIGHT:int		= 12;

		/**
		 * 	@private
		 */
		private var _width:int;

		/**
		 * 	@private
		 */
		private var _label:TextField;

		/**
		 * 	@private
		 */
		private var _index:int;

		/**
		 * 	@private
		 */
		private var _button:ButtonClear;

		/**
		 * 	@private
		 */
		private var _data:Array;

		/**
		 * 	@private
		 */
		private var _items:Array;

		/**
		 * 	@private
		 */
		private var _selectedIndex:Option;
		
		/**
		 * 	@constructor
		 */
		public function DropDown(options:UIOptions, icontrol:Control):void {
			
			var control:ControlRange = icontrol as ControlRange;

			// super!
			super(options, icontrol as ControlRange, true, icontrol.display);
			
			// set width
			_width	= options.width,
			_data	= control.data;

			// listen for changes			
			_control.addEventListener(ControlEvent.CHANGE, _onChange);
			
			// draw
			_draw(options.width, options.height);

			// add listeners			
			_button.addEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_button.addEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);

			// get value
			var value:* = control.value;
			
			// set index
			_index		= _data.indexOf(value);
			
			// set text
			setText(control.value);
		}
		
		/**
		 * 	@private
		 */
		private function _onWheel(event:MouseEvent):void {
			if (event.delta > 0) {
				if (_index > 0) {
					_control.value = _data[--_index];
				}
			} else {
				if (_index < _data.length - 1) {
					_control.value = _data[++_index];
				}
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onChange(event:ControlEvent):void {
			setText(event.value);
		}
		
		/**
		 * 	@private
		 */
		private function _draw(width:int, height:int, drawBG:Boolean = false):void {

			_button		= new ButtonClear(width, height),
			_label		= new TextField(width, 9),
			_label.x	= 2,
			_label.y	= 1;

			addChild(_label);
			addChild(_button);
		}
		
		/**
		 * 	@private
		 */
		private function _onPress(event:MouseEvent):void {
			
			var control:ControlRange, items:Array, start:int, len:int;
			
			control =	_control as ControlRange,
			items	= 	[],
			len		=	_data.length;
			
			_index	= 	_data.indexOf(control.value),			
			start	= 	-_index * ITEM_HEIGHT;
			
			// loop through data and create the options
			for (var count:int = 0; count < len; count++) {
				
				var item:Option	= new Option(
					(control.binding) ? (_data[count] ? _data[count][control.binding] : 'None') : _data[count] || 'off', count, _width, control.binding)
				;
				
				item.addEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
				item.addEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
				
				item.y = start;
				start += ITEM_HEIGHT;
				
				items.push(item);
				
				// add it
				var gr:Graphics = CONTAINER.graphics;
				
				// draw
				gr.lineStyle(0, LINE_DEFAULT, .5);
				gr.drawRect(-1, -_index * ITEM_HEIGHT - 1, _width + 1, len * ITEM_HEIGHT + 1);
				
				// display
				CONTAINER.display(this, item);
			}
			
			// store all the items
			_items = items;
			
			// listen for a mouse release
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onRelease);
			
			// stop propagation
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 */
		private function _onRelease(event:MouseEvent):void {

			var control:ControlRange	= _control as ControlRange;

			// if a valid index, set the value
			if (_selectedIndex) {

				_index = _selectedIndex.index;
				control.value = control.data[_index];
				
			}
			
			// kill all the items
			for each (var item:Option in _items) {
				item.removeEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
				item.removeEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
				item.dispose();
			}
			
			// remove references
			_selectedIndex = null,
			_items = null;
			
			// remove the popup
			CONTAINER.remove();
		}

		/**
		 * 	@private
		 */
		private function _onRollOver(event:MouseEvent):void {
			var option:Option = event.currentTarget as Option;
			_selectedIndex = option;
			option.draw(DROPDOWN_HIGHLIGHT, _width);
		}

		/**
		 * 	@private
		 */
		private function _onRollOut(event:MouseEvent):void {
			var option:Option = event.currentTarget as Option;
			_selectedIndex = null;
			option.draw(DROPDOWN_DEFAULT, _width);
		}
		
		/**
		 * 	Sets text to a value
		 */
		public function setText(value:*):void {
			var control:ControlRange	= _control as ControlRange;
			_label.text = (control.binding && value) ? value[control.binding] || 'None' : value || 'None';

		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			// remove value listening
			_control.removeEventListener(ControlEvent.CHANGE, _onChange);
			
			// add listeners			
			_button.removeEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_button.removeEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);
			
			_label 	= null,
			_button = null,
			_control = null;
			
			super.dispose();
		}
	}
}

import flash.display.*;

import ui.text.TextField;
import ui.controls.DropDown;
import ui.styles.*;

final class Option extends Sprite {
	
	/**
	 * 	@private
	 */
	private var _label:TextField;

	public var index:int;
	
	/**
	 * 	@constructor
	 */
	public function Option(text:String, index:int, width:int, bind:String = null):void {
		
		this.index			= index,
		_label				= new TextField(width, 9),
		_label.x			= 2,
		_label.y			= 1,
		_label.text			= text ? text.toUpperCase() : '';
		
		var graphics:Graphics = this.graphics;
		
		graphics.beginFill(DROPDOWN_DEFAULT);
		graphics.drawRect(0, 0, width, DropDown.ITEM_HEIGHT);
		graphics.endFill();

		addChild(_label);
	}
	
	/**
	 * 	Draw
	 */
	public function draw(color:int, width:int):void {
		graphics.clear();
		
		graphics.beginFill(color);
		graphics.drawRect(0, 0, width, DropDown.ITEM_HEIGHT);
		graphics.endFill();

	}

	/**
	 * 	Dispose
	 */	
	public function dispose():void {
		
		// remove
		if (parent) {
			parent.removeChild(this);
			removeChild(_label);
			_label = null;
		}
	}
	
}