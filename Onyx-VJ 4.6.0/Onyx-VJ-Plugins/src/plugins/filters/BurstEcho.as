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
	import flash.events.Event;
	import flash.geom.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.*;

	public final class BurstEcho extends TempoFilter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var _source:BitmapData;
		
		/**
		 * 
		 */
		private var _transform:ColorTransform	= new ColorTransform(1,1,1,.09);
		
		/**
		 * 
		 */
		private var _matrix:Matrix				= new Matrix();
		
		/**
		 * 	@constructor
		 */
		public function BurstEcho():void {
			
			super();
			/*	false,
				new ParameterNumber('alpha', 'Echo Alpha', 0, 1, .09)
			);*/
		}
		
		/**
		 * 
		 */
		public function set alpha(value:Number):void {
			_transform.alphaMultiplier = value;
		}
		
		/**
		 * 
		 */
		public function get alpha():Number {
			return _transform.alphaMultiplier;
		}
		/**
		 * 
		 */
		override public function initialize():void {
			_source = createDefaultBitmap();
			super.initialize();
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			
			// stop tweens
			Tween.stopTweens(_transform);
			
			var tween:Tween = new Tween(_transform, 2,//TempoImplementer.tempo,
				new TweenProperty('alphaMultiplier', _transform.alphaMultiplier, ((beat % 2) == 0) ? .95 : .1)
			);
		}
		
		/**
		 * 	Render
		 */
		public function applyFilter(bitmapData:BitmapData):void {
			
			// draw
			_source.draw(bitmapData, _matrix, _transform);
			
			// copy the pixels back to the original bitmap
			bitmapData.copyPixels(_source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
			
		}
		
		/**
		 * 
		 */
		override public function dispose():void {

			// stop tweens
			Tween.stopTweens(_transform);
			
			super.dispose();

			if (_source) {
				_source.dispose();
				_source = null;
			}
		}
	}
}