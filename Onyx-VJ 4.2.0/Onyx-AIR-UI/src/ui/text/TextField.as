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
	
	import flash.text.*;
	
	import onyx.core.*;
	
	import ui.styles.TEXT_DEFAULT;
	
	/**
	 * 	Default TextField (appears on directories, filters)
	 */
	public final class TextField extends flash.text.TextField implements IDisposable {
		
		/**
		 * 	@constructor
		 */
		public function TextField():void {
			
			super.selectable		= false,
			super.gridFitType		= GridFitType.PIXEL,
			super.embedFonts		= true,
			super.antiAliasType		= AntiAliasType.NORMAL,
			this.mouseEnabled		= false;
			//this.defaultTextFormat = new TextFormat('Courrier New', 7, 0xe4eaef,true);
			this.defaultTextFormat	= TEXT_DEFAULT;
			//super.textColor 		= 0x00FF00;
		}
		
		/**
		 * 
		 */
		public function dispose():void {
			Factory.release(ui.text.TextField, this);
		}
	}
}