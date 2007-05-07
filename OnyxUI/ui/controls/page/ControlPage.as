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
package ui.controls.page {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.controls.*;
	
	import ui.controls.*;
	import ui.core.UIObject;
	import ui.styles.CONTROL_MAP;
	import ui.text.TextField;

	/**
	 * 	The pages
	 */
	public final class ControlPage extends ScrollPane {
		
		/**
		 * 	@private
		 */
		private static const DEFAULT:UIOptions = new UIOptions();
		DEFAULT.width = 48;

		/**	
		 * 	@private
		 */
		private var _controls:Array		= [];
		
		/**
		 * 	@private
		 * 	If the controls passed in is a control array, listen for updates
		 */
		private var _ref:Controls;
		
		/**
		 * 	@constructor
		 */		
		public function ControlPage():void {
			
			super(100,120);		// controls size of ScrollPane
			
			// set mouseenabled
			mouseEnabled = false;
			
		}
		
		/**
		 * 	Removes all the controls from the page
		 */
		public function removeControls():void {
			
			// remove alls controls
			for each (var uicontrol:UIControl in _controls) {
				removeChild(uicontrol);		// for scrolling to work
				reset();					// for scrolling to work
				uicontrol.dispose();
			}
			
			_controls = [];
			
			// if it's a control array, remove listeners
			if (_ref) {
				_ref.removeEventListener(Event.CHANGE, _onUpdate);
				_ref = null;
			}
		}
		
		/**
		 * 	@private
		 * 	When the control is updated
		 */
		private function _onUpdate(event:Event):void {
			addControls(_ref);
		}
		
		/**
		 * 	Add controls
		 */
		public function addControls(controls:Array):void {
			
			var uicontrol:UIControl, x:int = 0, y:int = 8;
				
			var options:UIOptions	= DEFAULT;
			var width:int			= 65;
			var ref:Controls		= controls as Controls;
			
			removeControls();
			
			// if it's a Controls array, listen for changes
			if (ref){ 
				_ref = ref;
				_ref.addEventListener(Event.CHANGE, _onUpdate);
			}

			// now create a uicontrol based on each control
			for each (var control:Control in controls) {
				
				var uiClass:Class		= CONTROL_MAP[control.reflect()];
				
				if (uiClass) {

					uicontrol	= new uiClass(options, control);
					
					// position the control
					uicontrol.x = x;
					uicontrol.y = y;
					
					// save the control
					_controls.push(uicontrol);
					
					x += options.width + 3;
					
					// check width, respotion based on it
					if (x > width) {
						x = 0;
						y += options.height + 10;
					}
					
					// add it
					addChild(uicontrol);
				}				
			}
		}		
	}
}