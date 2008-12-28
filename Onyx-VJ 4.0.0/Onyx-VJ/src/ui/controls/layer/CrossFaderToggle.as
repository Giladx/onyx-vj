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
package ui.controls.layer {
	
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.display.*;
	
	import ui.controls.ButtonClear;
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.TextField;

	public final class CrossFaderToggle extends UIObject {

		/**
		 * 	@private
		 */
		private var _toggleA:ButtonClear;
		
		/**
		 * 	@private
		 */
		private var _toggleB:ButtonClear;
		
		/**
		 * 	@private
		 */
		private var _layer:LayerImplementor;
		
		/**
		 * 	@private
		 */
		private var _current:TextField;
		
		/**
		 * 	@constructor
		 */
		public function CrossFaderToggle(layer:LayerImplementor):void {
			
			_current	= Factory.getNewInstance(ui.text.TextField),
			_layer		= layer,
			_toggleA	= new ButtonClear(11,11),
			_toggleB	= new ButtonClear(11,11);
			
			_current.width		= 11,
			_current.height		= 11,
			_current.y			= 1,
			_current.textColor	= 0xCCCCCC;
			
			_toggleA.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_toggleB.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			_toggleA.x	= 12;
			_toggleB.x	= 24;
			
			addChild(_toggleA);
			addChild(_toggleB);
			
			select();
		}
		
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			_layer.channel = event.currentTarget === _toggleB; 
			select();
		}
		
		/**
		 * 	@private
		 */
		private function select():void {
			if (_layer.channel) {
				_current.text	= 'B',
				_current.x		= 25;

				addChild(_current);
				addChild(_toggleA);
				
				removeChild(_toggleB);
			} else {
				_current.text	= 'A',
				_current.x		= 14;

				addChild(_current);
				addChild(_toggleB);
				
				removeChild(_toggleA);
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			super.dispose();
			
			_toggleA.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_toggleB.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}	
	}
}