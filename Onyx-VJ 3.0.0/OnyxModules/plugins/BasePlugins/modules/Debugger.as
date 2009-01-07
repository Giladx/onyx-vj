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
package modules {
	
	import onyx.core.InterfaceOptions;
	import onyx.plugin.Module;

	/**
	 * 	Debugger Module
	 */
	public final class Debugger extends Module {
		
		/**
		 * 	@constructor
		 */
		public function Debugger():void {
			super(
				new InterfaceOptions(DebuggerUI, 200, 200, 614, 318)
			)
		}
		
		/**
		 * 
		 */
		override public function command(... args:Array):String {
			return 'ASDF';
		}
	}
}

import flash.display.Sprite;
import onyx.core.IDisposable;
import flash.events.Event;
import onyx.utils.GraphPlotter;
import flash.system.System;
import flash.utils.*;

/**
 * 	The debugger window
 */
final class DebuggerUI extends Sprite implements IDisposable {

	/**
	 * 	@private
	 */
	private var _memory:GraphPlotter	= new GraphPlotter(System.totalMemory / 1024);
	
	/**
	 * 	@private
	 */
	private var _fps:GraphPlotter		= new GraphPlotter(0, 0xFFFFFF, 50);
	
	/**
	 * 	@private
	 */
	private var _last:int				= getTimer();
	
	/**
	 * 	@constructor
	 */
	public function DebuggerUI():void {
		
		addChild(_fps);
		addChild(_memory);
		
		// start listening
		addEventListener(Event.ENTER_FRAME, _onFrame);
	}
	
	/**
	 * 	@private
	 */
	private function _onFrame(event:Event):void {
		_fps.register((1000 / (getTimer() - _last)));

		_memory.register(System.totalMemory / 1024);
		_last = getTimer();
	}
	
	/**
	 * 	Dispose
	 */
	public function dispose():void {
		
		removeEventListener(Event.ENTER_FRAME, _onFrame);

		_memory = null,
		_fps	= null;
	}
}