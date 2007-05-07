/** 
 * Copyright (c) 2007, www.onyx-vj.com
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
 	import flash.net.XMLSocket;
 	import flash.utils.*;
 	
 	import onyx.core.Console;
 	import onyx.errors.INVALID_CLASS_CREATION;
 	import onyx.events.*;

	public class NthPersistentClient extends NthClient {
		
		/**
		 * 	@private
		 */
		private static var fingers:Object		= new Object();
		
		/**
		 * 	@private
		 */
		private var _timer:Timer;

		/**
		 * 	@private
		 */
		private var _myConnected:Boolean = false;

		/**
		 * 	@private
		 */
		private var _connections:int = 0;

		/**
		 * 	@private
		 */
		private var _attempts:int = 0;
		
		/**
		 * 	@constructor
		 */
		public function NthPersistentClient():void {
			configureListeners();
			_tryConnect();
			
			super();
		}
		
		/**
		 *	@private
		 */
		private function _tryConnect():void {
	    	_attempts += 1;
			super.connect("localhost", 1383);
		}
		
	    override protected function connectHandler(event:Event):void {
        	_myConnected = true;
        	_connections += 1;
	    }
	    
		override protected function closeHandler(event:Event):void {
			_myConnected = false;
			_scheduleReconnect();
		}
	     
		private function _scheduleReconnect():void {
			// trace("NthClient - scheduling a reconnect");
			_timer = new Timer(1000,1);
			_timer.addEventListener(TimerEvent.TIMER, _tryReconnect);
			_timer.start();
			// super.closeHandler(event);
	    }
	    
		override protected function ioErrorHandler(event:IOErrorEvent):void {
	    	if ( ! this._myConnected ) {
				if ( _connections == 0 && _attempts <= 1 ) {
					trace("ioErrorHandler in NthEventClient! e=",event);
					Console.output("Unable to connect to NthEvent server, is it running?");
				}
	  			_scheduleReconnect();  		
	    	}
		}
	    
	    private function _tryReconnect(event:Event): void {
			_timer.removeEventListener(TimerEvent.TIMER, _tryReconnect);
			_timer.stop();
			_timer = null;
	    	_tryConnect();
	    }
	}
}