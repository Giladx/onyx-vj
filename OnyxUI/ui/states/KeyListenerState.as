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
package ui.states {
	
	import flash.events.KeyboardEvent;
	import flash.utils.*;
	
	import onyx.constants.ROOT;
	import onyx.core.Plugin;
	import onyx.plugin.*;
	import onyx.states.ApplicationState;
	
	import ui.core.*;
	
	// TBD, this should be a hash map to the key codes
	// - Keys should have down and up states
	// All key definitions should be mapped to macros (how do we deal with ui macros?)

	/**
	 * 	Listens for keyboard events
	 */
	public final class KeyListenerState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private static const dict:Object		= {};
		
		/**
		 * 	@private
		 */
		private const keyUpHash:Object			= {};
		
		/**
		 * 
		 */
		public static function registerKey(id:int, macro:Plugin):void {
			dict[id] = macro;
		}
		
		/**
		 * 
		 */
		public static function getKeyDefinition(id:int):Plugin {
			var plugin:Plugin = dict[id];
			return plugin;
		}

		/**
		 * 
		 */
		public function KeyListenerState():void {
			super(KeyListenerState);
		}
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			// listen for keys
			ROOT.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
		}
		
		/**
		 * 
		 */
		override public function pause():void {

			// remove listener
			ROOT.removeEventListener(KeyboardEvent.KEY_DOWN,	keyDown);
			ROOT.removeEventListener(KeyboardEvent.KEY_UP,		keyUp);
			
		}
		
		/**
		 * 	Terminates the keylistener
		 */
		override public function terminate():void {
		}
		
		/**
		 * 	@private
		 */
		private function keyDown(event:KeyboardEvent):void {
			
			var code:int		= event.keyCode;
			var plugin:Plugin	= dict[code];
			
			if (plugin) {
				
				if (!keyUpHash[code]) {
					
					var macro:Macro	= plugin.getDefinition() as Macro;
					keyUpHash[code] = macro;
					
					// execute the macro
					macro.keyDown();
					
					// add a listener for the key up
					ROOT.addEventListener(KeyboardEvent.KEY_UP, keyUp);
				}
			}
		}
		
		/**
		 * 
		 */
		private function keyUp(event:KeyboardEvent):void {
			
			var code:int	= event.keyCode;
			var macro:Macro = keyUpHash[code];
			if (macro) {
				macro.keyUp();
			}
			delete keyUpHash[code];
			
			// if no key ups left, remove listener
			for each (var i:Macro in keyUpHash) {
				return;
			}
			ROOT.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
	}
}