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

	import flash.text.TextFieldType;
	import ui.styles.*;
	import flash.text.TextFormat;

	public final class TextInput extends TextField {
		
		/**
		 * 	@constructor
		 */
		public function TextInput(width:int = 100, height:int = 16, format:TextFormat = null):void {

			super(width, height, format);
			
			super.type = TextFieldType.INPUT;
			super.mouseEnabled	= true;
			super.selectable	= true;
		}

	}
}