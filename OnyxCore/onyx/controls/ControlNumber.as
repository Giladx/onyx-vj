/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
	import onyx.utils.math.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Number Control
	 */
	public class ControlNumber extends Control {

		/**
		 * 	Default Factor
		 */
		public static const FACTOR:Object		= { multiplier: int(100) };
		
		/**
		 * 	@private
		 */
		private var _min:Number;

		/**
		 * 	@private
		 */
		private var _max:Number;
		
		/**
		 * 	@private
		 */
		protected var _defaultValue:Number;
		
		/**
		 * 	Multiplier
		 */
		public var multiplier:Number;
		
		/**
		 * 	@constructor
		 */
		public function ControlNumber(name:String, display:String, min:Number, max:Number, defaultvalue:Number, options:Object = null):void {
			
			_min = min;
			_max = max;
			_defaultValue = defaultvalue;
			
			super(name, display, options || FACTOR);
		}
				
		/**
		 * 	Resets
		 */
		override public function reset():void {
			_target[name] = _defaultValue;
			dispatchEvent(new ControlEvent(_defaultValue));
		}
		
		/**
		 * 
		 */
		public function defaultValue():Number {
			return _defaultValue;
		}
		
		/**
		 * 
		 */
		override public function setValue(v:*):* {

			var value:Number = onyx.utils.math.min(onyx.utils.math.max(v, _min), _max);
			dispatchEvent(new ControlEvent(value));
			
			return value;
		}
		
		/**
		 * 	Returns min value
		 */
 		public function get min():* {
 			return _min
 		}
 		
		/**
		 * 	Returns max value
		 */
 		public function get max():* {
 			return _max
 		}
 		
 		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlNumber;
		}
	}
}