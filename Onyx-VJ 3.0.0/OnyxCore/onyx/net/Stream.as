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
package onyx.net {
	
	import flash.events.*;
	import flash.net.NetStream;

	[Event(name='complete', type='flash.events.Event')]

	/**
	 * 	Base NetStream class
	 */
	public final class Stream extends NetStream {

		/**
		 * 	@private
		 */
		private static const REUSABLE:NetStatusEvent = new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false);

		/**
		 * 	Stores metadata for the stream
		 */
		public var metadata:Object;

		/**
		 * 	@private
		 */
		private var _path:String;
		
		/**
		 * 	@public
		 */
		public var connection:Connection;

		/**
		 * 	@constructor
		 */
		public function Stream(path:String, connection:Connection = null):void {
			_path = path;
			
			this.connection = connection || Connection.DEFAULT_CONNECTION
			
			super(this.connection);

			play(path);
		}
		
		/**
		 * 	Returns pathname 
		 */
		public function get path():String {
			return _path;
		}
		
		/**
		 * 	When metadata is returned, dispatch an event.complete event
		 */
		public function onMetaData(info:Object):void {
			
			metadata = info;
			
			// dispatch an event complete for a stream metadata event
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 	@private
		 * 	play Status
		 */
		public function onPlayStatus(info:Object):void {
			
			REUSABLE.info = info;
			
			// dispatch a client-side net status event
			dispatchEvent(REUSABLE);
		}

	}
}