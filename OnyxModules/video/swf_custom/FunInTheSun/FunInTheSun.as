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
package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import geom.Circle;
	
	import onyx.constants.*;
	import onyx.core.IDisposable;

	[SWF(width='320', height='240', frameRate='24', backgroundColor='#FFFFFF')]
	public class FunInTheSun extends Sprite implements IDisposable {
		
		private var _bmp:Bitmap;
		private var _scrollX:Number = 0;
		private var _scrollY:Number = 0;
		private var _targetX:Number = 0;
		private var _targetY:Number = 0;
		private var _timer:Timer = new Timer(500);
		
		public function FunInTheSun():void {
			
			_bmp = new Bitmap(new BitmapData(BITMAP_WIDTH, BITMAP_HEIGHT, true, 0x00000000))
			_bmp.smoothing = true;
			
			addChild(_bmp);
			
			for (var count:int = 0; count < 30; count++) {
				var circle:Circle = new Circle(_bmp.bitmapData);
			}
			
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
			
			addEventListener(Event.ENTER_FRAME, _ent);
			
			_ent();
		}
		
		private function _onTimer(event:TimerEvent):void {
			
			if (Math.random() < .8) {
				_targetX = ((Math.random() < .5) ? -1 : 1) * 10;
				_targetY = ((Math.random() < .5) ? -1 : 1) * 10;
			} else {
				_targetX = 0;
				_targetY = 0;
			}
			
		}
		
		private function _ent(event:Event = null):void {
			_scrollX += ((_targetX - _scrollX) / 10);
			_scrollY += ((_targetY - _scrollY) / 10);
			
			_bmp.bitmapData.scroll(_scrollX, _scrollY);
		}
		
		public function dispose():void {
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer.stop();
			_timer = null;
			
			removeEventListener(Event.ENTER_FRAME, _ent);

			removeChild(_bmp);
			_bmp.bitmapData.dispose();
			_bmp = null;
			
			for each (var circle:Circle in Circle.circles) {
				circle.dispose();
				if (contains(circle)) {
					removeChild(circle);
				}
			}
			
			Circle.circles = null;
		}
		
	}
}
