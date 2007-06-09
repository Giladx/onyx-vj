/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package ui.core {

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;

	
	/**
	 * 	Handles tooltips
	 */
	public final class ToolTipManager {
		
		/**
		 * 	@private
		 * 	Stores tool tip definitions
		 */
		private static var _dict:Dictionary = new Dictionary(true);

		/**
		 * 	@private
		 * 	The on timer
		 */
		private static var timer:Timer		= new Timer(650);
		
		/**
		 * 	@private
		 * 	The off timer
		 */
		private static var offTimer:Timer	= new Timer(100);
		
		/**
		 * 	@private
		 * 	The last object that displayed a tooltip
		 */
		private static var _lastObject:DisplayObject;
		
		/**
		 * 	@private
		 * 	ToolTip
		 */
		private static var toolTip:ToolTip;

		/**
		 * 	Registers a Display Object with a tooptip
		 */
		public static function registerToolTip(obj:DisplayObject, tip:String):void {
			_dict[obj] = tip;

			if (tip) {
				obj.addEventListener(MouseEvent.ROLL_OVER, _onToolOver, false, 0, true);
			} else {
				obj.removeEventListener(MouseEvent.ROLL_OVER, _onToolOver);
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _onToolOver(event:MouseEvent):void {
			
			var obj:DisplayObject = event.currentTarget as DisplayObject;
			obj.addEventListener(MouseEvent.ROLL_OUT, _onToolOut, false, 0, true);

			_lastObject = obj;
			offTimer.stop();
			
			if (!toolTip) {
				timer.start();
			} else {
				_onTimer(null);
			}
		}

		
		/**
		 * 	@private
		 */
		private static function _onToolOut(event:MouseEvent):void {
			
			var obj:DisplayObject = event.currentTarget as DisplayObject;
			obj.removeEventListener(MouseEvent.ROLL_OUT, _onToolOut);

			timer.stop();

			if (toolTip) 
				offTimer.start();
			
		}
		
		/**
		 * 	@private
		 */
		private static function _onTimer(event:TimerEvent):void {
			timer.stop();
			
			if (_lastObject.stage) {
				var stage:Stage = _lastObject.stage;
	
				if (!toolTip) {
					toolTip = new ToolTip();
				}
				toolTip.x = STAGE.mouseX + 4;
				toolTip.y = STAGE.mouseY - 4;
				toolTip.text = (_dict[_lastObject] as String).toUpperCase();
				
				STAGE.addChild(toolTip);
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _offTimer(event:TimerEvent):void {
			toolTip.parent.removeChild(toolTip);
			offTimer.stop();
			toolTip = null;
		}
		
		/**
		 * 	
		 */
		public static function set enabled(value:Boolean):void {
			if (value) {
				timer.addEventListener(TimerEvent.TIMER, _onTimer);
				offTimer.addEventListener(TimerEvent.TIMER, _offTimer);
			} else {
				timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				offTimer.removeEventListener(TimerEvent.TIMER, _offTimer);
			}
		}
		
		enabled = true;
	}
}

import flash.text.*;
import flash.text.TextField;
import ui.assets.PixelFont;
import ui.styles.TEXT_DEFAULT;

/**
 * 	Tooltip Display Class
 */
class ToolTip extends TextField {

	public function ToolTip():void {
		
		mouseEnabled = false;
		
		super.selectable		= false;
		super.autoSize			= TextFieldAutoSize.LEFT;
		
		super.background		= true;
		super.backgroundColor	= 0xFFCC00;
		
		super.defaultTextFormat = TEXT_DEFAULT;
		super.embedFonts		= true;
		super.textColor			= 0x000000;
		
	}

}