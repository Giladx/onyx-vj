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
package ui.window {
	
	import ui.styles.*;
	import ui.text.TextField;
	
	/**
	 * 	Help Window (used online)
	 */
	public final class HelpWindow extends Window {
		
		private var _text:TextField	= new TextField(390, 190, TEXT_ARIAL);
		
		public function HelpWindow():void {
			
			super('HELP', 396, 200, 614, 318);
			
			_text.x			= 4;
			_text.y			= 15;
			_text.wordWrap	= true;
			_text.textColor	= 0xDCC697;

			_text.htmlText	= 
			'ONYX IS A VIDEO-MIXING PROGRAM MEANT FOR DOING LIVE CLUB VISUALS AND ART INSTALLATIONS\n\n' +
			'LOAD VIDEOS BY DRAGGING FILES FROM THE BROWSER ON THE LEFT ONTO ONE OF THE LAYERS.' +
			'BLEND THE LAYERS BY CLICKING AND DRAGGING ON THE TEXT THAT SAYS "NORMAL" ON THE LAYER CONTROL.  YOU CAN CONTROL BRIGHTNESS, ALPHA, ETC, WITH THE CONTROLS UNDER THE "BASIC" TAB.' +

			'ADDING FILTERS AND EFFECTS:\n\n' +
			'ADD FILTERS TO LAYERS BY DRAGGING FILTERS TO THE LAYER.  CONTROL FILTER PARAMETERS BY CLICKING ON THE "FILTERS" TAB.  YOU CAN ALSO ADD GLOBAL FILTERS BY DRAGGING THEM ONTO THE CONTROL AT THE BOTTOM OF THE SCREEN.\n\n' +
			
			'FOR MORE HELP, PLEASE REFER TO THE TUTORIALS SECTION.';
			
			addChild(_text);
			
		}
	}
}