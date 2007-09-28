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
package onyx.tween {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.tween.easing.*;

	
	use namespace onyx_ns;

	[Event(name='complete', type='flash.events.Event')]

	/**
	 * 		Custom Tween Class
	 */
	public final class Tween extends EventDispatcher {
		
		/**
		 * 	@private
		 * 	Stores definitions for tweens
		 */
		private static var _definition:Dictionary	= new Dictionary(true);
		
		/**
		 * 	Stops tween for a particular object
		 */
		public static function stopTweens(target:Object):void {
			var existing:Dictionary = _definition[target];
			
			if (existing) {
				for each (var tween:Tween in existing) {
					tween.dispose();
				}
				
				delete _definition[target];
			}
		}
		
		/**
		 * 	@private
		 * 	Target object the tween should be applied to
		 */
		private var _target:Object;

		/**
		 * 	@private
		 * 	Target object the tween should be applied to
		 */
		private var _props:Array;

		/**
		 * 	@private
		 * 	Target object the tween should be applied to
		 */
		private var _startTime:int;

		/**
		 * 	@private
		 * 	Target object the tween should be applied to
		 */
		private var _ms:int;
		
		/**
		 * 	@constructor
		 */
		public function Tween(target:Object, ms:int, ... args:Array):void {
			
			// register the tween to the _definitions array
			var existing:Dictionary = _definition[target];
			
			if (existing) {
				existing[this]		= this;
			} else {
				var dict:Dictionary = new Dictionary(true);
				dict[this]			= this;
				_definition[target] = dict;
			}
			
			_props = args;
			_target = target;
			_ms = ms;
			
			restart();
		}
		
		/**
		 * 
		 */
		public function restart():void {
			
			// listen every frame
			ROOT.addEventListener(Event.ENTER_FRAME, _onTimer, false, 1000);
			_startTime = getTimer();
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:Event):void {
			
			var curTime:int = getTimer() - _startTime;
			
			// apply values
			for each (var prop:TweenProperty in _props) {
				var args:Array		= [Math.min(curTime, _ms), 0, prop.end - prop.start, _ms];
				var fn:Function		= prop.easing || Linear.easeIn;
				var value:Number 	= fn.apply(null, args) + prop.start;
			
				_target[prop.property] = value;
			}
			
			if (curTime >= _ms) {
				
				dispatchEvent(new Event(Event.COMPLETE));
				ROOT.removeEventListener(Event.ENTER_FRAME, _onTimer);
			}
		}
		
		/**
		 * 	Stops the tween
		 */
		public function stop():void {
			dispose();
		}
		
		/**
		 * 
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void {
			super.addEventListener(type, listener, useCapture, priority, true);
		}
		
		/**
		 * 
		 */
		public function get target():Object {
			return _target;
		}
		
		/**
		 * 
		 */
		public function get props():Array {
			return _props;
		}

		/**
		 * 	@private
		 * 	Disposes the tween
		 */		
		public function dispose():void {
			
			var existing:Dictionary = _definition[_target];
			
			if (existing) {
				delete existing[this];
			}
			
			ROOT.removeEventListener(Event.ENTER_FRAME, _onTimer);

			_props = null;			
			_target = null;
		}
	}
}