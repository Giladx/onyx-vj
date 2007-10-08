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
	
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import onyx.core.*;
	import onyx.events.*;
	
	use namespace onyx_ns;

	/**
	 * 	Controls Array.  This class stores all possible user-defined controls for a filter,
	 * 	transition, or other plugins.  Must be defined for any user-defined object.
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
		 * 	@private
		 * 	Children controls
		 */
		private var _children:Array;
		
		/**
		 * 	@constructor
		 */
		public function Controls(target:IControlObject, ... controls:Array):void {
			
			_target		= target,
			_children	= [];
			
			// add default controls
			addControl.apply(this, controls);
		}
		
		/**
		 * 	
		 */
		final public function addEventListener(type:String, method:Function, useCapture:Boolean = false, priority:int = 0, weak:Boolean = false):void {
			_dispatcher.addEventListener(type, method, useCapture, priority, weak);
		}
		
		/**
		 * 
		 */
		final public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 
		 */
		final public function hasEventListener(type:String):Boolean {
			return _dispatcher.hasEventListener(type);
		}
		
		/**
		 * 	Dispatch event
		 */
		final public function dispatchEvent(event:Event):Boolean {
			return _dispatcher.dispatchEvent(event);
		}
		
		/**
		 * 
		 */
		final public function willTrigger(type:String):Boolean{
			return _dispatcher.willTrigger(type);
		}
		
		/**
		 * 	Adds controls, if the control does 
		 */
		final public function addControl(... controls:Array):void {
			
			// loop through and add them controls
			for each (var control:Control in controls) {
				
				// store the target
				if (!control._target) {
					control.target	= _target,
					control.parent	= this;
					
					control.initialize();
				}
								
				// store a name index
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
		final public function setNewTarget(target:IControlObject):void {
			_target = target
			for each (var control:Control in this) {
				control.target = target;
			}
		}
		
		/**
		 * 
		 */
		final public function removeControl(... controls:Array):void {
			
			var changed:Boolean = false;
			
			// loop through and add them controls
			for each (var control:Control in controls) {
				
				// delete the name index
				delete _definitions[control.name];
				
				// if it's a proxy, remove the child indexes as well
				if (control is ControlProxy) {
					var proxy:ControlProxy = control as ControlProxy;
					delete _definitions[proxy.controlY.name];
					delete _definitions[proxy.controlX.name];
				}

				// remove from array
				var index:int = super.indexOf(control);
				if (index >= 0) {
					super.splice(index, 1);
					changed = true;
				}
			}
			
			if (changed) {

				// dispatch an update event
				_dispatcher.dispatchEvent(new Event(Event.CHANGE)); 
			}
		}
		
		/**
		 * 
		 */
		final public function addChild(child:Controls):void {
			
			// store a hash
			_children.push(child);

			// dispatch an update event
			_dispatcher.dispatchEvent(new Event(Event.CHANGE)); 
		}
		
		/**
		 * 
		 */
		final public function removeChildren():void {

			_children = [];
			
			// dispatch an update event
			_dispatcher.dispatchEvent(new Event(Event.CHANGE)); 

		}
		
		/**
		 * 
		 */
		final public function get children():Array {
			return _children;
		}
		
		/**
		 * 	Returns a control by name
		 */
		final public function getControl(name:String):Control {
			return _definitions[name];
		}
		
		/**
		 * 	Returns the control array as an xml object
		 * 	@param	An array of control names to exclude from the xml 
		 */
		public function toXML(nodeName:String = 'controls', ... excludeControls:Array):XML {
			
			var exclude:Array = excludeControls || [];
			var xml:XML = <{nodeName} />;
			var propXML:XML;
			
			for each (var control:Control in this) {
				
				// if it's not excluded
				if (exclude.indexOf(control.name) === -1 && control.value != control._defaultValue) {
					var value:XML = control.toXML();
					if (value) {
						xml.appendChild(value);
					}
				}
				
			}
			
			return xml;
		}
		
		/**
		 * 	Loads from xml
		 */
		final public function loadXML(xml:XMLList):void {
			
			var name:String, control:Control;
			
			// loop through each control
			for each (var controlXML:XML in xml.*) {
				
				try {

					// check to see if it's complex content, if so, loop
					if (controlXML.hasComplexContent()) {
						
						for each (var childXML:XML in controlXML.*) {

							name		= childXML.name();
							control		= getControl(name);
							
							control.loadXML(childXML);

						}
						
					} else {

						name			= controlXML.name();
						control			= getControl(name);
					
						control.loadXML(controlXML);

					}
				} catch (e:Error) {

					Console.error(e);
			
				}
			}
		}
	}
}