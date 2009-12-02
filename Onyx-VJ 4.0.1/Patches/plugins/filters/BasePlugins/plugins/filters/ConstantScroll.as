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
package plugins.filters {
	
	import flash.display.BitmapData;
	import flash.filters.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;

	public final class ConstantScroll extends Filter implements IBitmapFilter {
		
		private var scrollX:int = 0;
		private var scrollY:int = 0;
		public var scrollXSpeed:int = 0;
		public var scrollYSpeed:int = 0;
		private var bitmap:BitmapData;
		
		public function ConstantScroll():void {
			parameters.addParameters(
				new ParameterProxy('speed', 'speed', 
					new ParameterInteger('scrollXSpeed', 'x speed', -100, 100, 0),
					new ParameterInteger('scrollYSpeed', 'y speed', -100, 100, 0),
					true
				),
				new ParameterExecuteFunction('reset', 'reset')
			);
		}
		
		public function reset():void {
			scrollX = scrollY = 0;
		}
		
		override public function initialize():void {
			bitmap = createDefaultBitmap();
		}
		
		public function applyFilter(source:BitmapData):void {
			scrollX = (scrollX + scrollXSpeed) % (DISPLAY_WIDTH * 2),
			scrollY = (scrollY + scrollYSpeed) % (DISPLAY_HEIGHT * 2);
			source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, new DisplacementMapFilter(bitmap, ONYX_POINT_IDENTITY, 4, 4, scrollX, scrollY));
		}
		
		override public function dispose():void {
			bitmap.dispose();
			bitmap = null;
			super.dispose();
		}
	}
}