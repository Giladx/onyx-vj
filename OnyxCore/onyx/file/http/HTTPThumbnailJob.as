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
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	
	import onyx.core.*;
	import onyx.file.*;
	import onyx.jobs.Job;
	import onyx.utils.event.*;

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
				
				// create a thumbnail loader
				var loader:ThumbLoader = new ThumbLoader(file);
				
				// listen for ioerror, complete, security_error
				addStatusListeners(loader.contentLoaderInfo, _onComplete);
				
				// load
				loader.load(new URLRequest(FileBrowser.startupFolder + path));
			}
		}
		
		private function _onComplete(event:Event):void {
			var info:LoaderInfo		= event.currentTarget as LoaderInfo;
			var loader:ThumbLoader	= info.loader as ThumbLoader;
			
			removeStatusListeners(info, _onComplete);
			
			var content:Bitmap = loader.content as Bitmap;
			
			if (content) {
				var thumbnail:Bitmap	= loader.file.thumbnail;
				
				thumbnail.bitmapData	= content.bitmapData,
				thumbnail.width			= 46,
				thumbnail.height		= 35,
				thumbnail.smoothing		= false,
				thumbnail.pixelSnapping	= PixelSnapping.ALWAYS;
			}
			
			loader.unload();
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