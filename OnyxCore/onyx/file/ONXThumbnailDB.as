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
	
	import flash.display.BitmapData;
	import flash.utils.*;
	
	import onyx.core.Console;
	import onyx.file.*;
	
	/**
	 * 	Stores bytearray of files, and their associated thumbnails
	 */
	public final class ONXThumbnailDB {

		/**
		 * 	@private
		 */
		private var _files:Array		= [];
		
		/**
		 * 	@private
		 */
		private var _lookup:Dictionary	= new Dictionary(true);
		
		/**
		 * 	@private
		 */
		public var path:String;
		
		/**
		 * 	@constructor
		 */
		public function ONXThumbnailDB(path:String):void {
			this.path = path;
		}
		
		/**
		 * 	Adds a file to the db
		 */
		public function addFile(path:String, data:BitmapData):void {
			
			if (!_lookup[path]) {
				
				var def:FileDef = new FileDef(path, data);
				_lookup[path]	= def;
				_files.push(path);
				
			}
		}
		
		/**
		 * 	Loads database from bytearray
		 */
		public function load(bytes:IDataInput):void {
			
			try {
				
				while (bytes.bytesAvailable) {
					
					var thumbnail:ByteArray	= new ByteArray();
					var total:int		= bytes.readUnsignedInt();
					var path_length:int	= bytes.readUnsignedInt();
					var path:String		= bytes.readUTFBytes(path_length);
					var bmp:BitmapData	= new BitmapData(46,35,false,0);
					
					bytes.readBytes(thumbnail, 0, total - path_length - 8);
					bmp.setPixels(bmp.rect, thumbnail);
					
					addFile(path, bmp);
					
				}
				
			} catch (e:Error) {
				// trace(e);
			}
				
		}
		
		/**
		 * 
		 */
		public function getThumbnail(path:String):BitmapData {
			var def:FileDef = _lookup[path];
			return (def) ? def.thumbnail : null;
		}
		
		/**
		 * 
		 */
		public function get bytes():ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			for each (var def:FileDef in _lookup) {
				var thumbnail:ByteArray = def.thumbnail.getPixels(def.thumbnail.rect);
				bytes.writeUnsignedInt(thumbnail.length + def.path.length + 8);
				bytes.writeUnsignedInt(def.path.length);
				bytes.writeUTFBytes(def.path);
				bytes.writeBytes(thumbnail);
			}
			
			return bytes;
		}

		/**
		 * 
		 */
		public function get files():Array {
			return _files;
		}
		
		/**
		 * 	Saves the database
		 */
		public function save():void {
			
			var bytes:ByteArray = this.bytes;
			File.save(path + '/thumbs.onx', this.bytes, saveHandler);
			
		}
		
		/**
		 * 	@private
		 */
		private function saveHandler(query:FileQuery):void {
			Console.output(query.path + ' thumbnails saved.');
		}
		
		/**
		 * 
		 */
		public function updateFile():void {
		}
	}
}

import flash.utils.ByteArray;
import flash.display.BitmapData;

final class FileDef {
	
	/**
	 * 
	 */
	public var path:String;
	
	/**
	 * 
	 */
	public var thumbnail:BitmapData;
	
	/**
	 * 
	 */
	public function FileDef(path:String, thumbnail:BitmapData):void {
		this.path = path;
		this.thumbnail = thumbnail;
	}
	
}