/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
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
package plugins.filters {
	
	import flash.display.BitmapData;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.*;

	/**
	 * 
	 */
	public final class BounceFilter extends Filter implements IBitmapFilter {
		
		/**
		 * 	@constructor
		 */
		public function BounceFilter():void {
			parameters.addParameters(
				new ParameterExecuteFunction('switchDir', 'switch dir')
			)
		}
		
		/**
		 * 
		 */
		public function switchDir():void {
			content.framerate	*= -1;
		}
		
		/**
		 * 
		 */
		public function applyFilter(bitmapData:BitmapData):void {
			
			var totalTime:int	= content.totalTime;
			var time:int		= content.time * totalTime;
			var start:int		= content.loopStart * totalTime;
			var end:int			= content.loopEnd	* totalTime;
			var frame:int		= content.framerate * DISPLAY_STAGE.frameRate * 2;
			
			if (time + frame > end || time + frame < start) {
				content.framerate	*= -1;
			}
		}
	}
}
