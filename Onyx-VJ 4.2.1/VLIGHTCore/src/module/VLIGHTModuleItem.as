package module {
	
	import events.VLIGHTEvent;
	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.xml.XMLNode;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;
	
	public class VLIGHTModuleItem extends Module {
		
		public const VLIGHT:EventDispatcher = new EventDispatcher();
		
		public var 	conn:XMLSocket;
		private var _host:String;
		private var _port:String;
		
		private var _timer:Timer;
		private var _attempts:int;
		
		private var _refresh:int;	//[ms]
		private var ef:Boolean;		//flag
		
		public function VLIGHTModuleItem() {
			
			_host = '127.0.0.1';
			_port = '2048'; //'2049';
			
			// init			
			super(new ModuleInterfaceOptions(null, 140, 110));
			
			// add parameters
			parameters.addParameters(
				new ParameterString('host', 'host'),
				new ParameterExecuteFunction('connect', 'connect')
			);
			
		}
		
		/**
		 * 
		 */
		override public function initialize():void {
				
			conn     = new XMLSocket();
			
			_refresh 	= 1000;
			_attempts 	= 0;
			
			conn.addEventListener(Event.CONNECT, handleSocketConnected);
			conn.addEventListener(Event.CLOSE, handleSocketClose);
			//conn.addEventListener(DataEvent.DATA, onData, false, -1);
			conn.addEventListener(IOErrorEvent.IO_ERROR, handleSocketIOError);
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSocketSecurityError);
			
			// connect
			connect();
			
		}
		private function _scheduleReconnect():void {
			_timer = new Timer(1000,1);
			_timer.addEventListener(TimerEvent.TIMER, _reconnect);
			_timer.start();
		}
		private function _reconnect(event:Event): void {
			_timer.removeEventListener(TimerEvent.TIMER, _reconnect);
			_timer.stop();
			_timer = null;
			connect();
		}
		public function connect():void {
		
			// 10sec timeout
			if(_attempts<10) {
				_attempts += 1;
				try{
					Console.output('VLIGHT Module: attempt '+_attempts+' on '+_host+'@'+_port);
					conn.connect(_host, int(_port));
															
				} catch (e : SecurityError) {
					_scheduleReconnect()
				} finally {
					// timer with refresh
					ef = true
					_timer = new Timer(_refresh,0);
					_timer.addEventListener(TimerEvent.TIMER, _update);
					_timer.start();
				}
			} else {
				Console.output('VLIGHT Module: network down');
				_attempts = 0;
			}
			
		}
		private function _update(e: TimerEvent):void {
			conn.addEventListener(DataEvent.DATA, onData, false, -1);
		}
		
		
		private function handleSocketConnected(e : Event) : void {
			Console.output('VLIGHT Module: connected');
			_attempts = 0;
		}
		private function handleSocketIOError(e : IOErrorEvent) : void {
			Console.output("VLIGHT Module: unable to connect, socket error");
			_scheduleReconnect();
		}
		private function handleSocketSecurityError(e : SecurityErrorEvent) : void {
			Console.output('VLIGHT Module: security error');
		}
		private function handleSocketClose(e:Event):void {
			Console.output('VLIGHT Module: connection lost');
			_scheduleReconnect();
		}
	
		private function onData(event:DataEvent):void {
			
			trace(VLIGHT.hasEventListener(VLIGHTEvent.PEAK));
			//var xml:XML = new XML(event.data);
			conn.removeEventListener(DataEvent.DATA, onData);
			//if(xml.name()=="sound")
			//	Console.output(xml.attribute("a"));
			///Console.output(event.data);
			VLIGHT.dispatchEvent(new VLIGHTEvent(VLIGHTEvent.PEAK,1)); 
			
		}
				
	}
}