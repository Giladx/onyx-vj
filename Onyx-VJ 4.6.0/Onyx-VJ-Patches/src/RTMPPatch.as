package
{	
	import flash.display.BitmapData;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetDataEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Matrix;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	public class RTMPPatch extends Patch 
	{
		
		// fms
		//private var host:String								= 'rtmp://192.168.0.10/live';
		private var host:String								= 'rtmfp://localhost';
		
		//cumulus engine private var host:String								= 'rtmp://localhost:1935/live';
		private var streamName:String							= 'livestream';
		//private var streamName:String							= 'cameraFeed';
		

		//private var connection:NetConnection					= new NetConnection();

		private var stream:NetStream;

		private var video:Video;

		public function RTMPPatch():void 
		{
			
			//connect();
		}
		
		/**
		 * 	@parameter
		 */
		/*private function connect():void {
			trace("connect");
			if (connection.uri !== host) {
				
				if (connection.connected) {
					clearConnections();
				}
				
				Security.loadPolicyFile('http://localhost/crossdomain.xml');
				connection.addEventListener(NetStatusEvent.NET_STATUS, handleConnection);
				connection.client = this;
				connection.connect(host);
				
			}
		}*/
		/**
		 * 	@public
		 */
		public function onBWDone():void {
			trace("onBWDone");
		}
		/**
		 * 	@public
		 */
		public function onFCSubscribe(info:Object):void{
			trace("onFCSubscribe");
		}
		
		/**
		 * 	@private
		 */
		private function clearConnections():void {
			
			/*connection.close();
			if (stream) {
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,		trace);
				stream.removeEventListener(NetStatusEvent.NET_STATUS,	handleStream);
				stream.close();
			}
			if (video) {
				video.attachNetStream(null);
				video = null;
			}*/
		}
		
		/**
		 * 	@private
		 */
		private function handleConnection(event:NetStatusEvent):void {
			/*Console.output( 'RTMPPatch: ' + event.info.code);
			switch (event.info.code) {
				case 'NetConnection.Connect.Success':
					
					stream = new NetStream(connection);
					stream.client	= this;
					stream.checkPolicyFile = true;// needed???
					stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, trace);
					stream.addEventListener(NetStatusEvent.NET_STATUS, handleStream);
					
					stream.bufferTime			= 0;
					stream.backBufferTime		= 0;
					stream.useHardwareDecoder	= true;
					stream.play(streamName);
					
					break;
				case 'NetStream.Buffer.Full':// must be somewhere else...
					
					Console.output( 'RTMPPatch: ' + event.info.code);
					
					break;
			}*/
		}
		
		/**
		 * 	@public
		 */
		public function onMetaData(info:Object):void {
			
			Console.output( 'RTMPatch: ' + info.width, info.height);
						
			if (video) {
				video.attachNetStream(null);
				video = null;
			}			
			video	= new Video(320, 240);
			//video	= new Video(info.width, info.height);
			video.attachNetStream(stream);			
		}
		
		/**
		 * 	@private
		 */
		private function handleStream(e:NetStatusEvent):void {
			trace(e.info.code);
		}
		
		override public function render(info:RenderInfo):void {
			
			var source:BitmapData = info.source;
			if (video) {
				//source.clear();
				try {
					source.draw(video);
				} catch (e:Error) {
					Console.output( e.message);
				}
			}
			info.copyPixels(source);

		}
		/**
		 * 	@public
		 */
		override public function dispose():void {
			
			if (stream) {
				
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,		trace);
				stream.removeEventListener(NetStatusEvent.NET_STATUS,	handleStream);
				stream.close();
				stream = null;
				
			}
			
			/*if (connection) {
				connection.removeEventListener(NetStatusEvent.NET_STATUS, handleConnection);
				if (connection.connected) {
					connection.close();
				}
			}*/
			
			super.dispose();
			
		}
		
	}
}