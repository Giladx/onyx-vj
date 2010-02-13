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

	/**
	 * 
	 */
	public final class DisplaceFilter extends Filter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var _layer:ILayer;

		/**
		 * 	@private
		 */
		private var _filter:DisplacementMapFilter;
		
		/**
		 * 	@constructor
		 */
		public function DisplaceFilter():void {
			super(true,
				new ParameterLayer('layer', 'layer')
			);
		}
		
		public function set layer(value:ILayer):void {
			_layer = value;
			_filter = new DisplacementMapFilter(value.source, ONYX_POINT_IDENTITY, 1, 1, 1, 1, 'wrap', 0xFF0000, 1);
		}
		
		public function get layer():ILayer {
			return _layer;
		}
		
		public function applyFilter(source:BitmapData):void {
			if (_filter) {
				source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _filter);
			}
		}
		
		override public function dispose():void {
			_layer = null;
			_filter = null;
		}
		
	}
}