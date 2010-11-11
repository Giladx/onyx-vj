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
package ui.states {
	
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.*;
	
	import onyx.asset.*;
	import onyx.asset.vp.*;

	import onyx.core.*;
	import onyx.plugin.*;
	
	import ui.core.UserInterfaceAPI;

	/**
	 * 
	 */
	public final class FirstRunState extends ApplicationState {
		
		/**
		 * 
		 */
		override public function initialize():void {
			
			// initialize the screens
			initWindow();
			
			checkAppFolders();
		}
		
		/**
		 * 	@private
		 */
		private function initWindow():void {
			
			// grab the stage
			var stage:Stage				= DISPLAY_STAGE;
		
			// no scale please thanks
			// stage.align					= StageAlign..TOP;
			stage.scaleMode 			= StageScaleMode.NO_SCALE;
			
		}
		
		/**
		 *	@private 
		 */
		private function action(event:Event):void {
			
			StateManager.loadState(new QuitState());
				
			StateManager.removeState(this);
		}
		
		/**
		 * 	@private
		 */
		private function checkAppFolders():void {
			Onyx.initializeAdapters(new VPAdapter(), new UserInterfaceAPI());
			StateManager.removeState(this);
		}

	}
}