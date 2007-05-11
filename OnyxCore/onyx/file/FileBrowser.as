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
package onyx.file {
	
	import flash.display.Loader;
	import flash.events.*;
	import flash.media.Camera;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.file.http.HTTPAdapter;
	import onyx.plugin.*;
	import onyx.settings.*;
	
	/**
	 * 	Stores a cache of directories - so re-querying will not be necessary
	 */
	final public class FileBrowser {

		/**
		 * 	@private
		 * 	Cache for the paths
		 */
		private static var _cache:Object = [];
		
		/**
		 * 	@private
		 * 	Store the file adapter
		 */
		private static var _adapter:FileAdapter;
		
		/**
		 * 	Returns initial directory
		 */
		public static function get initialDirectory():String {
			return _adapter.INITIAL_DIR;
		}
		
		/**
		 * 	Gets file name from a path
		 */
		public static function getFileName(path:String):String {
			return _adapter.getFileName(path);
		}
		
		/**
		 * 	initializes the adapter
		 */
		public static function initialize(adapter:FileAdapter):void {
			_adapter = adapter;
		}

		/**
		 * 	Queries the filesystem
		 */
		public static function query(folder:String, callback:Function, filter:FileFilter = null, refresh:Boolean = false):void {
			
			// check for cache
			if (refresh || !_cache[folder]) {
				
				if (folder.substr(0,ONYX_QUERYSTRING.length) === ONYX_QUERYSTRING) {
					
					// query plugins
					_queryPlugins(folder);
					
				} else {
					
					var query:FileQuery = _adapter.query(folder, callback);
					query.addEventListener(Event.COMPLETE,						_onLoadHandler);
					query.addEventListener(IOErrorEvent.IO_ERROR,				_onLoadHandler);
					query.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onLoadHandler);
					query.load(filter);
					
					return;
				}
				
			}

			// execute callback
			doCallBack(_cache[folder], callback, filter);
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
				doCallBack(query.folderList, query.callback, query.filter);
				
			} else {
				var error:ErrorEvent = event as ErrorEvent;
				Console.error(new Error(error.text));
				
			}

			// clear reference
			query.dispose();
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
						
						file = new File(ONYX_QUERYSTRING + 'camera://' + name, null);
						files.push(file);
					}
					
					break;
				
				// return visualizers
				case 'visualizers':
				
					plugins = Visualizer.visualizers;
					
					for each (plugin in plugins) {
						file = new File(ONYX_QUERYSTRING + 'visualizer://' + plugin.name, null);
						files.push(file);
					}
				
					break;
					
				case 'renderer':
				
					plugins = Renderer.renderers;
					
					for each (plugin in plugins) {
						file = new File(ONYX_QUERYSTRING + 'renderer://' + plugin.name, null);
						files.push(file);
					}
			}

			// save the cache
			_cache[lookup] = list;
		}
		
		/**
		 * 	@private
		 */
		private static function doCallBack(list:FolderList, callback:Function, filter:FileFilter = null):void {
			
			if (filter && list) {
				var list:FolderList = list.clone(filter);
			}
			
			// call the callback
			callback(list);
		}
	}
}