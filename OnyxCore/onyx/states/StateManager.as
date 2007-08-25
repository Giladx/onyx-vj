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
package onyx.states {
	
	import flash.events.Event;
	
	/**
	 * 	Manager class that loads and removes states
	 */
	public final class StateManager {
		
		/**
		 * 	@private
		 * 	Stores states	
		 */
		private static var _states:Array			= [];

		/**
		 * 	Loads an application state
		 */
		public static function loadState(state:ApplicationState):void {

			_states.push(state);
			state.initialize();

		}
		
		/**
		 * 	Removes an application state
		 */
		public static function removeState(state:ApplicationState):void {
			
			// pause
			state.pause();
			
			// destroy
			state.terminate();
			
			// remove state
			_states.splice(_states.indexOf(state), 1);
			
			// dispatch an event
			state.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		/**
		 * 	Returns state matches
		 */
		public static function getStates(type:Class):Array {
			
			var matches:Array = [];
			
			for each (var state:ApplicationState in _states) {
				if (state is type) {
					matches.push(state);
				}
			}
			
			return matches;
		}
		
		/**
		 * 	Pauses all states of type
		 * 	@param		the type of class to pause, if null, all states are paused
		 */
		public static function pauseStates(type:Class = null):void {
			if (type) {
				for each (var state:ApplicationState in _states) {
					if (state is type) {
						state.pause();
					}
				}
				
			} else {
				for each (state in _states) {
					state.pause();
				}
			}
		}
		
		
		/**
		 * 	Pauses all states of type
		 * 	@param		the type of class to pause, if null, all states are paused
		 */
		public static function resumeStates(type:Class = null):void {
			
			if (type) {
				for each (var state:ApplicationState in _states) {
					if (state is type) {
						state.initialize();
					}
				}
				
			} else {
				for each (state in _states) {
					state.initialize();
				}
			}
		}
	}
}