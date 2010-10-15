package plugins.filters {
	
	import flash.events.*;
	
	import onyx.plugin.PluginManager;
	import onyx.parameter.*;
	
	import onyx.plugin.SoundFilter;
	import onyx.events.*;
	
	import services.sound.ID;
	
	public class ToggleSound extends SoundFilter {
		
		private var _sync:String	= 'level';
		private var _level:int 		= 50;
		
		public function ToggleSound():void {
			
			super();
				
			parameters.addParameters(
				new ParameterArray('sync','mode',new Array('level'/*,'low','mid','high'*/),_sync),
				new ParameterInteger('level', 'level', 0, 100, _level, 1, 5)
			);
			
		}
		
		public function set sync(value:String):void {
			_sync = value;
		}
		public function get sync():String {
			return _sync;
		}
		
		public function set level(value:int):void {
			_level = value;
		}
		public function get level():int {
			return _level;
		}
		
		// do some peak interaction here
		override public function onPeak(e:Event):void {
			var slevel:int = PluginManager.modules[ID].slevel;
			
			if(slevel>=_level)
				content.visible = true;
			else
				content.visible = false;
		}
		
	}
	
}