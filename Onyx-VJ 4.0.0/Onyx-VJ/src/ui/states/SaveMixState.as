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
	import flash.filesystem.File;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.utils.file.*;
	
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
			var file:File = AIR_ROOT.resolvePath(ONYX_LIBRARY_PATH);
			file.browseForSave('Select the name and location of the mix file to save.');
			file.addEventListener(Event.SELECT, action);
			file.addEventListener(Event.CANCEL, action);
			
		}
		
		/**
		 * 	@private
		 */
		private function action(event:Event):void {
			if (event.type === Event.SELECT) {
				var file:File = event.currentTarget as File;
				
				if (file.type !== '.onx') {
					file = new File(file.nativePath + '.onx');
				}

				/// SC 
				// write the file
				var xml:XML = Display.toXML();
				
				// TODO: save all windows MIDI!
				for each(var registration:WindowRegistration in WindowRegistration.registrations) {
					if(	registration.name=='SETTINGS') {
						var win:Window = WindowRegistration.getWindow(registration.name);
						Console.output(win.toXML());
					}
				}
				
				writeTextFile(file, xml);
							
				//
				var cache:AIRDirectoryQuery = AIRAdapter.getDirectoryCache(getRelativePath(AIR_ROOT, file.parent));
				if (cache) {
					var db:AIRThumbnailDB = cache.db;
					
					// add the mix, and save
					if (db) {
						db.addFile(getRelativePath(AIR_ROOT, file), Display.source)
						writeBinaryFile(AIR_ROOT.resolvePath(cache.path + '/.ONXThumbnails'), db.bytes);
					}
				}
				OnyxFile.queryDirectory(getRelativePath(AIR_ROOT, file.parent), onSave, true);
			} else {
				StateManager.removeState(this);
			}
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