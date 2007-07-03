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
	
	import onyx.core.*;
	import onyx.events.ControlEvent;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Returns plugins based on type passed in
	 */
	public final class ControlPlugin extends ControlRange {
		
		/**
		 * 	@private
		 * 	This is used for serialization of the plugin
		 */
		private static const LOOKUP:Array	= ['filter', 'macro', 'transition', 'visualizer'];
		
		/**
		 * 	Use Filters
		 */
		public static const FILTERS:int		= 0;

		/**
		 * 	Use Macros
		 */
		public static const MACROS:int		= 1;

		/**
		 * 	Use Transitions
		 */
		public static const TRANSITIONS:int	= 2;

		/**
		 * 	Use Visualizers
		 */
		public static const VISUALIZERS:int	= 3;
		
		/**
		 * 	Use Renderers
		 */
		public static const RENDERERS:int	= 4;
		
		/**
		 * 	@private
		 * 	Stores the plugin type to use
		 */
		private var _type:int;
		
		/**
		 * 	@constructor
		 */
		public function ControlPlugin(name:String, display:String, type:int = 0, defaultValue:int = 0):void {
			
			_type = type;
			
			var data:Array;
			
			switch (type) {
				case FILTERS:
					data = Filter.filters;
					data.unshift(null);
					break;
					
				case MACROS:
					data = Macro.macros;
					data.unshift(null);
					
					break;
				case TRANSITIONS:
					data = Transition.transitions;
					data.unshift(null);
					
					break;
				case VISUALIZERS:
					data = Visualizer.visualizers;
					data.unshift(null);
					
					break;
				case RENDERERS:
					data = Renderer.renderers;
					break;
			}
			
			super(name, display, data, defaultValue, 'name');
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			var type:PluginBase = _target[name];
			return type ? type._plugin : null;
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			var plugin:Plugin = v as Plugin;
			dispatchEvent(new ControlEvent(v));
			_target[name] = plugin ? plugin.getDefinition() : null;
		}
		
		/**
		 * 
		 */
		override public function dispatch(v:*):* {
			var plugin:Plugin = v as Plugin;
			dispatchEvent(new ControlEvent(v));
			return plugin ? plugin.getDefinition() : null;
		}
		
		/**
		 * 	TBD: This needs to store data
		 * 	Returns xml representation of the control
		 */
		override public function toXML():XML {
			
			var xml:XML				= <{name}/>;
			var plugin:PluginBase	= _target[name];
			
			if (plugin) {
				
				// set what type we are
				xml.@type	= LOOKUP[_type];
				
				// get the registration name
				xml.@id		= plugin._plugin.name;
			}
			
			return xml;
		}
		
		/**
		 * 	Load xml (return a new object of type='id')
		 */
		override public function loadXML(xml:XML):void {
			
			var name:String, type:String, def:Plugin;
			
			type	= xml.@type,
			name	= xml.@id;
			
			switch (type) {
				case 'visualizer':
					def = Visualizer.getDefinition(name);
					break;
				case 'filter':
					def = Filter.getDefinition(name);
					break;
				case 'macro':
					def = Macro.getDefinition(name);
					break;
				case 'transition':
					def = Transition.getDefinition(name);
					break;
				case 'renderer':
					def = Renderer.getDefinition(name);
					break;
			}
			
			value = def.getDefinition();
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlPlugin;
		}
	}
}