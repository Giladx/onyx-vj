/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
package ui.controls {
	
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import ui.core.UIObject;
	
	/**
	 * 	Clear Button
	 */
	public final class ButtonClear extends SimpleButton {
		
		/**
		 * 	@constructor
		 */
		final public function ButtonClear(width:int, height:int, show:Boolean = true):void {

			if (show) {
				overState = new OverState(width, height);
			}
			hitTestState = new HitState(width, height);
		}
	}
}

import flash.display.Shape;
import ui.styles.*;
import flash.display.Graphics;

/**
 * 	Hitstate
 */
final class HitState extends Shape {
	
	final public function HitState(width:int, height:int):void {

		var graphics:Graphics = this.graphics;
		
		graphics.beginFill(0);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
	}
}

/**
 * 	overstate
 */
final class OverState extends Shape {
	
	final public function OverState(width:int, height:int):void {

		var graphics:Graphics = this.graphics;
		
		graphics.beginFill(BUTTON_OVER, .2);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();

	}
}

/**
 * 	Downstate
 */
final class DownState extends Shape {
	
	final public function DownState(width:int, height:int):void {

		graphics.beginFill(BUTTON_DOWN, .2);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
	}
}