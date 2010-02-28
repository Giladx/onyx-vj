package {
	
	import flash.display.*;
	
	import module.*;
	
	import onyx.plugin.*;

	final public class RecorderModule extends PluginLoader {
		
		/**
		 *
		 */
		public function RecorderModule():void {
			
			this.addPlugins(
				new Plugin('Recorder', RecorderModuleInst, 'Recorder')
			);
			
		}
	}
}
