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
package ui.window {
	

	import onyx.display.*;
	import onyx.plugin.*;
	
	import ui.layer.UIDisplay;


	/**
	 * 	Display Window
	 */
	public final class DisplayWindow extends Window {
		
		/**
		 * 	@private
		 * 	The display controls
		 */
		private var _display:UIDisplay;
		
		/**
		 * 	@constructor
		 */
		public function DisplayWindow(reg:WindowRegistration):void {
			
			super(reg, false, 0, 0);

			// set our display
			_display	= new UIDisplay(Display as OutputDisplay);

			//
			addChild(_display);
		}
	}
}