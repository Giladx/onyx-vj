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
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.Transition;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.controls.layer.*;
	import ui.core.*;
	import ui.styles.*;
	
	/**
	 * 	This window allows one to use a crossfader
	 */
	public final class CrossFaderWindow extends Window implements IControlObject {
		
		/**
		 * 	@private
		 */
		private var _btn:ButtonClear;
		
		/**
		 * 	@private
		 */
		private var _fader:AssetCrossFader;
		
		/**
		 * 	@private
		 */
		private var _faderBG:AssetCrossFaderBG;
		
		/**
		 * 	@private
		 */
		private var _controls:Controls;
		
		/**
		 * 	@private
		 */
		private var _display:IDisplay;
		
		/**
		 * 	@private
		 */
		private var _transitionDrop:DropDown;
		
		/**
		 * 
		 */
		private var control:ControlPlugin;
				
		/**
		 * 	@constructor
		 */
		public function CrossFaderWindow(reg:WindowRegistration):void {

			// create the window
			super(reg, true, 192, 53);

			var options:UIOptions	= new UIOptions();
			options.width			= 100;
			options.label			= false;
			
			_btn					= new ButtonClear(187, 20),
			_fader					= new AssetCrossFader(),
			_faderBG				= new AssetCrossFaderBG(),
			_display				= DISPLAY;
			
			control = _display.controls.getControl('transition') as ControlPlugin;
			_controls				= new Controls(this, control);

			// add the control
			_transitionDrop		= new DropDown(options, control);

			// draw
			_btn.x				= 3,
			_btn.y				= 14,
			_fader.x			= _display.channelMix * 179 + 3,
			_fader.y			= 14,
			_faderBG.x			= 3,
			_faderBG.y			= 18,
			_transitionDrop.x	= 44,
			_transitionDrop.y	= 40;

			// add the fader
			addChild(_faderBG);
			addChild(_fader);
			addChild(_btn);
			addChild(_transitionDrop);
			
			// add mouse handlers
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);

		}
		
		/**
		 * 
		 */
		public function set ratio(value:Number):void {
			
			_display.channelMix = value;
			_fader.x = ((value * 176) >> 0) + 3;
		}
		
		/**
		 * 	Gets the ratio
		 */
		public function get ratio():Number {
			return _display.channelMix;
		}
		
		/**
		 * 	Returns controls
		 */
		public function get controls():Controls {
			return _controls
		}
		
		/**
		 * 	@private
		 */
		private function downHandler(event:MouseEvent):void {
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 * 	@private
		 */
		private function moveHandler(event:MouseEvent):void {
			ratio = Math.min(Math.max((((_btn.mouseX >> 0) - 5) / 176), 0), 1);
		}
		
		/**
		 * 	@private
		 */
		private function upHandler(event:MouseEvent):void {
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			_display = null,
			control = null;
			
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			_fader.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);

			super.dispose();
		}
	}
}