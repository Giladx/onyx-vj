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
	
	import flash.events.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	
	public final class MoverScaler extends TempoFilter {
		
		public var mindelay:Number	= .4;
		public var maxdelay:Number	= 1;
		public var scaleMin:Number	= 1;
		public var scaleMax:Number	= 1.8;
		
		public function MoverScaler():void {

			parameters.addParameters(
				new ParameterNumber('mindelay',	'Min Delay', .1, 50, .4),
				new ParameterNumber('maxdelay',	'Min Delay', .1, 50, 1),
				new ParameterNumber('scaleMin', 'scale min', 1, 4, 1),
				new ParameterNumber('scaleMax', 'scale max', 1, 4, 1.8)
			);
			
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			
			if (event is TimerEvent) {
				delay = (((maxdelay - mindelay) * Math.random()) + mindelay) * 1000;
			}
			
			var scale:Number	= ((scaleMax - scaleMin) * Math.random()) + scaleMin;
			var ratio:Number	= (scale - 1);
			var x:int			= ratio * (- DISPLAY_WIDTH) * Math.random();
			var y:int			= ratio * (- DISPLAY_HEIGHT) * Math.random();
			
			new Tween(
				content, 
				Math.max(delay * Math.random(), 32),
				new TweenProperty('x', content.x, x),
				new TweenProperty('y', content.y, y),
				new TweenProperty('scaleX', content.scaleX, scale),
				new TweenProperty('scaleY', content.scaleY, scale)
			);

		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			Tween.stopTweens(this);

			super.dispose();
		}
	}
}