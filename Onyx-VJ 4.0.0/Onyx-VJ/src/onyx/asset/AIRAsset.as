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
package onyx.asset {
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	
	import onyx.utils.file.*;

	/**
	 * 
	 */
	public final class AIRAsset extends OnyxFile {
		
		/**
		 * 	@private
		 */
		private static const DEFAULT:BitmapData = new BitmapData(THUMB_WIDTH, THUMB_HEIGHT, false, 0);
		
		/**
		 * 	@private
		 */
		private var file:File;
		
		/**
		 * 
		 */
		public function AIRAsset(file:File, data:BitmapData = null):void {
			this.file				= file;
			thumbnail.bitmapData	= data || DEFAULT;
		}
		
		/**
		 * 
		 */
		override public function get name():String {
			return file.name;
		}
		
		/**
		 * 
		 */
		override public function get path():String {
			return getRelativePath(AIR_ROOT, file);	
		}
		
		/**
		 * 
		 */
		override public function get isDirectory():Boolean {
			return file.isDirectory;
		}
		
		/**
		 * 
		 */
		override public function get extension():String {
			return file.extension;
		}
	}
}