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
package ui.window {
	
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextFieldAutoSize;
	
	import onyx.core.Plugin;
	
	import ui.assets.AssetWindow;
	import ui.core.UIObject;
	import ui.text.*;
	import onyx.tween.easing.Back;
	
	/**
	 * 	Window
	 */
	internal class Window extends UIObject {
		
		/**
		 * 	@private
		 */
		private var _title:TextField;
		
		/**
		 * 	@private
		 */
		private var _background:AssetWindow;
		
		/**
		 * 	@constructor
		 */
		public function Window(reg:WindowRegistration, background:Boolean, width:int, height:int):void {
			
			// check for title
			if (background) {
				
				if (reg && reg.name) {
					_title					= new TextField(width, 16);
					
					_title.autoSize			= TextFieldAutoSize.LEFT,
					_title.x				= 2,
					_title.y				= 1,
					_title.text				= reg.name;
					
					addChild(_title);
				}
			
				_background = new AssetWindow();
				
				_background.width	= width,
				_background.height	= height;
	
				addChildAt(_background, 0);
			}
			
			super(true);	
		}

	}
}