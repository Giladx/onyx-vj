/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package onyx.core {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.events.TempoEvent;
	import onyx.parameter.*;
	
	[ExcludeClass]
	
	[Event(name='click', type='onyx.events.TempoEvent')]
	
	/**
	 * 	Base tempo dispatcher.  use onyx.constants.TEMPO instead of this class directly.  (for performance)
	 */
	public final class TempoImplementer extends EventDispatcher implements ITempo {
		
		/**
		 * 	@private
		 */
		private var _delay:int					= 100;
		
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
		private const parameters:Parameters		= new Parameters(this as IParameterObject);
		
		/**
		 * 	@private
		 * 	The beat signature (0-15)
		 */
		private var _step:int					= 0;
		
		/**
		 * 	@private
		 * 	The beat signature to apply to all tempo filters that are listening to global tempo
		 */
		private var _snapTempo:TempoBeat;
		/**
		 * 
		 */
		private var _snapControl:ParameterTempo;

		/**
		 * 	@constructor
		 */
		public function TempoImplementer():void {
				
			_timer			=	new Timer(2),
			_snapControl	=	new ParameterTempo('snapTempo', 'snap to tempo', false);
			
			parameters.addParameters(
				_snapControl,
				new ParameterInteger('delay', 'tempo', 40, 1000, _delay)
			);

			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
								
			snapTempo = null;
		}
		
		/**
		 * 	
		 */
		public function getParameter(name:String):Parameter {
			return parameters.getParameter(name);
		}
		
		/**
		 * 	Sets global tempo filters
		 */
		public function set snapTempo(value:TempoBeat):void {
			
			_snapTempo = value;

			(value === true) ? start() : stop();
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
			
			if (time >= _delay) {
				
				_last = getTimer() - (time - _delay);
				_step = ++_step % 64;

				dispatchEvent(new TempoEvent(_step));
			}
		}
		
		/**
		 * 	Sets tempo
		 */
		public function set delay(value:int):void {
			
			// offset by 3 cause it's a little slow sometimes
			_delay = parameters.getParameter('delay').dispatch(value);
			start();
		}
		
		/**
		 * 	Gets tempo
		 */
		public function get delay():int {
			return _delay;
		}
		
		/**
		 * 
		 */
		public function getParameters():Parameters {
			return parameters;
		}
		
		/**
		 * 	Disposes
		 */
		public function dispose():void {
		}
		
	}
}