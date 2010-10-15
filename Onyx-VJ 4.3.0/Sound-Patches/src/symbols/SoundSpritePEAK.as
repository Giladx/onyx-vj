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
	import onyx.events.*;
	
	import services.sound.ID;
	
	/**
	 * 	Basic/common VLIGHT's patches functionality
	 */
	public class SoundSpritePEAK extends SoundSprite implements ISound {
				
		private var _sync:String	= 'level';
		private var _level:int 		= 50;
		
		/**
		 * 	@constructor
		 */
		public function SoundSpritePEAK():void {
			
			super();
			
			getParameters().addParameters(
				new ParameterArray('sync','mode',new Array('level'/*,'low','mid','high'*/),_sync),
				new ParameterInteger('level', 'level', 0, 100, _level, 1, 5)
			);
			
			// add event listener
			PluginManager.modules[ID].LINEIN.addEventListener(SndEvent.SOUND, onPeak);
										
		}
		
		public function set sync(value:String):void {
			_sync = value;
		}
		public function get sync():String {
			return _sync;
		}
		
		public function set level(value:int):void {
			_level = value;
		}
		public function get level():int {
			return _level;
		}
		
		public function onPeak(e:Event):void {
			//(e.clone() as VLIGHTEvent).val);
		}
					
		override public function dispose():void {
			PluginManager.modules[ID].LINEIN.removeEventListener(SndEvent.SOUND, onPeak);
		}
	}
}
