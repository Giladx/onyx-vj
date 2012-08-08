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
	
	import flash.display.*;
	import flash.events.Event;
	//import flash.filesystem.File;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import ui.window.*;
	
	/**
	 * 
	 */
	public final class SaveMixState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var xml:XML;
		
		/**
		 * 	@private
		 */
		private var data:BitmapData;
		
		/**
		 * 	@private
		 */
		private var dbSave:Boolean;
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			// pause rendering
			Display.pause(true);
			StateManager.pauseStates(ApplicationState.KEYBOARD);
			
			// choose a directory
			/*const file:File = new File(AssetFile.resolvePath(ONYX_LIBRARY_PATH));
			file.browseForSave('Select the name and location of the mix file to save.');
			file.addEventListener(Event.SELECT, action);
			file.addEventListener(Event.CANCEL, action);*/
			
		}
		
		/**
		 * 	@private
		 */
		private function action(event:Event):void {
			/*if (event.type === Event.SELECT) {
				var file:File = event.currentTarget as File;
				
				if (file.type !== '.onx') {
					file = new File(file.nativePath + '.onx');
				}

				// write the file
				const xml:XML = Display.toXML();
				
				// write the text file
				writeTextFile(file, xml);
				
				// remove this
				StateManager.removeState(this);
				
				// refresh the browser
				const window:Browser = WindowRegistration.getWindow('BROWSER') as Browser;
				if (window) {
					window.refresh();
				}
				
			} else {
				StateManager.removeState(this);
			}*/
				StateManager.removeState(this);
		}
		
		/**
		 * 	@private
		 */
		private function onSave(query:AssetQuery, list:Array):void {

			var browser:Browser			= WindowRegistration.getWindow('FILE BROWSER') as Browser;
			if (browser) {
				browser.updateFolders();
			}
			
			StateManager.removeState(this);
			
		}
		
		/**
		 * 
		 */
		override public function terminate():void {
			
			Display.pause(false);
			StateManager.resumeStates(ApplicationState.KEYBOARD);
			
		}
	}
}