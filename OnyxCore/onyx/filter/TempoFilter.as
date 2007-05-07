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
package onyx.filter {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.core.TempoBeat;
	import onyx.core.onyx_ns;
	import onyx.events.ControlEvent;
	import onyx.events.TempoEvent;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	
	use namespace onyx_ns;
	
	public class TempoFilter extends Filter {
		
		/**
		 * 	@private
		 */
		private static const GLOBAL_TEMPO_CONTROL:Control	= TEMPO.controls.getControl('snapTempo');
		
		/**
		 * 	Store multiplier
		 */
		public static const DEFAULT_FACTOR:Object	= { 
			multiplier: .001,
			factor:		25,
			toFixed:	2
		};
		
		/**
		 * 	@private
		 */
		protected var timer:Timer;
		
		/**
		 * 	@private
		 */
		protected var _delay:int					= 100;
		
		/**
		 * 	@private
		 */
		private var _snapTempo:TempoBeat;
		
		/**
		 * 
		 */
		private var _snapBeat:int;
		
		/**
		 * 	@private
		 */
		private var _snapControl:ControlTempo;
		
		/**
		 * 	@private
		 */
		private var _delayControl:ControlInt;
		
		/**
		 * 
		 */
		private const GLOBAL_TEMPO:TempoBeat		= TempoBeat.BEATS['global'];

		/**
		 * 	@private
		 */
		protected const BEATS:Array					= [GLOBAL_TEMPO].concat(TEMPO.BEATS);;
		
		/**
		 * 	@constructor
		 */
		final public function TempoFilter(unique:Boolean, defaultBeat:TempoBeat = null, ... controls:Array):void {
			
			_snapControl	= new ControlTempo('snapTempo', 'Snap Tempo', BEATS),
			_delayControl	= new ControlInt('delay', 'delay', 1, 5000, 0, DEFAULT_FACTOR);
			
			super(unique);
			
			controls.unshift(
				_snapControl,
				_delayControl
			);
			
			super.controls.addControl.apply(null, controls);
			
			// default to global
			this.snapTempo = defaultBeat || BEATS[0];
		}
		
		/**
		 * 	@private
		 * 	When the global tempo changes
		 */
		private function _onTempoEvent(event:ControlEvent):void {
			
			// set the beat
			var tempo:TempoBeat = event.value;
			_snapBeat	= tempo ? tempo.mod : null;
			
			// re-initialize the filter
			_setTempo(event.value);
		}
		
		/**
		 * 	Sets delay
		 */
		final public function set delay(value:int):void {
			_delay = _delayControl.setValue(value);
			
			if (timer) {
				timer.delay = _delay;
			}
		}
		
		/**
		 * 	Sets delay
		 */
		final public function get delay():int {
			return _delay;
		}
		
		/**
		 * 	Whether or not the filter snaps to beat
		 */
		final public function set snapTempo(value:TempoBeat):void {
			
			// if we're being told to listen to the global, listen for events, and pass in the global tempo
			if (value === GLOBAL_TEMPO) {
				
				GLOBAL_TEMPO_CONTROL.addEventListener(ControlEvent.CHANGE, _onTempoEvent);
				
				// set our value to global
				_snapTempo	= _snapControl.setValue(value);

				// set the beat
				var tempo:TempoBeat = GLOBAL_TEMPO_CONTROL.value;
				_snapBeat	= tempo ? tempo.mod : null;
				
				// initialize
				_setTempo(GLOBAL_TEMPO_CONTROL.value);
				
			} else {
				
				GLOBAL_TEMPO_CONTROL.removeEventListener(ControlEvent.CHANGE, _onTempoEvent);
				
				// set value
				_snapTempo	= _snapControl.setValue(value);
				
				if (value) {
					_snapBeat	= value.mod;
				}
				
				_setTempo(value);
				
			}
		}
		
		/**
		 * 	@private
		 */
		private function _setTempo(value:TempoBeat):void {

			// remove timer stuff anyways
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer.stop();
				timer = null;
			}
			
			// remove tempo stuff
			TEMPO.removeEventListener(TempoEvent.CLICK, onTempo);
			
			// re-init
			if (content) {
				initialize();
			}

		}
		
		/**
		 * 	Used by other filters to determine when the next firing will happen
		 */
		final protected function get nextDelay():int {
			return _snapTempo ? (_snapBeat * TEMPO.tempo) : timer.delay;
		}
		
		/**
		 * 	Get the associated beat it's snapping on
		 */
		final public function get snapTempo():TempoBeat {
			return _snapTempo;
		}
		
		/**
		 * 	initialize
		 */		
		override public function initialize():void {
			
			if (_snapTempo) {

				TEMPO.addEventListener(TempoEvent.CLICK, onTempo);
				
			} else {
				
				timer = new Timer(_delay);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				
			}
			
		}
		
		/**
		 * 	@private
		 */
		protected function onTempo(event:TempoEvent):void {
			if (event.beat % _snapBeat === 0) {
				onTrigger(event.beat, event);
			}
		}
		
		/**
		 * 	@private
		 */
		protected function onTimer(event:TimerEvent):void {
			onTrigger((event.currentTarget as Timer).currentCount, event);
		}

		/**
		 * 	@private
		 */
		protected function onTrigger(beat:int, event:Event):void {
			trace('BEAT');
		}

		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			super.dispose();
			
			// stop the timer
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
			
			TEMPO.removeEventListener(TempoEvent.CLICK, onTempo);
			GLOBAL_TEMPO_CONTROL.removeEventListener(ControlEvent.CHANGE, _onTempoEvent);
			
			_snapControl	= null,
			_delayControl	= null;
		}
	}
}