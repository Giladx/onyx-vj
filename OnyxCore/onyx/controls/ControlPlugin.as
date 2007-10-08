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
	 * 	Returns a list of plugins.  These can either be filters, macros, transitions, or visualizers.
	 * 	This control will dispatch an actual instance of the plugin, rather than the plugin definition itself.
	 * 
	 * 	@see onyx.plugin.Filter
	 * 	@see onyx.plugin.Transition
	 * 	@see onyx.plugin.Visualizer
	 */
	public final class ControlPlugin extends ControlRange {
		
		/**
		 * 	@private
		 * 	This is used for serialization of the plugin
		 */
		private static const LOOKUP:Array	= ['filter', 'macro', 'transition', 'visualizer', 'renderer'];
		
		public static const FILTERS_BITMAP:int	= 0;
		public static const FILTERS_TEMPO:int	= 5;
		public static const MACROS:int			= 1;
		public static const TRANSITIONS:int		= 2;
		public static const VISUALIZERS:int		= 3;
		public static const RENDERERS:int		= 4;
		
		/**
		 * 	@private
		 * 	Stores the plugin type to use
		 */
		private var _type:int;
		
		/**
		 * 	@private
		 */
		private var _item:PluginBase;
		
		/**
		 * 	@private
		 */
		private var _value:Plugin;
		
		/**
		 * 	@private
		 */
		private var _autoCreate:Boolean;
		
		/**
		 * 	@constructor
		 */
		public function ControlPlugin(name:String, display:String, type:int = 0, showEmpty:Boolean = true, autoCreate:Boolean = true, defaultValue:Plugin = null):void {
			
			var data:Array;
			
			_type		= type,
			_autoCreate = autoCreate;

			switch (type) {
				case FILTERS_BITMAP:
					data = Filter.filters;
					break;
				case FILTERS_TEMPO:
					data = Filter.filters;
					break;
				case MACROS:
					data = Macro.macros;
					break;
				case TRANSITIONS:
					data = Transition.transitions;
					break;
				case VISUALIZERS:
					data = Visualizer.visualizers;
					break;
				case RENDERERS:
					data = Renderer.renderers;
					showEmpty = false;
					break;
			}
			
			if (showEmpty) {
				data = data.concat();
				data.unshift(null);
			}
			
			if (defaultValue) {
				_value	= defaultValue,
				_item	= defaultValue.getDefinition();
			}

			super(name, display, data, defaultValue, 'name');
		}
		
		/**
		 * 
		 */
		override public function reset():void {
			
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			return _value;
		}
		
		/**
		 * 
		 */
		override public function initialize():void {

			switch (_type) {
				case FILTERS_BITMAP:
				
					var parent:Filter = _target as Filter;
					
					if (parent) {
						
						var index:int = _data.indexOf(parent._plugin);
						
						if (index >= 0) {
							_data.concat();
							_data.splice(index, 1);
						}
					}
					break;
			}
			
		}
		
		/**
		 * 	Returns the created plugin
		 */
		public function get item():PluginBase {
			return _item;
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			
			var plugin:Plugin = v as Plugin;
			
			// initialize and create a plugin 
			if (_item) {
				_item.dispose();
				parent.removeChildren();
			}
			
			// create new plugin
			if (_autoCreate && plugin) {
				
				// _item a new plugin
				_item = plugin.getDefinition();
				_item.initialize();
				
				var obj:IControlObject = _item as IControlObject;
				
				// need to update parent with new controls
				if (obj && obj.controls.length) {		
					parent.addChild(obj.controls);
				}
				
				// now we need to see if we should propagate the content object
				if (_item is Filter && obj is Filter) {
					(_item as Filter).setContent((obj as Filter).getContent());
				}
			} 

			// see if it has the property, it's ok if it doesn't
			_value = REUSABLE_EVENT.value = plugin;

			dispatchEvent(REUSABLE_EVENT);
		}
		
		/**
		 * 
		 */
		override public function dispatch(v:*):* {
			
			var plugin:Plugin = REUSABLE_EVENT.value = v as Plugin;
			dispatchEvent(REUSABLE_EVENT);
			
			return plugin;
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
			
			value = def;
			
			var parent:IControlObject = _item as IControlObject; 
			
			if (parent) {
				parent.controls.loadXML(xml.controls);
			}
		}
		
		
		
		/**
		 * 	Returns xml representation of the control
		 */
		override public function toXML():XML {
			
			var xml:XML				= <{name}/>;
			
			if (_item) {
				
				var parent:IControlObject = _item as IControlObject;
				
				// set what type we are
				xml.@type	= LOOKUP[_type];
				
				// get the registration name
				xml.@id		= _item._plugin.name;
				
				if (parent) {
					xml.appendChild(parent.controls.toXML());
				}
			}
			
			return xml;
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlPlugin;
		}
	}
}