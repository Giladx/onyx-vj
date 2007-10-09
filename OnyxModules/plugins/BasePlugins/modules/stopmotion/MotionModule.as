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
package modules.stopmotion {
	
	import onyx.plugin.Module;
	import onyx.core.InterfaceOptions;

	public final class MotionModule extends Module {
		
		/**
		 * 	@constructor
		 */
		public function MotionModule():void {
			super(
				new InterfaceOptions(MotionModuleUI, 300, 300)
			)
		}
		
		/**
		 * 	Turn on the module
		 */		
		override public function initialize():void {
			
		}
	}
}

import flash.display.*;
import onyx.core.*;
import onyx.controls.*;
import onyx.display.Display;
import onyx.constants.*;

final class MotionModuleUI extends Sprite implements IDisposable, IControlObject {
	
	/**
	 * 	@private
	 */
	private var bitmap:Bitmap;
	
	/**
	 * 	@private
	 */
	private var display:Display;
	
	/**
	 * 
	 */
	private var _controls:Controls;
	
	/**
	 * 	@constructor
	 */
	public function MotionModuleUI():void {
		
		_controls = new Controls(this,
			new ControlExecute('capture', 'capture')
		);
		
		display	= AVAILABLE_DISPLAYS[0];
		bitmap = new Bitmap(display.source);
		
		bitmap.width	= 160,
		bitmap.height	= 120,
		bitmap.x		= 1;
		
		addChild(bitmap);
	}
	
	/**
	 * 
	 */
	public function capture():void {
		Console.output('motion captured');
	}
	
	/**
	 * 
	 */
	public function get controls():Controls {
		return _controls;
	}
	
	/**
	 * 	Dispose the UI
	 */
	public function dispose():void {
		
		display = null,
		bitmap	= null;
		
	}
}