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
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * 
	 */
	public final class BufferDisplay extends Macro {
		
		private const bitmaps:Array		= [];
		private var current:int;
		private var save:Boolean		= true;
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, _saveBitmap);
			
		}
		
		/**
		 * 	@private
		 */
		private function _saveBitmap(event:Event):void {
			
			var len:int = bitmaps.length;
			if (len > 2) {
				
				Display.pause(true);
				
				var index:int			= current++ % len;
				var bitmap:BitmapData	= bitmaps[index];
				
				Display.source.copyPixels(bitmap, DISPLAY_RECT, ONYX_POINT_IDENTITY);
				Display.source.unlock();
				Display.source.lock();
				//Display.source.fillRect(DISPLAY_RECT, Math.random() * 0xFFFFFF);
				
			// save every other 
			} else {
				if (save) {
					bitmaps.push(Display.source.clone());
				}
				save = !save;
			}
		}

		/**
		 * 
		 */
		override public function keyUp():void {
			DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, _saveBitmap);
			
			while (bitmaps.length) {
				var bitmap:BitmapData = bitmaps.shift() as BitmapData;
				bitmap.dispose();
			}
			Display.pause(false);
		}
	}
}