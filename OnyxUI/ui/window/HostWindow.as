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
package ui.window {
	
	import onyx.net.Host;
	
	import ui.core.UIManager;
	import ui.controls.DropDown;
	import ui.controls.SliderV;
	import ui.controls.TextButton;
	import ui.controls.UIOptions;
	import flash.events.MouseEvent;
	
	
	/**
	 * 	Host Window
	 */
	public final class HostWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var _host:Host	= new Host();
		
		/**
		 * 	@Constructor
		 */
		public function HostWindow():void {
			
			var options:UIOptions = new UIOptions();
			options.width = 100;
			
			var button:TextButton = new TextButton(options, 'Listen');
			button.x = 4;
			button.y = 12;
			button.addEventListener(MouseEvent.MOUSE_DOWN, _onConnectLocal);
			
			addChild(button);
			
			button = new TextButton(options, 'Connect Remote');
			button.x = 4;
			button.y = 24;
			button.addEventListener(MouseEvent.MOUSE_DOWN, _onConnectRemote);
			
			addChild(button);
			
			super('HOST', 190, 50, 406, 522);
		}
		
		/**
		 * 	@private
		 */
		private function _onConnectLocal(event:MouseEvent):void {
			_host.connect(null, 0);
		}
		
		/**
		 * 	@private
		 */
		private function _onConnectRemote(event:MouseEvent):void {
		}

	}
}