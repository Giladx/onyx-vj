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
package ui.window {
	
	import flash.desktop.*;
	import flash.events.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.parameter.*;
	
	import ui.controls.*;
	import ui.core.*;
	import ui.states.*;
	import ui.styles.*;
	
	/**
	 * 	Menu Window
	 */
	public final class MenuWindow extends Window implements IParameterObject {
		
		/**
		 * 	@private
		 */
		private var quitButton:TextButton;
		
		/**
		 *	@private
		 */
		private const parameters:Parameters		= new Parameters(this as IParameterObject);
		private const MOBILE_MENU_OPTIONS:UIOptions = new UIOptions(true, false, null, 69, 48);
		
		/**
		 * 	@constructor
		 */
		public function MenuWindow(reg:WindowRegistration):void {

			quitButton			= new TextButton(MOBILE_MENU_OPTIONS, 'QUIT', 0xFFFFFF);
			quitButton.addEventListener(MouseEvent.CLICK, buttonHandler);
			
			// position and create window
			super(reg, false, 0, 0);
			
		}
		
		/**
		 * 
		 */
		public function set state(value:WindowState):void {
			UIObject.select(null);
			WindowState.load(value);
		}
		
		/**
		 * 
		 */
		public function get state():WindowState {
			return WindowState.currentState;
		}
		
		/**
		 * 
		 */
		public function getParameters():Parameters {
			return parameters;
		}
		
		/**
		 * 	Creates all the buttons
		 */
		public function createButtons(x:int, y:int):void {
			
			this.x = x;
			this.y = y;
			
			var index:int = 0;
			var w:int = MENU_OPTIONS.width + 2;

			// loop through registrations
			for each (var reg:WindowRegistration in WindowRegistration.registrations) {
				
				// create control
				var control:MenuButton = new MenuButton(reg, MOBILE_MENU_OPTIONS, 0xFFFFFFF);
				control.x	= Math.floor(index / 2) * w;
				//control.y	= (index++ % 2) * 18;
				control.y	= (index++ % 2) * 50;
				
				// add child
				addChild(control);
				
			}
			
			quitButton.x	= Math.floor(index / 2) * w;
			//quitButton.y	= (index % 2) * 18;
			quitButton.y	= (index % 2) * 50;
			addChild(quitButton);
		}
		
		/**
		 * 
		 */
		private function buttonHandler(event:MouseEvent):void {
			switch (event.currentTarget) {
				case quitButton:
				
					StateManager.loadState(new QuitState());
				
					break;
			}
		}
		
		/**
		 * 	
		 */
		override public function dispose():void {
			quitButton.removeEventListener(MouseEvent.CLICK, buttonHandler);
			super.dispose();
		}
	}
}