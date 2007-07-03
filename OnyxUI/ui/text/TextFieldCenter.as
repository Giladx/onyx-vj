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
package ui.text {
	
	import flash.text.*;
	
	import onyx.utils.math.floor;
	
	import ui.styles.TEXT_DEFAULT;
	
	/**
	 * 	Default TextField -- This class exists because there is a Flash Player Bug with centered text and 
	 * 	anti-aliasing.  This class centers text based on the width of an auto-sized textfield
	 */
	public class TextFieldCenter extends flash.text.TextField {
		
		/**
		 * 	@private
		 * 	The x value to snap to
		 */
		private var _x:int;
		
		/**
		 * 
		 */
		private var _width:int;
		
		/**
		 * 	@constructor
		 */
		public function TextFieldCenter(width:int, height:int, x:int, y:int):void {
			
			_x		= x;
			_width	= width;
			
			super.selectable		= false,
			super.defaultTextFormat	= TEXT_DEFAULT,
			super.gridFitType		= GridFitType.PIXEL,
			super.antiAliasType		= AntiAliasType.NORMAL,
			super.autoSize			= TextFieldAutoSize.LEFT,
			super.width				= width,
			super.height			= height,
			super.embedFonts		= true,
			super.mouseEnabled		= false,
			super.mouseWheelEnabled	= false,
			super.y					= y;
			
		}
		
		override public function set text(value:String):void {
			super.text = value;
			
			// autocenter based on width / size of the textfield
			// << 0 is for floor
			super.x = (_width / 2) - (super.width / 2) << 0;
		}
		
		/**
		 * 
		 */
		override public function set x(value:Number):void {
			super.x = _x = x;

			// autocenter based on width / size of the textfield
			super.x = (_width / 2) - (super.width / 2);
		}
	}
}