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
	import onyx.tween.*;
	
	/**
	 * 
	 */
	public final class Alpha extends TempoFilter {
		
		public var min:Number		= 0;
		public var max:Number		= 1;
		public var seed:Number		= 1;
		public var smooth:Boolean	= false;
		
		/**
		 * 	@constructor
		 */
		public function Alpha():void {

			parameters.addParameters(
				new ParameterNumber('min',	'min alpha',	0,	1,	0),
				new ParameterNumber('max',	'max alpha',	0,	1,	1),
				new ParameterNumber('seed',	'seed',			0,	1,	1),
				new ParameterBoolean('smooth', 'smooth')
			)
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			if (Math.random() <= seed) {
				if (smooth) {
					new Tween(content, nextDelay,
						new TweenProperty('alpha', content.alpha, (max - min) * Math.random() + min)
					); 
				} else {
					content.alpha = ((max - min) * Math.random()) + min;
				}
			}
		}
	}
}