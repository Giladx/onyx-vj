/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package effects {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.events.TempoEvent;
	import onyx.filter.Filter;
	import onyx.filter.TempoFilter;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	import onyx.utils.math.*;

	public final class FrameRND extends TempoFilter {
		
		public var rndframe:String = 'start';
		
		public var mindelay:Number	= .5;
		public var maxdelay:Number	= 2;
		public var minframe:Number	= .6;
		public var maxframe:Number	= 4;
		public var smooth:Boolean	= true;
		public var direction:String	= 'both';

		public function FrameRND():void {

			super(
				true,
				null,
				new ControlNumber('mindelay',	'Min Delay', .1, 50, .5),
				new ControlNumber('maxdelay',	'Min Delay', .1, 50, 2),
				new ControlRange('rndframe',	'RND Frame', ['off', 'start', 'end'], 0),
				new ControlNumber('minframe',	'min framerate', .2, 8, .6),
				new ControlNumber('maxframe',	'max framerate', .2, 8, 4),
				new ControlRange('direction',	'direction',	['both', 'forward', 'reverse'], 0),
				new ControlBoolean('smooth',	'smooth')
			)
		}
		
		override protected function onTrigger(beat:int, event:Event):void {

			if (event is TimerEvent) {
				delay = (((maxdelay - mindelay) * random()) + mindelay) * 1000;
			}
			
			var nextDelay:int = this.nextDelay;
			
			switch (rndframe) {
				case 'end':
					var newtime:Number			= random();
					var timeToTraverse:Number	= content.totalTime * (newtime - content.time);
					
					new Tween(content, nextDelay, new TweenProperty('framerate', content.framerate, timeToTraverse / nextDelay));

					break;
				case 'start':
					content.time = random();
					break;
				default:
					var framerate:Number = (((maxframe - minframe) * random()) + minframe);
					switch (direction) {
						case 'both':
							framerate *= (random() <= .5 ? 1 : -1)
							break;
						case 'reverse':
							framerate *= -1;
							break;
					}
					
					if (smooth) {
						if (random() > .5) {
							new Tween(content, 500, new TweenProperty('framerate', 0, 1));
							return;
						}
					}
					
					content.framerate = framerate;
			}
		}
	}
}