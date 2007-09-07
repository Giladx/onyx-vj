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

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.utils.getTimer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;


	use namespace onyx_ns;
	
	[ExcludeClass]
	public final class ContentMP3 extends Content {
	
		/**
		 * 	@private
		 */
		private var _length:int;

		/**
		 * 	@private
		 */
		private var _loopStart:int;

		/**
		 * 	@private
		 */
		private var _loopEnd:int;	

		/**
		 * 	@private
		 */
		private var _sound:Sound;

		/**
		 * 	@private
		 */
		private var _channel:SoundChannel;

		/**
		 * 	@private
		 */
		private var _visualizer:Visualizer;
		
		/**
		 * 	@private
		 */
		private var _transform:SoundTransform	= new SoundTransform(.5);

		/**
		 * 	@constructor
		 */
		public function ContentMP3(layer:ILayer, path:String, sound:Sound):void {
			
			// add a control for the visualizer
			_controls = new Controls(this, 
				new ControlInt('volume', 'volume', 0, 100, 50),
				new ControlInt('pan', 'pan', 0, 100, 50),
				new ControlPlugin('visualizer', 'Visualizer', ControlPlugin.VISUALIZERS)
			);
			
			_sound		= sound;
			_length		= Math.max(int(sound.length / 100) * 100, 0);
			
			_loopStart	= 0;
			_loopEnd	= _length;
			
			super(layer, path, null);
		}
		
		/**
		 * 
		 */
		public function set volume(value:int):void {
			_transform.volume = value / 100;
			
			if (_channel) {
				_channel.soundTransform = _transform;
			}
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
			
			if (_channel) {
				_channel.soundTransform = _transform;
			}
		}
		
		/**
		 * 
		 */
		public function get pan():int {
			return _transform.pan * 100;
		}

		/**
		 * 	Gets the visualizer
		 */
		public function get visualizer():Visualizer {
			return _visualizer;
		}

		/**
		 * 	Sets the visualizer
		 */
		public function set visualizer(obj:Visualizer):void {
			
			// remove extra controls
			if (_visualizer && _controls.length > 1) {
				
				_controls.splice(1, _controls.length - 1);
				_controls.dispatchEvent(new Event(Event.CHANGE));
				
			}
			
			// we get passed in a visualizer			
			if (obj) {

				// if it has controls, add them to our controls (dispatches a change)
				if (obj.controls) {
					_controls.concat.apply(_controls, obj.controls);
				}
			}

			_visualizer = obj;
		}
		
		/**
		 * 	Updates the bimap source
		 */
		override public function render():RenderTransform {
			
			if (_channel) {
				
				var position:Number = Math.ceil(_channel.position);
				
				if (position >= _loopEnd || position < _loopStart || position >= _length) {
					_channel.stop();
					_channel = _sound.play(_loopStart, 0, _transform);
				}
	
				// draw ourselves			
				if (_visualizer) {
					
					var transform:RenderTransform		= _visualizer.render();
					
					transform = (transform) ? transform.concat(getTransform()) : getTransform();
								
					// get local references
					var rect:Rectangle					= transform.rect;
					var matrix:Matrix					= transform.matrix;
					
					// render content
					renderContent(_source, transform.content, transform, _filter);
					
					// render filters
					renderFilters(_source, _rendered, _filters);
		
					// return transformation
					return transform;
				}
			}
				
			return null;
		}
		
		/**
		 * 	
		 */
		override public function get time():Number {
			return (_channel) ? _channel.position / _sound.length : 0;
		}
		
		/**
		 * 	
		 */
		override public function set time(value:Number):void {
			
			if (_channel) {
				_channel.stop();
			}
			
			_channel = _sound.play(value * _length);
			
		}
		
		/**
		 * 	
		 */
		override public function set loopStart(value:Number):void {
			_loopStart = __loopStart.dispatch(value) * _length;
		}
		
		/**
		 * 	
		 */
		override public function get loopStart():Number {
			return _loopStart / _length;
		}
		
		/**
		 * 	
		 */
		override public function set loopEnd(value:Number):void {
			_loopEnd = __loopEnd.dispatch(value) * _length;
		}
		
		/**
		 * 	
		 */
		override public function get loopEnd():Number {
			return _loopEnd / _length;
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {

			super.dispose();
	
			_channel.stop();
			_channel	= null,
			_sound		= null;
		}
	}
}