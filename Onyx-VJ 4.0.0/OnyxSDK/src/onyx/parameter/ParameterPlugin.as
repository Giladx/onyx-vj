/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package onyx.parameter {
	
	import onyx.core.*;
	import onyx.events.*;
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
	public final class ParameterPlugin extends ParameterArray {
		
		/**
		 * 	@constructor
		 */
		public function ParameterPlugin(name:String, display:String, data:Array, showEmpty:Boolean = true, defaultValue:PluginBase = null):void {

			if (showEmpty) {
				data = data.concat();
				data.unshift(null);
			}

			super(name, display, data, defaultValue ? defaultValue._plugin : data[0], 'name');
			
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			var obj:PluginBase = target[name];
			return (obj) ? obj._plugin : null;
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {

			var currentTarget:PluginBase	= target[name];
			if (v) {
				var plugin:Plugin				= v as Plugin;
				
				if (!currentTarget || currentTarget._plugin !== plugin) {
					
					if (currentTarget) {
						currentTarget.dispose();
					}
					
					var newPlug:PluginBase	= plugin.createNewInstance();
					newPlug.initialize();
					
					target[name] = dispatch(newPlug);
				} 

			} else {
				
				if (currentTarget) {
					currentTarget.dispose();
				}
				
				target[name] = dispatch(null);
			}
		}
		
		/**
		 * 	Load xml (return a new object of type='id')
		 */
		override public function loadXML(xml:XML):void {
			
			/*
			var name:String, type:String, def:Plugin;
			
			type	= xml.@type,
			name	= xml.@id;
			
			switch (type) {
				case 'visualizer':
					def = PluginManager.getVisualizerDefinition(name);
					break;
				case 'filter':
					def = PluginManager.getFilterDefinition(name);
					break;
				case 'macro':
					def = PluginManager.getMacroDefinition(name);
					break;
				case 'transition':
					def = PluginManager.getTransitionDefinition(name);
					break;
			}
			
			value = def;
			
			var parent:IParameterObject = _item as IParameterObject; 
			
			if (parent) {
				parent.getParameters().loadXML(xml.parameters);
			}
			*/
		}
		
		
		
		/**
		 * 	Returns xml representation of the control
		 */
		override public function toXML():XML {
			
			var xml:XML				= <{name}/>;
			
			/*
			if (_item) {
				
				var parent:IParameterObject = _item as IParameterObject;
				
				// set what type we are
				// xml.@type	= LOOKUP[_type];
				
				// get the registration name
				xml.@id		= _item._plugin.id;
				
				if (parent) {
					xml.appendChild(parent.getParameters().toXML());
				}
			}*/
			
			return xml;
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterPlugin;
		}
	}
}