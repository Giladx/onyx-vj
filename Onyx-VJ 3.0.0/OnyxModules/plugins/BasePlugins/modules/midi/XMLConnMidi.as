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
package modules.midi {
	
	import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    
    import flash.net.XMLSocket;
    import flash.xml.XMLNode;

	import onyx.core.Console;
	import onyx.midi.Midi;
	import onyx.plugin.Module;
	
	/**
	 * 	This is a debugger class for using a XMLsocket-based midi adapter
	 */
	public final class XMLConnMidi extends Module {
		
		/**
		 * 	@private
		 */
		private var conn:XMLSocket;
		
		/**
		 * 	@private
		 */
		private var debugger:MidiDebugger;
		
		/**
		 * 	Turn on the module
		 */		
		override public function initialize():void {

			conn	= new XMLSocket();

		    conn.addEventListener(Event.CONNECT, handleSocketConnected);
            conn.addEventListener(DataEvent.DATA, handleSocketData);
            conn.addEventListener(IOErrorEvent.IO_ERROR, handleSocketIOError);
            conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSocketSecurityError);
            try{
                conn.connect("127.0.0.1", 10000);
                Console.output('MIDI Module : connected');
            } catch (e : SecurityError) {
                Console.output('MIDI Module : security error');
            }
        }
	
		/**
		 * 
		 */
		private function handleSocketConnected(e : Event) : void {
            Console.output('MIDI Module : connected');
        }
        
        private function handleSocketIOError(e : IOErrorEvent) : void {
        	Console.output("MIDI Module : unable to connect, socket error");
        }
        
        private function handleSocketSecurityError(e : SecurityErrorEvent) : void {
            Console.output('MIDI Module : security error');
        }
        
		private function handleSocketData(e : DataEvent) : void {
			
		    var data : XML = new XML(e.data);
            
            switch(data.name().toString()){
                case "c":
                    // 0xB0 is a "control change"
                    // Receives a n attr
                    // Receives a d attr
                    //                 //devindex  //0xb0 
                    Midi.receiveMessage(1, 0xB0, uint(parseInt(data.@n)), data.@d);
                break;
                
                case "n1":
                    // 0x90 is a "note on" ?????
                    // Receives a p attr
                    // Receives a v attr
                    var p : int = int(parseInt(data.@p));
                    Midi.receiveMessage(1, 0x90, int(parseInt(data.@p)), data.@v);
                    //var noteEvent : NoteEvent = new NoteEvent(NoteEvent.NOTE_ON, p);
                    //noteEvent.velocity = MidiManager.$midiValueHashTable[data.@v];
                    //this.dispatchEvent(noteEvent);
                break;
                
                case "n0":
                    // Receives a p attr
                    var pitchOff : int = int(parseInt(data.@p));
                    //var noteOffEvent : NoteEvent = new NoteEvent(NoteEvent.NOTE_OFF, pitchOff);
                    //noteOffEvent.velocity = 0;
                    //this.dispatchEvent(noteOffEvent);
                break;
                
                case "p":
                    // Receives a n attr
                    //dispatchEvent(new ProgramChangeEvent(ProgramChangeEvent.PROGRAM_CHANGE, uint(parseInt(data.@n))));
                break;
            }
            
        }
		
		/**
		 * 
		 */
		override public function command(... args:Array):String {
			
			var command:String = args.shift();
			
			switch (command) {
				case 'debug':
				
					if (debugger) {
						debugger.stop();
						debugger = null;
					} else {
						debugger = new MidiDebugger(args[0] || 0, args[1] || 0xb0);
						debugger.start()
					}
					
					return 'DEBUG ' + (debugger ? ' STARTED' : 'STOPPED');
			}
			
			return 'COMMANDS:\nRECEIVE device command # #\n SENDS A DEBUG MIDI EVENT\n';
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			conn.close();
			super.dispose();
		}
		
	}
}

import onyx.constants.*;
import onyx.midi.*;
import flash.events.Event;

final class MidiDebugger {
	
	public var deviceIndex:int;
	public var command:int;
	
	public function MidiDebugger(deviceIndex:int, command:int):void {
		this.deviceIndex	= deviceIndex,
		this.command		= command;
	}
	
	public function start():void {
		STAGE.addEventListener(Event.ENTER_FRAME, sendMessage);
	}
	
	private function sendMessage(event:Event):void {
		Midi.receiveMessage(deviceIndex, command, Math.random() * 127 >> 0, Math.random() * 127 >> 0); 
	}
	
	public function stop():void {
		STAGE.removeEventListener(Event.ENTER_FRAME, sendMessage);
	}
		
}