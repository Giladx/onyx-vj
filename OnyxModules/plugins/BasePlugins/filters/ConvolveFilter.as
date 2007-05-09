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
package filters {
	
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	
	use namespace onyx_ns;

	/**
	 * 	TBD: Turn this into a convolve filter
	 */
	public final class ConvolveFilter extends Filter implements IBitmapFilter {

		/**
		 * 
		 */
		private var __blurX:Control;
		private var __blurY:Control;
		private var _filter:BlurFilter					= new BlurFilter(4, 4);
		
		public function ConvolveFilter():void {

			__blurX = new ControlInt('blurX', 'blurX', 0, 42, 4);
			__blurY = new ControlInt('blurY', 'blurY', 0, 42, 4);
			
			super(
				false,
				new ControlProxy('blur', 'blur',
					__blurX,
					__blurY,
					{ factor: 5, invert: true }
				)
			);
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			bitmapData.applyFilter(bitmapData, BITMAP_RECT, POINT, _filter);
		}
		
		public function terminate():void {
			_filter = null;
		}
		
		public function set blurX(x:int):void {
			_filter.blurX = __blurX.setValue(x);
		}
		
		public function get blurX():int {
			return _filter.blurX;
		}
		
		public function set blurY(y:int):void {
			_filter.blurY = __blurY.setValue(y);
		}
		
		public function get blurY():int {
			return _filter.blurY;
		}
		
		public function get quality():int {
			return _filter.quality;
		}
		
		override public function dispose():void {

		}
	}
}