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
package plugins.filters.tempo {
	
	import flash.events.Event;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class Blink extends TempoFilter {
		
		public var seed:int			= 50;
		
		public function Blink():void {

			parameters.addParameters(
				new ParameterInteger('seed',	'seed', 0, 100, 50)
			)
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			content.alpha = (Math.random() * 100 > seed) ? 1 : 0;
		}
	}
}