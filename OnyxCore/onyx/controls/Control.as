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

	import flash.events.EventDispatcher;
	
	import onyx.core.onyx_ns;
	import onyx.events.ControlEvent;
	
	use namespace onyx_ns;
	
	[Event(name='change', type='onyx.events.ControlEvent')]
	
	/**
	 *	Base Control Class, dispatches when values have changed, as well as 
	 *	enforces limits on values
	 */
	public class Control extends EventDispatcher {

		/**
		 * 	@private
		 * 	The target object for the control
		 */
		onyx_ns var _target:IControlObject;

		/**
		 * 	stores the display name
		 */
		public var display:String;

		/**
		 * 	name of the property to affect
		 */
		public var name:String;
		
		/**
		 * 	stores options that will be implemented by the UI
		 */
		public var metadata:Object;
		
		/**
		 * @constructor
		 */
		public function Control(name:String, display:String = null, metadata:Object = null):void {
			
			this.name		= name,
			this.display	= display || name,
			this.metadata	= metadata;
			
		}
		
		/**
		 *	Returns target value
		 */
		public function get value():* {
			return _target[name];
		}
		
		/**
		 * 	Returns the contrained value.  Use this function on a property when you
		 * 	want an object to dispatch a controlevent when changing of the property occurs:
		 * 
		 * 	For instance:
		 * 
		 * 	<code>
		 * 	public function set alpha(value:Number):void {
		 * 		super.alpha = _setValue(value);
		 * 	}
		 * 	</code>
		 * 
		 * 	This will dispatch an event to the control and update the UI.
		 * 	
		 */
		public function setValue(v:*):* {
			dispatchEvent(new ControlEvent(v));
			return v;
		}
		
		/**
		 * 	Sets the value to the target
		 */
		public function set value(v:*):void {
			_target[name] = setValue(v);
		}
		
		/**
		 * 	Override this control with another control
		 */
		public function override(target:IControlObject, value:*):ControlOverride {
			
			var j:ControlOverride	= new ControlOverride();

			j.target				= _target,
			j.value					= _target[name],
			_target[name]			= value,
			_target					= target;
			
			return j;
		}
		
		/**
		 * 	Changes the target to another object
		 */
		public function set target(value:IControlObject):void {
			_target = value;
		}
		
		/**
		 * 	Resets the control
		 */
		public function reset():void {
		}

		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		public function reflect():Class {
			return Control;
		}
		
		/**
		 * 	Loads the value from xml
		 */
		public function loadXML(xml:XML):void {
			value = xml;
		}
		
		/**
		 * 	Returns xml representation of the control
		 */
		public function toXML():XML {
			var xml:XML = <{name}/>;
			var value:Object = _target[name];
			xml.appendChild((value) ? value.toString() : value);
			
			return xml;
		}
	}
}