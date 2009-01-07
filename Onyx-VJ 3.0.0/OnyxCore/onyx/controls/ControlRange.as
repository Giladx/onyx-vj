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
	 * 	Control that has a confined set of values.
	 * 
	 * 	@see onyx.controls.ControlBlend
	 * 	@see onyx.controls.ControlTempo
	 * 	@see onyx.controls.ControlLayer
	 */
	public class ControlRange extends Control {
		
		/**
		 * 	@private
		 */
		protected var _data:Array;
		
		/**
		 * 	The property name to bind to when displaying
		 */
		public var binding:String;
		
		/**
		 * 	@constructor
		 */
		public function ControlRange(name:String, display:String, data:Array, defaultValue:Object, binding:String = null):void {
			
			this.binding  		= binding,
			this._data			= data;
			
			super(name, display, defaultValue);
		}
		
		/**
		 * 
		 */
		override public function reset():void {
			_target[name] = dispatch(defaultValue);
		}

		/**
		 * 	Returns all data
		 */
		public function get data():Array {
			return _data;
		}
		
		/**
		 * 
		 */
		override public function loadXML(xml:XML):void {
			super.loadXML(xml);
		}
 		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlRange;
		}
	}
}