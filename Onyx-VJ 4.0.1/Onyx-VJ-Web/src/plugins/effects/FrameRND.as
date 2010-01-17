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
package plugins.effects {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	import onyx.tween.easing.*;

	public final class FrameRND extends TempoFilter {
		
		public var rndframe:String = 'start';
		
		public var mindelay:Number	= .5;
		public var maxdelay:Number	= 2;
		public var minframe:Number	= .6;
		public var maxframe:Number	= 4;
		public var smooth:Boolean	= true;
		public var direction:String	= 'both';

		public function FrameRND():void {

			parameters.addParameters(
				new ParameterNumber('mindelay',	'Min Delay', .1, 50, .5),
				new ParameterNumber('maxdelay',	'Min Delay', .1, 50, 2),
				new ParameterArray('rndframe',	'RND Frame', ['off', 'start', 'end'], 0),
				new ParameterNumber('minframe',	'min framerate', .2, 8, .6),
				new ParameterNumber('maxframe',	'max framerate', .2, 8, 4),
				new ParameterArray('direction',	'direction',	['both', 'forward', 'reverse'], 0),
				new ParameterBoolean('smooth',	'smooth')
			)
		}
		
		override protected function onTrigger(beat:int, event:Event):void {

			if (event is TimerEvent) {
				delay = (((maxdelay - mindelay) * Math.random()) + mindelay) * 1000;
			}
			
			var nextDelay:int = this.nextDelay;
			
			switch (rndframe) {
				case 'end':
					var newtime:Number			= Math.random();
					var timeToTraverse:Number	= content.totalTime * (newtime - content.time);
					
					new Tween(content, nextDelay, new TweenProperty('framerate', content.framerate, timeToTraverse / nextDelay));

					break;
				case 'start':
					content.time = Math.random();
					break;
				default:
					var framerate:Number = (((maxframe - minframe) * Math.random()) + minframe);
					switch (direction) {
						case 'both':
							framerate *= (Math.random() <= .5 ? 1 : -1)
							break;
						case 'reverse':
							framerate *= -1;
							break;
					}
					
					if (smooth) {
						if (Math.random() > .5) {
							new Tween(content, 500, new TweenProperty('framerate', 0, 1));
							return;
						}
					}
					
					content.framerate = framerate;
			}
		}
	}
}