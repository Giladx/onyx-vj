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
	 * 	Basic/common VLIGHT's patches functionality
	 */
	public class VLSprite extends Sprite implements IParameterObject {
		
		/**
		 * 	@private
		 */
		private var parameters:Parameters	= new Parameters(this as IParameterObject);
		
		private var _silence:int 	= 10;
		private var _amp:int 		= 10;
		
		/**
		 * 	@constructor
		 */
		public function VLSprite():void {
			
			parameters.addParameters(
				new ParameterInteger('silence', 'silence', 8, 100, 30),
				new ParameterInteger('amp', 'amp', 8, 100, 30)
			);
			
		}
		
		public function set silence(value:int):void {
			_silence = value;
		}
		public function get silence():int {
			return _silence;
		}
		
		public function set amp(value:int):void {
			_amp = value;
		}
		public function get amp():int {
			return _amp;
		}
		
		final public function getParameters():Parameters {
			return parameters;
		}
		
		public function dispose():void {
		}
				
	}
}
