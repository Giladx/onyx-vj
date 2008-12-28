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
package macros {

	public final class RandomFrameRateMacro extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			for each (var layer:Layer in Display.layers) {
				layer.framerate = Math.max(Math.random() * 2, 1) * (Math.random() > .5 ? 1 : -1);
			}
			
		}
		
		override public function keyUp():void {
		}
	}
}