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
package onyx.file {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.ByteArray;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.utils.*;
	import onyx.utils.string.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Core File Class
	 */
	public final class File {
		
		/**
		 * 	The default thumbnail
		 */
		public static const DEFAULT_BITMAP:BitmapData	= new BitmapData(46,35, false, 0x000000);
		
		/** @private **/
		public static var CAMERA_ICON:BitmapData;
		
		/** @private **/
		public static var VISUALIZER_ICON:BitmapData;
		
		/**
		 * 
		 */
		public static var startupFolder:String;
		
		/**
		 * 	@private
		 * 	Cache for the paths
		 */
		private static var _cache:Object		= {};
		
		/**
		 * 	@private
		 * 	Store the file adapter
		 */
		onyx_ns static var _adapter:FileAdapter;
		
		/**
		 * 	Gets file name from a path
		 */
		public static function getFileName(path:String):String {
			return _adapter.getFileName(path);
		}

		/**
		 * 	Queries the filesystem
		 */
		public static function query(folder:String, callback:Function, filter:FileFilter = null, refresh:Boolean = false, thumbnail:Boolean = false):void {
			
			// check for cache
			if (refresh || !_cache[folder]) {
				
				if (folder.substr(0,13) === 'onyx-query://') {
					
					// query default objects (such as visualizers, cameras, etc)
					_queryPlugins(folder);
					
				} else {
					var query:FileQuery = _adapter.query(folder, callback);
					query.addEventListener(Event.COMPLETE,						_onLoadHandler);
					query.addEventListener(IOErrorEvent.IO_ERROR,				_onLoadHandler);
					query.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onLoadHandler);
					
					return query.load(filter, thumbnail);
				}
			}

			// execute callback
			doCallBack(callback, _cache[folder], filter);
		}
		
		/**
		 * 	@private
		 */
		private static function _queryPlugins(lookup:String):void {
			
			var list:FolderList = new FolderList(lookup);
			var files:Array		= list.files;
			var type:String		= lookup.substr(13, lookup.length);
			
			var file:File, plugin:Plugin;
			
			switch (type) {
				
				// return cameras
				case 'cameras':

					var plugins:Array = AVAILABLE_CAMERAS;

					for each (var name:String in plugins) {
						
						file = new File('onyx-camera://' + name);
						file.thumbnail.bitmapData = CAMERA_ICON;
						files.push(file);
					}
					
					break;
				
				// return visualizers
				case 'visualizers':
				
					plugins = Visualizer.visualizers;
					
					for each (plugin in plugins) {
						file = new File('onyx-visualizer://' + plugin.name);
						file.thumbnail.bitmapData = VISUALIZER_ICON;
						files.push(file);
					}
				
					break;
			}

			// save the cache
			_cache[lookup] = list;
		}
		
		/**
		 * 	Saves a bytearray to the filesystem
		 */
		public static function save(path:String, bytes:ByteArray, callback:Function):void {
			
			var query:FileQuery = _adapter.save(path, callback);
			
			// listen for a save
			query.addEventListener(Event.COMPLETE, _onSaveHandler);
			
			// save
			query.save(bytes);
			
		}
		
		/**
		 * 	@private
		 */
		private static function _onSaveHandler(event:Event):void {
			
			// get query
			var query:FileQuery = event.currentTarget as FileQuery;
			
			// remove listener
			query.removeEventListener(Event.COMPLETE, _onSaveHandler);

			// execute the callback			
			query.callback(query);
			
			// destroy the query
			query.dispose();
		}
		
		/**
		 * 	@private
		 */
		private static function _onLoadHandler(event:Event):void {
			
			var query:FileQuery = event.currentTarget as FileQuery;
			
			// remove handlers
			query.removeEventListener(Event.COMPLETE,						_onLoadHandler);
			query.removeEventListener(IOErrorEvent.IO_ERROR,				_onLoadHandler);
			query.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onLoadHandler);
			
			// check for error
			if (!(event is ErrorEvent)) {
				
				// save the path
				_cache[query.path] = query.folderList;
				
				// do the callback
				doCallBack(query.callback, query.folderList, query.filter);
				
			} else {
				
				var error:ErrorEvent = event as ErrorEvent;
				Console.error(new Error(error.text));
				
				// do the callback
				doCallBack(query.callback);
				
			}

			// clear reference
			query.dispose();
		}
		
		/**
		 * 	@private
		 */
		private static function doCallBack(callback:Function, list:FolderList = null, filter:FileFilter = null):void {
			
			if (filter && list) {
				var list:FolderList = list.clone(filter);
			}
			
			// call the callback
			callback(list);
		}
		
		/**
		 * 	Saves the path
		 */
		public var path:String;
		
		/**
		 * 	Saves thumbnail
		 */
		public var thumbnail:Bitmap;
		
		/**
		 * 	@constructor
		 */
		public function File(path:String):void {
			this.path		= path,
			this.thumbnail	= new Bitmap(DEFAULT_BITMAP, PixelSnapping.ALWAYS, false);
		}
		
		/**
		 * 	Gets extension
		 */
		public function get extension():String {
			return getExtension(path);
		}
	}
}