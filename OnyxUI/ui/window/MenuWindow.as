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
	
	import onyx.controls.*;
	import onyx.errors.*;
	import onyx.utils.math.*;
	
	import ui.controls.*;
	import ui.core.*;
	import ui.styles.*;
	
	/**
	 * 	Menu Window
	 */
	public final class MenuWindow extends Window implements IControlObject {
		
		/**
		 * 	@private
		 */
		private var _stateDropDown:DropDown;
		
		/**
		 *	@private
		 */
		private var _controls:Controls;
		
		/**
		 * 	@constructor
		 */
		public function MenuWindow(reg:WindowRegistration):void {
			
			_controls = new Controls(this,
				new ControlRange('state', 'state', WindowState.states, null, 'name')
			);
			
			_stateDropDown = new DropDown(UI_OPTIONS_NOLABEL, _controls.getControl('state'));
			
			// position and create window
			super(reg, false, 100, 100);
			
			// add the drop down
			addChild(_stateDropDown);
		}
		
		/**
		 * 
		 */
		public function set state(value:WindowState):void {
			UIObject.select(null);
			WindowState.load(value);
		}
		
		/**
		 * 
		 */
		public function get state():WindowState {
			return WindowState.currentState;
		}
		
		/**
		 * 
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	Creates all the buttons
		 */
		public function createButtons(x:int, y:int):void {
			
			this.x = x;
			this.y = y;
			
			// loop through registrations
			for each (var reg:WindowRegistration in WindowRegistration.registrations) {
				
				// get index
				var index:int = reg.index;
				
				// create control
				var control:MenuButton = new MenuButton(reg, MENU_OPTIONS);
				control.x = index * (MENU_OPTIONS.width + 2) + 50;

				// add child
				addChild(control);
				
			}
		}
		
		/**
		 * 	
		 */
		override public function dispose():void {
			
		}
	}
}