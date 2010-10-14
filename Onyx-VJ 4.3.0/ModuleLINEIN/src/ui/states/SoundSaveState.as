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
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.utils.*;
	
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;

	
	/**
	 * 
	 */
	public final class SoundSaveState extends ApplicationState {
		
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
		private static var nowDate:String;
		
		override public function initialize():void {
						
			// remove midi learn state, if there
			if(!StateManager.getStates('SoundLearnState')) {
				StateManager.removeState(StateManager.getStates('SoundLearnState')[0]);
			}
			
			// pause rendering
			StateManager.pauseStates(ApplicationState.KEYBOARD);
			
			// choose a directory
			const file:File = new File(AssetFile.resolvePath(ONYX_LIBRARY_PATH));
			file.browseForSave('Select the name and location of the mix file to save.');
			//file.addEventListener(Event.SELECT, action);
			//file.addEventListener(Event.CANCEL, action);
			
		}
			
		/*private function action(event:Event):void {
			if (event.type === Event.SELECT) {
				var file:File = event.currentTarget as File;
				
				if (file.type !== '.mid') {
					file = new File(file.nativePath + '.mid');
				}
				
				var xml:XML = <midi/>;
				
				var meta:XML = <metadata />
				meta.appendChild(<version>{VERSION}</version>);
				xml.appendChild(meta);
								
				xml.appendChild(Midi.toXML());
							
				writeTextFile(file, xml);
				
			}
			
			StateManager.removeState(this);
			
		}
		
		private function onSave(query:AssetQuery, list:Array):void {

			//var browser:Browser = WindowRegistration.getWindow('FILE BROWSER') as Browser;
			//if (browser) {
			//	browser.updateFolders();
			//}
			StateManager.removeState(this);
			
		}
				
		override public function terminate():void {
			StateManager.resumeStates(ApplicationState.KEYBOARD);
		}*/
		
	}
}