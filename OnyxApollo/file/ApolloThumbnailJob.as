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
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import onyx.file.File;
	import onyx.jobs.Job;
	import onyx.utils.string.*;
	import flash.geom.Matrix;

	public final class ApolloThumbnailJob extends Job {
		
		/**
		 * 	@private
		 */
		private var db:ONXThumbnailDB;
		
		/**
		 * 	@private
		 */
		private var files:Array;
		
		/**
		 * 	@private
		 */
		private var jobs:Array;
		
		/**
		 * 	@constructor
		 */
		public function ApolloThumbnailJob(db:ONXThumbnailDB, files:Array):void {
			this.db		= db,
			this.files	= files,
			this.jobs	= [];
		}
		
		override public function initialize(...args):void {
			
			for each (var checkfile:onyx.file.File in files) {
				switch (getExtension(checkfile.path)) {
					case 'jpg':
					case 'swf':
					case 'png':
					case 'jpeg':
					
						var loader:ThumbLoader = new ThumbLoader(checkfile);
						jobs.push(loader);
					
						break;
				}
			}
			
			_nextQueue();
		}
		
		private function _nextQueue():void {
			var loader:ThumbLoader = jobs.shift() as ThumbLoader;
			
			if (loader) {
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onComplete);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
				loader.load(new URLRequest(loader.file.path));
			} else {
				if (files.length) {
					trace('saving thumbnails');
					db.save();
				}
			}
		}
		
		private function _onComplete(event:Event):void {
			var info:LoaderInfo		= event.currentTarget as LoaderInfo;
			var loader:ThumbLoader	= info.loader as ThumbLoader;
			
			info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onComplete);
			info.removeEventListener(IOErrorEvent.IO_ERROR, _onComplete);
			info.removeEventListener(Event.COMPLETE, _onComplete);
			
			var width:int	= 46;
			var height:int	= 35;
			
			var matrix:Matrix	= new Matrix();
			var bmp:BitmapData	= new BitmapData(width, height ,false, 0);

			matrix.scale(width / loader.width, height / loader.height);

			bmp.draw(loader, matrix);

			loader.file.thumbnail.bitmapData = bmp;
			
			loader.unload();
			
			db.addFile(loader.file.path, bmp);
			
			_nextQueue();
		}
	}
}

import flash.display.Loader;
import onyx.file.File;

final class ThumbLoader extends Loader {
	
	public var file:File;
	
	public function ThumbLoader(file:File):void {
		this.file = file;
	}
}

/*
package onyx.file.http {
	
	import flash.display.Loader;
	import flash.events.*;
	
	import onyx.file.File;
	import onyx.jobs.Job;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;

	public final class HTTPThumbnailJob extends Job {
		
		private var paths:Array;
		private var files:Array;
		
		public function HTTPThumbnailJob(paths:Array, files:Array):void {
			this.paths = paths;
			this.files = files;
		}
		
		override public function initialize(...args):void {
			
			while (paths.length) {
				var path:String = paths.shift() as String;
				var file:File = files.shift() as File;
				
				var loader:ThumbLoader = new ThumbLoader(file);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onComplete);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
				loader.load(new URLRequest(path));
			}
		}
		
		private function _onComplete(event:Event):void {
			var info:LoaderInfo		= event.currentTarget as LoaderInfo;
			var loader:ThumbLoader	= info.loader as ThumbLoader;
			
			info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onComplete);
			info.removeEventListener(IOErrorEvent.IO_ERROR, _onComplete);
			info.removeEventListener(Event.COMPLETE, _onComplete);
			
			var content:Bitmap = loader.content as Bitmap;
			if (content) {
				loader.file.thumbnail.bitmapData = content.bitmapData;
			}
			
			loader.unload();
		}
		
	}
}

import flash.display.Loader;
import onyx.file.File;

*/