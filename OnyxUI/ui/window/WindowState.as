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
package ui.window {
	
	import ui.core.*;
	import flash.utils.Dictionary;
	
	/**
	 * 	Stores states of windows
	 */
	public final class WindowState {

		// auto-register the default window state
		{	register(
				new WindowState('DEFAULT', [
					new WindowStateReg('FILE BROWSER',	6,		318),
					new WindowStateReg('CONSOLE',		6,		561),
					new WindowStateReg('FILTERS',		412,	318),
					new WindowStateReg('LAYERS',		0,		0),
					new WindowStateReg('DISPLAY',		680,	580),
					new WindowStateReg('KEY MAPPING',	615,	319, 	false),
					new WindowStateReg('SETTINGS',		200,	561),
					new WindowStateReg('CROSSFADER',	411,	561),
					new WindowStateReg('MACROS',		411,	618)
				])
			)
		}
		
		/**
		 * 	@private
		 */
		public static const states:Array = [];
		
		/**
		 * 	@private
		 * 	Look-up for states by name
		 */
		private static const lookup:Object	= {};
		
		/**
		 * 	@private
		 * 	The current window state
		 */
		public static var currentState:WindowState;
		
		/**
		 * 	Registers a window state
		 */
		public static function register(state:WindowState):void {
			states.push(state);
			lookup[state.name] = state;
		}
		
		/**
		 * 	Registers a state for use
		 */
		public static function load(state:WindowState):void {
			currentState = state || lookup.DEFAULT;
			WindowRegistration.initialize(currentState);
		}
		
		/**
		 * 	Returns a window state based upon name
		 */
		public static function getState(name:String):WindowState {
			return lookup[name];
		}
		
		/**
		 * 	The states of the windows to arrange
		 */
		public var windows:Array;
		
		/**
		 * 	Name of the state
		 */
		public var name:String;
		
		/**
		 * 	@constructor
		 */
		public function WindowState(name:String, windows:Array):void {
			this.name		= name,
			this.windows	= windows;
		}
	}
}