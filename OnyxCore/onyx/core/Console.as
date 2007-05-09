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
package onyx.core {
	
	import flash.events.EventDispatcher;
	
	import onyx.display.Display;
	import onyx.events.ConsoleEvent;

	[Event(name="output",	type="onyx.events.ConsoleEvent")]
	
	public final class Console extends EventDispatcher {
		
		/**
		 * 	@private
		 */
		private static const dispatcher:Console	= new Console();
		
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
			
			dispatcher.dispatchEvent(
				new ConsoleEvent(args.join(' '))
			);
			
		}
		
		/**
		 * 	Outputs an error event to the console
		 */
		public static function error(e:Error):void {
			dispatcher.dispatchEvent(new ConsoleEvent(e.message));
		}
		
		/**
		 * 	Executes a command
		 */
		public static function executeCommand(command:String):void {
			
			var commands:Array = command.split(' ');
			
			if (commands.length) {
				var firstcommand:String = commands.shift();
				
				if (Command[firstcommand]) {
					var fn:Function = Command[firstcommand];
					
					try {
						var message:String = fn.apply(null, commands);
					} catch (e:Error) {
						error(e.message);
					}
				}
			}
		}
		
		/**
		 * 	Traces an stack trace
		 */
		public static function outputStack():void {
			
			trace('output stack');
			try {
				throw(new Error('stack trace'));
			} catch (e:Error) {
				trace(e.getStackTrace());
			}
		}

	}
}