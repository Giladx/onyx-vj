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
	
	import onyx.core.onyx_ns;
	import onyx.events.ControlEvent;

	
	use namespace onyx_ns;
	
	/**
	 * 	Number Control that stores and constrains numeric values.
	 */
	public class ControlNumber extends Control {
		
		/**
		 * 	@private
		 */
		private var _min:Number;

		/**
		 * 	@private
		 */
		private var _max:Number;
		
		/**
		 * 	Multiplier
		 * 	100 will make 0.1 appear as 100 in the ui
		 */
		public var multiplier:Number;
		
		/**
		 * 	The sensitivity of the mouse
		 */
		public var factor:Number;
		
		/**
		 * 	@constructor
		 */
		public function ControlNumber(name:String, display:String, min:Number, max:Number, defaultvalue:Number, multiplier:Number = 100, factor:Number = 1):void {
			
			_min			= min,
			_max			= max,
			this.multiplier = multiplier,
			this.factor		= factor;
			
			super(name, display, defaultvalue);
		}
				
		/**
		 * 	Resets
		 */
		override public function reset():void {
			_target[name] = REUSABLE_EVENT.value = defaultValue;
			dispatchEvent(REUSABLE_EVENT);
		}
		
		/**
		 * 
		 */
		override public function dispatch(v:*):* {

			var value:Number = Math.min(Math.max(v, _min), _max);
			REUSABLE_EVENT.value = value;
			dispatchEvent(REUSABLE_EVENT);
			
			return value;
		}
		
		/**
		 * 	Returns min value
		 */
 		public function get min():* {
 			return _min;
 		}
 		
		/**
		 * 	Returns max value
		 */
 		public function get max():* {
 			return _max;
 		}
 		
 		/**
 		 * 
 		 */
 		override public function toXML():XML {
 			var xml:XML			= <{name} />;
 			var value:Number	= this.value;
 			
 			if (!isNaN(value)) {
 				xml.appendChild(value.toFixed(3));
 			}
 			
			return xml;
 		}
 		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlNumber;
		}
	}
}