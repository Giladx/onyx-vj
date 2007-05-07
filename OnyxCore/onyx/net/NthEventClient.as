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
 	import onyx.midi.IMidiDispatcher;

	/**
	 * 	NthEvent Client - passes midi events over to MIDI
	 */
	public class NthEventClient extends NthPersistentClient implements IMidiDispatcher {
		
		/**
		 * 	@private
		 */
		private static const instance:NthEventClient	= new NthEventClient();

		/**
		 * 	@private
		 */
		private static var fingers:Object		= new Object();

		/**
		 * 	@constructor
		 */
		public function NthEventClient() {
			
			super();

			// We only want one of these to be active - it sits waiting for
			// the next event from the NthServer, and as soon as an event comes in,
			// it requests the next one.
			if ( instance ) {
				throw INVALID_CLASS_CREATION;
			}
		}
		
		public static function getInstance():NthEventClient {
			return instance;
		}
		
	    override protected function connectHandler(event:Event):void {
        	super.connectHandler(event);
        	Console.output("NthEventClient is connected to NthServer...");
	        requestNextEvent();
	    }
	    
	    protected function requestNextEvent():void {
	     	this.send("<next_event/>");
	    }
	
		override protected function dataHandler(event:DataEvent):void {
	        var x:XML = new XML(event.data);
	        if ( x.localName() == "event" ) {
	        	var tm:Number = x.attribute("time");
	        	var c:XMLList = x.children()
	        	for each ( var x2:XML in c ) {
	        		var s:String = x2.localName();
	        		if ( s.search("finger_") == 0 ) {
	        			var f:FingerEvent = new FingerEvent(s.substr(7),tm,x2);
	        			updateFingers(f);
	        			dispatchEvent(f);
	        		} else if ( s.search("midi_") == 0 ) {
	        			var m:MidiEvent = new MidiEvent(s.substr(5),tm,x2);
	        			dispatchEvent(m);
	        		}
	        	}
	        }
	       	requestNextEvent();
	    }
	    
		override protected function closeHandler(event:Event):void {
			Console.output("NthEventClient has been disconnected...");
			super.closeHandler(event);
		}
	     
	    private function updateFingers(f:FingerEvent):void {
				fingers[f.fingerUID()] = new FingerState(f);
	    }
	    
	    public function getFingerStates():Object {
			return fingers;
	    }
	}
}