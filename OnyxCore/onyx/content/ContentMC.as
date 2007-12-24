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
	import flash.system.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;
			
	use namespace onyx_ns;
	
	[ExcludeClass]
	public class ContentMC extends Content {
		

		/**
		 * 	@private
		 * 	Stores paths of loaded stuff
		 */
		private static const _dict:Object = {};
		
		/**
		 * 	@private
		 * 	Registers a loader
		 */
		public static function registration(path:String):ContentRegistration {
			return _dict[path];
		}
		
		/**
		 * 
		 */
		public static function register(path:String, loader:Loader = null):void {
			
			var reg:ContentRegistration = _dict[path];
			
			if (!reg) {
				reg			= new ContentRegistration(),
				reg.loader	= loader,
				_dict[path] = reg;
			}
			
			reg.refCount++;
		}
		
		/**
		 * 	Unregisters from shared
		 */
		public static function unregister(path:String):Boolean {
			
			var reg:ContentRegistration = _dict[path];
			
			if (reg) {
				reg.refCount--;
				
				if (reg.refCount === 0) {
					reg.dispose();
					delete _dict[path];
				}
			} else {
				return false;
			}
			
			return true;
		}

		/**
		 * 	@private
		 * 	The left loop point
		 */
		protected var _loopStart:Number;
		
		/**
		 * 	@private
		 * 	The right loop point
		 */
		protected var _loopEnd:Number;
		
		/**
		 * 	@private
		 * 	Stores the loader object where the content was loaded into
		 */
		private var _loader:Loader;
		
		/**
		 * 	@private
		 * 	The frame number we are currently should navigate to
		 */
		private var _frame:Number;
		
		/**
		 * 	@private
		 * 	The amount of frames to move per frame
		 */
		private var _framerate:Number;
		
		/**
		 * 	@private
		 */
		private var _ratioX:Number;
		
		/**
		 * 	@private
		 */
		private var _ratioY:Number;
		
		/**
		 * 	@private
		 * 	Stores last time the draw was executed
		 */
		private var _lastTime:uint;

		/**
		 * 	@constructor
		 */		
		public function ContentMC(layer:ILayer, path:String, loader:Loader):void {

			_loader			= loader,
			_framerate		= loader.contentLoaderInfo.frameRate / STAGE.frameRate, // sets the framerate based on the swf framerate
			_frame			= 0,
			_ratioX			= BITMAP_WIDTH / loader.contentLoaderInfo.width, // set the ratio (so all movies look like scale = 1 at 320x240)
			_ratioY			= BITMAP_HEIGHT / loader.contentLoaderInfo.height,
			_loopStart		= 0,
			_loopEnd		= 1,
			_lastTime		= getTimer() - STAGE.frameRate;	// sets the last time we executed
			
			super(layer, path, loader.content);
			
		}

		/**
		 * 	Sets the time
		 */
		override public function set time(value:Number):void {
			
			var mc:MovieClip = super._content as MovieClip;
			
			_frame	= mc.totalFrames * value;
			
		}
		
		/**
		 * 	Gets the time
		 */
		override public function get time():Number {
			var mc:MovieClip = super._content as MovieClip;
			return _frame / (mc.totalFrames);
		}
		
		/**
		 * 	Gets the total time
		 */
		override public function get totalTime():int {
			var mc:MovieClip = super._content as MovieClip;
			return (mc.totalFrames / _loader.contentLoaderInfo.frameRate) * 1000;
		}
		
		/**
		 * 	Updates the bimap source
		 */
		override public function render():RenderTransform {

			var mc:MovieClip = super._content as MovieClip;
			var lastTime:int = getTimer();
			
			if (!_paused) {
				
				var time:int, frame:Number, totalFrames:int, loopEnd:int, loopStart:int;

				// get framerate
				time		= 1000 / ((lastTime - _lastTime)) || STAGE.frameRate;
				
				frame		= _frame + ((STAGE.frameRate / time) * _framerate),
				totalFrames	= mc.totalFrames;
				
				loopEnd		= totalFrames * _loopEnd,
				loopStart	= totalFrames * _loopStart;
				
				// constrain the frame
				frame = (frame < loopStart) ? loopEnd : Math.max(frame % loopEnd, loopStart);

				// save the frame				
				_frame = frame;
				
			}

			// store last time
			_lastTime = lastTime;

			// go to the right frame
			mc.gotoAndStop(_frame << 0);

			// render me baby					
			return super.render();
		}
		
		/**
		 * 	Gets the framerate
		 */
		override public function get framerate():Number {
			// get the ratio of the original framerate and the actual framerate
			var ratio:Number = _loader.contentLoaderInfo.frameRate / STAGE.frameRate;
			
			return (_framerate / ratio);
		}

		/**
		 * 	Sets framerate
		 */
		override public function set framerate(value:Number):void {
			var ratio:Number = _loader.contentLoaderInfo.frameRate / STAGE.frameRate;
			_framerate = super.__framerate.dispatch(value) * ratio;
		}

		

		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		override public function set loopStart(value:Number):void {
			_loopStart = __loopStart.dispatch(Math.min(value, _loopEnd));
		}
		
		/**
		 * 
		 */
		override public function get loopStart():Number {
			return _loopStart;
		}
		
		/**
		 * 	Sets the end loop point
		 */
		override public function set loopEnd(value:Number):void {
			
			_loopEnd = __loopEnd.dispatch(Math.max(value, _loopStart, 0.01));

		}
		
		/**
		 * 	Sets the end loop point
		 */
		override public function get loopEnd():Number {
			return _loopEnd;
		}
		
		/**
		 * 
		 */
		override public function get scaleX():Number {
			return super._scaleX / _ratioX;
		}
				
		/**
		 * 
		 */
		override public function set scaleX(value:Number):void {
			super.scaleX = value * _ratioX;
		}

		/**
		 * 
		 */
		override public function get scaleY():Number {
			return super._scaleY / _ratioY;
		}
		
		/**
		 * 
		 */
		override public function set scaleY(value:Number):void {
			super.scaleY = value * _ratioY;
		}
		
		
		/**
		 * 
		 */
		override public function set anchorX(value:int):void {
			super._anchorX = super.__anchorX.dispatch(value * _ratioX);
		}
		
		/**
		 * 
		 */
		override public function set anchorY(value:int):void {
			super._anchorY = super.__anchorY.dispatch(value * _ratioY);
		}
		
		
		/**
		 * 	Destroys the content
		 */
		override public function dispose():void {

			var mc:MovieClip = super._content as MovieClip;

			// dispose
			super.dispose();

			// unregister from the shared movieclips if it's the last one
			var value:Boolean = unregister(_path);
			
			if (!value && mc is IDisposable) {
				(mc as IDisposable).dispose();
			}
			
			// remove reference
			_loader = null;
		}

	}
}