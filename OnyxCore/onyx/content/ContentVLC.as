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
 
package onyx.content {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	
	import onyx.constants.*;
	import onyx.controls.Controls;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.net.*;
	import onyx.utils.string.*;
	import onyx.plugin.Module;
	
	import onyx.events.TelnetEvent;
		
    
	[ExcludeClass]
	public class ContentVLC extends Content {
		
		/**
         *  @private
         *  Will contain the reference to the VLC client.
         */
        private var _client:Object;
        
		/**
         *  @private
         */
        private var _file:String;
        
		/**
		 * 	@private
		 */
		private var _stream:Stream;

		/**
		 * 	@private
		 */
		private var _totalTime:Number;

		/**
		 * 	@private
		 */
		private var _loopStart:Number;

		/**
		 * 	@private
		 */
		private var _loopEnd:Number;

		/**
		 * 	@private
		 */
		private var _video:Video;
		
		/**
		 * 	@private
		 */
		private var _time:Number;
		
		/**
		 * 	@private
		 */
		private var _rate:Number;
		
		/**
		 * 	@private
		 */
		private var _counter:Number;
		
		/**
         *  @private
         */
        private var _request:String;
		
		/**
		 * 	@constructor
		 */
		public function ContentVLC(layer:ILayer, path:String, stream:Stream):void {
			
			// direct access to VLC client from VLCModule
            _client = Module.modules['VLC'].client;
            _client.addEventListener(TelnetEvent.DATA, _onData);
            
			// VLC does not like spaces
			_file = removeExtension(path).split(' ').join('_');
						
			_loopStart = 0;
			_loopEnd = 1;
			
			_stream = stream;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, _onStatus);
			
			_video = new Video(BITMAP_WIDTH,BITMAP_HEIGHT);
			_video.attachNetStream(_stream);
			
			_counter = 0;
			_request = '';
						
			super(layer, path, _video);
			
		} 
		
		private function _onData(event:TelnetEvent):void {
            
            switch(_request) {
                
                case 'length'   :   _totalTime = Number(event.message);
                                    break;
                case 'time'     :   //_time = Number(event.message);
                                    break;
                case 'position' :   _time = Number(event.message);
                                    break;
                
            }
            
            //Console.output(event.message);
                    
            _request = '';
            
        }
        
		/**
		 * 
		 */
		private function _onStatus(event:NetStatusEvent):void {
			
			switch (event.info.code) {
				
				case 'NetStream.Seek.Notify':
                    // get total time (length)
                    _request = 'length';
                    Console.executeCommand('VLC ' + _request + ' ' + _file);
                    break;
                    
				case 'NetStream.Play.Start':
					// get total time (length)
					//Console.executeCommand('VLC length ' + _file);
				    break;
					
				case 'NetStream.Play.Stop':
					// go to 0
					//Console.output(event.info.code);
					
			}
		}
										
		/**
		 * 	@private
		 * 	Updates the bitmap source
		 */
		override public function render():RenderTransform {
			
			_counter++;

			// il time del cursore  è tra 0 e 1
			if(_counter/30 == 1) {
				
				_counter = 0;
				
				_request = 'position';
	       		Console.executeCommand('VLC ' + _request + ' ' + _file);
				
			}
						
			// test loop points
			if (_time >= _loopEnd || _time < _loopStart) {
				
				// set the VLC time
	            // Console.getInstance().vlc.seek(_path, 100 * _loopStart);
				// set the stream object time
				_stream.seek(_loopStart);
				
			}
			
			return super.render();
		}

		/**
		 * 
		 */
		override public function get time():Number {
			return _time;
		}
		
		/**
		 * 	@private
		 * 	Goes to particular time
		 */		
		override public function set time(value:Number):void {
			
			Console.executeCommand('VLC ' + ' ' + _file + ' seek ' + 100 * value);
			_stream.seek(value * _totalTime);
						
		}
		
		/**
		 * 
		 */
		override public function get loopStart():Number {
			return _loopStart / _totalTime;
			
		}
		
		/**
		 * 	@private
		 * 	Sets Loop Start
		 */		
		override public function set loopStart(value:Number):void {
			_loopStart = __loopStart.dispatch(value);// * (100 * Math.pow(_rate,2) / _totalTime); // _totalTime;
		}

		/**
		 * 
		 */
		override public function get loopEnd():Number {
			return _loopEnd / _totalTime;
		}
		
		/**
		 * 	@private
		 * 	Sets Loop Start
		 */		
		override public function set loopEnd(value:Number):void {
			_loopEnd = __loopEnd.dispatch(value);// * (100 * Math.pow(_rate,2) / _totalTime); // _totalTime;
		}
		
		/**
		 * 
		 */
		override public function pause(value:Boolean = false):void {
			if (value) {
	//			Console.getInstance().vlc.pause(_path);
			} else {
	//			Console.getInstance().vlc.play(_path);
			}
		}

		/**
		 * 
		 */
		override public function dispose():void {
			
			Console.executeCommand("VLC del " + _path);
			_client.removeEventListener(TelnetEvent.DATA, _onData);
			
			super.dispose();
			
			_video.attachNetStream(null);
			_stream.close();
			
			_video		= null,
			_stream		= null;
			
			_time		= 0;
		}

	}
}