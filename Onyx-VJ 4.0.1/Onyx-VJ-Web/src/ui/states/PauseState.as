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
package ui.states {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import ui.window.*;
	
	/**
	 * 
	 */
	public final class PauseState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var startTime:int;
		
		/**
		 * 
		 */
		override public function initialize():void {
			startTime = getTimer();
			
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME,		pauseHandler);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_DOWN,	pauseHandler);
		}
		
		/**
		 * 	@private
		 */
		private function pauseHandler(event:Event):void {
			if (event.type === MouseEvent.MOUSE_DOWN || getTimer() - startTime > DEBUG::SPLASHTIME) {
				
				DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, pauseHandler);
				DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, pauseHandler);
	
				// register the default state
				WindowState.load(
					WindowState.getState('DEFAULT')
				);
				
				// create the bottom buttons
				var window:MenuWindow = new MenuWindow(null);
				window.createButtons(775, 732);
				
				// load menu bar
				DISPLAY_STAGE.addChild(window);
				
				// we're initialized
				INITIALIZED = true;
				
				// create layers
				(Display as OutputDisplay).createLayers(3);
				
				// remove this
				StateManager.removeState(this);
			}
		}
	}
}