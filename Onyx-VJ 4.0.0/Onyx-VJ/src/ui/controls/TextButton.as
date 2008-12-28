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
package ui.controls {
	
	import ui.core.UIObject;
	import ui.styles.*;
	
	/**
	 * 	Text Button
	 */
	public final class TextButton extends UIObject {
		
		/**
		 * 	@constsructor
		 */
		public function TextButton(options:UIOptions, name:String, textColor:uint = TEXT_LABEL):void {
			
			var options:UIOptions = options || UI_OPTIONS;
			var width:int	= options.width;
			var height:int	= options.height;

			// create a background color			
			displayBackground(width, height);
			
			// add a label
			addLabel(name.toUpperCase(), width, height, ((height / 2) - 4) >> 0, 0, null, 0xFFFFFF);

			// add a button
			addChild(new ButtonClear(width, height));
		}
	}
}