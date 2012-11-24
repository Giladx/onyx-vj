/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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
package plugins {
	
	import onyx.plugin.*;
	
	import plugins.filters.*;
	
	final public class AIRPlugins extends PluginLoader {
		
		public function AIRPlugins():void {
			
			addPlugins(
				

				new Plugin('Mask',					MaskFilter,			'Mask Filter')
			
			);
			
		}
	}
}
