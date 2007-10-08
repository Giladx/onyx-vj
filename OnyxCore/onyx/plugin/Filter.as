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
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.content.IContent;
	import onyx.controls.*;
	import onyx.core.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	The base Filter class
	 */
	public class Filter extends PluginBase {
		
		/**
		 * 	@private
		 * 	Stores definitions
		 */
		private static const _definition:Object	= {};
		
		/**
		 * 	@private
		 */
		onyx_ns static const _filters:Array		= [];
		
		/**
		 * 	Registers a plugin
		 */
		onyx_ns static function registerPlugin(plugin:Plugin, index:int = -1):void {
			if (!_definition[plugin.name]) {
				_definition[plugin.name] = plugin;
				plugin._parent = _filters;
				_filters.splice(index || _filters.length - 1, 0, plugin);
			}
		}

		/**
		 * 	Returns a definition
		 */
		public static function getDefinition(name:String):Plugin {
			return _definition[name];
		}
		
		/**
		 * 
		 */
		public static function getFilter(name:String):Filter {
			var plugin:Plugin = _definition[name];
			return plugin ? plugin.getDefinition() as Filter : null;
		}
		
		/**
		 * 	Returns a list of plugins of all filters registered
		 */
		public static function get filters():Array {
			return _filters;
		}
		
		/**
		 * 	Returns a content's filters that match a type
		 * 	(i.e) passing in type of BlurFilter will return all blurfilters in another layer
		 */
		public static function getFilters(content:IContent, plugin:Plugin):Array {
			var filters:Array = content.filters;
			var matches:Array = [];
			
			for each (var filter:Filter in filters) {
				if (filter is plugin._definition) {
					matches = matches;
					matches.push(filter);
				}
			}
			
			return matches;
		}

		/**
		 * 	Stores the layer
		 */
		protected var content:IContent;
		
		/**
		 * 	@private
		 * 	Stores whether the filter is unique or not
		 */
		onyx_ns var _unique:Boolean;
		
		/**
		 * 	@private
		 * 	Whether the filter is muted
		 */
		onyx_ns var _muted:Boolean;
		
		/**
		 * 	@contructor
		 */
		final public function Filter(unique:Boolean, ... controls:Array):void {
			
			super();
			
			_unique = unique;
			
			// passing in controls?
			if (controls) {
				super.controls.addControl.apply(null, controls);
			}
		}
		
		/**
		 * 
		 */
		public function set muted(value:Boolean):void {
			content.muteFilter(this, value);
		}
		
		/**
		 * 
		 */
		final public function get muted():Boolean {
			return _muted;
		}
		
		/**
		 * 	Gets the index of the filter
		 */
		final public function get index():int {
			return content.getFilterIndex(this);
		}

		/**
		 * 	@private
		 *	Called by layer when a filter is added to it
		 */
		onyx_ns final function setContent(content:IContent):void {
			this.content	= content;
		}
		
		/**
		 * 	@private
		 *	Called by layer when a filter is added to it
		 */
		onyx_ns final function getContent():IContent {
			return content;
		}
				
		/**
		 * 	Moves the filter up
		 */
		final public function moveFilter(index:int):void {
			content.moveFilter(this, index);
		}
		
		/**
		 * 	Removes the filter
		 */
		final public function removeFilter():void {
			content.removeFilter(this);
		}
		
		/**
		 * 	Returns xml
		 */
		final public function toXML():XML {
			var xml:XML = <filter id={name} />;
			xml.appendChild(controls.toXML());
			return xml;
		}
		
		/**
		 * 	@private
		 * 	Clean gets called after dispose
		 */
		onyx_ns override function clean():void {
			
			super.clean();
			content	= null;

		}
		
		/**
		 * 
		 */
		final override public function toString():String {
			return 'onyx-filter://' + (_plugin ? _plugin.name : getQualifiedClassName(this));
		}

	}
}