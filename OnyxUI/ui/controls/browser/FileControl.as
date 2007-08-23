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
package ui.controls.browser {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	import onyx.file.*;
	
	import ui.assets.AssetCamera;
	import ui.controls.*;
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.TextField;
	import ui.text.TextFieldCenter;
	
	/**
	 * 	Thumbnail for file
	 */
	public final class FileControl extends UIObject {
		
		/**
		 * 	@private
		 */
		private static const DROP_SHADOW:Array	= [new DropShadowFilter(1,45, 0x000000,1,0,0,1)];
		
		/**
		 * 	@private
		 */
		private var _label:TextField			= new TextField(46, 35);

		/**
		 * 	@private
		 */
		private var _button:ButtonClear			= new ButtonClear(47, 36);

		/**
		 * 	@private
		 */		
		private var _file:File;
		
		/**
		 * 	@constructor
		 */
		public function FileControl(file:File, thumbnail:Bitmap):void {
			
			// store file
			_file = file;
			
			thumbnail.x			= 1,
			thumbnail.y			= 1,
			thumbnail.width		= 46,
			thumbnail.height	= 35;
			
			addChild(thumbnail);
			
			// add label
			_label.wordWrap		= true,
			_label.text			= FileBrowser.getFileName(path),
			_label.filters		= DROP_SHADOW,
			_label.x			= 1,
			_label.y			= 1,
			doubleClickEnabled	= true;
			
			addChild(_label);
			addChild(_button);
			
			// draw border: choose different color for VLC files
			var graphics:Graphics = this.graphics;
			switch(_file.extension) {
				case 'swf':
				case 'onx':
				case 'mix':
				case 'flv':
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'mp3':
				case 'xml':	graphics.beginFill(0x647789);
							break;
				default	  : graphics.beginFill(0xf0e68c);		
			}
			graphics.drawRect(0,0,48,37);
			graphics.endFill();
		}
		
		/**
		 * 	@private
		 * 	Remove handlers
		 */
		private function _handler(event:Event):void {
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			info.removeEventListener(Event.COMPLETE, _handler);
			info.removeEventListener(IOErrorEvent.IO_ERROR, _handler);
		}
		
		/**
		 * 	Returns path
		 */
		public function get path():String {
			return _file.path;
		}
		
		/**
		 * 	Destroys control
		 */
		override public function dispose():void {
			
			removeChild(_label);
			removeChild(_button);
			
			_button	= null,
			_label	= null,
			_file	= null;
			
			super.dispose();
		}
		
		/**
		 * 
		 */
		override public function toString():String {
			return '[FileControl: ' + _file.path + ']';
		}
	}
}