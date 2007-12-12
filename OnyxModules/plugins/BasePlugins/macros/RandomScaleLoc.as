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
package macros {
	
	import onyx.constants.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.tween.*;

	public final class RandomScaleLoc extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			var scale:Number, ratio:Number, x:int, y:int;
			
			for each (var layer:ILayer in DISPLAY.layers) {

				scale	= 1 + (Math.random() * 2);
				ratio	= scale - 1;
				x		= ratio * (-BITMAP_WIDTH) * Math.random();
				y		= ratio * (-BITMAP_HEIGHT) * Math.random();

				new Tween(
					layer,
					175,
					new TweenProperty('x', layer.x, x),
					new TweenProperty('y', layer.y, y),
					new TweenProperty('scaleX', layer.scaleX, scale),
					new TweenProperty('scaleY', layer.scaleY, scale)
				)
			}	
		}
		
		override public function keyUp():void {
		}
	}
}