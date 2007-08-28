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


	[ExcludeClass]
	public class ContentVLC extends Content {
		
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
		 * 	@constructor
		 */
		public function ContentVLC(layer:Layer, path:String, stream:Stream):void {
			
			_stream = stream;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, _onStatus);
			
			//Console.getInstance().vlc.getLength('ch1');
			
			// put this in a handler
			//_totalTime	= Console.getInstance().vlc.length;
						
			_video		= new Video(BITMAP_WIDTH,BITMAP_HEIGHT);
			
			_video.attachNetStream(stream);
			
			super(layer, path, _video);
			
			
		}
		
		/**
		 * 
		 */
		private function _onStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case 'NetStream.Play.Complete':
				
					//Console.getInstance().vlc.sendCommand("control ch1 seek 0");
					//_stream.seek(_loopStart);
					break;
			}
		}
		
		/**
		 * 	@private
		 * 	Updates the bimap source
		 */
		override public function render():RenderTransform {
			
			/*var time:Number = _stream.time;
			
			// test loop points
			if (time >= _loopEnd || time < _loopStart) {
				_stream.seek(_loopStart);
			}*/
			
			return super.render();
		}

		/**
		 * 
		 */
		override public function get time():Number {
			return _stream.time / _totalTime;
		}
		
		/**
		 * 	@private
		 * 	Goes to particular time
		 */		
		override public function set time(value:Number):void {
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
			_loopStart = __loopStart.dispatch(value) * _totalTime;
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
			_loopEnd = __loopEnd.dispatch(value) * _totalTime;
		}
		
		/**
		 * 
		 */
		override public function pause(value:Boolean = false):void {
			if (value) {
				_stream.pause();
			} else {
				_stream.resume();
			}
		}

		/**
		 * 
		 */
		override public function dispose():void {
		
			super.dispose();
			
			_video.attachNetStream(null);
			_stream.close();
			
			_video		= null,
			_stream		= null;
		}
	}
}