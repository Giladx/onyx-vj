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
	import onyx.tween.*;

	public final class ResetAll extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			var filter:Filter, test:Filter, filters:Array;
			
			for each (var layer:Layer in Display.layers) {
				new Tween(
					layer,
					600,
					new TweenProperty('x', layer.x, 0),
					new TweenProperty('y', layer.y, 0),
					new TweenProperty('scaleX', layer.scaleX, 1),
					new TweenProperty('scaleY', layer.scaleY, 1)
				)
				
				filter	= null;
				filters = layer.filters;
				
				for each (test in filters) {
					if (test.name === 'DISTORT') {
						filter = test;
						break;
					}
				}
				
				if (filter) {
					
					new Tween(
						filter,
						600,
						new TweenProperty('bottomLeftX',	filter.getParameterValue('bottomLeftX'), 0),
						new TweenProperty('topLeftX',		filter.getParameterValue('topLeftX'), 0),
						new TweenProperty('bottomRightX',	filter.getParameterValue('bottomRightX'), DISPLAY_WIDTH),
						new TweenProperty('topRightX',		filter.getParameterValue('topRightX'), DISPLAY_WIDTH),
						new TweenProperty('bottomLeftY',	filter.getParameterValue('bottomLeftY'), DISPLAY_HEIGHT),
						new TweenProperty('topLeftY',		filter.getParameterValue('topLeftY'), 0),
						new TweenProperty('bottomRightY',	filter.getParameterValue('bottomRightY'), DISPLAY_HEIGHT),
						new TweenProperty('topRightY',		filter.getParameterValue('topRightY'), 0)
					)
					
				}
			}	
		}
		
		override public function keyUp():void {
		}
	}
}