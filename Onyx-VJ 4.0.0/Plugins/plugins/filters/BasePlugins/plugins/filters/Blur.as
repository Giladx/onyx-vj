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
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;

	import onyx.tween.*;

	
	use namespace onyx_ns;

	public final class Blur extends Filter implements IBitmapFilter {
		
		public var mindelay:Number						= .4;
		public var maxdelay:Number						= 1;

		private var _tween:Boolean;
		private var _timer:Timer;
		private var _blurX:int							= 4;
		private var _blurY:int							= 4;
		
		private var __blurX:ParameterNumber;
		private var __blurY:ParameterNumber;
		private var _filter:BlurFilter					= new BlurFilter(_blurX, _blurY)
		
		public function Blur():void {

			__blurX = new ParameterInteger('blurX', 'blurX', 0, 42, 4);
			__blurY = new ParameterInteger('blurY', 'blurY', 0, 42, 4);
			
			parameters.addParameters(
				__blurX,
				__blurY
			);
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			bitmapData.applyFilter(bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY, _filter);
		}
		
		public function terminate():void {
			_filter = null;
		}
		
		public function set blurX(x:int):void {
			_filter.blurX = _blurX = __blurX.dispatch(x);
		}
		
		public function get blurX():int {
			return _filter.blurX;
		}
		
		public function set blurY(y:int):void {
			_filter.blurY = _blurY = __blurY.dispatch(y);
		}
		
		public function get blurY():int {
			return _filter.blurY;
		}
		
		public function get quality():int {
			return _filter.quality;
		}
		
		override public function dispose():void {
			_filter = null;
		}
	}
}