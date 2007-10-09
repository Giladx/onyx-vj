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
	
	import flash.events.NetStatusEvent;
	import flash.media.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.net.*;


	[ExcludeClass]
	public class ContentFLV extends Content {
		
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
		private var _transform:SoundTransform	= new SoundTransform(.5);
	
		/**
		 * 	@constructor
		 */
		public function ContentFLV(layer:ILayer, path:String, stream:Stream):void {
			
			_stream = stream;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, _onStatus);
			
			_totalTime	= stream.metadata.duration;
			
			_video		= new Video(BITMAP_WIDTH,BITMAP_HEIGHT);
			_video.attachNetStream(stream);
			
			_controls = new Controls(this, 
				new ControlInt('volume', 'volume', 0, 100, 50),
				new ControlInt('pan', 'pan', -100, 100, 0)
			);
			
			super(layer, path, _video);
		}
		
		
		/**
		 * 
		 */
		public function set volume(value:int):void {
			_transform.volume = value / 100;
			
			_stream.soundTransform = _transform;
		}
		
		/**
		 * 
		 */
		public function get volume():int {
			return _transform.volume * 100;
		}


		/**
		 * 
		 */
		public function set pan(value:int):void {
			_transform.pan = value / 100;
			
			_stream.soundTransform = _transform;
		}
		
		/**
		 * 
		 */
		public function get pan():int {
			return _transform.pan * 100;
		}
		
		/**
		 * 
		 */
		private function _onStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case 'NetStream.Play.Complete':
					_stream.seek(_loopStart);
					break;
			}
		}
		
		/**
		 * 	@private
		 * 	Updates the bimap source
		 */
		override public function render():RenderTransform {
			
			var time:Number = _stream.time;
			
			// test loop points
			if (time >= _loopEnd || time < _loopStart) {
				_stream.seek(_loopStart);
			}
			
			// remove
			if (_stream.connection.uri !== 'null') {
				_video.attachNetStream(null);
			}
	
			// get the transformation
			var transform:RenderTransform		= getTransform();

			// render content
			renderContent(_source, _content, transform, _filter);
			
			// render filters
			_filters.render(_source);

			// attach
			if (_stream.connection.uri !== 'null') {
				_video.attachNetStream(_stream);
			}
	
			// return transformation
			return transform;
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