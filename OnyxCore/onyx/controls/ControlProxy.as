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
	
	use namespace onyx_ns;
	
	/**
	 * 	This control is a pointer to child controls -- it is used to display multiple values in a control (such as x/y, or scaleX/scaleY)
	 */
	public final class ControlProxy extends Control {
		
		/**
		 * 	ControlY
		 */
		public var controlY:Control;
		
		/**
		 * 	ControlX
		 */
		public var controlX:Control;
		
		/**
		 * 	@constructor
		 */
		public function ControlProxy(property:String, displayName:String, controlX:Control, controlY:Control, metadata:Object = null):void {
			
			this.controlY = controlY;
			this.controlX = controlX;
			
			controlY.metadata = metadata;
			controlX.metadata = metadata;
			
			super(property, displayName, null, metadata);
		}
		
		/**
		 * 
		 */
		override public function dispatch(v:*):* {
			if (v is Array) {
				controlX.value = v[0];
				controlY.value = v[1];
			}
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			dispatch(v);
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			return [controlX.value, controlY.value];
		}

		/**
		 * 
		 */
		override public function set target(value:IControlObject):void {
			controlY.target = value;
			controlX.target = value;
		}
		
		/**
		 * 
		 */
		override public function toXML():XML {
			var xml:XML = <{name}/>;
			xml.appendChild(controlX.toXML());
			xml.appendChild(controlY.toXML());

			return xml;
		}
		
		/**
		 * 
		 */
		override public function loadXML(xml:XML):void {
			
			controlY.loadXML(xml.child(controlY.name));
			controlX.loadXML(xml.child(controlX.name));
			
		}
		
		/**
		 * 
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			controlY.removeEventListener(type, listener, useCapture);
			controlX.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlProxy;
		}
	}
}