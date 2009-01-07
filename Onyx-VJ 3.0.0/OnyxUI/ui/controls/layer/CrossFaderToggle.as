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
package ui.controls.layer {
	
	import flash.events.MouseEvent;
	
	import onyx.display.*;
	
	import ui.controls.ButtonClear;
	import ui.core.UIObject;
	import ui.text.TextField;
	import ui.styles.*;

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
		private var _layer:ILayer;
		
		/**
		 * 	@private
		 */
		private var _current:TextField;
		
		/**
		 * 	@constructor
		 */
		public function CrossFaderToggle(layer:ILayer):void {
			
			_current	= new TextField(11,11),
			_layer		= layer,
			_toggleA	= new ButtonClear(11,11),
			_toggleB	= new ButtonClear(11,11);
			
			_current.y			= 1,
			_current.textColor	= 0xCCCCCC;
			
			_toggleA.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			_toggleB.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			
			_toggleA.x	= 12;
			_toggleB.x	= 24;
			
			addChild(_toggleA);
			addChild(_toggleB);
			
			select();
		}
		
		/**
		 * 	@private
		 */
		private function _mouseDown(event:MouseEvent):void {
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
			
			_toggleA.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			_toggleB.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
		}	
	}
}