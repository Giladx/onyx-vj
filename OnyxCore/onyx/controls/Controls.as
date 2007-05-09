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
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import onyx.core.onyx_ns;
	import onyx.utils.string.parseBoolean;
	
	use namespace onyx_ns;

	/**
	 * 
	 */
	dynamic public class Controls extends Array implements IEventDispatcher {
		
		/**
		 * 	@private
		 */
		private var _definitions:Dictionary		= new Dictionary(true);
		
		/**
		 * 	@private
		 */
		private var _dispatcher:EventDispatcher	= new EventDispatcher();
		
		/**
		 * 	@private
		 */
		private var _target:IControlObject;
		
		/**
		 * 	@constructor
		 */
		public function Controls(target:IControlObject, ... controls:Array):void {
			
			_target = target;
			
			addControl.apply(this, controls);
		}
		
		/**
		 * 	
		 */
		public function addEventListener(type:String, method:Function, useCapture:Boolean = false, priority:int = 0, weak:Boolean = false):void {
			_dispatcher.addEventListener(type, method, useCapture, priority, true);
		}
		
		/**
		 * 
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		
		/**
		 * 
		 */
		public function hasEventListener(type:String):Boolean {
			return _dispatcher.hasEventListener(type);
		}
		
		/**
		 * 	Dispatch event
		 */
		public function dispatchEvent(event:Event):Boolean {
			return _dispatcher.dispatchEvent(event);
		}
		
		/**
		 * 
		 */
		public function willTrigger(type:String):Boolean{
			return _dispatcher.willTrigger(type);
		}
		
		/**
		 * 	Adds controls
		 */
		public function addControl(... controls:Array):void {
			
			// loop through and add them controls
			for each (var control:Control in controls) {
				
				control.target = _target;
				
				_definitions[control.name] = control;
				
				if (control is ControlProxy) {
					var proxy:ControlProxy = control as ControlProxy;
					_definitions[proxy.controlY.name] = proxy.controlY;
					_definitions[proxy.controlX.name] = proxy.controlX;
				}

				super.push(control);
			}
		}
		
		/**
		 * 	
		 */
		public function getControl(name:String):Control {
			return _definitions[name];
		}
		
		/**
		 * 	@private
		 */
		onyx_ns function set target(value:IControlObject):void {
			for each (var control:Control in this) {
				control.target = value;
			}
		}
		
		/**
		 * 	Returns the control array as an xml object
		 * 	@param	An array of control names to exclude from the xml 
		 */
		public function toXML(... excludeControls:Array):XML {
			
			var exclude:Array = excludeControls || [];
			var xml:XML = <controls />;
			var propXML:XML;
			
			for each (var control:Control in this) {
				
				// if it's not excluded
				if (exclude.indexOf(control.name) === -1) {
					xml.appendChild(control.toXML());
				}
				
			}
			
			return xml;
		}
		
		/**
		 * 	Loads from xml
		 */
		public function loadXML(xml:XML):void {
			
			var name:String, control:Control;
			
			for each (var controlXML:XML in xml.*) {
				
				try {
					
					// proxy control
					if (controlXML.hasComplexContent()) {

						for each (var proxy:XML in controlXML.*) {
							
							name			= proxy.name();
							control			= getControl(name);
							
							// TBD: better serialization
							control.loadXML(proxy);
						}
						
					// individual property
					} else {
	
						name				= controlXML.name();
						
						control				= getControl(name);
						
						// TBD: better serialization
						control.loadXML(controlXML);
					}
	
				} catch (e:Error) {
				}
			}
		}

		/**
		 * 
		 */
		AS3 override function concat(...args):Array {
			
			super.push.apply(super, args);
			_dispatcher.dispatchEvent(new Event(Event.CHANGE));
			
			return null;
		}
		
		/**
		 * 	Destroys
		 */
		public function dispose():void {
			
			_target			= null,
			_definitions	= null;
			
		}
	}
}