/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package onyx.asset {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.media.*;
	import flash.utils.ByteArray;
	
	import onyx.plugin.*;
	import onyx.utils.file.*;
	
	import ui.states.*;
	
	/**
	 * 
	 */
	public final class AIRDirectoryQuery extends AssetQuery {
		
		/**
		 * 	@private
		 */
		public var db:AIRThumbnailDB;
		
		/**
		 * 
		 */
		internal var list:Array;
		
		/**
		 * 
		 */
		private var files:Array;
		
		/**
		 * 
		 */
		public function AIRDirectoryQuery(path:String, callback:Function):void {
			
			// super
			super(path, callback);
			
			// query
			query();
			
		} 
		
		/**
		 * 	@private
		 */
		public function query():void {
			
			list = [];

			var file:File	= AIR_ROOT.resolvePath(path);
			
			// grab files
			file.addEventListener(FileListEvent.DIRECTORY_LISTING, fileHandler);
			file.getDirectoryListingAsync();
		}
		
		/**
		 * 
		 */
		private function fileHandler(event:FileListEvent):void {
			var file:File = event.currentTarget as File;
			file.removeEventListener(FileListEvent.DIRECTORY_LISTING, fileHandler);
			
			var files:Array = event.files;
			var dbFile:File	= file.resolvePath('.ONXThumbnails');
			
			db	= new AIRThumbnailDB();
			
			if (path.length > ONYX_LIBRARY_PATH.length) {
				
				list.push(new AIRAsset(AIR_ROOT.resolvePath(path).parent))
				
			}

			// if db file, load			
			if (dbFile.exists) {
				this.files = files;

				var stream:FileStream = new FileStream();
				stream.addEventListener(Event.COMPLETE, dbHandler);
				stream.openAsync(dbFile, FileMode.READ);
				
				return;
			}
							
			// create and queue
			createWithoutDB(files);

			// execute the callback immediately
			callback(this, list);
		}
		
		/**
		 * 
		 *
		 */
		private function dbHandler(event:Event):void {
			var stream:FileStream = event.currentTarget as FileStream;
			stream.removeEventListener(Event.COMPLETE, dbHandler);
			
			var bytes:ByteArray = new ByteArray();
			stream.readBytes(bytes);
			stream.close();
			
			db.load(bytes);

			// create and auto thumbnail
			createWithDB(files);
			files = null;

			// execute the callback
			callback(this, list);
		}
		
		/**
		 * 	@private
		 */
		private function createWithDB(files:Array):void {
			
			var jobs:Array = [];
		
			// add files				
			for each (var file:File in files) {

				if (file.isDirectory || valid(file)) {
					var data:BitmapData = db.getThumbnail(getRelativePath(AIR_ROOT, file));
					var asset:AIRAsset	= new AIRAsset(file, data);
					
					// add to the list
					list.push(asset);
					
					// queue it for thumbnailing
					if (!data && !file.isDirectory) {
						jobs.push(asset);
					}
				}
			}

			if (jobs.length) {
				StateManager.loadState(new AIRThumbnailState(AIR_ROOT.resolvePath(path), db, jobs));
			}
		}
		
		/**
		 *	@private 
		 */
		private function createWithoutDB(files:Array):void {

			var asset:OnyxFile, jobs:Array;
			
			jobs = [];

			// add files				
			for each (var file:File in files) {

				if (file.isDirectory || valid(file)) {
					asset = new AIRAsset(file);
					list.push(asset)
					
					if (!file.isDirectory) {
						jobs.push(asset);
					}
				}
				
			}
			
			if (jobs.length) {
				StateManager.loadState(new AIRThumbnailState(AIR_ROOT.resolvePath(path), db, jobs));
			}
		}
		
		/**
		 * 
		 */
		private function valid(file:File):Boolean {
			switch (file.extension) {
				case 'onr':
				case 'swf':
				case 'onx':
				case 'mix':
				case 'flv':
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'mp3':
				case 'm4v':
				case 'mov':
				case 'mp4':
				case 'mpg':
				case 'mpeg':
				case '3gp':	
				case 'xml':
					return file.name !== '.ONXThumbnails';
					break;
			}
			return false;
		}
	}
}