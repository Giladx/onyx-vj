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
	
	import flash.utils.Dictionary;
	
	import onyx.display.*;
	import onyx.plugin.*;
	
	public final class SlowDown extends Macro {
		
		private var hash:Dictionary;
		
		override public function keyDown():void {
			
			hash = new Dictionary(true);
			
			for each (var layer:Layer in Display.layers) {
				hash[layer]		= layer.framerate;
				layer.framerate /= 3;
			}
		}
		
		override public function keyUp():void {
			
			for each (var layer:Layer in Display.layers) {
				layer.framerate = hash[layer] || 1;
				delete hash[layer];
			}
			hash = null;
		}
	}
}