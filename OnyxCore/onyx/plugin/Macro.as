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
package onyx.plugin {
	
	import flash.utils.Dictionary;
	
	import onyx.constants.*;
	import onyx.core.*;
	
	use namespace onyx_ns;

	/**
	 * 
	 */
	public class Macro extends PluginBase {

		/**
		 * 	@private
		 * 	Stores definitions
		 */
		private static const _definition:Object	= {};
		
		/**
		 * 	@private
		 */
		onyx_ns static const _macros:Array		= [];
		
		/**
		 * 	Registers a plugin
		 */
		onyx_ns static function registerPlugin(plugin:Plugin, index:int = -1):void {
			if (!_definition[plugin.name]) {
				_definition[plugin.name] = plugin;
				plugin._parent = _macros;
				_macros.splice(index || _macros.length - 1, 0, plugin);
			}
		}

		/**
		 * 	Returns a definition
		 */
		public static function getDefinition(name:String):Plugin {
			return _definition[name];
		}
		
		/**
		 * 	Returns a list of plugins of all filters registered
		 */
		public static function get macros():Array {
			return _macros;
		}
		
		/**
		 * 	@constructor
		 */
		public function Macro():void {
		}
		
		/**
		 * 	Initializes the macro
		 */
		public function initialize():void {
		}
		
		/**
		 * 	Terminates the macro
		 */
		public function terminate():void {
		}
		
		/**
		 * 
		 */
		override public function toString():String {
			return ONYX_QUERYSTRING + 'macro://' + _plugin.name;
		}
	}
}