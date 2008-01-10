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
	
	import filters.Distort;
	
	import flash.events.Event;
	
	import onyx.constants.*;
	import onyx.core.Plugin;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	import onyx.utils.GCTester;

	public final class Random3DDistort extends Macro {
		
		private const _plugin:Plugin = Filter.getDefinition('DISTORT');
		
		private const amountW:int = BITMAP_WIDTH / 3;
		private const amountH:int = BITMAP_HEIGHT / 3;
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			var scale:Number, ratio:Number, x:int, y:int, filters:Array, filter:Distort;
			
			for each (var layer:ILayer in DISPLAY.loadedLayers) {
				
				if (layer.path) {
					filter	= null;
					filters = layer.filters;
					
					for each (var test:Filter in filters) {
						if (test is Distort) {
							filter = test as Distort;
							break;
						}
					}
					
					if (!filter) {
						filter = _plugin.getDefinition() as Distort;
						layer.addFilter(filter);
					}
					
					var tween:Tween = new Tween(
						filter,
						300,
						new TweenProperty('bottomLeftX', filter.bottomLeftX, (Math.random() * amountW * 2) - amountW),
						new TweenProperty('topLeftX', filter.topLeftX, (Math.random() * amountW * 2) - amountW),
						new TweenProperty('bottomRightX', filter.bottomRightX, BITMAP_WIDTH + (Math.random() * amountW * 2) - amountW),
						new TweenProperty('topRightX', filter.topRightX, BITMAP_WIDTH + (Math.random() * amountW * 2) - amountW),
						new TweenProperty('bottomLeftY', filter.bottomLeftY, BITMAP_HEIGHT + (Math.random() * amountH * 2) - amountH),
						new TweenProperty('topLeftY', filter.topLeftY, (Math.random() * amountH * 2) - amountH),
						new TweenProperty('bottomRightY', filter.bottomRightY, BITMAP_HEIGHT + (Math.random() * amountH * 2) - amountH),
						new TweenProperty('topRightY', filter.topRightY, (Math.random() * amountH * 2) - amountH)
					)
					
				}
			}	
		}
		
		override public function keyUp():void {
		}
	}
}