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
	
	import events.VLIGHTEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import vlight.IVLIGHTPeak;
	
	/**
	 * 	Basic/common VLIGHT's patches functionality
	 */
	public class VLSpritePEAK extends VLSprite implements IVLIGHTPeak {
				
		private var _bass:int 		= 10;
		private var _mid:int 		= 10;
		private var _high:int 		= 10;
		
		
		/**
		 * 	@constructor
		 */
		public function VLSpritePEAK():void {
			
			super();
			
			getParameters().addParameters(
				new ParameterInteger('bass', 'bass', 8, 100, 30),
				new ParameterInteger('mid', 'mid', 8, 100, 30),
				new ParameterInteger('high', 'high', 8, 100, 30)
			);
			
			// add event listener
			PluginManager.modules["VLIGHT"].VLIGHT.addEventListener("peak", onPeak);
										
		}
		
		public function onPeak(e:Event):void {

			Console.output("peak ");//(e.clone() as VLIGHTEvent).val);
			
		}
		
		public function set bass(value:int):void {
			_bass = value;
		}
		public function get bass():int {
			return _bass;
		}
		public function set mid(value:int):void {
			_mid = value;
		}
		public function get mid():int {
			return _mid;
		}
		public function set high(value:int):void {
			_high = value;
		}
		public function get high():int {
			return _high;
		}
				
	}
}
