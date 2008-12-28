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
package ui.text {

	import flash.display.*;
	import flash.filters.*;
	import flash.text.TextFieldAutoSize;
	
	import ui.styles.*;

	/**
	 * 	Converts text field into bitmap
	 */
	public final class TextBitmap extends Bitmap {
		
		/**
		 * 	@private
		 */
		private static var _text:TextField = new TextField();
		text.autoSize = TextFieldAutoSize.LEFT;
		
		/**
		 * 	@constructor
		 */
		public function TextBitmap(text:String = null, makeReadable:Boolean = true):void {
			if (text) {
				_text.text = text;
			}
		}
		
		public function set text(value:String):void {
			var bmp:BitmapData = super.bitmapData;
			if (bmp) {
			}
		}
		
	}
}