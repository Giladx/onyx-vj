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
	
	import flash.net.LocalConnection;
	
	import onyx.core.Console;
	import onyx.midi.Midi;
	import onyx.plugin.Module;
	
	/**
	 * 	This is a debugger class for using a localconnection-based midi adapter
	 */
	public final class LocalConnMidi extends Module {
		
		/**
		 * 	@private
		 */
		private var conn:LocalConnection;
		
		/**
		 * 	@private
		 */
		private var debugger:MidiDebugger;
		
		/**
		 * 	Turn on the module
		 */		
		override public function initialize():void {

			conn	= new LocalConnection();

			conn.client	= this;

			connect();
		}
		
		/**
		 * 
		 */
		private function connect():void {
			try {
				conn.connect('/onyx/debug/');
			} catch (e:Error) {
				Console.error(e);
			}
		}
		
		/**
		 * 
		 */
		public function onData(data:String):void {
			
			var parse:Array, device:int, command:int, valueA:int, valueB:int;
			
			// parse the message
			parse	= data.split(',');
			
			// send a message through onyx
			Midi.receiveMessage(parse[1], parse[3], parse[4], parse[5]);
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
	
	/**
	 * 	@private
	 */
	private function sendMessage(event:Event):void {
		Midi.receiveMessage(deviceIndex, command, Math.random() * 127 >> 0, Math.random() * 127 >> 0); 
	}
	
	/**
	 * 
	 */
	public function stop():void {
		STAGE.removeEventListener(Event.ENTER_FRAME, sendMessage);
	}
		
}