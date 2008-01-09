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
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.controls.Control;
	import onyx.events.ControlEvent;
	
	import ui.assets.*;
	import ui.controls.ButtonClear;
	import ui.controls.UIControl;

	/**
	 * 	The visibility control
	 */
	public final class LayerVisible extends UIControl {
		
		/**
		 * 
		 */
		public static const LAYER_VISIBLE:BitmapData	= new AssetEyeIcon();
		
		/**
		 * 
		 */
		private static const LAYER_DISABLED:BitmapData	= new AssetEyeIconDisabled();
		
		/**
		 * 	@private
		 */
		private var _icon:Bitmap						= new Bitmap(LAYER_VISIBLE);
		
		/**
		 * 
		 */
		private var _button:ButtonClear					= new ButtonClear(10,10);
		
		/**
		 * 	@constructor
		 */
		public function LayerVisible(control:Control):void {
			
			super(null, control);
			
			_control.addEventListener(ControlEvent.CHANGE, _controlHandler);
			_button.addEventListener(MouseEvent.MOUSE_DOWN, _mouseHandler);
			
			_icon.x = 1;
			_icon.y = 1;
			
			addChild(_icon);
			addChild(_button);
		}
		
		/**
		 * 	@private
		 */
		private function _mouseHandler(event:Event):void {
			_control.value = !_control.value;
		}
		
		/**
		 * 	@private
		 */
		private function _controlHandler(event:ControlEvent):void {
			if (event.value) {
				_icon.bitmapData	= LAYER_VISIBLE;
				parent.alpha		= 1;
			} else {
				_icon.bitmapData	= LAYER_DISABLED;
				parent.alpha		= .6;
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			_control.removeEventListener(ControlEvent.CHANGE, _controlHandler);
			_button.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseHandler);
			
			_icon.bitmapData	= null;
			_icon				= null,
			_button				= null;
			
			super.dispose();
		}
	}
}