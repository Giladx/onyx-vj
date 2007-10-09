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
package onyx.jobs {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import onyx.display.IDisplay;
	import onyx.events.RenderEvent;
	import onyx.file.*;
	import onyx.utils.bitmap.*;
	
	[Event(name='start', type='flash.events.Event')]
	
	/**
	 * 	Saves a display's output for n frames
	 */
	public final class SaveJob extends Job {
		
		/**
		 * 	@private
		 */
		private var _maxFrames:int;

		/**
		 * 	@private
		 */
		private var _currentFrame:int;

		/**
		 * 	@private
		 */
		private var _display:IDisplay;

		/**
		 * 	@private
		 */
		private var _frames:Array		= [];
		
		/**
		 * 	@constructor
		 */
		public function SaveJob(display:IDisplay, frames:int):void {
			
			_display	= display;
			_maxFrames	= frames;
			
			_display.addEventListener(RenderEvent.RENDER, _onRender);
		}
		
		/**
		 * 	@private
		 */
		private function _onRender(event:Event):void {
			
			if (_currentFrame >= _maxFrames) {
				
				_display.removeEventListener(RenderEvent.RENDER, _onRender);
				save();
				
				return;
			}
			
			_frames.push(_display.source.clone());

			_currentFrame++;
		}
		
		/**
		 * 	@private
		 */
		private function save():void {
			
			var encoder:JPGEncoder = new JPGEncoder();
			
			_currentFrame = 0;
			
			var len:int = _frames.length;
			
			// loop through the frames and save them
			for (var count:int = 0; count < len; count++) {
				
				// get bitmap reference
				var bmp:BitmapData = _frames[count];

				// save
				File.save(count + '.jpg', encoder.encode(bmp), _onSave);

				// destroy the bitmap
				bmp.dispose();
			}
			
			terminate();
		}

		/**
		 * 	@private
		 */
		private function _onSave(query:FileQuery):void {
		}
		
		/**
		 * 
		 */
		override public function terminate():void {
			
			_display.removeEventListener(RenderEvent.RENDER, _onRender);
			_display = null;
			
			super.terminate();
		}
	}
}