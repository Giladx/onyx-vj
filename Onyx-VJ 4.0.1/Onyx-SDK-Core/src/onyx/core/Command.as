/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package onyx.core {

	import flash.system.Capabilities;
	
	import onyx.display.*;
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
			if (module) {
				_modules[name] = module;
			} else {
				delete _modules.name;
			}
		}
		
		/**
		 * 	Executes a command
		 */
		internal static function execute(name:String, args:Array):Object {
			
			const method:Function = Command[name];
			const module:Module	= _modules[name.toUpperCase()];
			
			try {
				if (method !== null) {
					var message:String = method.apply(Command, args);
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
							'RESOLUTION: OUTPUTS THE SIZE OF THE FLASH DISPLAY_STAGE'
				
					break;
				case 'contributors':
					text =	'CONTRIBUTORS<br>-------------<br>' +
							'DANIEL HAI: <A HREF="HTTP://WWW.DANIELHAI.COM">HTTP://WWW.DANIELHAI.COM</A>' +
							'BRUCE LANE: <A HREF="HTTP://WWW.BATCHASS.FR">HTTP://WWW.BATCHASS.FR</A>' +
							'STEFANO COTTAFAVI';
					break;
				case 'plugins':
					text =	PluginManager.filters.length + ' FILTERS, ' +
							PluginManager.transitions.length + ' TRANSITIONS, ' +
							PluginManager.visualizers.length + ' VISUALIZERS LOADED.';
					break;
				case 'version':
					text =	'FLASH PLUG-IN VERSION: ' + Capabilities.version;
					break;
				case 'modules':
					text =	'';
					for each (var module:Module in PluginManager.modules) {
						text +=	module.name + ' loaded.  type ' + module.name + ' for options.<br>'
					}
					break;
				// dispatch the start-up motd
				default:
					text =	_createHeader('<b>ONYX ' + VERSION + '</b>', 21) + 
							'COPYRIGHT 2003-2010: WWW.ONYX-VJ.COM' ;/*+
							'<br>TYPE "HELP" OR "HELP COMMANDS" FOR MORE COMMANDS.' ;*/
					break;
			}
			
			// output?
			return text;
		}
		
		/**
		 * 	@private
		 */
		private static function _createHeader(command:String, size:int = 14):String {
			return '<font size="' + size + '" color="#DCC697" face="DefaultFont">' + command + '</font><br>';
		}

		/**
		 * 	Gets resolution
		 */		
		private static const resolution:Function = res;

		/**
		 * 	Gets resolution
		 */		
		private static function res():String {
			return 'RESOLUTION: ' + DISPLAY_STAGE.stageWidth + 'x' + DISPLAY_STAGE.stageHeight;
		}
	}
}
