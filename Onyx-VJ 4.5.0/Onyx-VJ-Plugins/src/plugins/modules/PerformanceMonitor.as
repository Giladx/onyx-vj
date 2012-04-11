/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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

package plugins.modules { 
	
	import onyx.core.*;
	import onyx.utils.*;
	import onyx.plugin.*;
	
	
	public final class PerformanceMonitor extends Module {
		
		/**
		 * 	@constructor
		 */
		public function PerformanceMonitor():void {
			super(
				new ModuleInterfaceOptions(PerformanceMonitorUI, 152, 68, 360, 346)
			)
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import flash.utils.*;

import onyx.core.*;
import onyx.utils.*;
import onyx.plugin.*;

/**
 * 	The debugger window
 */
final class PerformanceMonitorUI extends Sprite implements IDisposable {
	
	/**
	 * 	@private
	 */
	private var _memory:GraphPlotter	= new GraphPlotter(System.totalMemory / 1024);
	
	/**
	 * 	@private
	 */
	private var _fps:GraphPlotter		= new GraphPlotter(0, 0xFFFFFF, 74);
	
	/**
	 * 	@private
	 */
	private var _last:int				= getTimer();
	
	/**
	 * 	@constructor
	 */
	public function PerformanceMonitorUI():void {
		
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
