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
package ui.states {
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import onyx.constants.STAGE;
	import onyx.states.ApplicationState;
	import onyx.states.StateManager;
	
	import ui.controls.filter.LayerFilter;

	public final class FilterMoveState extends ApplicationState {
		
		private var _origin:LayerFilter;
		private var _filters:Dictionary;
		
		public function FilterMoveState(origin:LayerFilter, filters:Dictionary):void {
			_origin = origin;
			_filters = filters;
		}
		
		override public function initialize():void {

			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			for each (var filter:LayerFilter in _filters) {
				if (filter !== _origin) {
					filter.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
				}
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseOver(event:MouseEvent):void {
			var control:LayerFilter = event.currentTarget as LayerFilter;
			
			_origin.filter.moveFilter(control.filter.index);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			StateManager.removeState(this);
		}
		
		/**
		 * 	Terminate
		 */
		override public function terminate():void {
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			for each (var filter:LayerFilter in _filters) {
				filter.removeEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			}
			
			_origin = null;
			_filters = null;
		}
	}
}