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
package ui.controls.layer {
	
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.events.ControlEvent;
	
	import ui.assets.AssetRightArrow;
	import ui.controls.UIControl;

	public final class LoopEnd extends Sprite {
		
		private var _control:Control;
		
		public function LoopEnd(control:Control):void {
			
			buttonMode = useHandCursor = cacheAsBitmap = true, _control = control;
			
			_control.addEventListener(ControlEvent.CHANGE, _onChanged);

			var sprite:DisplayObject = addChild(new AssetRightArrow());
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMarkerDown);
		}
		
		/**
		 * 	@private
		 */
		private function _onChanged(event:ControlEvent):void {
			x = event.value * 176 + 8;
		}

		/**
		 * 	@private
		 */
		private function _onMarkerDown(event:MouseEvent):void {
			
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onMarkerMove);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onMarkerUp);
			
			_onMarkerMove(event);
		}

		/**
		 * 	@private
		 */
		private function _onMarkerMove(event:MouseEvent):void {
			_control.value = (parent.mouseX - 8) / 176;
		}

		/**
		 * 	@private
		 */
		private function _onMarkerUp(event:MouseEvent):void {
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onMarkerMove);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onMarkerUp);
		}

		/**
		 * 	Override set x so that we can draw a background on it
		 */
		override public function set x(value:Number):void {
			super.x = value;
			
			var graphics:Graphics = this.graphics;
			graphics.clear();
			graphics.beginFill(0x111111, .8);
			graphics.drawRect(0,0,193 - super.x,7);
			graphics.endFill();
		}

	}
}