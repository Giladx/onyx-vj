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
package onyx.core {
	
	import flash.events.*;
	
	import onyx.display.Display;
	import onyx.events.ConsoleEvent;

	[Event(name="output",	type="onyx.events.ConsoleEvent")]
	
	/**
	 * 	This class dispatches messages dispatched from the Onyx core
	 */
	public final class Console extends EventDispatcher {
		
		/**
		* 	@private
		*/
		private var _remote:Boolean = new Boolean();
		
		/**
		 * 	@private
		 */
		private static const REUSABLE_EVENT:ConsoleEvent	= new ConsoleEvent('');

		/**
		 * 	@private
		 */
		private static const dispatcher:Console				= new Console();
		
		/**
		 * 	@constructor
		 */
		public function Console():void {
		}
		
		/**
		 * 	Returns the console instance
		 */
		public static function getInstance():Console {
			return dispatcher;
		}
		
		/**
		 * 	Outputs an event to the console
		 */
		public static function output(... args:Array):void {
			
			REUSABLE_EVENT.message	= args.join(' ');
			dispatcher.dispatchEvent(REUSABLE_EVENT);
			
		}
		
		/**
		 * 	Outputs an error event to the console
		 */
		public static function error(e:Error):void {
			REUSABLE_EVENT.message = e.message;
			dispatcher.dispatchEvent(REUSABLE_EVENT);
		}
		
		/**
		 * 	Executes a command
		 */
		public static function executeCommand(command:String):void {
			
			var args:Array = command.split(' ');
			
			if (args.length) {
				
				// we need to check the command qualifier
				var name:String		= args.shift();
				
				// grab the output
				var commandReturn:Object = Command.execute(name, args) || 'COMMAND "' + name + '" NOT SUPPORTED.';
				(commandReturn is String) ? output(commandReturn as String) : error(commandReturn as Error);
			}
		}
		
		/**
		 * 	Traces an stack trace
		 */
		public static function outputStack():void {
			
			//debug::start
			
			try {
				throw(new Error('stack trace'));
			} catch (e:Error) {
				trace(e.getStackTrace());
			}
			
			//debug::end
		}
	}
}