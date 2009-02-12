package module {
	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.asset.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;
	
	import midi.*;
	
	import ui.states.MidiLearnState;
	import ui.states.MidiSaveState;
	
	/**
	 * 
	 */
	public final class MidiModuleItem extends Module {
		
		/**
		 * 	@private
		 */
		private const controls:Dictionary	= UserInterface.getAllControls();
		
		public var    conn:Socket;
		private var   _host:String;
		private var   _port:String;
		
		private var   _timer:Timer;
		private var   _attempts:int;
		
		/**
		 * 	@constructor
		 */		
		public function MidiModuleItem():void {
			
			_host = '127.0.0.1';
			_port = '20000';
			
			// init			
			super(new ModuleInterfaceOptions(null, 140, 110));
			
			// add parameters
			parameters.addParameters(
				new ParameterString('host', 'host'),
				new ParameterString('port', 'port'),
				new ParameterExecuteFunction('connect', 'connect'),
				
				new ParameterExecuteFunction('learn', 'learn'),	
				new ParameterExecuteFunction('save', 'save'),	
				new ParameterExecuteFunction('load', 'load')
			);
			
		}
		
		
		/**
		 * 
		 */
		override public function initialize():void {
			
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
	    
	    public function get connected():Boolean {
        	return conn.connected;
        }
		
		private function _reconnect(event:Event): void {
            _timer.removeEventListener(TimerEvent.TIMER, _reconnect);
            _timer.stop();
            _timer = null;
            connect();
        }
        private function _scheduleReconnect():void {
            _timer = new Timer(1000,1);
            _timer.addEventListener(TimerEvent.TIMER, _reconnect);
            _timer.start();
        }
        
        
		/**
		 * 	@public
		 */
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
				
						
		/**
		 * 
		 */
		public function learn():void {
            StateManager.loadState(new MidiLearnState());
        }
        public function load():void {
            //StateManager.loadState(new MidiLoadState());
            
            //for (var i:Object in UserInterface.getAllControls()) {
			//	Console.output((i as UserInterfaceControl).getParameter());
			//}
			
			/*for (var i:Object in UserInterface.getAllControls()) {
				(i as UserInterfaceControl).addEventListener(MouseEvent.MOUSE_DOWN, handler);
			}*/
            
        }
		public function save():void {
            StateManager.loadState(new MidiSaveState());
        }
		/**
		 * 	@private
		 */
		private function _onFileSaved(query:AssetQuery):void {
			Console.output(query.path + ' saved.');
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
        
        
        private function handleProgress(event:ProgressEvent):void {
            
            var n:int = event.bytesLoaded;
            var data:ByteArray = new ByteArray();
            
            conn.readBytes(data,0,n);
            
            // SC: TODO...n==3 very restrictive due to startup errors!!
            if(n==3) Midi.receiveMessage(data);
            
        }
        
		public function sendData(bytes:ByteArray):void {
			conn.writeBytes(bytes);
			conn.flush();
		}
		
		/*private function handler(event:MouseEvent):void {
			trace(event.currentTarget);
		}	
		public function highlight2():void {
			for (var i:Object in UserInterface.getAllControls()) {
				(i as UserInterfaceControl).transform.colorTransform = new ColorTransform(2,2,2,1);
			}
		}*/
		
		
	}
}