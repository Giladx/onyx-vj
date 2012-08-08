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
	
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;


	public final class AutoCompose extends TempoFilter implements IBitmapFilter {
		
		private var _buffer:BitmapData;
		private var _alpha:ColorTransform	= new ColorTransform(1,1,1,.3);
		private var _currentBlur:Number		= 0;
		private var _currentDelay:Number	= 0;

		public var preblur:Number			= 0;
		public var drawDelay:Number			= 1;
		public var mode:String				= 'lighten';
		
		public function AutoCompose():void {
			
			parameters.addParameters(
				new ParameterExecuteFunction('clear', 'clear'),
				new ParameterNumber('preblur',	'preblur', 0, 30, 0, 10),
				new ParameterNumber('drawDelay',	'drawDelay', 0, 30, 1, 10),
				new ParameterNumber('alpha',	'alpha', 0, 1, .3),
				new ParameterBlendMode('mode', 'mode', mode)
			);

		}
		
		public function clear():void {
			_buffer.fillRect(DISPLAY_RECT, 0);
		}
		
		override public function initialize():void {
			_buffer = createDefaultBitmap();
			super.initialize();
		}
		
		public function applyFilter(source:BitmapData):void {
			
			_currentBlur	+= preblur;
			_currentDelay	+= drawDelay;
			
			if (_currentBlur >= 2) {
				var factor:int = _currentBlur - 2;
				
				_currentBlur -= factor;
				_buffer.applyFilter(_buffer, DISPLAY_RECT, ONYX_POINT_IDENTITY, new BlurFilter(factor,factor));
			}
			
			if (_currentDelay >= 1) {
				_currentDelay--;

				// auto-scroll
				_buffer.draw(source, null, _alpha,mode);
			}
			
			source.copyPixels(_buffer, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
		
		public function set alpha(value:Number):void {
			_alpha.alphaMultiplier = value;
		}
		
		public function get alpha():Number {
			return _alpha.alphaMultiplier;
		}
		
		override public function dispose():void {
			_buffer.dispose();
			_buffer = null;
		}
	}
}