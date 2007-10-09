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

	import flash.system.Capabilities;
	
	import onyx.constants.*;
	import onyx.display.*;
	import onyx.jobs.StatJob;
	import onyx.plugin.*;
	
	use namespace onyx_ns;

	/**
	 * 	This class defines command-line commands usable by Onyx
	 */
	public final class Command {
		
		/**
		 * 	@private
		 */
		private static const _modules:Object = {}
		
		/**
		 * 	Registers a module to be executable through the console object
		 */
		public static function registerModule(name:String, module:Module):void {
			_modules[name] = module;
		}
		
		/**
		 * 	Executes a command
		 */
		internal static function execute(name:String, args:Array):Object {
			
			var method:Function = Command[name];
			var module:Module	= _modules[name];
			
			try {
				if (method !== null) {
					var message:String = method.apply(null, args);
				} else if (module !== null) {
					message = ((args.length > 0) ? '' : _createHeader(name)) + module.command.apply(module, args);
				}
			} catch (e:Error) {
				return e;
			}
			
			return message;
		}
		
		/**
		 * 	@private
		 * 	Help information
		 */
		private static function help(... args:Array):String {
			
			var text:String;
			
			switch (args[0]) {
				case 'command':
				case 'commands':
				
					text =	_createHeader('commands') + 'PLUGINS: SHOWS # OF PLUGINS<br>' +
							'CLEAR: CLEARS THE TEXT<br>' +
							'STAT [TIME:INT]:	TESTS ALL LAYERS FOR AVERAGE RENDERING TIME<br>' +
							'HELP CONTRIBUTORS: LIST OF CONTRIBUTORS TO THE ONYX PROJECT<br>' +
							'RESOLUTION: OUTPUTS THE SIZE OF THE FLASH STAGE'
				
					break;
				case 'contributors':
					text =	'CONTRIBUTORS<br>-------------<br>DANIEL HAI: <A HREF="HTTP://WWW.DANIELHAI.COM">HTTP://WWW.DANIELHAI.COM</A>'
					break;
				case 'plugins':
					text =	Filter.filters.length + ' FILTERS, ' +
							Transition.transitions.length + ' TRANSITIONS, ' +
							Visualizer.visualizers.length + ' VISUALIZERS LOADED.';
					break;
				case 'version':
					text =	'FLASH PLUG-IN VERSION: ' + Capabilities.version;
					break;
				case 'modules':
					text =	'';
					for each (var module:Module in Module.modules) {
						text +=	module.name + ' loaded.  type ' + module.name + ' for options.<br>'
					}
					break;
				// dispatch the start-up motd
				default:
					text =	_createHeader('<b>ONYX ' + VERSION + '</b>', 21) + 
							'COPYRIGHT 2003-2007: WWW.ONYX-VJ.COM' +
							'<br>TYPE "HELP" OR "HELP COMMANDS" FOR MORE COMMANDS.' +
							'<br>' ;
					break;
			}
			
			// output?
			return text;
		}
		
		/**
		 * 	@private
		 */
		private static function _createHeader(command:String, size:int = 14):String {
			return '<font size="' + size + '" color="#DCC697" face="Pixel">' + command + '</font><br>';
		}

		/**
		 * 	Gets resolution
		 */		
		private static const resolution:Function = res;

		/**
		 * 	Gets resolution
		 */		
		private static function res():String {
			return 'RESOLUTION: ' + STAGE.stageWidth + 'x' + STAGE.stageHeight;
		}
		
		/**
		 * 	Finds out
		 */
		private static function stat(... args:Array):String {
			
			// does a stat job for a specified amount of time
			var time:int = args[0] || 2;
			
			var job:StatJob = new StatJob();
			job.initialize(time);
			
			return 'STARTING STAT JOB FOR ' + time.toFixed(2) + ' SECONDS';
		}
		
		/**
		 * 
		 */
		private static function layer(... args:Array):String {
			
			try {
				
				var display:IDisplay	= AVAILABLE_DISPLAYS[0];
				var layer:ILayer		= display.layers[args[0]];
				
				layer[args[1]] = args[2];
			} catch (e:Error) {
				Console.error(e.message);
			}
			
			return 'unimplemented';
		}
		
	}
}
