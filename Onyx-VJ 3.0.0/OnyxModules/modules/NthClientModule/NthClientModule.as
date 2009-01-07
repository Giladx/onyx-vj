package {
	
	import flash.display.Sprite;
	
	import onyx.plugin.*;
	import nth.core.NthClient;

	public class NthClientModule extends Sprite implements IPluginLoader {
		
		/**
		 * 	Return plugins
		 */
		public function get plugins():Array {
			return [new NthClient()];
		}
	}
}
