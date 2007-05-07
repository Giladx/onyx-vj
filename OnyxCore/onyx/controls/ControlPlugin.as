package onyx.controls {
	
	import onyx.core.onyx_ns;
	import onyx.filter.Filter;
	import onyx.macro.Macro;
	import onyx.sound.Visualizer;
	import onyx.transition.Transition;
	import onyx.core.PluginBase;
	import onyx.plugin.Plugin;
	import onyx.events.ControlEvent;
	
	use namespace onyx_ns;
	
	/**
	 * 	Returns plugins based on type passed in
	 */
	public final class ControlPlugin extends ControlRange {
		
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
		 * 	@constructor
		 */
		public function ControlPlugin(name:String, display:String, type:int = 0, defaultValue:int = 0):void {
			
			var data:Array;
			
			switch (type) {
				case FILTERS:
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
			}
			
			data.unshift(null);
			
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
		override public function setValue(v:*):* {
			var plugin:Plugin = v as Plugin;
			dispatchEvent(new ControlEvent(v));
			return plugin ? plugin.getDefinition() : null;
		}
		
		/**
		 * 	TBD: This needs to store data
		 * 	Returns xml representation of the control
		 */
		override public function toXML():XML {
			return <{name}>{_target[name].toString()}</{name}>;
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlPlugin;
		}
	}
}