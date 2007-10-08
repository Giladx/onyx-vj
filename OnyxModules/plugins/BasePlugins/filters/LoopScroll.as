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
package filters {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.constants.POINT;
	import onyx.controls.Control;
	import onyx.controls.ControlInt;
	import onyx.controls.IControlObject;
	import onyx.plugin.*;
	import onyx.plugin.IBitmapFilter;
	import onyx.layer.LayerProperties;
	import onyx.controls.ControlOverride;

	public final class LoopScroll extends Filter implements IBitmapFilter {
		
		private var _x:int;
		private var xOverride:ControlOverride;
		
		public function LoopScroll():void {
			super(false);
		}
		
		/**
		 * 
		 */
		override public function initialize():void {
			var properties:LayerProperties	= content.properties as LayerProperties;
			var xControl:Control			= properties.getControl('x');
			
			// override the control target
			xOverride						= xControl.override(this, 0);
			_x = xOverride.value;
		}
		
		/**
		 * 
		 */
		public function set x(value:int):void {
			_x = value;
		}
		
		/**
		 * 
		 */
		public function get x():int {
			return 0;
		}
		
		public function applyFilter(source:BitmapData):void {
			
			var x:int = _x % BITMAP_WIDTH;
			
			if (x > 0) {
				
				var leftRect:BitmapData = new BitmapData(x, source.height - 0, true, 0x000000);
				leftRect.copyPixels(source, new Rectangle(source.width - x, 0, x, source.height), POINT);
				
				source.scroll(x, 0);
				source.copyPixels(leftRect, leftRect.rect, POINT);
				leftRect.dispose();
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			if (content) {
				var control:Control = content.properties.getControl('x');
				control.override(xOverride.target, xOverride.value);
			}
			xOverride = null;
		}
	}
}