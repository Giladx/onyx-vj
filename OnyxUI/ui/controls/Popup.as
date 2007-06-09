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
	import flash.text.TextFormatAlign;
	
	import onyx.constants.*;
	
	import ui.assets.AssetWindow;
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.TextFieldCenter;

	/**
	 * 	Popup class
	 */
	public final class Popup extends UIObject {
		
		/**
		 * 	@private
		 */
		private var _text:TextFieldCenter;
		
		/**
		 * 	@constructor
		 */
		public function Popup(width:int, height:int, text:String):void {

			// add the background
			var sprite:DisplayObject = addChild(new AssetWindow());
			sprite.width	= width;
			sprite.height	= height;

			// add the textfield
			_text			= new TextFieldCenter(width, height, 0, 14);
			_text.multiline	= true;
			_text.wordWrap	= true;
			_text.text		= text;
			
			// add it
			addChild(_text);
		}	
		
		public function addToStage(add:Boolean = true):void {
			// add or remove from stage?
			(add) ? STAGE.addChild(this) : STAGE.removeChild(this);
			
			x = STAGE.stageWidth / 2 - (this.width / 2);
			y = STAGE.stageHeight / 2 - (this.height / 2);
		}
	}
}