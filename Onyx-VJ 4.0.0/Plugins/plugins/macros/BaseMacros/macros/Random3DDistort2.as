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

	public final class Random3DDistort2 extends Macro {
		
		private const plugin:Plugin = PluginManager.getFilterDefinition('DISTORT');
		
		private const amountW:int = DISPLAY_WIDTH / 3;
		private const amountH:int = DISPLAY_HEIGHT / 3;
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			var scale:Number, ratio:Number, x:int, y:int, filters:Array, filter:Filter;
			
			for each (var layer:Layer in Display.loadedLayers) {
				
				if (layer.path) {
					filter	= null;
					filters = layer.filters;
					
					for each (var test:Filter in filters) {
						if (test.name === 'DISTORT') {
							filter = test;
							break;
						}
					}
					
					if (!filter) {
						filter = plugin.createNewInstance() as Filter;
						layer.addFilter(filter);
					}
					
					new Tween(
						filter,
						300,
						
						new TweenProperty('bottomLeftX',	filter.getParameterValue('bottomLeftX'), (Math.random() * amountW * 2) - amountW),
						new TweenProperty('topLeftX', 		filter.getParameterValue('topLeftX'), (Math.random() * amountW * 2) - amountW),
						new TweenProperty('bottomRightX',	filter.getParameterValue('bottomRightX'), DISPLAY_WIDTH + (Math.random() * amountW * 2) - amountW),
						new TweenProperty('topRightX',		filter.getParameterValue('topRightX'), DISPLAY_WIDTH + (Math.random() * amountW * 2) - amountW),
						new TweenProperty('bottomLeftY',	filter.getParameterValue('bottomLeftY'), DISPLAY_HEIGHT + (Math.random() * amountH * 2) - amountH),
						new TweenProperty('topLeftY',		filter.getParameterValue('topLeftY'), (Math.random() * amountH * 2) - amountH),
						new TweenProperty('bottomRightY',	filter.getParameterValue('bottomRightY'), DISPLAY_HEIGHT + (Math.random() * amountH * 2) - amountH),
						new TweenProperty('topRightY',		filter.getParameterValue('topRightY'), (Math.random() * amountH * 2) - amountH)
					)
					
				}
			}	
		}
		
		override public function keyUp():void {
		}
	}
}