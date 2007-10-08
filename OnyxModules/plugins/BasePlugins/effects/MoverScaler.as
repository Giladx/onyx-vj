/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
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
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.events.TempoEvent;
	import onyx.plugin.TempoFilter;
	import onyx.tween.*;
	import onyx.tween.easing.*;


	public final class MoverScaler extends TempoFilter {
		
		public var mindelay:Number	= .4;
		public var maxdelay:Number	= 1;
		public var scaleMin:Number	= 1;
		public var scaleMax:Number	= 1.8;
		
		private var tween:Tween;
		
		public function MoverScaler():void {

			super(
				true,
				null,
				new ControlNumber('mindelay',	'Min Delay', .1, 50, .4),
				new ControlNumber('maxdelay',	'Min Delay', .1, 50, 1),
				new ControlNumber('scaleMin', 'scale min', 1, 4, 1),
				new ControlNumber('scaleMax', 'scale max', 1, 4, 1.8)
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
			var x:int			= ratio * (-BITMAP_WIDTH) * Math.random();
			var y:int			= ratio * (-BITMAP_HEIGHT) * Math.random();
			
			tween = new Tween(
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
			
			if (tween) {
				tween.dispose();
			}

			super.dispose();
		}
	}
}