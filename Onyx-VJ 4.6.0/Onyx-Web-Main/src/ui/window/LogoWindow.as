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
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.System;
	import flash.text.TextFieldType;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.plugin.ONYX_TITLE;
	import onyx.utils.*;
	
	import ui.states.*;
	import ui.text.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Console window
	 */
	public final class LogoWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var _border:Graphics;
		
		/**
		 * 	@private
		 */
		private var _text:TextField;
		
		/**
		 * 	@constructor
		 */
		public function LogoWindow(reg:WindowRegistration):void {
			
			super(reg, false, 190, 75);
			
			_draw();
			
		}
		
		/**
		 * 	@private
		 * 	Draw
		 */
		private function _draw():void {
			
			_border						= this.graphics;
			
			_text						= Factory.getNewInstance(TextField);
			_text.width					= 190,
			_text.height				= 75,
			_text.multiline				= true,
			_text.wordWrap				= true,
			_text.x						= 0,
			_text.y						= 0,
			_text.selectable			= true;
			_text.antiAliasType			= flash.text.AntiAliasType.ADVANCED;
			_text.sharpness				= 400;
			_text.thickness				= 0;
			
			_text.htmlText = '<font size="28" color="#DCC697" face="DefaultFont"><b>ONYX ' + VERSION + '</b></font><br>';
			_text.htmlText += '<TEXTFORMAT LEADING="3"><FONT FACE="DefaultFont" SIZE="21" COLOR="#e4eaef" KERNING="0">' + ONYX_TITLE + ' edition</font></textformat><br/>';
			
			addChild(_text);
			
		}
	}
}