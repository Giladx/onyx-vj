package macros {
	
	import filters.EchoFilter;
	
	import onyx.constants.*;
	import onyx.display.IDisplay;
	import onyx.plugin.*;

	public final class EchoDisplay extends Macro {
		
		private var filter:Filter;
		
		override public function keyDown():void {
			
			var display:IDisplay = AVAILABLE_DISPLAYS[0];
			
			filter = Filter.getDefinition('ECHO FILTER').getDefinition() as Filter;
			display.addFilter(filter);
			
		}
		
		override public function keyUp():void {
			var display:IDisplay = AVAILABLE_DISPLAYS[0];
			display.removeFilter(filter);
			filter = null;
		}
	}
}