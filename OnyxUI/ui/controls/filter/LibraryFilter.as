/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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

	import onyx.filter.Filter;
	import onyx.plugin.Plugin;
	
	import ui.assets.AssetLayerFilterInactive;
	import ui.controls.ButtonClear;
	import ui.controls.UIControl;
	import ui.core.ToolTipManager;
	import ui.core.UIObject;
	import ui.text.TextField;
	
	public final class LibraryFilter extends UIObject {
		
		/**
		 * 	@private
		 * 	Associated Plugin
		 */
		private var _plugin:Plugin;
		
		/**
		 * 	@private
		 */
		private var _label:TextField = new TextField(70,12);

		/**
		 * 	@private
		 */
		private var _btn:ButtonClear = new ButtonClear(87,12);

		/**
		 * 	@private
		 */
		private var _bg:AssetLayerFilterInactive = new AssetLayerFilterInactive();
		
		/**
		 * 	@constructor
		 */
		public function LibraryFilter(plugin:Plugin):void {
			
			_plugin = plugin;
			_draw();
			
			ToolTipManager.registerToolTip(this, plugin.description);

		}
		
		/**
		 * 	@private
		 */
		private function _draw():void {
			
			_label.text			= _plugin.name;
			_label.y			= 2;
			_label.x			= 2;
			
			addChild(_bg);
			addChild(_label);
			addChild(_btn);
		}
		
		/**
		 * 	Returns the plugin
		 */
		public function get filter():Plugin {
			return _plugin;
		}
	}
}