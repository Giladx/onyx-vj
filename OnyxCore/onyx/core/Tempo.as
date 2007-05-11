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
package onyx.core {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.errors.*;
	import onyx.events.TempoEvent;
	
	[Event(name='click', type='onyx.events.TempoEvent')]
	
	/**
	 * 	Tempo
	 */
	public final class Tempo extends EventDispatcher implements IControlObject {

		/**
		 * 	@private
		 */
		public const BEATS:Array = [
			null,
			TempoBeat.BEATS['1/16'],
			TempoBeat.BEATS['1/8'],
			TempoBeat.BEATS['1/4'],
			TempoBeat.BEATS['1/2'],
			TempoBeat.BEATS['1'],
			TempoBeat.BEATS['2'],
			TempoBeat.BEATS['4']
		];
		
		/**
		 * 
		 */
		public static function serialize():void {
		}
		
		/**
		 * 	Gets tempo
		 */
		public static function get tempo():int {
			return TEMPO.tempo;
		}
		
		/**
		 * 	@private
		 */
		private var _tempo:int				= 125;
		
		/**
		 * 	@private
		 * 	Store timer
		 */
		private var _timer:Timer;
		
		/**
		 * 	@private
		 * 	Last execution time
		 */
		private var _last:int;
		
		/**
		 * 	@private
		 * 	Controls related to tempometer
		 */
		private var _controls:Controls;
		
		/**
		 * 	@private
		 * 	The beat signature (0-15)
		 */
		private var _step:int				= 0;
		
		/**
		 * 	@private
		 * 	The beat signature to apply to all tempo filters that are listening to global tempo
		 */
		private var _snapTempo:TempoBeat		= BEATS[3];
		/**
		 * 
		 */
		private var _snapControl:ControlTempo;

		/**
		 * 	@constructor
		 */
		public function Tempo():void {
			
			if (TEMPO) {
				throw INVALID_CLASS_CREATION;
			} else {
				
				_timer			= new Timer(5);
				_snapControl	= new ControlTempo('snapTempo', 'global tempo', BEATS)
				_controls	= new Controls(this,
					_snapControl,
					new ControlInt('tempo', 'tempo', 40, 1000, _tempo)
				);
				
			}
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		/**
		 * 	Sets global tempo filters
		 */
		public function set snapTempo(value:TempoBeat):void {
			_snapTempo = value;

			(value) ? start() : stop();
		}
		
		/**
		 * 	Gets global tempo filters
		 */
		public function get snapTempo():TempoBeat {
			return _snapTempo;
		}
		
		/**
		 * 	Stars the meter
		 */
		public function start():void {
			_last = getTimer(),
			_step = 0;
			
			_timer.start();
			
			dispatchEvent(new TempoEvent(0));
		}
		
		/**
		 * 	Stops the meter
		 */
		public function stop():void {
			_timer.stop();
		}
		
		/**
		 * 	@private
		 * 	Check to see if tempo has fired
		 */
		private function _onTimer(event:TimerEvent):void {
			
			var time:int = getTimer() - _last;
			
			if (time >= _tempo) {
				
				_last = getTimer() - (time - _tempo);
				_step = ++_step % 64;

				dispatchEvent(new TempoEvent(_step));
			}
		}
		
		/**
		 * 	Sets tempo
		 */
		public function set tempo(value:int):void {
			
			// offset by 3 cause it's a little slow sometimes
			_tempo = _controls.getControl('tempo').setValue(value);
			start();
		}
		
		/**
		 * 	Gets tempo
		 */
		public function get tempo():int {
			return _tempo;
		}
		
		/**
		 * 	Override event listener to start automatically
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			if (type === TempoEvent.CLICK) {
				start();
			}
		}
		
		
		/**
		 * 	If nothing is listening, stop
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
			if (!super.hasEventListener(TempoEvent.CLICK)) {
				stop();
			}
		}
		
		/**
		 * 	Disposes
		 */
		public function dispose():void {
		}
		
		/**
		 * 
		 */
		public function get controls():Controls {
			return _controls;
		}
		
	}
}