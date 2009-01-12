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
	import flash.media.*;
	import flash.utils.ByteArray;
	
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.utils.event.*;
	
	[ExcludeSDK]
	
	/**
	 * 
	 */
	public class AssetFile {
		
		/**
		 * 	@private
		 */
		private static const cache:Object	= {};
		
		/**
		 * 	@private
		 */
		private static var adapter:IAssetAdapter;
		
		/**
		 * 
		 */
		public static function initialize(plugin:IAssetAdapter):void {
			adapter = plugin;
		}

		/**
		 * 
		 */
		public static function queryDirectory(path:String, callback:Function):void {
			switch (path) {
				case 'onyx-query://cameras':
				
					callback(
						new AssetQuery(path, callback),
						cache[path] || buildCameras()
					);
					
					break;
				default:
					adapter.queryDirectory(path, callback);
					break;
			}
		}
		
		/**
		 * 	@private
		 */
		public static function resolvePath(path:String):String {
			return adapter.resolvePath(path);
		}  
		
		/**
		 * 	@private
		 */
		private static function buildCameras():Array {
			var list:Array = [];
			for each (var name:String in Camera.names) {
				list.push(new CameraAsset(name));
			}
			cache['onyx-query://cameras'] = list;
			return list;
		}
		
		/**
		 * 	Callback is:
		 */
		public static function queryContent(path:String, callback:Function, layer:LayerImplementor, settings:LayerSettings, transition:Transition):void {
			var index:int		= path.indexOf('://');
			if (index > 4) {
				switch (path.substr(0, index)) {
					case 'camera':
						callback(EVENT_COMPLETE, new ContentCamera(layer, path, Camera.getCamera(String(Camera.names.indexOf(path.substr(index + 3))))), settings, transition);
						return;
				}
			}
			
			// fall through to the adapter
			adapter.queryContent(path, callback, layer, settings, transition);
		}
		
		/**
		 * 
		 */
		public static function queryFile(path:String, callback:Function):void {
			adapter.queryFile(path, callback);
		}
		
		/**
		 * 
		 */
		public static function save(path:String, callback:Function, bytes:ByteArray, extension:String):void {
			adapter.save(path, callback, bytes, extension); 
		}
		
		/**
		 * 
		 */
		public static function browseForSave(callback:Function, title:String, bytes:ByteArray, extension:String):void {
			adapter.browseForSave(callback, title, bytes, extension)
		}
		
		/**
		 *	Store a thumbnail 
		 */
		public const thumbnail:Bitmap = new Bitmap();
		
		/**
		 * 
		 */
		public function get name():String {
			return null;
		}
		
		/**
		 * 
		 */
		public function get path():String {
			return null;
		}
		
		/**
		 * 
		 */
		public function get extension():String {
			return null;
		}
		
		/**
		 * 
		 */
		public function get isDirectory():Boolean {
			return false;
		}
	}
}