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
	
	import flash.net.*;
	
	import onyx.errors.*;

	/**
	 * 	Core NetConnection Class
	 */
	public class Connection extends NetConnection {
		
		/**
		 * 	Stores the default connection for all netconnections
		 */
		internal static const DEFAULT_CONNECTION:Connection = new Connection();
		
		/**
		 * 	@private
		 */
		private static const HOSTS:Object = {};
		
		/**
		 * 	Returns a connection for a given host name
		 * 	Creates one if one doesn't exist
		 */
		public static function getConnection(host:String):Connection {
			if (host) {
				var conn:Connection = HOSTS[host];
				if (!conn) {
					conn = new Connection(host);
					HOSTS[host] = conn;
				}
				return conn;
			} else {
				return DEFAULT_CONNECTION;
			}
		}
		
		/**
		 * 	@constructor
		 */
		public function Connection(server:String = null):void {
			
			objectEncoding = ObjectEncoding.AMF0;
			connect(server);
		}
	}
}