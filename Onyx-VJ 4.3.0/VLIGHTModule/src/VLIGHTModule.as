/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights rescerved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package {
	
	import module.*;
	
	import onyx.core.*;
	import onyx.plugin.Plugin;
	import onyx.plugin.PluginLoader;
	
	/**
	 *  
	 */
	public final class VLIGHTModule extends PluginLoader {
		
		/**
		 * 
		 */
		public function VLIGHTModule():void {
			this.addPlugins(
				new Plugin('VLIGHT', VLIGHTModuleItem, 'VLIGHTModule')
			)
		}
	}
}