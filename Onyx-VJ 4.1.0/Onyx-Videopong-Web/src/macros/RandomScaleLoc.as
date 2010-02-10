/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package macros {
	
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.tween.*;

	public final class RandomScaleLoc extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			var scale:Number, ratio:Number, x:int, y:int;
			
			for each (var layer:Layer in Display.layers) {

				scale	= 1 + (Math.random() * 1.8);
				ratio	= scale - 1;
				x		= ratio * (-DISPLAY_WIDTH) * Math.random();
				y		= ratio * (-DISPLAY_HEIGHT) * Math.random();

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