/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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
package plugins.visualizer {
	
	import flash.display.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class RadarVisualizer extends Visualizer {
		
		private const shape:Shape	= new Shape();
		public var height:int		= 200;
		private var smooth:Number;
		private var CHANNEL_LENGTH:uint = 256;
		
		//place in middle of screen
		private var xVal:Number = DISPLAY_WIDTH / 2;
		
		//evenly distribute
		private var spacing:Number = (DISPLAY_WIDTH / CHANNEL_LENGTH);		
		public function RadarVisualizer():void {
			parameters.addParameters(
				new ParameterInteger('height', 'height', 100, 300, height)
			);
		}
		
		/**
		 * 	Render
		 */
		override public function render(info:RenderInfo):void {
			
			var step:Number					= DISPLAY_WIDTH / 127;
			var graphics:Graphics			= shape.graphics;
			graphics.clear();
			
			var analysis:Array = SpectrumAnalyzer.getSpectrum(true);
			
			for (var count:int = 0; count < analysis.length; count++) {
				var value:Number	= analysis[count];
				value = ( value * CHANNEL_LENGTH ) << 0;
				var color:uint		= 0xFF0000 |(value << 8);
				graphics.lineStyle(1, color, 1);
				graphics.beginFill(color);
				graphics.drawCircle(Math.random() * DISPLAY_WIDTH, Math.random() * DISPLAY_HEIGHT, value / 8);
				graphics.endFill();
			}
			info.render(shape);
			
		}
	}
}
