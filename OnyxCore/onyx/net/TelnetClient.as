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
package onyx.net {
	
	import flash.events.*;
    import flash.net.Socket;
    import flash.system.Security;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;
    
    import onyx.events.TelnetEvent;
    
    [Event(name='state', 	type='onyx.events.TelnetEvent')]
	[Event(name='data', 	type='onyx.events.TelnetEvent')]
	
	/**
	 * 	Telnet Client
	 */
    public class TelnetClient extends EventDispatcher {
    	
        protected static const CR:int 		= 13; 		// Carriage Return (CR)
        protected static const WILL:int 	= 0xFB; 	// 251 - WILL (option code)
        protected static const WONT:int 	= 0xFC; 	// 252 - WON'T (option code)
        protected static const DO:int   	= 0xFD; 	// 253 - DO (option code)
        protected static const DONT:int 	= 0xFE; 	// 254 - DON'T (option code)
        protected static const IAC:int  	= 0xFF; 	// 255 - Interpret as Command (IAC)

        protected var _serverURL:String;
        protected var _portNumber:Number;
        protected var _socket:Socket;
        
        protected var _status:String;			// socket status (connected, unconnected, error)
        protected var _code:int;				// output data code
		protected var _data:String;				// output text from telnet server
        
		/**
		 * 	@constructor
		 */
        public function TelnetClient():void {
            
            _serverURL 	= new String();
            _portNumber = new Number();
            
            _status 	= new String();
            _code 		= 0;
            _data 		= new String();
                        
            // Create a new Socket object and assign event listeners.
            _socket = new Socket();
            _socket.addEventListener(Event.CONNECT, _connectHandler);
            _socket.addEventListener(Event.CLOSE, _closeHandler);
            _socket.addEventListener(ErrorEvent.ERROR, _errorHandler);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, _dataHandler);
            
        }
        
        public function connect(server:String, port:Number):void {
        	
        	_serverURL 	= server;
            _portNumber = port;
            
            _socket.connect(server, int(port));
            
        }
        
        public function disconnect():void {
        
            _socket.close();
            
        }
        
        /**
         * Socked methods
         *
         * */
        private function _ioErrorHandler(event:IOErrorEvent):void {
            _status = "Unable to connect: socket error";
            dispatchEvent(new TelnetEvent(TelnetEvent.STATE, _status));
        }

		/**
		 * 	@private
		 */                
        private function _connectHandler(event:Event):void {
            if (_socket.connected) {
                _status = "connected";
            } else {
                _status = "not connected";
            }
            dispatchEvent(new TelnetEvent(TelnetEvent.STATE, _status));
        }
        
		/**
		 * 	@private
		 */                
        private function _closeHandler(event:Event):void {
        	        	
            _status = "Disconnected by the server";
            dispatchEvent(new TelnetEvent(TelnetEvent.STATE, _status));
        }
        
		/**
		 * 	@private
		 */                
        private function _errorHandler(event:ErrorEvent):void {
            _status = event.text;
            dispatchEvent(new TelnetEvent(TelnetEvent.STATE, _status));
        }
        
		/**
		 * 	@private
		 */                
        protected function _dataHandler(event:ProgressEvent):void {
            
            var n:int = _socket.bytesAvailable;
            _data = '';
            
            // Loop through each available byte returned from the socket connection.
            while (--n >= 0) {
                // Read next available byte.
                var b:int = _socket.readUnsignedByte();
                switch (_code) {
                    case 0:
                        // If the current byte is the "Interpret as Command" code, set the state to 1.
                        if (b == IAC) {
                            _code = 1;
                        // Else, if the byte is not a carriage return, store character to _data.
                        } else if (b != CR) {
                            _data = _data.concat(String.fromCharCode(b));
                        }
                        break;
                    case 1:
                        // If the current byte is the "DO" code, set the state to 2.
                        if (b == DO) {
                            _code = 2;
                        } else {
                            _code = 0;
                        }
                        break;
                    // Blindly reject the option.
                    case 2:
                        /*
                            Write the "Interpret as Command" code, "WONT" code, 
                            and current byte to the socket and send the contents 
                            to the server by calling the flush() method.
                        */
                        _socket.writeByte(IAC);
                        _socket.writeByte(WONT);
                        _socket.writeByte(b);
                        _socket.flush();
                        _code = 0;
                        break;
                }
            }
            // dispatch an event complete
            dispatchEvent(new TelnetEvent(TelnetEvent.DATA, _data));
        }
                
        /**
		 *  Send generic command manually.
		 **/
		public function sendCommand(command:String):void {
		    var by:ByteArray = new ByteArray();
		    by.writeMultiByte(command + "\n", "UTF-8");
		    _socket.writeBytes(by);
		    _socket.flush();
		}
		
		/**
		 *  Get connection infos 
		 **/
		public function get serverURL():String {
        	return _serverURL;
        }
        
        public function get portNumber():Number {
        	return _portNumber;
        }
        
        public function get status():String {
        	return _status;
        }
        
        public function set status(value:String):void {
        	_status = value;
        }
                
    }
}
