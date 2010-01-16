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
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;

	import onyx.tween.*;
	
	use namespace onyx_ns;

	/**
	 * 	TBD: Turn this into a convolve filter
	 */
	public final class ConvolveFilter extends Filter implements IBitmapFilter {

		/**
		 * 
		 */
		private var __blurX:Parameter;
		private var __blurY:Parameter;
		private var _filter:BlurFilter					= new BlurFilter(4, 4);
		
		public function ConvolveFilter():void {

			__blurX = new ParameterInteger('blurX', 'blurX', 0, 42, 4);
			__blurY = new ParameterInteger('blurY', 'blurY', 0, 42, 4);
			
			super(
				false,
				new ParameterProxy('blur', 'blur',
					__blurX,
					__blurY,
					{ factor: 5, invert: true }
				)
			);
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			bitmapData.applyFilter(bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY, _filter);
		}
		
		public function terminate():void {
			_filter = null;
		}
		
		public function set blurX(x:int):void {
			_filter.blurX = __blurX.dispatch(x);
		}
		
		public function get blurX():int {
			return _filter.blurX;
		}
		
		public function set blurY(y:int):void {
			_filter.blurY = __blurY.dispatch(y);
		}
		
		public function get blurY():int {
			return _filter.blurY;
		}
		
		public function get quality():int {
			return _filter.quality;
		}
		
		override public function dispose():void {

		}
	}
}