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
	
	import flash.events.Event;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.content.Content;
	import onyx.controls.*;
	import onyx.filter.Filter;
	import onyx.filter.TempoFilter;
	import onyx.tween.Tween;
	import onyx.tween.TweenProperty;
	import onyx.tween.easing.*;
	import onyx.utils.math.*;

	public final class ThreshGate extends TempoFilter {
		
		public var seed:Number = .03;
		
		public function ThreshGate():void {

			super(	
				true,
				null,
				new ControlNumber('seed', 'rnd seed', 0, 1, seed)
			)
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			if (random() < seed) {

				Tween.stopTweens(this);

				var delay:int = nextDelay;
				var tween:Tween = new Tween(this, delay * 2, new TweenProperty('value', 0, 100, Linear.easeOut));
				tween.addEventListener(Event.COMPLETE, _onComplete);
			}
		}
		
		/**
		 * 
		 */
		private function _onComplete(event:Event):void {

			if (content) {
				Tween.stopTweens(this);
				var tween:Tween = new Tween(this, nextDelay * 2, new TweenProperty('value', value, 0, Linear.easeOut));
			}
		}
		
		/**
		 * 
		 */
		public function set value(i:int):void {
			content.threshold = i;
		}
		
		/**
		 * 
		 */
		public function get value():int {
			return content.threshold;
		}
	}
}