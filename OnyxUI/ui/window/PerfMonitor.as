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
package ui.window {
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import onyx.controls.Control;
	import onyx.controls.ControlInt;
	import onyx.core.Onyx;
	import onyx.events.ControlEvent;
	
	import ui.text.TextField;
	
	public final class PerfMonitor extends Window {
		
		private var _lasttime:int		= getTimer();
		
		private var _target:TextField	= new TextField(55,9);
		private var _label:TextField	= new TextField(55,9);
		
		public function PerfMonitor():void {
			
			super('PERFORMANCE', 60, 30, 760, 384);
			
			_draw();
			
			_applyEventHandlers();
			
			draggable = true;
		}
		
		private function _draw():void {

			addChildren(
				_target,	2, 12,
				_label,	2, 21
			);
			
			// _frameRateChange();

		}
		
		private function _applyEventHandlers():void {
			
			addEventListener(Event.ADDED, _onAdded);
		}
		
		private function _onAdded(event:Event):void {

			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			_lasttime = getTimer();

		}
		
		private function _onRemoved(event:Event):void {

			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);

		}
		
		private function _onEnterFrame(event:Event):void {
			
			_label.text = 'actual: ' + round((1000 / (getTimer() - _lasttime))).toString();
			_lasttime = getTimer();
			
		}
		
		override public function dispose():void {
			
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			removeEventListener(Event.ADDED, _onAdded);

			_target = null,
			_label	= null,
	
			super.dispose();
		}
	}
}