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
	
	import flash.display.BitmapData;
	import flash.filters.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.plugin.Filter;
	import onyx.plugin.IBitmapFilter;

	public final class ConstantScroll extends Filter implements IBitmapFilter {
		
		private var scrollX:int = 0;
		private var scrollY:int = 0;
		public var scrollXSpeed:int = 0;
		public var scrollYSpeed:int = 0;
		private var bitmap:BitmapData;
		
		public function ConstantScroll():void {
			super(true,
				new ControlProxy('speed', 'speed', 
					new ControlInt('scrollXSpeed', 'x speed', -100, 100, 0),
					new ControlInt('scrollYSpeed', 'y speed', -100, 100, 0),
					true
				),
				new ControlExecute('reset', 'reset')
			);
		}
		
		public function reset():void {
			scrollX = scrollY = 0;
		}
		
		override public function initialize():void {
			bitmap = BASE_BITMAP();
		}
		
		public function applyFilter(source:BitmapData):void {
			scrollX = (scrollX + scrollXSpeed) % (BITMAP_WIDTH * 2),
			scrollY = (scrollY + scrollYSpeed) % (BITMAP_HEIGHT * 2);
			source.applyFilter(source, BITMAP_RECT, POINT, new DisplacementMapFilter(bitmap, POINT, 4, 4, scrollX, scrollY));
		}
		
		override public function dispose():void {
			bitmap.dispose();
			bitmap = null;
			super.dispose();
		}
	}
}