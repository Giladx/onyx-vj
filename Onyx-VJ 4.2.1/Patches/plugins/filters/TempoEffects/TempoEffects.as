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
package {
	
	import onyx.plugin.*;
	
	import plugins.effects.*;
	
	/**
	 * 
	 */
	final public class TempoEffects extends PluginLoader {

		/**
		 * 
		 */
		public function TempoEffects():void {
			
			addPlugins(
			
				// bitmap filters
				new Plugin('Alpha Effect', 			Alpha,			'Randomizes the alpha'),
				new Plugin('Blink Effect', 			Blink,			'Randomizes the visibility'),
				new Plugin('Frame Random', 			FrameRND,		'Randomizes Frame Rates'),
				new Plugin('MoveScale Effect', 		MoverScaler,	'Moves and Scales Object')
			);
			
		}
	}
}
