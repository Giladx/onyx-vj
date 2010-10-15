package plugins.filters {
	
	import flash.events.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.PluginManager;
	import onyx.plugin.SoundFilter;
	
	import services.sound.ID;
	
	public class AlphaSound extends SoundFilter {
		
		private var _sync:String	= 'level';
		private var _sens:Number		= 150;
		
		public function AlphaSound():void {
			
			super();
				
			parameters.addParameters(
				new ParameterArray('sync','mode',new Array('level'/*,'low','mid','high'*/),_sync),
				new ParameterNumber('sens', 'sens', 0, 400, _sens, 1, 10)
			);
			
		}
		
		public function set sync(value:String):void {
			_sync = value;
		}
		public function get sync():String {
			return _sync;
		}
		
		public function set sens(value:Number):void {
			_sens = value;
		}
		public function get sens():Number {
			return _sens;
		}
		
		// do some peak interaction here
		override public function onPeak(l:Array,r:Array):void {
			content.alpha = mod.SP.slevel/100 * _sens/100;
		}
		
	}
	
}