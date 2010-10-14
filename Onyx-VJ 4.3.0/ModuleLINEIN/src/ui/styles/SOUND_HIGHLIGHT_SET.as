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
package ui.styles {

	import flash.geom.ColorTransform;
	import core.Sound;
	
	public function SOUND_HIGHLIGHT_SET(soundhash:uint):ColorTransform {
		switch(soundhash) {
			case Sound.SOUND_LOW : 	return new ColorTransform(1,1,1,.5,0,0,255);
			case Sound.SOUND_MID :	return new ColorTransform(1,1,1,.5,0,255,0);
			case Sound.SOUND_HIGH:	return new ColorTransform(1,1,1,.5,255,0,0);
			default: 				return null
		}
	}
		
}