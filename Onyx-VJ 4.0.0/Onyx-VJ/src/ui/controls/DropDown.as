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
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.core.*;
	import ui.styles.*;
	import ui.text.TextField;
	
	/**
	 * 	Drop down control (relates to ParameterArray)
	 */
	public final class DropDown extends UIControl {
		
		/**
		 * 	Option heights
		 */
		public static const ITEM_HEIGHT:int		= 14;

		/**
		 * 	@private
		 */
		private var _width:int;

		/**
		 * 	@private
		 */
		private var label:TextField;

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
		 * 
		 */
		override public function initialize(p:Parameter, options:UIOptions = null, label:String=null):void {
			
			// add control
			var param:ParameterArray = p as ParameterArray;
			
			// initialize
			super.initialize(param, options);
			
			// set width
			_width	= options.width,
			_data	= param.data;

			// listen for changes			
			parameter.addEventListener(ParameterEvent.CHANGE, _onChange);
			
			// draw
			_draw(options.width, options.height);

			// add listeners			
			_button.addEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_button.addEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);

			// get value
			var value:* = param.value;
			
			// set index
			_index		= _data.indexOf(value);
			
			
			// set text
			setText(param.value);
		}
		
		/**
		 * 	@private
		 */
		private function _onWheel(event:MouseEvent):void {
			if (event.delta > 0) {
				if (_index > 0) {
					parameter.value = _data[--_index];
				}
			} else {
				if (_index < _data.length - 1) {
					parameter.value = _data[++_index];
				}
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onChange(event:ParameterEvent):void {
			setText(event.value);
		}
		
		/**
		 * 	@private
		 */
		private function _draw(width:int, height:int, drawBG:Boolean = false):void {

			label			= Factory.getNewInstance(TextField);
			_button			= new ButtonClear(width, height),
			label.width		= width - 2,
			label.height	= height,
			label.x			= 1,
			label.y			= 2;

			addChild(label);
			addChild(_button);
		}
		
		/**
		 * 	@private
		 */
		private function _onPress(event:MouseEvent):void {
			
			var param:ParameterArray, items:Array, start:int, len:int;
			param	= super.parameter as ParameterArray;

			items	= 	[],
			len		=	_data.length;
			
			_index	= 	_data.indexOf(parameter.value),			
			start	= 	-_index * ITEM_HEIGHT;
			
			// loop through data and create the options
			for (var count:int = 0; count < len; count++) {
				
				var item:Option	= Factory.getNewInstance(Option) as Option;
				item.init(
					(param.binding) ? (_data[count] ? _data[count][param.binding] : 'None') : _data[count] || 'off', count, _width, param.binding
				);
				
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
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _onRelease);
			
			// stop propagation
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 */
		private function _onRelease(event:MouseEvent):void {

			var control:ParameterArray	= parameter as ParameterArray;

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
			_selectedIndex	= null,
			_items			= null;
			
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
			
			var control:ParameterArray	= parameter as ParameterArray;
			label.text = (control.binding && value) ? value[control.binding] || 'None' : value || 'None';

		}
		
		override public function reflect():Class {
			return DropDown;
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			// remove value listening
			parameter.removeEventListener(ParameterEvent.CHANGE, _onChange);
			
			// add listeners			
			_button.removeEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_button.removeEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);
			
			// dispose
			super.dispose();

		}
	}
}

import flash.display.*;

import ui.text.TextField;
import ui.controls.DropDown;
import ui.styles.*;
import onyx.core.*;

final class Option extends Sprite {
	
	// register
	Factory.registerClass(Option);
	
	/**
	 * 	@private
	 */
	private var label:TextField;

	/**
	 * 	Row index
	 */
	public var index:int;
	
	/**
	 * 
	 */
	public function init(text:String, index:int, width:int, bind:String = null):void {

		this.index		= index;
		label			= Factory.getNewInstance(TextField);
		label.width		= width;
		label.height	= 9;
		label.x			= 2;
		label.y			= 2;
		label.text		= text ? text.toUpperCase() : '';
		addChild(label);
		
		var graphics:Graphics = this.graphics;
		graphics.clear();
		graphics.beginFill(DROPDOWN_DEFAULT);
		graphics.drawRect(0, 0, width, DropDown.ITEM_HEIGHT);
		graphics.endFill();
		
	}
	
	/**
	 * 	Draw
	 */
	public function draw(color:int, width:int):void {
		
		var graphics:Graphics = this.graphics;
		
		graphics.clear();
		graphics.beginFill(color);
		graphics.drawRect(0, 0, width, DropDown.ITEM_HEIGHT);
		graphics.endFill();

	}

	/**
	 * 	Dispose
	 */	
	public function dispose():void {
		
		// release to Factory
		Factory.release(Option, this);
		Factory.release(TextField, label);
		removeChild(label);
		
		// remove
		if (parent) {
			parent.removeChild(this);
		}
	}
	
}