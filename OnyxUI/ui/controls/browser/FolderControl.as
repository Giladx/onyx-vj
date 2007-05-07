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
package ui.controls.browser {
	
	import flash.display.Bitmap;
	
	import onyx.file.*;
	
	import ui.assets.AssetFolder;
	import ui.assets.AssetFolderUp;
	import ui.controls.ButtonClear;
	import ui.controls.UIControl;
	import ui.core.UIObject;
	import ui.text.TextField;

	/**
	 * 	Folder Control
	 */
	public final class FolderControl extends UIObject {
		
		/**
		 * 	@private
		 */
		private static const FOLDER_WIDTH:int = 90;
		
		/**
		 * 	@private
		 */
		private var _label:TextField = new TextField(FOLDER_WIDTH,10);

		/**
		 * 	@private
		 */
		private var _img:Bitmap;

		/**
		 * 	@private
		 */
		private var _btn:ButtonClear = new ButtonClear(FOLDER_WIDTH + 2,11);
		
		/**
		 * 	@private
		 */
		private var _folder:Folder;
		
		/**
		 * 	@constructor
		 */
		public function FolderControl(folder:Folder, useArrowFolder:Boolean = false):void {
			
			_folder = folder;
			
			if (useArrowFolder) {
				_img = new AssetFolderUp();
				_label.text = 'up one level';
			} else {
				_img = new AssetFolder();
				_label.text = FileBrowser.getFileName(folder.path);
			}
			
			_btn.x = -2;
			_btn.y = -1;
			_img.y = 1;
			_label.x = 9;
			
			addChild(_label);
			addChild(_img);
			addChild(_btn);
			
		}
		
		/**
		 * 	Returns path
		 */
		public function get path():String {
			return _folder.path;
		}
		
		/**
		 * 	Disposes the control
		 */
		override public function dispose():void {
			_label	= null,
			_img	= null,
			_btn	= null;
			
			super.dispose();
		}
	}
}