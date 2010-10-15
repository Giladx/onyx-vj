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
package onyx.events {
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;
	
	/**
	 * 	Sound event
	 */
	final public class SndEvent extends Event {
		
		public static const SOUND:String 	= 'sound';
		public static const FFT:String 		= 'sound_fft';
		public static const WAVE:String 	= 'sound_wave';
		
		public var data:ByteArray;
		
		/**
		 * 
		 */
		public function SndEvent(type:String, data:ByteArray):void {
			super(type);
			this.data = data; 
		}
		
		/**
		 * 
		 */
		override public function clone():Event {
			return new SndEvent(type,data);
		}
		
	}
}