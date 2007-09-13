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
	
	import onyx.plugin.TempoFilter;
	import onyx.display.LayerSettings;
	
	/**
	 * 
	 */
	public final class SuperTrigger extends TempoFilter {
		
		public static const REVERSE:int = 1;
		public static const DOUBLE:int	= 2;
		public static const HALF:int	= 3;
		
		public var behavior:int;
		public var length:int			= 2;
		public var currentLength:int	= 0;
		
		/**
		 * 	@constructor
		 */
		public function SuperTrigger():void {
			
			super(true);
			
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			
			// check for a re-do of the behavior
			if (currentLength === 0) {
				
				// check for end behavior
				switch (behavior) {
					case REVERSE:
						content.time += nextDelay / content.totalTime;
						break;
				}
				
				var seed:int = Math.random() * 100;
				
				// reverse
				if (seed > 85) {
					
					// reverse
					content.time += nextDelay / content.totalTime; 
					content.framerate = -1;
					
					behavior = REVERSE;
				
				// double
				} else if (seed > 60) {
					
					content.framerate = 2;
					behavior = DOUBLE;
				
				// normal
				}  else if (seed > 40) {
					
					content.framerate = .6;
					behavior = HALF;
				}  else if (seed > 20) {
					
					content.framerate = 3;
					behavior = HALF;
				}
				
				currentLength = Math.random() * 3 + 1;
				
				return;
			}
			
			currentLength--;
			
			// check for end behavior
			switch (behavior) {
				case REVERSE:
					content.time += nextDelay / content.totalTime;
					break;
			}
		}

		/**
		 * 
		 */
	}
}