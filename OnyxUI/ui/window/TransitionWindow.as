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
package ui.window {
	
	import onyx.controls.*;
	import onyx.core.Onyx;
	import onyx.display.Layer;
	import onyx.events.TransitionEvent;
	import onyx.plugin.*;
	
	import ui.controls.*;
	import ui.core.UIManager;
	import ui.styles.UI_OPTIONS;
	
	public final class TransitionWindow extends Window implements IControlObject {
		
		/**
		 * 	@private
		 */
		private var dropdown:DropDown;

		/**
		 * 	Stores current transition plugin to use
		 */		
		private var _transition:Transition;
		
		/**
		 * 	@private
		 * 	returns controls
		 */
		private var _controls:Controls;
		
		/**
		 * 	@Constructor
		 */
		public function TransitionWindow():void {

			// position and create			
			super('TRANSITIONS', 190, 34);
		
			// init controls
			_controls = new Controls(this,
				new ControlPlugin('transition', 'Layer Transition', ControlPlugin.TRANSITIONS),
				new ControlInt('duration', 'Duration', 1, 20, 3, { factor: 10 })
			);
			
			var options:UIOptions	= new UIOptions();
			options.width			= 100;
			
 			dropdown				= new DropDown(options, _controls.getControl('transition'));
			dropdown.x = 2;
			dropdown.y = 20;
			
			var slider:SliderV		= new SliderV(UI_OPTIONS, _controls.getControl('duration'));
			slider.x				= 110;
			slider.y				= 20;
			
			addChild(slider);
			addChild(dropdown);
		}
		
		/**
		 * 	Gets controls
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 
		 */
		public function get duration():int {
			return (UIManager.transition) ? UIManager.transition.duration / 1000 : 2;
		}
		
		
		/**
		 * 
		 */
		public function set duration(value:int):void {
			(UIManager.transition) ? UIManager.transition.duration = value * 1000 : null;
		}
		
		/**
		 * 	Sets the transition
		 */
		public function set transition(value:Transition):void {
			
			_transition = value;

			// valid
			if (value)  {

				value.duration			= duration * 1000;
				UIManager.transition	= value;

			}
		}
		
		/**
		 * 
		 */
		public function get transition():Transition {
			return _transition;
		}
		
	}
}