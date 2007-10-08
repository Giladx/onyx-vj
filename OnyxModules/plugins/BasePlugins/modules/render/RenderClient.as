package modules.render {
	
	import flash.events.*;
	import flash.net.Socket;
	
	import onyx.constants.*;
	import onyx.core.Console;
	import onyx.plugin.Module;
	
	public final class RenderClient extends Module {
		
		/**
		 * 	@private
		 */
		private var socket:Socket;
		
		/**
		 * 	@private
		 */
		private var job:RenderJob;
		
		/**
		 * 
		 */
		override public function initialize():void {
			socket = new Socket();
			socket.addEventListener(Event.CLOSE,						handler);
			socket.addEventListener(Event.CONNECT,						handler);
			socket.addEventListener(IOErrorEvent.IO_ERROR,				handler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,			handler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	handler);
		}
		
		private function handler(event:Event):void {
			switch (event.type) {
				case Event.CONNECT:
					if (!job) {
						this.job = new RenderJob(socket, AVAILABLE_DISPLAYS[0]);
					}
					break;
			}
			Console.output(event.type);
		}
		
		override public function command(... args:Array):String {
			var command:String = args.shift() as String;
			
			switch (command) {
				case 'PAUSE':
					return '';
				case 'STATUS':
					return (socket && socket.connected) ? 'connected' : 'not connected';

				case 'CONNECT':
					
					var host:String = args[0] || 'localhost'; 
					var port:int	= args[1] || 8888;

					socket.connect(host, port);
					
					return 'connecting to ' + host + ':' + port;
			}
			return '';
		}
	}
}