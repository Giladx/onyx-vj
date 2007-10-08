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
package onyx.controls {

	import onyx.constants.*;
	import onyx.core.*;
	import onyx.events.ControlEvent;
	
	use namespace onyx_ns;

	/**
	 * 	Displays available tempo beats that the user-defined object can sync to.  Current values are: 16th note, eighth note, quarter note, half note, whole note.
	 * 
	 * 	@see onyx.core.IControlObject
	 */
	public final class ControlTempo extends ControlRange {
		
		/**
		 * 	@private
		 */
		private var _defaultvalue:uint;
		
		/**
		 * 
		 */

		/**
		 * 	@constructor
		 */
		public function ControlTempo(name:String, display:String, showGlobal:Boolean = true):void {
			
			super(name, display, showGlobal ? TEMPO_BEATS_GLOBAL : TEMPO_BEATS, 0, null);
			
		}

		/**
		 * 
		 */
		override public function dispatch(v:*):* {
			REUSABLE_EVENT.value = v;
			dispatchEvent(REUSABLE_EVENT);
			return v;
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			REUSABLE_EVENT.value = v; 
			dispatchEvent(REUSABLE_EVENT);
			_target[name] = v;
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlTempo;
		}
		
		/**
		 * 	Loads xml
		 */
		override public function loadXML(xml:XML):void {
			var beat:TempoBeat = TempoBeat.BEATS[xml.toString()];
			value = beat;
		}
	}
}