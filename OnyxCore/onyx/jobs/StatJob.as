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
package onyx.jobs {
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import onyx.constants.*;
	import onyx.core.Console;
	import onyx.core.Onyx;
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;
	
	/**
	 * 	Performs a test on the framerate
	 */
	public final class StatJob extends TimerJob {
		
		/**
		 * 	@private
		 */
		private var _start:uint = 0;
		
		/**
		 * 	@private
		 */
		private var _frames:uint = 0;
		
		/**
		 * 
		 */
		override public function initialize(...args):void {
			
			var time:Number = args[0];
			
			Console.output('STARTING STAT JOB FOR ' + (time).toFixed(2) + ' SECONDS');
			ROOT.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			
			super.initialize((time * 1000) >> 0);
		}
		
		/**
		 * 	@private
		 */
		private function _onEnterFrame(event:Event):void {
			if (!_start) {
				_start = getTimer();
			} else {
				_frames++;
			}
		}
		

		/**
		 * 
		 */
		override public function terminate():void {
			
			ROOT.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			
			Console.output(
				'END OF STAT JOB: ' + 
				'AVERAGE FPS: ' + ((1000 / ((getTimer() - _start) / _frames) as Number).toFixed(2))
			);
			
			super.terminate();
		}
		
	}
}