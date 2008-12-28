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
	import onyx.utils.GCTester;

	public final class Random3DDistort extends Macro {
		
		private const amountW:int = DISPLAY_WIDTH / 2.5;
		private const amountH:int = DISPLAY_HEIGHT / 2.5;
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			var scale:Number, ratio:Number, x:int, y:int, filters:Array, filter:Filter, plugin:Plugin;
			
			plugin = PluginManager.getFilterDefinition('DISTORT');
			
			if (plugin) {
				
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
							new TweenProperty('bottomLeftX',	filter.getParameterValue('bottomLeftX'), (Math.random() * -amountW)),
							new TweenProperty('topLeftX',		filter.getParameterValue('topLeftX'), (Math.random() * -amountW)),
							new TweenProperty('bottomRightX',	filter.getParameterValue('bottomRightX'), DISPLAY_WIDTH + (Math.random() * amountW)),
							new TweenProperty('topRightX',		filter.getParameterValue('topRightX'), DISPLAY_WIDTH + (Math.random() * amountW)),
							new TweenProperty('bottomLeftY',	filter.getParameterValue('bottomLeftY'), DISPLAY_HEIGHT + (Math.random() * amountH)),
							new TweenProperty('topLeftY',		filter.getParameterValue('topLeftY'), (Math.random() * -amountH)),
							new TweenProperty('bottomRightY',	filter.getParameterValue('bottomRightY'), DISPLAY_HEIGHT + (Math.random() * amountH)),
							new TweenProperty('topRightY',		filter.getParameterValue('topRightY'), (Math.random() * -amountH))
						)
						
					}
				}
			}
			
			
		}
		
		override public function keyUp():void {
		}
	}
}