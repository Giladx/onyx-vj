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
package onyx.midi {
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import onyx.controls.*;
	import onyx.events.MidiEvent;
	
	/**
	 * 
	 */
	final public class Midi extends EventDispatcher {
		
		/**
		 * 	Instance
		 */
		public static const instance:Midi		= new Midi();
		
		/**
		 * 	@private
		 */
		private static const REUSABLE:MidiEvent	= new MidiEvent();
		
		/**
		 * 	@private
		 */
		private static var _map:Dictionary;
		
		/**
		 * 	@constructor
		 */
		public function Midi():void {
			if (instance) {
				throw new Error('');
			}
			
			_map = new Dictionary(false);
		}
		
		// RAW_DATA,0,1391,176,51,50
		// byte 1: device index
		// byte 2-3
		
		/**
		 * 
		 */
		public static function receiveMessage(deviceIndex:int, command:int, midiControl:int, value:int):void {
			
			var hash:uint, behavior:IMidiControlBehavior;
			
			// create the hash
			hash		= deviceIndex << 16 | command << 8 | midiControl;
			behavior	= _map[hash]; 

			if (behavior) {
				behavior.setValue(value);
			}
			
			if (instance.hasEventListener(MidiEvent.DATA)) {
			
				REUSABLE.deviceIndex	= deviceIndex,
				REUSABLE.command		= command,
				REUSABLE.control		= midiControl,
				REUSABLE.value			= value;
				
				instance.dispatchEvent(REUSABLE);
				
			}
		}	
		
		/**
		 * 
		 */
		public static function registerControl(control:Control, deviceIndex:int, command:int, midiControl:int):void {
			
			// based on the control and the command type, create behaviors
			var behavior:IMidiControlBehavior;

			// create the hash
			var hash:uint = deviceIndex << 16 | command << 8 | midiControl;
			
			/*	0x80: Note Off
				0x90: Note On
				0xa0: Polyphonic key pressure
				0xb0: control change
				0xc0: program change
				0xd0: key pressure
				0xe0: pitch wheel
				0xf0: System message
			*/
			switch (command) {
				
				// toggle messages -- need to add note on, note off behavior
				case 0x80:
				case 0x90:
				
					if (control is ControlExecute) {
						behavior = new ExecuteBehavior(control as ControlExecute);
					}

					_map[hash] = behavior;

					break;
					
				// slider value messages
				case 0xb0: // control change
				case 0xe0: // pitch wheel

					if (control is ControlNumber) {
						behavior = new NumericBehavior(control as ControlNumber);
					} else if (control is ControlRange) {
						behavior = new NumericRange(control as ControlRange);
					}
				
					_map[hash] = behavior;
			
					return;
					
				// system message -- what to do?
				case 0xf0:
					break;
			}
			
		}
	}
}