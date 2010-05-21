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
 package events {
 	
 	import flash.events.Event;
 	import flash.utils.ByteArray;
 	
	/**
	 * 	VLIGHT event
	 */
	final public class VLIGHTEvent extends Event {
		
		public static const FFT:String = 'fft';
		public static const PEAK:String = 'peak';
		
		public var val:int;
				
		/**
		 * 
		 */
		public function VLIGHTEvent(type:String,val:int):void {
			this.val = val;
			super(type);
		}
		
		/**
		 * 	Clones the event
		 */
		override public function clone():Event {
			return new VLIGHTEvent(type, val);
		}
	
	}
}