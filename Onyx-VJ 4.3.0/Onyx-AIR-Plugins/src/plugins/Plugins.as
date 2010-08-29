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
package plugins {
	
	import onyx.plugin.*;
	
	import plugins.assets.*;
	import plugins.filters.*;
	import plugins.filters.tempo.*;
	import plugins.transitions.*;
	import plugins.visualizer.*;
	import plugins.macros.*;
	import plugins.fonts.*;
	import plugins.modules.*;
	
	final public class Plugins extends PluginLoader {

		public function Plugins():void {
			
			addPlugins(
			
				// modules
				new Plugin('Recorder', 				Recorder, 			'Recorder')

			);
			
		}
	}
}
