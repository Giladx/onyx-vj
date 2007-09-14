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
	
	import flash.display.DisplayObject;
	
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.ControlEvent;
	import onyx.plugin.*;
	
	import ui.controls.*;
	import ui.core.MacroManager;
	
	/**
	 * 	Macro window
	 */
	public final class MacroWindow extends Window implements IControlObject {
		
		/**
		 * 	@private
		 */
		private var _controls:Controls;
		
		/**
		 * 	@constructor
		 */
		public function MacroWindow(reg:WindowRegistration):void {
			
			_controls = new Controls(this,
				new ControlPlugin('f1', 'f1', ControlPlugin.MACROS, true, true, MacroManager.ACTION_1),
				new ControlPlugin('f2', 'f2', ControlPlugin.MACROS, true, true, MacroManager.ACTION_2),
				new ControlPlugin('f3', 'f3', ControlPlugin.MACROS, true, true, MacroManager.ACTION_3),
				new ControlPlugin('f4', 'f4', ControlPlugin.MACROS, true, true, MacroManager.ACTION_4),
				new ControlPlugin('f5', 'f5', ControlPlugin.MACROS, true, true, MacroManager.ACTION_5),
				new ControlPlugin('f6', 'f6', ControlPlugin.MACROS, true, true, MacroManager.ACTION_6),
				new ControlPlugin('f7', 'f7', ControlPlugin.MACROS, true, true, MacroManager.ACTION_7),
				new ControlPlugin('f8', 'f8', ControlPlugin.MACROS, true, true, MacroManager.ACTION_8),
				new ControlPlugin('f9', 'f9', ControlPlugin.MACROS, true, true, MacroManager.ACTION_9),
				new ControlPlugin('f10', 'f10', ControlPlugin.MACROS, true, true, MacroManager.ACTION_10),
				new ControlPlugin('f11', 'f11', ControlPlugin.MACROS, true, true, MacroManager.ACTION_11),
				new ControlPlugin('f12', 'f12', ControlPlugin.MACROS, true, true, MacroManager.ACTION_12)
			);
			
			super(reg, true, 192, 104);
			
			var options:UIOptions	= new UIOptions(true, true, 'left', 72);
			var index:int			= 0;
			
			for each (var control:ControlPlugin in _controls) {
				var sprite:DisplayObject = addChild(new DropDown(options, control));
				sprite.x = ((index / 6) >> 0) * 94 + 20,
				sprite.y = (index % 6) * 15 + 15;
				
				index++;
				control.addEventListener(ControlEvent.CHANGE, _controlChange);
			}
		}
		
		/**
		 * 
		 */
		private function _controlChange(event:ControlEvent):void {
			
			var control:ControlPlugin		= event.currentTarget as ControlPlugin;
			var num:int						= int(control.name.substr(1));
			
			MacroManager['ACTION_' + num]	= event.value;
		}

		/**
		 * 
		 */
		public function get controls():Controls {
			return _controls;
		}
		
	}
}