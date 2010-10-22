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
	
	import services.sound.*;
	
	/**
	 * 	Sound patches with FFT functionality
	 */
	public class SoundSpriteFFT extends SoundImplementer {
		
		private var _bands:int 	= 16;
				
		/**
		 * 	@constructor
		 */
		public function SoundSpriteFFT():void {
			
			super();
			
			getParameters().addParameters(
				new ParameterArray('bands','bands',new Array(8,16,32,64,128,256),_bands)
			);
						
		}
		
		public function set bands(value:int):void {
			_bands = value;
		}
		public function get bands():int {
			return _bands;
		}
			
		override public function onPeak(l:Array,r:Array):void {
		}
		
	}
}
