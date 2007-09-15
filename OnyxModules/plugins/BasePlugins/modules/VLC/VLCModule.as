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
package modules.VLC{
	
	import flash.events.*;
	
	import modules.VLC.events.VLCEvent;
	
	import onyx.events.TelnetEvent;
		
	import onyx.core.Console;
	import onyx.plugin.Module;
	
	/**
	 * 	VLC Module
	 * 	Written by Stefano Cottafavi
	 */
	public final class VLCModule extends Module {
		
		/**
		 * 	@private
		 * 	VLC Client
		 */
		private var client:VLCClient;

		/**
		 * 	Turn on the module
		 */		
		override public function initialize():void {
			
			client = new VLCClient();
			client.addEventListener(TelnetEvent.STATE, 	_onState);
			
			//remove if you don't want to print everything out
			client.addEventListener(VLCEvent.DATA, _onData);
						
			client.connect('localhost', 4212);
		}
		
		/**
		 * 	@private
		 * 	Connection handler
		 */
		private function _onState(event:TelnetEvent):void {
			
			switch(event.message) {
				
				case 'connected' 	: client.sendCommand("admin");
				case 'not connected': Console.output('\n  VLCModule: '+client.status+' TO VLC @ '+client.serverURL+':'+client.portNumber.toString()+'\n');
										break;
				default				: Console.output(event.message);
					
			}
			
		}
		
		/**
		 * 	@private
		 */
		private function _onData(event:VLCEvent):void {
			
			Console.output(event.message);
		
		}
		
		/**
		 * 	Custom command
		 */
		override public function command(... args:Array):String {
			
			switch (args[0].toString()) {
				
				case 'STATE'		: return client.status+' TO VLC @ '+client.serverURL+':'+client.portNumber.toString();
								
				case 'CONNECT'		: if (args.length != 3) {
											Console.executeCommand('vlc');	
										  } else {
										  	client.connect(args[1], args[2]);
										  }
									  return '';
		  	  
				case 'DISCONNECT'	: client.disconnect();
									  client.status = 'Disconnected by the client';
									  return client.status;
				
				case 'SHOW'			: client.show();
									  return null;
									  
				default				: return 'USAGE:<br>' + 'vlc state<br>' +
											 'vlc connect server port<br>' +
											 'vlc disconnect <br>';
							
			}

		}
		
	}
}
