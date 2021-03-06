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
package onyx.utils {
	
	import flash.events.*;
	import flash.utils.*;

	/**
	 * 	Tests an object for it's garbage collection
	 */
	public final class GCTester extends EventDispatcher {

		/**
		 * 	@private
		 */		
		private var dict:Dictionary = new Dictionary(true);
		
		/**
		 * 	@private
		 */
		private var _timer:Timer = new Timer(150);
		
		/**
		 * 	@private
		 */
		private var lastTrace:String;

		/**
		 * 	@constructor
		 */
		public function GCTester(obj:Object):void {
			
			dict[obj] = 1;
			
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:TimerEvent):void {
			for (var i:Object in dict) {
				lastTrace = i.toString();
				return;
			}
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer.stop();
			
			trace('GC:', lastTrace);
		}
	}
}