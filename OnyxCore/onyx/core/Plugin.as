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

	import onyx.utils.array.swap;
	
	use namespace onyx_ns;
	
	/**
	 * 	Base class for external files
	 */
	public final class Plugin {
		
		/**
		 * 	Stores the name for the plug-in
		 */
		public var name:String;
		
		/**
		 * 	@private
		 * 	Class definition for the object
		 */
		onyx_ns var _definition:Class;
		
		/**
		 * 	@private
		 * 	The parent global array used by Onyx to get filter indices
		 */
		onyx_ns var _parent:Array;
		
		/**
		 * 	Stores the description for the plug-in (for use in UI)
		 */
		public var description:String;
		
		/**
		 * 	@private
		 * 	Store metadata about the plugin
		 */
		private var metadata:Object;
		
		/**
		 * 	@constructor
		 */
		public function Plugin(name:String, definition:Class, description:String = null):void {

			this.name			= name,
			this.description	= description,
			_definition			= definition;

		}
		
		/**
		 * 	Returns a new object based on the plugin definition
		 */
		public function getDefinition():PluginBase {
			
			var obj:PluginBase	= new _definition() as PluginBase;
			obj._plugin			= this;
			
			return obj;
		}
		
		/**
		 * 	Registers metadata with the object
		 */
		public function registerData(name:String, value:*):void {
			if (!metadata) {
				metadata = {};
			}
			metadata[name] = value;
		}
		
		/**
		 * 	Gets metadata for the object
		 */
		public function getData(name:String):* {
			return (metadata) ? metadata[name] : null;
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return '[Plugin: ' + name + ']';
		}

	}
}