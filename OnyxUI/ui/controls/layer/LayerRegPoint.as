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
package ui.controls.layer {
	
	import onyx.controls.Control;
	import onyx.controls.ControlProxy;
	import onyx.events.ControlEvent;
	
	import ui.assets.AssetLayerRegPoint;
	import ui.controls.ButtonClear;
	import ui.controls.UIControl;
	import ui.controls.page.ControlPage;
	import flash.events.Event;
	import onyx.controls.ControlInt;
	import flash.display.DisplayObject;

	public final class LayerRegPoint extends UIControl {
		
		/**
		 * 	@private
		 */
		private static const OFFSET_X:int	= -4;

		/**
		 * 	@private
		 */
		private static const OFFSET_Y:int	= -4;
		
		/**
		 * 	
		 */
		public static const SCALE:Number	= .6;
		
		/**
		 * 
		 */
		public var controlX:ControlInt;
		
		/**
		 * 
		 */
		public var controlY:ControlInt;
		
		/**
		 * 	@constructor
		 */
		public function LayerRegPoint(control:ControlProxy, mask:DisplayObject):void {
			super(null, control);
			
			addChild(new AssetLayerRegPoint());
			
			// store controls
			controlX = control.controlX as ControlInt,
			controlY = control.controlY as ControlInt;
			
			// add listeners
			controlX.addEventListener(ControlEvent.CHANGE, _onControlXChange);
			controlY.addEventListener(ControlEvent.CHANGE, _onControlYChange);
			
			this.mask = mask;
		}
		
		/**
		 * 	@private
		 */
		private function _onControlXChange(event:ControlEvent):void {
			x = event.value * SCALE + OFFSET_X;
		}
		
		/**
		 * 	@private
		 */
		private function _onControlYChange(event:ControlEvent):void {
			y = event.value * SCALE + OFFSET_Y;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			super.dispose();
		}
	}
}