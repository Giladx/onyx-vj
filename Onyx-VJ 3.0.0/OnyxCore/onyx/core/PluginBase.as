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
package onyx.core {

	import flash.events.EventDispatcher;
	
	import onyx.controls.*;
	
	use namespace onyx_ns;

	/**
	 * 	Base class for all plug-ins
	 */
	public class PluginBase extends EventDispatcher implements IControlObject {
		
		/**
		 * 
		 */
		onyx_ns var _plugin:Plugin;
		
		/**
		 * 	@private
		 */
		protected var _controls:Controls;
		
		/**
		 * 	@constructor
		 */
		public function PluginBase(... args:Array):void {
			_controls = new Controls(this);
			_controls.addControl.apply(null, args);
		}
		
		/**
		 * 
		 */
		public function initialize():void {
			
		}
		
		/**
		 * 
		 */
		final public function get name():String {
			return _plugin ? _plugin.name : '';
		}
		
		/**
		 * 	Disposes the filter
		 */
		final public function get controls():Controls {
			return _controls;
		}

		/**
		 * 	Disposes the filter
		 */
		public function dispose():void {
		}
		
		/**
		 * 	Clones the filter
		 */
		final public function clone():PluginBase {
			
			var base:PluginBase = _plugin.getDefinition();
			for each (var control:Control in controls) {
				var newControl:Control = base.controls.getControl(control.name);
				if (!(newControl is ControlExecute)) {
					newControl.value = control.value;
				}
			}
			
			return base;
		}
		
		/**
		 * 	Returns the related plugin (classfactory)
		 */
		public function get plugin():Plugin {
			return _plugin;
		}
		
		/**
		 * 	Cleans the content
		 */
		onyx_ns function clean():void {
			_controls	= null,
			_plugin		= null;
		}
	}
}