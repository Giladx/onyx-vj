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
package plugin {
	
	import flash.events.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	
	import sound.ISoundPeak;
	import events.SoundEvent;
	
	use namespace onyx_ns;
	
	/**
	 * 	Base Sound Filter class.  Extend this class if you'd like your filter to respond to the sound.
	 * 
	 * 	@see onyx.plugin.Filter
	 * 
	 */
	public class SoundFilter extends Filter implements ISoundPeak {
		
		/**
		 * 	@constructor
		 */
		public function SoundFilter():void {
			
			// add params
			//parameters.addParameters(snapControl, delayControl);
			parameters.addParameters(
			/*	new ParameterInteger('bass', 'bass', 0, 100, 30),
				new ParameterInteger('mid', 'mid', 0, 100, 30),
				new ParameterInteger('high', 'high', 0, 100, 30)*/
			);
			
			
			
		}
		
		override public function initialize():void {
			// add event listener
			PluginManager.modules["LINEIN"].LINEIN.addEventListener("sound", onPeak);
		}
		
		public function onPeak(e:Event):void {
			//(e.clone() as VLIGHTEvent).val);
		}
		
		public function onSound(e:Event):void {			
		}
		
		/**
		 * 
		 */
		override final public function set muted(value:Boolean):void {
			super.muted = value;
			initialize();
		}
		
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {

			PluginManager.modules["LINEIN"].LINEIN.removeEventListener("sound", onPeak);
			super.dispose();
			
		}
		
		/**
		 * 
		 */
		final override onyx_ns function clean():void {

			// remove listener
			
			//GLOBAL_TEMPO_CONTROL.removeEventListener(ParameterEvent.CHANGE, _globalTempoHandler);

		}
	}
}