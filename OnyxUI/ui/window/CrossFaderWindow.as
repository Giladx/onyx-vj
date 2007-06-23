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
	import flash.geom.ColorTransform;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.utils.math.*;
	
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
		 * 
		 */
		private var _ratioControl:ControlNumber;
		
		/**
		 * 	@private
		 */
		private var _faderDisplay:SliderV;
		
		/**
		 * 	@private
		 */
		private static const LEFT_CHANNEL:ColorTransform	= new ColorTransform();
		
		/**
		 * 	@private
		 */
		private static const RIGHT_CHANNEL:ColorTransform	= new ColorTransform(1,1,1,0);
		
		/**
		 * 	@private
		 */
		private var _display:IDisplay;
		
		/**
		 * 	@constructor
		 */
		public function CrossFaderWindow():void {
			
			super('CROSS FADER', 192, 53);
			
			_ratioControl	= new ControlNumber('ratio', 'ratio', 0, 1, 0);
			
			_btn			= new ButtonClear(187, 20),
			_fader			= new AssetCrossFader(),
			_faderBG		= new AssetCrossFaderBG(),
			_controls		= new Controls(this, _ratioControl),
			_display		= Display.getDisplay(0);

			// add the control
			_faderDisplay	= new SliderV(UI_OPTIONS_NOLABEL, _controls.getControl('ratio'));
			
			// listen for changes
			_ratioControl.addEventListener(ControlEvent.CHANGE, changeHandler);

			_btn.x			= 3,
			_btn.y			= 14,
			_fader.x		=  RIGHT_CHANNEL.alphaMultiplier * 179 + 3,
			_fader.y		= 14,
			_faderBG.x		= 3,
			_faderBG.y		= 18,
			_faderDisplay.x	= 74,
			_faderDisplay.y	= 40;

			// add the fader
			addChild(_faderBG);
			addChild(_fader);
			addChild(_faderDisplay);
			addChild(_btn);

			// tell the toggle controls that this is the controller
			CrossFaderToggle.window = this;
			
			// add mouse handlers
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);

		}
		
		/**
		 * 
		 */
		public function set ratio(value:Number):void {
			LEFT_CHANNEL.alphaMultiplier	= 1 - value;
			RIGHT_CHANNEL.alphaMultiplier	= value;
		}
		
		/**
		 * 	Gets the ratio
		 */
		public function get ratio():Number {
			return RIGHT_CHANNEL.alphaMultiplier;
		}
		
		/**
		 * 	Registers a layer
		 */
		public function registerLayer(layer:ILayer, channelType:String):void {
			
			var channel:ColorTransform;
			
			switch (channelType) {
				case 'A':
					channel = LEFT_CHANNEL;
					break;
				case 'B':
					channel = RIGHT_CHANNEL;
					break;
			}
						
			_display.registerBaseTransform(layer, channel);

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
		 * 
		 */
		private function changeHandler(event:ControlEvent):void {
			_fader.x = floor(event.value * 176) + 3;
		}
		
		/**
		 * 	@private
		 */
		private function moveHandler(event:MouseEvent):void {
			_ratioControl.value	= ((_btn.mouseX >> 0) - 5) / 176;
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
			super.dispose();
			
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			_fader.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			_ratioControl.removeEventListener(ControlEvent.CHANGE, changeHandler);

			CrossFaderToggle.window = null;
		}
	}
}