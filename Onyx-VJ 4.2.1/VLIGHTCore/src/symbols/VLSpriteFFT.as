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
package symbols {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * 	VLIGHT's patches with FFT functionality
	 */
	final public class VLSpriteFFT extends VLSprite {
		
		private var _bands:int 	= 16;
				
		/**
		 * 	@constructor
		 */
		public function VLSpriteFFT():void {
			
			super();
			
			getParameters().addParameters(
				new ParameterInteger('bands', 'bands', 2, 16, 16)
			);
						
		}
		
		public function set bands(value:int):void {
			_bands = value;
		}
		public function get bands():int {
			return _bands;
		}
								
		/**
		 * 	
		 */
		override public function dispose():void {
		}
	}
}
