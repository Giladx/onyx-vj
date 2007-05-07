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
package onyx.file.nth {
	
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import onyx.core.Console;
	import onyx.file.*;
	import onyx.net.NthCmdClient;
	import onyx.events.*;
	
	public final class NthQuery extends FileQuery {
		
		private var _fileclient:NthCmdClient;
		
		/**
		 * 	@constructor
		 */
		public function NthQuery(folder:String, callback:Function):void {
			super(folder, callback);
			_fileclient = NthCmdClient.getInstance();
		}
		
		/**
		 * 	Loads files
		 */
		override public function load(filter:FileFilter):void {
			
			super.filter = filter;
			
			_fileclient.listDir(path);
			_fileclient.addEventListener(NthCmdEvent.DONE, _onLoadHandler);
		}
		
		/**
		 * 	For now saves it to the clipboard
		 */
		override public function save(bytes:ByteArray):void {
			bytes.position = 0;
			System.setClipboard(bytes.readUTFBytes(bytes.length));
			
			dispatchEvent(new Event(Event.COMPLETE))
		}
		
		/**
		 *  @private
		 */
		 private function _processThumbs(list:FolderList):void {
		 	var thumbs:Array = [];
		 	var n:int;
		 	var leng:int = list.files.length;
		 	var origfiles:Array = list.files;
		 	
		 	// Remove all the .jpg and .png files from the list
			for ( n=leng-1; n>=0; n-- ) {
				f = origfiles[n];
				if ( f.path.search(".jpg$")>0 || f.path.search(".png$")>0 ) {
					thumbs.push(f);
					list.files.splice(n,1);
				}
			}
			// Scan the list and fill in the matching jpg/png files as thumbnails
			for each ( var f:File in list.files ) {
				var i:int = f.path.lastIndexOf(".");
				var base:String = f.path.substring(0,i);
				for each ( var f2:File in thumbs ) {
					var i2:int = f2.path.lastIndexOf(".");
					var base2:String = f2.path.substring(0,i2);
					if ( base2 == base ) {
						f.thumbnail = f2.path;
					}
				}
			}
		 }
		 
		/**
		 * 	@private
		 */
		private function _onLoadHandler(event:NthCmdEvent):void {
			
			// var loader:URLLoader = event.currentTarget as URLLoader;
			_fileclient.removeEventListener(NthCmdEvent.DONE, _onLoadHandler);
	
			// error			
			if (!(event is ErrorEvent)) {
				if (!(event is NthFileEvent)) {
					trace("Unexpected type of NthCmdEvent in _onLoadHandler");
				} else {
					folderList = (event as NthFileEvent).folderList;
					_processThumbs(folderList);
				}
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}