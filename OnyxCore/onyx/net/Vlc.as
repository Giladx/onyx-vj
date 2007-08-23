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
	
    import onyx.net.Telnet;

	/**
	 * Telnet subclass that implements specific VLC commands
	 **/
    public class Vlc extends Telnet{
    	
    	private var _vcodec:String;
		private var _acodec:String;
		private var _samplerate:String;
		private var _access:String;
		private var _mux:String;
		private var _dst:String;
	
    	public function Vlc():void {
    		super();
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
