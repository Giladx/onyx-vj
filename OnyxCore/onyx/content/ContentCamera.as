/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
	import flash.media.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	
	[ExcludeClass]
	public final class ContentCamera extends Content {
		
		/**
		 * 	@private
		 * 	The video to attach the camera to
		 */
		private var _video:Video;
		
		/**
		 * 	@private
		 * 	The number of frames to save
		 */
		public var save:int				= 0;
		
		/**
		 * 	@private
		 * 	The frames we've saved
		 */
		private var _frames:Array		= [];
		
		/**
		 * 	@private
		 */
		private var _currentFrame:int	= 0;
		
		/**
		 * 
		 */
		private var _camera:Camera;
		
		/**
		 * 	@constructor
		 */
		public function ContentCamera(layer:Layer, path:String, camera:Camera):void {
			
			_controls = new Controls(this);
			
			_camera	= camera;
			_camera.setMotionLevel(0,0);
			_camera.setMode(BITMAP_WIDTH,BITMAP_HEIGHT, 30);

			_video	= new Video(BITMAP_WIDTH, BITMAP_HEIGHT);
			_video.attachCamera(camera);
			
			super(layer, path, _video);
			
		}
		
		/**
		 * 
		 */
		public function set qualityRate(value:int):void {
			// _camera.setMode(BITMAP_WIDTH,BITMAP_HEIGHT,value);
		}

		/**
		 * 
		 */
		public function get qualityRate():int {
			return _camera.fps;
		}
		
		/**
		 * 	Overload render
		 */
		override public function render():RenderTransform {
			
			if (save === 0) {
				
				super.render();
				
			} else {
				
				// render a bitmap
				var bmp:BitmapData = BASE_BITMAP();
				bmp.draw(_video);
				
				// add the bitmap
				_frames.push(bmp);
				
				// TBD: Capture
				// if the frame is over the save amount, dispose bitmap, shift the array
				while (_frames.length > save) {
					
					bmp = _frames[0];
					bmp.dispose();
					
					_frames.shift();
				}
				
				// now increment the currentFrame
				_currentFrame = _currentFrame ++ & _frames.length;
				
				bmp = _frames[_currentFrame];
				_content = bmp;
				
				super.render();
			}
			
			return null;
		}
		
		/**
		 * 
		 */
		override public function get time():Number {
			return ((_frames) ? _currentFrame / _frames.length : 0);
		}
		
		/**
		 * 
		 */
		override public function set time(value:Number):void {
			_currentFrame = value * _frames.length;
		}
		
		/**
		 * 
		 */
		override public function set framerate(value:Number):void {
		}
		
		/**
		 * 	Disposes
		 */
		override public function dispose():void {
			
			super.dispose();

			_video.attachCamera(null);
			_video		= null,
			_camera		= null;
		}
		
	}
}