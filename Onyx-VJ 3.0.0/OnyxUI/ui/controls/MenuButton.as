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
	
	import ui.assets.AssetBitmap;
	import ui.styles.*;
	import ui.text.*;
	import ui.window.*;
	
	/**
	 * 	Text Button
	 */
	public final class MenuButton extends Sprite {
		
		/**
		 * 	@private
		 */
		private var background:Bitmap;

		/**
		 * 	@private
		 */
		private var reg:WindowRegistration;
		
		/**
		 * 	@constsructor
		 */
		public function MenuButton(reg:WindowRegistration, options:UIOptions):void {
			
			var options:UIOptions	= options || UI_OPTIONS;
			var width:int			= options.width;
			var height:int			= options.height;

			// add a label
			var label:TextFieldCenter	= new TextFieldCenter(width + 3, height, 0, 1);
			label.textColor				= TEXT_LABEL,
			label.text					= reg.name.toUpperCase(),
			label.mouseEnabled			= false;

			addChild(label);

			// add a button
			addChild(new ButtonClear(width, height));
			
			// add background
			addChildAt(background = new AssetBitmap(width, height), 0);
			
			// save registration and set enabled / disabled
			this.reg		= reg;
			this.enabled	= reg.enabled;
			//this.enabled	= reg.enabled;
			
			// add listener
			addEventListener(MouseEvent.MOUSE_DOWN, _onClick);
		}
		
		/**
		 * 	Sets enabled
		 */
		public function set enabled(value:Boolean):void {
			background.transform.colorTransform = (value) ? LAYER_HIGHLIGHT : DEFAULT;
		}
		
		/**
		 * 	@private
		 */
		private function _onClick(event:MouseEvent):void {
			this.enabled = reg.enabled = !reg.enabled;
		}
	}
}