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
	
	import flash.events.*;
	import flash.media.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.net.*;
	import onyx.plugin.*;
	import onyx.utils.string.*;
	
	/**
	 * 	Protocol for default onyx types
	 */
	public final class ProtocolVLC extends Protocol {
		
		public var file:String;
		
		/**
         *  @private 
         */
		private var _client:Object;
		
		/**
		 *	@constructor 
		 */
		public function ProtocolVLC(path:String, callback:Function, layer:ILayer):void {
			
			// direct access to VLC client from VLCModule
			_client = Module.modules['VLC'].client;
			
			super(path, callback, layer);
			
		}
		
		/**
		 * 
		 */
		override public function resolve():void {
			
			// verify if VLC is connected 
			if (!_client.isConnected) {
				
				Console.output('VLC is not connected');
				dispatchContent(new Event(Event.COMPLETE), new ContentNull());
			
			}
			
			path = path.split('vlc://')[1];
			
			// VLC does not like spaces... (maybe better to avoid file names with spaces)
			file = removeExtension(path).split(' ').join('_');
			
			var server:String	= _client.serverURL;
			// broadcast/vod ...with vod cannot retrieve totaltime
            var media:String    = 'broadcast';
            			
			// TODO: verify multiple names !!!!!!!!!!
			var pathVLC:String = 'http://'+ server + ':8081/' + file + '.flv';
                                                            
			// !!! absolutely specify the acodec or put --no-audio option in vlc         acodec=mp3,samplerate=44100
			Console.executeCommand('VLC new ' + file + ' ' + media + ' \"' + path + '\" #transcode{vcodec=FLV1}:std{access=http,dst=localhost:8081/' + file + '.flv} enabled');
			Console.executeCommand('VLC play ' + file);
						
			var stream:Stream = new Stream(pathVLC);
			stream.addEventListener(Event.COMPLETE, streamHandler);
			stream.addEventListener(NetStatusEvent.NET_STATUS, streamHandler);
			
		}
		
		/**
         *  @private
         */		
		private function streamHandler(event:Event):void {
			
			if (event is NetStatusEvent) {
				
                var status:NetStatusEvent = event as NetStatusEvent;
                //////
                //Console.output(status.info.code);
                               
            } else if (event is Event) {
                
                //Console.output(event.type);
                
                if(event.type === Event.COMPLETE) {
            	            	
            	   var stream:Stream = event.currentTarget as Stream;
                   stream.removeEventListener(Event.COMPLETE, streamHandler);
            
                   dispatchContent(new Event(Event.COMPLETE), new ContentVLC(layer, path, stream));
                
                }
            }
                
			
		}
	}
}