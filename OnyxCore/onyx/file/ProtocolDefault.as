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
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	
	import onyx.content.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.net.*;
	import onyx.plugin.*;
	import onyx.utils.string.*;
	
	/**
	 * 
	 */
	public final class ProtocolDefault extends Protocol {
		
		/**
		 * 	@constructor
		 */
		public function ProtocolDefault(path:String, callback:Function, layer:ILayer):void {
			super(path, callback, layer);
		}
		
		/**
		 * 
		 */
		override public function resolve():void {
			
			var extension:String = getExtension(path);
		
			switch (extension) {
				case 'mp4':
				case 'm4v':
				case 'm4a':
				case 'mov':
				case '3gp':
				case 'flv':
					var stream:Stream = new Stream(path);
					stream.addEventListener(Event.COMPLETE,				_onStreamComplete);
					stream.addEventListener(NetStatusEvent.NET_STATUS,	_onStreamComplete);
					
					break;
					
				case 'mp3':
				
					var sound:Sound		= new Sound();
					sound.addEventListener(Event.COMPLETE, _onSoundHandler);
					sound.addEventListener(IOErrorEvent.IO_ERROR, _onSoundHandler);
					sound.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
					sound.load(new URLRequest(path));
					break;

				// load a loader if we're any other type of file
				case 'swf':

					// need to check for already loaded swf's of the same name (performance gain);
					var reg:ContentRegistration = ContentMC.registration(path);
				
				case 'gif':
				case 'jpg':
				case 'jpeg':
				case 'png':
				
					// check to see if it's to be a shared content object
					if (reg) {
						
						ContentMC.register(path);
						_createLoaderContent(reg.loader.contentLoaderInfo);
						
					} else {
						
						var loader:Loader = new Loader();
						
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,				_onLoadHandler);
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE,						_onLoadHandler);
						loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,				_onLoadProgress);
						loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onLoadHandler);
						
						loader.load(new URLRequest(path));
						
					}
					break;
			}
		}
		
		/**
		 * 	@private
		 * 	Handles events when a sound object retrieves it's ID3 information
		 */
		private function _onSoundHandler(event:Event):void {
			var sound:Sound = event.currentTarget as Sound;
			sound.removeEventListener(Event.COMPLETE, _onSoundHandler);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, _onSoundHandler);
			sound.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);

			dispatchContent(event, new ContentMP3(layer, path, sound));
		}
		
		/**
		 * 	@private
		 * 	Dispatched when a stream receives meta data
		 */
		private function _onStreamComplete(event:Event):void {
			
			var stream:Stream = event.currentTarget as Stream;

			if (event.type === Event.COMPLETE) {
				
				stream.removeEventListener(Event.COMPLETE, _onStreamComplete);
				stream.removeEventListener(NetStatusEvent.NET_STATUS, _onStreamComplete);
				
				dispatchContent(event, new ContentFLV(layer, path, stream));
				
			} else if (event is NetStatusEvent) {
				var status:NetStatusEvent = event as NetStatusEvent;

				if (status.info.code === 'NetStream.Play.StreamNotFound') {
					stream.removeEventListener(Event.COMPLETE, _onStreamComplete);
					stream.removeEventListener(NetStatusEvent.NET_STATUS, _onStreamComplete);
					
					dispatchContent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, 'File Not Found'));
				}
			}

		}
		
		/**
		 * 	@private
		 * 	Progress handler, forward the event
		 */
		private function _onLoadProgress(event:ProgressEvent):void {
			dispatchEvent(event);
		}
		
		/**
		 * 	@private
		 * 	Handler for loaded loaders
		 */
		private function _onLoadHandler(event:Event):void {
			
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			
			info.removeEventListener(IOErrorEvent.IO_ERROR,				_onLoadHandler);
			info.removeEventListener(Event.COMPLETE,					_onLoadHandler);
			info.removeEventListener(ProgressEvent.PROGRESS,			_onLoadProgress);
			info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onLoadHandler);
			
			if (event is ErrorEvent) {
				return dispatchContent(event);
			}
				
			if (getQualifiedClassName(info.content) === 'flash.display::MovieClip') {
				
				var reg:ContentRegistration = ContentMC.registration(path);
				
				// if something loaded before us, use it's loader instead of our own
				if (reg) {
					info = reg.loader.contentLoaderInfo;
				}
				
				ContentMC.register(path, info.loader);
			}

			// load it
			_createLoaderContent(info);
		}
		
		/**
		 * 	@private
		 */
		private function _createLoaderContent(info:LoaderInfo):void {
			
			var loader:Loader			= info.loader;
			var content:DisplayObject	= loader.content;
			
			if (content is MovieClip) {
				var type:Class = ContentMC;
			} else if (content is IRenderObject) {
				type = ContentCustom;
			} else {
				type = ContentSprite;
			}
			
			//contentEvent.contentType(this, contentEvent.path, contentEvent.reference)
			dispatchContent(new Event(Event.COMPLETE), new type(layer, path, loader));
		}
	}
}