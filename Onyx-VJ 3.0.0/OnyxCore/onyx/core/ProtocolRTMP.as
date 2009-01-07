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
package onyx.core {
	
	import flash.events.*;
	import flash.media.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.file.Protocol;
	import onyx.net.*;
	import onyx.plugin.*;
	import onyx.utils.string.*;
	
	/**
	 * 	Protocol for default onyx types
	 */
	internal final class ProtocolRTMP extends Protocol {
		
		public var file:String;
		
		/**
		 *	@constructor 
		 */
		public function ProtocolRTMP(path:String, callback:Function, layer:ILayer):void {
			super(path, callback, layer);
		}
		
		/**
		 * 
		 */
		override public function resolve():void {
			
			var match:Array		= path.match('rtmp://(.*/.*/)');
			var server:String	= match[0];
			file				= removeExtension(path.replace(match[1], ''));
			
			var conn:Connection	= Connection.getConnection(server);
			
			if (!conn.connected) {
				conn.addEventListener(NetStatusEvent.NET_STATUS, connectHandler);
			} else {
				connectHandler(null, conn);
			}
		}
		
		/**
		 * 	@private
		 */
		private function connectHandler(event:NetStatusEvent = null, conn:Connection = null):void {
			
			var conn:Connection = conn || event.currentTarget as Connection;
			
			if (event) {
				
				if (!(event.info.code == 'NetConnection.Connect.Success')) {
					return dispatchContent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
				}
			}
			
			var stream:Stream = new Stream(file, conn);
			stream.addEventListener(Event.COMPLETE, streamHandler);
		}
		
		/**
		 * 	@private
		 */
		private function streamHandler(event:Event):void {
			var stream:Stream = event.currentTarget as Stream;
			stream.removeEventListener(Event.COMPLETE, streamHandler);
			
			dispatchContent(new Event(Event.COMPLETE), new ContentFLV(layer, path, stream))
		}
	}
}