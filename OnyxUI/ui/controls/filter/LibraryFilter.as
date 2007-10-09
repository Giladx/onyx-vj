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
package ui.controls.filter {

	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.filters.*;
	
	import onyx.core.Plugin;
	
	import ui.controls.ButtonClear;
	import ui.core.ToolTipManager;
	import ui.core.UIObject;
	import ui.text.TextField;
	
	public final class LibraryFilter extends UIObject {
		
		/**
		 * 	@private
		 */
		private static const DROP_SHADOW:Array	= [new DropShadowFilter(1, 45, 0x000000,1,0,0,1)];
		
		/**
		 * 	@private
		 * 	Associated Plugin
		 */
		private var _plugin:Plugin;
		
		/**
		 * 	@private
		 */
		private var _label:TextField = new TextField(47,35);

		/**
		 * 	@private
		 */
		private var _btn:ButtonClear = new ButtonClear(47,35);
		
		/**
		 * 	@constructor
		 */
		public function LibraryFilter(plugin:Plugin):void {
			
			_plugin = plugin;

			var bmp:Bitmap	= new Bitmap(_plugin.thumbnail);
			bmp.x = bmp.y	= 1;
			
			// draw shit
			addChild(bmp);
			
			_label.wordWrap		= true,
			_label.text			= _plugin.name,
			_label.y			= 2,
			_label.x			= 2,
			_label.filters		= DROP_SHADOW;

			
			addChild(_label);
			addChild(_btn);
			
			var graphics:Graphics = this.graphics;
			graphics.beginFill(0x45525c);
			graphics.drawRect(0,0,48,37);
			graphics.endFill();
			
			ToolTipManager.registerToolTip(this, plugin.description);

		}
		
		/**
		 * 	Returns the plugin
		 */
		public function get filter():Plugin {
			return _plugin;
		}
	}
}