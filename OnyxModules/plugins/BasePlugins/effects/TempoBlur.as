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
package effects {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.plugin.IBitmapFilter;
	import onyx.plugin.TempoFilter;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	import onyx.utils.math.*;

	public final class TempoBlur extends TempoFilter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var _toggle:Boolean			= false;
		
		/**
		 * 
		 */
		public var frameRelease:int				= 6;
		
		/**
		 * 
		 */
		private var _release:int		= 6;
		
		/**
		 * 	@constructor
		 */
		public function TempoBlur():void {

			super(true,
				null,
				new ControlInt('frameRelease', 'release', 1, 20, 6)
			);
			
		}
		
		/**
		 * 
		 */
		public function applyFilter(source:BitmapData):void {
			if (_toggle) {
				source.applyFilter(source, BITMAP_RECT, POINT, new BlurFilter(_release*4, _release*4));
				
				_toggle = --_release > 0;
			}
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			_toggle			= true;
			_release		= frameRelease;
		}
	}
}