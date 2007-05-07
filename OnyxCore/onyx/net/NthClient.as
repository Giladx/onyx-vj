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
 	import flash.net.*;
 	import flash.utils.*;
 	
 	import onyx.core.Console;
 	import onyx.errors.*;
 	import onyx.events.*;
 	import onyx.midi.IMidiDispatcher;
 	
 	/**
 	 * 
 	 */
	public class NthClient extends XMLSocket implements IMidiDispatcher {
		
		/**
		 * 	@private
		 */
	 	static private var warned:Boolean = false;
	 	
	 	/**
	 	 * 	@constructor
	 	 */
	 	public function NthClient():void {
	 	}
		
		protected function configureListeners():void {
	        this.addEventListener(Event.CLOSE, closeHandler);
	        this.addEventListener(Event.CONNECT, connectHandler);
	        this.addEventListener(DataEvent.DATA, dataHandler);
	        this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        this.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	        this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	    }
	    
	    protected function closeHandler(event:Event):void {
			// removeListeners();
	    }
	    
	    protected function removeListeners():void {	        
	    	this.removeEventListener(Event.CLOSE, closeHandler);
	        this.removeEventListener(Event.CONNECT, connectHandler);
	        this.removeEventListener(DataEvent.DATA, dataHandler);
	        this.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        this.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
	        this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	    }
	    
		protected function connectHandler(event:Event):void {
	    }
	    
		protected function dataHandler(event:DataEvent):void {
		}

	    protected function ioErrorHandler(event:IOErrorEvent):void {
	        if (! this.connected && !warned) {
	        	Console.output("You need to start the NthEvent server...");
	        	warned = true;	// so we only do it once
	        } else {
		        trace("ioErrorHandler: " + event);
		    }
	    }
	
	    protected function progressHandler(event:ProgressEvent):void {
	        trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
	    }
	
	    protected function securityErrorHandler(event:SecurityErrorEvent):void {
	        trace("securityErrorHandler: " + event);
	    }
	}
}