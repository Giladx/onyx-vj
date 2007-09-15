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
package modules.VLC {
	
	import flash.events.*;
	
	import onyx.net.TelnetClient;
	
	import modules.VLC.events.VLCEvent;
    
    //[Event(name='state', 	type='modules.VLC.events.VLCEvent')]
	//[Event(name='data', 	type='modules.VLC.events.VLCEvent')]
	//[Event(name='length', 	type='modules.VLC.events.VLCEvent')]
	//[Event(name='time', 	type='modules.VLC.events.VLCEvent')]
	//[Event(name='rate', 	type='modules.VLC.events.VLCEvent')]
	
	/**
	 * Telnet subclass that implements specific VLC commands
	 **/
    public class VLCClient extends TelnetClient {
    	
    	private var _vcodec:String;
		private var _acodec:String;
		private var _samplerate:String;
		private var _access:String;
		private var _mux:String;
		private var _dst:String;
		
		// this will be used to identify the 
		// request to the server (length, time, etc..)
		public var request:String = '';
       	
       	override protected function _dataHandler(event:ProgressEvent):void {
            
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
            
            //control for the information asked to server: length, time or other
           	switch(request) {
           		
           		case 'length'	: _data = _data.split('rate :')[1].split('title :')[0] ;
           							dispatchEvent(new VLCEvent(VLCEvent.LENGTH, _data));
           						  	break;
           						  	
           		case 'time'		: _data = _data.split('rate :')[1].split('title :')[0] ;
           							dispatchEvent(new VLCEvent(VLCEvent.TIME, _data));
           							break;
           							
           		case 'rate'		: _data = _data.split('rate :')[1].split('title :')[0] ;
           							dispatchEvent(new VLCEvent(VLCEvent.RATE, _data));
           							break;
           							
           		default		 	:   dispatchEvent(new VLCEvent(VLCEvent.DATA, _data));
           		
           	} 
        
        }
        
        /**
        *  show VLC telnet specific commands help.
        **/   
        public function help():void {
            sendCommand("help");
        }
        
        /**
        *	new channel (default type is broadcast)
        * 		- ch		: channel name
        * 		- type		: broadcast|VoD
        * 		- input		: source file to stream
        * 		- output	: output stream format
        **/
        public function newCh(ch:String = null, type:String = 'broadcast', input:String = null, output:Array = null):void {
            sendCommand("new " + ch + " " + type + " " + input);
        }
        
        /**
        *	setup a property
        * 		- ch			: channel name
        * 		- properties	: broadcast/VoD (Video On Demand) 
        **/
        public function setup(ch:String, properties:String):void {
            sendCommand("setup " + ch + " " + properties);
        }
        
        /**
        *	show current element state and configurations
        * 		- ch	: name|media
        * 		- type	: broadcast/VoD (Video On Demand)
        * 		- input	: source file to stream 
        **/
        public function show(ch:String = ''):void {
            sendCommand("show " + ch);
        }
        
        // control commands
        public function control(ch:String, cmd:String):void {
        	
            sendCommand("control " + ch + " " + cmd);
            
        }
        
        public function play(ch:String):void {
        	
            sendCommand("control " + ch + " play");
            
        }
        
        public function pause(ch:String):void {
        	
            sendCommand("control " + ch + " pause");
            
        }
        
        public function stop(ch:String):void {
        	
            sendCommand("control " + ch + " stop");
            
        }
        
        // percentage from 0 to 100
        public function seek(ch:String, percentage:Number):void {
        	
            sendCommand("control " + ch + " seek " + percentage);
            
        }
        
        
        // this is for test purposes only
        public function load():void {
        	sendCommand("new ch1 broadcast input C:\\chasta.mpg output #transcode{vcodec=FLV1,acodec=mp3,samplerate=44100}:std{access=http,dst=localhost:8081/stream.flv} enabled");
        }
        
        
        /**
        *  close VLC telnet server
        **/
 		public function exit():void {
        	sendCommand("exit");
        }           
    }
}
