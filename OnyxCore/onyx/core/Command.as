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

	import onyx.constants.*;
	import onyx.display.*;
	import onyx.jobs.StatJob;
	import onyx.plugin.*;
	
	use namespace onyx_ns;

	/**
	 * 	This class defines command-line commands usable by Onyx
	 */
	public final class Command {
		
		public static function help(... args:Array):void {
			
			var text:String;
			
			switch (args[0]) {
				case 'command':
				case 'commands':
				
					text =	_createHeader('commands') + 'PLUGINS: SHOWS # OF PLUGINS<br>' +
							'CLEAR: CLEARS THE TEXT<br>' +
							'STAT [TIME:INT]:	TESTS ALL LAYERS FOR AVERAGE RENDERING TIME<br>' +
							'HELP CONTRIBUTORS: LIST OF CONTRIBUTORS TO THE ONYX PROJECT<br>' +
							'RESOLUTION: OUTPUTS THE SIZE OF THE FLASH STAGE';
							'VLC: TOGGLE LOCAL(CONSOLE)/REMOTE(TELNET)';
				
					break;
				case 'contributors':
					text =	'CONTRIBUTORS<br>-------------<br>DANIEL HAI: <A HREF="HTTP://WWW.DANIELHAI.COM">HTTP://WWW.DANIELHAI.COM</A>'
					break;
				case 'plugins':
					text =	Filter.filters.length + ' FILTERS, ' +
							Transition.transitions.length + ' TRANSITIONS, ' +
							Visualizer.visualizers.length + ' VISUALIZERS LOADED.';
					break;
				case 'stat':
					text =	_createHeader('stat') + 'TESTS FRAMERATE AND LAYER RENDERING TIMES.<br><br>USAGE: STAT [NUM_SECONDS:INT]<br>';
					break;
				case 'vlc':
					text =	_createHeader('vlc') + 'VLC COMMANDS HELP<br><br>CTRL+T toggle console/telnet<br>' + 
					'USAGE:<br>' + 'vlc connect server port<br>' +
									'vlc disconnect <br>';
					break;
				// dispatch the start-up motd
				default:
					text =	_createHeader('<b>ONYX ' + VERSION + '</b>', 21) + 
							'COPYRIGHT 2003-2007: WWW.ONYX-VJ.COM' +
							'<br>TYPE "HELP" OR "HELP COMMANDS" FOR MORE COMMANDS.' +
							'<br>TYPE "CTRL+T" FOR TELNET CONSOLE.' +
							'<br>' ;
					break;
			}
			
			// output?
			Console.output(text);
		}
		
		private static function _createHeader(command:String, size:int = 14):String {
			return '<font size="' + size + '" color="#DCC697" face="Pixel">' + command + '</font><br><br>';
		}

		/**
		 * 	Gets resolution
		 */		
		public static const resolution:Function = res;

		/**
		 * 	Gets resolution
		 */		
		public static function res():void {
			Console.output('RESOLUTION: ' + STAGE.stageWidth + 'x' + STAGE.stageHeight);
		}
		
		/**
		 * 	Finds out
		 */
		public static function stat(... args:Array):void {
			
			// does a stat job for a specified amount of time
			var time:int = args[0] || 2;
			
			var job:StatJob = new StatJob();
			job.initialize(time);
		}
		
		/**
		 * 
		 */
		public static function layer(... args:Array):void {
			
			try {
				
				var display:Display = Display.getDisplay(0);
				var layer:ILayer	= display.layers[args[0]];
				
				layer[args[1]] = args[2];
			} catch (e:Error) {
				Console.error(e.message);
			}
			
		}
		
		/**
		 * 
		 */
		public static function vlc(... args:Array):void {
			
				switch(args[0]) {
					case 'connect'		: if(args.length != 3) {
											help('vlc');	
										  } else {
										  	Console.getInstance().vlc.connect(args[1], args[2]);
										  }
									  	  break;
					case 'disconnect'	: Console.getInstance().vlc.disconnect();
										  Console.getInstance().vlc.status = 'Disconnected by the client';
										  Console.stateVlc(Console.getInstance().vlc.status);
										  break;
					default				: help('vlc');
				}
				
		}
		
	}
}
