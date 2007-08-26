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
	
	import onyx.core.Console;
	import onyx.plugin.Module;
	
	/**
	 * 	VLC Module
	 * 	Written by Stefano Coffati
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
			client.addEventListener(Event.CONNECT, _onConnect);
			client.addEventListener(Event.CLOSE, _onClose);
			client.addEventListener(ErrorEvent.ERROR, _onError);
			client.addEventListener(Event.COMPLETE, _onComplete);
			
			client.connect('localhost', 4212);
		}
		
		/**
		 * 	@private
		 * 	Connection handler
		 */
		private function _onConnect(event:Event):void {
			
			client.sendCommand("admin");
			Console.output('VLCModule: blah blah');
			
			// output
			// Console.stateVlc(vlc.status+' TO VLC @ '+vlc.serverURL+':'+vlc.portNumber.toString());
									
			client.show();
		}
		
		/**
		 * 	@private
		 */
		private function _onClose(event:Event):void {
			
			Console.output(client.status);
			
		}
		
		/**
		 * 	@private
		 */
		private function _onError(event:ErrorEvent):void {
			
			Console.output(client.status);

		}
		
		/**
		 * 	@private
		 */
		private function _onComplete(event:Event):void {
			
			Console.output(client.data);
		
		}
		
		/**
		 * 	Custom command
		 */
		override public function command(... args:Array):String {
			
			var command:String = args.shift();
			
			switch (command) {
				/*
				case 'connect'		: if (args.length != 3) {
											HELP('vlc');	
										  } else {
										  	Console.getInstance().vlc.connect(args[1], args[2]);
										  }
									  	  break;
				case 'disconnect'	: Console.getInstance().vlc.disconnect();
									  Console.getInstance().vlc.status = 'Disconnected by the client';
									  Console.stateVlc(Console.getInstance().vlc.status);
									  break;
				*/
				default:
					return	'USAGE:<br>' + 'vlc connect server port<br>' +
							'vlc disconnect <br>';
			}
			
			return '';
		}
		
	}
}

/**
		public var vlc:Vlc = new Vlc();		
		private static const REUSABLE_VLC_STATE:VlcEvent	= new VlcEvent('state','');
		private static const REUSABLE_VLC_DATA:VlcEvent		= new VlcEvent('data','');

		// add VLC listeners
		vlc.addEventListener(Event.CONNECT, _onConnect);
		vlc.addEventListener(Event.CLOSE, _onClose);
		vlc.addEventListener(ErrorEvent.ERROR, _onError);
		vlc.addEventListener(Event.COMPLETE, _onComplete);

		private function _onClose(event:Event):void {
			
			Console.stateVlc(vlc.status);
			
		}
		
		private function _onError(event:ErrorEvent):void {
			
			Console.stateVlc(vlc.status);

		}
		
		private function _onComplete(event:Event):void {
			
			Console.dataVlc(vlc.data);
		
		}
		
		public static function stateVlc(... args:Array):void {
			
			REUSABLE_VLC_STATE.message	= args.join(' ');
			
			dispatcher.dispatchEvent(REUSABLE_VLC_STATE);
		}
		
		public static function dataVlc(... args:Array):void {
			
			REUSABLE_VLC_DATA.message	= args.join(' ');
			
			dispatcher.dispatchEvent(REUSABLE_VLC_DATA);
		}
		
		public function get remote():Boolean {
			return _remote;
		}
		
		public function set remote(value:Boolean):void {
			_remote = value;
		}
**/