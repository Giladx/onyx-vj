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
package file {
	
	import flash.events.*;
	import flash.filesystem.*;
	import flash.net.Responder;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.file.*;
	import onyx.utils.string.*;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	/**
	 * 	Queries via the apollo filesystem
	 */
	public final class ApolloQuery extends FileQuery {
		
		/**
		 * 	@private
		 */
		private var _db:ONXThumbnailDB;
		
		/**
		 * 	@constructor
		 */
		public function ApolloQuery(path:String, callback:Function):void {

			super(path, callback);

		}

		/**
		 * 	Starts a filesystem query
		 */		
		override public function load(filter:FileFilter, thumbnail:Boolean):void {
			
			super.filter = filter;
			
			if (thumbnail) {
				
				// store the db (this is how we'll know later whether to thumbnail the swfs or not)
				_db = new ONXThumbnailDB(path);
					
				// first check for thumbnail cache
				var db:flash.filesystem.File = new flash.filesystem.File(path + '\\thumbs.onx');
				
				// if it exists, first wait for the db to load
				if (db.exists) {
					
					var stream:FileStream = new FileStream();
					stream.addEventListener(Event.COMPLETE, _onDBComplete);
					stream.addEventListener(IOErrorEvent.IO_ERROR, _onDBComplete);
					stream.openAsync(db, FileMode.READ);
					
					return;
				} 
			}
			
			// start the file query
			_beginQuery();
		}
		
		/**
		 * 	@private
		 */
		private function _onDBComplete(event:Event):void {
			var stream:FileStream = event.currentTarget as FileStream;
			stream.removeEventListener(Event.COMPLETE, _onDBComplete);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, _onDBComplete);
			
			if (!(event is ErrorEvent)) {

				// load thumbnail data from the database
				_db.load(stream);
				
			}

			// close the file stream
			stream.close();
			
			// query the directory now
			_beginQuery();
		}		
		
		/**
		 * 	@private
		 */
		private function _beginQuery():void {
			
			super.filter = filter;

			// get our filesys path
			var folder:flash.filesystem.File = new flash.filesystem.File(path);
			
			// get directory
			folder.addEventListener(FileListEvent.DIRECTORY_LISTING, _onDirectoryList);
			folder.listDirectoryAsync();
			
		}
		
		override public function save(bytes:ByteArray):void {
			
			var f:flash.filesystem.File = new flash.filesystem.File(path);
			var stream:FileStream = new FileStream();
			stream.open(f, FileMode.WRITE);
			stream.writeBytes(bytes);
			
		}

		/**
		 *	@private
		 *	Handler for when diretory is queried
		 */
		private function _onDirectoryList(event:FileListEvent):void {

			var folder:flash.filesystem.File = event.currentTarget as flash.filesystem.File;

			// clean reference
			folder.removeEventListener(FileListEvent.DIRECTORY_LISTING, _onDirectoryList);

			// create our onyx folder object
			var list:FolderList		= new FolderList(path);
			var directory:Array		= event.files;
			
			var dbChanged:Boolean	= false;

			// push the parent diretory
			list.folders.push(new onyx.file.Folder(folder.parent.url));
			
			// loop through files and folders
			for each (var fileObj:flash.filesystem.File in directory) {
				
				var path:String = fileObj.url;
				
				// push folders					
				if (fileObj.isDirectory) {
					
					list.folders.push(
						new onyx.file.Folder(path)
					);
				
				// push files
				} else {
					
					// check to see if it's a db file
					if (fileObj.name !== 'thumbs.onx') {
						
						// check to see if it's in the database already, if not, load it
						switch (getExtension(path)) {
							case 'png':
							case 'jpeg':
							case 'jpg':
							case 'swf':
							case 'flv':
							
								list.files.push(
									new onyx.file.File(path)
								);
								break;
						}
					}
					
				}
			}
			
			// if db exists, we should try to thumbnail swfs
			if (_db) {
				
				var jobs:Array = [];
				
				// now we should loop through and see if the database contains the thumbs
				for each (var checkfile:onyx.file.File in list.files) {
					
					var thumbnail:BitmapData = _db.getThumbnail(checkfile.path);
					
					if (!thumbnail) {
						jobs.push(checkfile);
					} else {
						checkfile.thumbnail.bitmapData = thumbnail;
					}
				}
				
				if (jobs.length) {
					var job:ApolloThumbnailJob = new ApolloThumbnailJob(_db, jobs);
					job.initialize();
				}
				
			}

			// we're done, send it over			
			super.folderList = list;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}