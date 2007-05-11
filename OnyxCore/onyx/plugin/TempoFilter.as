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
package onyx.plugin {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.ControlEvent;
	import onyx.events.TempoEvent;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	import onyx.utils.GCTester;
	
	use namespace onyx_ns;
	
	public class TempoFilter extends Filter {
		
		/**
		 * 	@private
		 */
		protected static const GLOBAL_TEMPO_CONTROL:Control	= TEMPO.controls.getControl('snapTempo');
		
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
		 * 	@private
		 * 	The beat signature to snap to
		 */
		private var _snapBeat:int;
		
		/**
		 * 	@private
		 * 	The control that handles tempo
		 */
		private var _snapControl:ControlTempo;

		/**
		 * 
		 */
		private const GLOBAL_TEMPO:TempoBeat		= TempoBeat.BEATS['global'];
				
		/**
		 * 	@private
		 * 	The delay control
		 */
		private var _delayControl:ControlInt;

		/**
		 * 	@private
		 * 	
		 */
		protected const BEATS:Array					= [GLOBAL_TEMPO].concat(TEMPO.BEATS);;
		
		/**
		 * 	@constructor
		 */
		public function TempoFilter(unique:Boolean, defaultBeat:TempoBeat = null, ... controls:Array):void {
			
			_snapControl	= new ControlTempo('snapTempo', 'Snap Tempo', BEATS),
			_delayControl	= new ControlInt('delay', 'delay', 1, 5000, 0, DEFAULT_FACTOR);
			
			super(unique);
			
			controls.unshift(
				_snapControl,
				_delayControl
			);
			
			super.controls.addControl.apply(null, controls);
			
			// tempo
			_snapTempo = defaultBeat || GLOBAL_TEMPO;
			
		}
		
		/**
		 * 
		 */
		override final public function set muted(value:Boolean):void {
			super.muted = value;
			initialize();
		}
		
		/**
		 * 	listen
		 */
		override final public function initialize():void {
			
			// remove handlers, start from scratch
			_cleanHandlers();
			
			// if valid tempo, listen for clicks, otherwise, it's set to none
			// and we should use the timer delay
			if (_snapTempo) {

				// if the tempo is the global tempo, grab it's value, and listen for the global
				// tempo events
				if (_snapTempo === GLOBAL_TEMPO) {
					
					// listen for changes
					GLOBAL_TEMPO_CONTROL.addEventListener(ControlEvent.CHANGE, _globalTempoHandler);
						
					// sync to the global tempo
					_setTempo(GLOBAL_TEMPO_CONTROL.value);

				}
				
			} else {
				
				// remove listener
				GLOBAL_TEMPO_CONTROL.removeEventListener(ControlEvent.CHANGE, _globalTempoHandler);
				
				_setTempo(null);

			}
		}

		/**
		 * 	@private
		 */
		private function _setTempo(value:TempoBeat):void {
			
			// only listen for events if we're not muted
			if (content && !_muted) {
				
				if (value) {
					
					_snapBeat = value.mod;
					TEMPO.addEventListener(TempoEvent.CLICK, onTempo);
					
				} else {
				
					timer = new Timer(_delay);
					timer.start();
					timer.addEventListener(TimerEvent.TIMER, onTimer);
					
				}
			}
		}

		/**
		 * 	@private
		 */
		private function _cleanHandlers():void {
			
			// remove tempo stuff
			TEMPO.removeEventListener(TempoEvent.CLICK, onTempo);
			
			// remove timer
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer.stop();
				timer = null;
			}
		}
		
		/**
		 * 	@private
		 * 	When the global tempo changes
		 */
		private function _globalTempoHandler(event:ControlEvent):void {
			
			_cleanHandlers();
			
			// set the beat
			var tempo:TempoBeat = event.value;
			_snapBeat	= tempo ? tempo.mod : null;
			
			// update all effects listening for tempo
			_snapControl.setValue(GLOBAL_TEMPO);
			
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
						
			// remove handlers, start from scratch
			_cleanHandlers();
			
			// if the global tempo is being passed in, store it
			if (value === GLOBAL_TEMPO) {
				
				// store it in the control, so it can dispatch a change event
				_snapTempo	= _snapControl.setValue(value);
				
				// listen for global tempo changes
				GLOBAL_TEMPO_CONTROL.addEventListener(ControlEvent.CHANGE, _globalTempoHandler);
				
				// set our tempo to the global
				_setTempo(GLOBAL_TEMPO_CONTROL.value);

			} else {
				
				// remove listener
				GLOBAL_TEMPO_CONTROL.removeEventListener(ControlEvent.CHANGE, _globalTempoHandler);

				_snapTempo	= _snapControl.setValue(value);
				_setTempo(value);
				
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
		 * 	@private
		 */
		final protected function onTempo(event:TempoEvent):void {
			if (event.beat % _snapBeat === 0) {
				onTrigger(event.beat, event);
			}
		}
		
		/**
		 * 	@private
		 */
		final protected function onTimer(event:TimerEvent):void {
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

			_cleanHandlers();
			
			super.dispose();
			
			_snapControl	= null,
			_delayControl	= null;
		}
		
		/**
		 * 
		 */
		override final onyx_ns function clean():void {

			// remove listener
			GLOBAL_TEMPO_CONTROL.removeEventListener(ControlEvent.CHANGE, _globalTempoHandler);

			super.clean();
		}
	}
}