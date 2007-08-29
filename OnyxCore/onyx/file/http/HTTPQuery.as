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
package onyx.file.http {
	
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import onyx.file.*;
	import onyx.jobs.*;
	import onyx.settings.*;
	import onyx.utils.string.*;

	/**
	 * 	Base HTTP Query class
	 */
	public final class HTTPQuery extends FileQuery {
		
		/**
		 * 	@constructor
		 */
		public function HTTPQuery(folder:String, callback:Function):void {
			super(folder, callback);
		}
		
		/**
		 * 	Loads files
		 */
		override public function load(filter:FileFilter, thumbnail:Boolean):void {
			
			super.filter = filter;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, _onLoadHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
			
			loader.load(new URLRequest(path + '/files.xml'));
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
		 * 	@private
		 */
		private function _onLoadHandler(event:Event):void {
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, _onLoadHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoadHandler);
			
			// error			
			if (!(event is ErrorEvent)) {
	
				// declare the node
				var node:XML, thumbs:Array, thumbfiles:Array, xml:XML, files:XMLList, dirs:XMLList;
	
				// load the data into an xml doc			
				xml = new XML(loader.data);
				
				// create the Folder
				var rootpath:String = pathUpOneLevel(xml.query.@path.toString());
				var list:FolderList = new FolderList(pathUpOneLevel(rootpath));
	
				// get the children
				files	= xml.query.file,
				dirs	= xml.query.folder;
				
				// parse for files Folder
				for each (node in dirs) {
					name = node.@name;
					
					// check for full protocol
					if (name.indexOf('://') > 0) {
						
					// check for parent folder directive
					} else if (name === '..') {
						name = rootpath.substr(0, rootpath.lastIndexOf('/', rootpath.length - 2));
						
					// check to see if it's a relative path directoive
					} else if (name.substr(0,1) === '/') {
						name = FileBrowser.startupFolder + INITIAL_APP_DIRECTORY + name;
						
					// default, append the file name
					} else {
						name = FileBrowser.startupFolder + pathUpOneLevel(rootpath + name);
					}
					
					list.folders.push(new Folder(name));
				}
				
				thumbs = [],
				thumbfiles = [];
				
				// parse for files Folder
				for each (node in files) {
					
					// get name of the node
					var name:String = String(node.@name);
					
					var thumbpath:String	= node.@thumb;
					
					// check for full protocol
					if (name.indexOf('://') > 0) {
					
					// default, append the directory / path
					} else {
						name = FileBrowser.startupFolder + pathUpOneLevel(rootpath + name);
					}
					
					var file:File			= new File(name);
					
					// call a job to update these bitmaps
					if (thumbpath) {
						thumbfiles.push(file);
						thumbs.push(rootpath + thumbpath);
					}
					
					list.files.push(file);
					
				}
				
				// if we need to call to get thumbnails updated, call the job to do that
				if (thumbs.length) {
					var job:HTTPThumbnailJob = new HTTPThumbnailJob(thumbs, thumbfiles);
					job.initialize();
				}
				
				folderList = list;
			}
			
			dispatchEvent(event);
		}
	}
}