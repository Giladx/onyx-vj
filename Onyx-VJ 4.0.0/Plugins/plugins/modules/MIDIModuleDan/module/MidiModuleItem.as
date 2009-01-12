package module {
	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	public final class MidiModuleItem extends Module {
		
		public var    conn:Socket;

		/**
		 * 	@private
		 */
		private var _host:String	= 'localhost';
		private var _port:String	= '10000';
		private var   _timer:Timer;
		private var   _attempts:int;
		
		private var   debugger:MidiDebugger;

		/**
		 * 	@constructor
		 */		
		public function MidiModuleItem():void {

			// init			
			super(new ModuleInterfaceOptions(null, 140, 110));
			
			// add parameters
			parameters.addParameters(
				new ParameterString('host', 'host'),
				new ParameterString('port', 'port'),
				new ParameterExecuteFunction('connect', 'connect')
			);
			
		}
		
		
		
		/**
		 * 	Turn on the module
		 */		
		override public function initialize():void {
			
			trace('init');
                        		
			conn     = new Socket();
            
            _attempts = 0;
                
		    conn.addEventListener(Event.CONNECT, handleSocketConnected);
		    conn.addEventListener(Event.CLOSE, handleSocketClose);
            conn.addEventListener(ProgressEvent.SOCKET_DATA, handleProgress);
            conn.addEventListener(IOErrorEvent.IO_ERROR, handleSocketIOError);
            conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSocketSecurityError);
            
            // connect
            connect();

        }
	    
	    
	    public function connect():void {
            
            // 10sec timeout
            if(_attempts<10) {
            	_attempts += 1;
	            try{
	            	Console.output('MIDI Module: attempt '+_attempts+' on '+_host+'@'+_port);
	                conn.connect(_host, int(_port));
	            } catch (e : SecurityError) {
	            	_scheduleReconnect()
	            }
	       	} else {
	       		Console.output('MIDI Module: network down');
	       		_attempts = 0;
	       	}
	       	
	    }
	    	    
        /**
         * 
         */
        public function get connected():Boolean {
        	return conn.connected;
        }
        
        /**
         * 
         */
	    private function _reconnect(event:Event): void {
            _timer.removeEventListener(TimerEvent.TIMER, _reconnect);
            _timer.stop();
            _timer = null;
            connect();
        }
		     
        
		public function set host(value:String):void {
			_host = value;
		}
		
		public function get host():String {
			return _host;
		}
		
		public function set port(value:String):void {
			_port = value;
		}
		
		public function get port():String {
			return _port;
		}
		
		
		private function handleSocketConnected(e : Event) : void {
            Console.output('MIDI Module: connected');
            _attempts = 0;
        }
        
        private function handleSocketIOError(e : IOErrorEvent) : void {
        	Console.output("MIDI Module: unable to connect, socket error");
        	_scheduleReconnect();
        }
        
        private function handleSocketSecurityError(e : SecurityErrorEvent) : void {
            Console.output('MIDI Module: security error');
        }
        
        private function handleSocketClose(e:Event):void {
        	Console.output('MIDI Module: connection lost');
       		_scheduleReconnect();
        }
         
        private function _scheduleReconnect():void {
            _timer = new Timer(1000,1);
            _timer.addEventListener(TimerEvent.TIMER, _reconnect);
            _timer.start();
        }
        
       
        private function handleProgress(event:ProgressEvent):void {
            
            var n:int = event.bytesLoaded;
            var data:ByteArray = new ByteArray();
            
            conn.readBytes(data,0,n);
            
            // SC: TODO...n==3 very restrictive due to startup errors!!
            // if(n==3) Midi.receiveMessage(data);
            
        }
        
		public function sendData(bytes:ByteArray):void {
			conn.writeBytes(bytes);
			conn.flush();
		}
        
		/**
		 * 
		 */
		override public function command(... args:Array):String {
			
			var command:String = args.shift();
			
			switch (command) {
				case 'debug':
				
					if (debugger) {
						debugger.stop();
						debugger = null;
					} else {
						debugger = new MidiDebugger(args[0] || 0, args[1] || 0xb0);
						debugger.start()
					}
					
					return 'DEBUG ' + (debugger ? ' STARTED' : 'STOPPED');
			}
			
			return 'COMMANDS:\nRECEIVE device command # #\n SENDS A DEBUG MIDI EVENT\n';
		}
		
		override public function close():void {
			
			if(conn.connected) {
				var bytes:ByteArray = new ByteArray();
				bytes.writeMultiByte('quit','quit');
				
				sendData(bytes);
				conn.close();
			}
			
			super.close();	
				
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			super.dispose();
		}
	}
}



/**
 * 
 *	MIDI Debugger
 *   	
 **/
import onyx.plugin.DISPLAY_STAGE; 
import flash.events.Event;

final class MidiDebugger {
	
	public var deviceIndex:int;
	public var command:int;
	
	/**
	 * 	@constructor
	 */
	public function MidiDebugger(deviceIndex:int, command:int):void {
		this.deviceIndex	= deviceIndex,
		this.command		= command;
	}
	
	public function start():void {
		DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, sendMessage);
	}
	
	private function sendMessage(event:Event):void {
		// Midi.sendMessage(0xFF,50);  
	}
	
	public function stop():void {
		DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, sendMessage);
	}
		
}
