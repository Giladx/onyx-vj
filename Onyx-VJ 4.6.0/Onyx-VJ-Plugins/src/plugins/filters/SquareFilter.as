/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
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
package plugins.filters {
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	
	public final class SquareFilter extends Filter implements IBitmapFilter {
		
		private var _source:BitmapData;
		private var _mask:BitmapData;
		
		private var _amount:Number	= 15;
		private var _invert:Boolean	= false;
		private var _delay:int    	 	= 100;
		private var previousTime:Number = 0.0;
		private var time:Number;
		private var dt:Number ;
		private var square:int;
		private var scaleX:Number;
		private var scaleY:Number;	
		private var count:int = 0;
		
		public function SquareFilter():void {
			
			parameters.addParameters(
				new ParameterInteger('amount', 'amount', 2, 15, _amount, 1, 5),
				new ParameterBoolean('invert', 'invert'),
				new ParameterInteger('delay', 'delay', 3, 1000, _delay, 10)
			);
		}
		
		override public function initialize():void {
			
			_source     = content.source.clone();
			_mask       = content.source.clone();
			_mask.fillRect(DISPLAY_RECT, 0x00000000);
			
		}
		
		public function set amount(value:Number):void {
			_amount = value;
		}
		
		public function get amount():Number {
			return _amount;
		}
		
		public function set invert(value:Boolean):void {
			_invert = value;
		}
		
		public function get invert():Boolean {
			return _invert;
		}
		
		public function get delay():int {
			return _delay;
		}
		
		public function set delay(value:int):void {
			_delay = value;
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			
			//take the bitmapData stream and make a copy into _source
			_source.draw(bitmapData);

			time = getTimer();
			dt = time - previousTime;
			
			if ( dt > delay )
			{
				square = Math.pow(_amount, 2);
				
				scaleX = Math.ceil(DISPLAY_WIDTH / _amount);
				scaleY = Math.ceil(DISPLAY_HEIGHT / _amount);
				count = Math.random()*square;
				
				_mask.fillRect( new Rectangle( count%_amount*scaleX, 
					int(count/_amount)*scaleY,
					scaleX,
					scaleY),
					0xFFFFFFFF);
				
				previousTime = time;
			}
			
			bitmapData.copyPixels( _source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _mask, ONYX_POINT_IDENTITY, false );
		}
		
		override public function dispose():void {
			if (_source) {
				_source.dispose();
				_source = null;
			}
			_mask = null;
			
			super.dispose();
		}
		
	}
}
