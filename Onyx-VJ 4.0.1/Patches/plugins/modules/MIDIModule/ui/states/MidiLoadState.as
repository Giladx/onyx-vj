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
	
	import flash.filesystem.*;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.*;
	import flash.geom.*;
		
	import midi.Midi;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.utils.file.*;
	import onyx.utils.string.*;
	
	import ui.states.*;	
	import ui.window.*;
	import ui.controls.*;
	import ui.styles.*;
	
	/**
	 * 
	 */
	public final class MidiLoadState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var data:BitmapData;
		
		/**
		 * 	@private
		 */
		private var dbSave:Boolean;
		
		/**
		 * 
		 */
		public static var MIDI_XML:XML;
		
		
		/**
		 * 	@constructor
		 */
		public function MidiLoadState():void {
			
			super('MidiLoadState');
								
		}
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			if(!Midi.controlsSet) {
				Midi.controlsSet = new Dictionary(true);	
			}
			
			// pause rendering
			//StateManager.pauseStates(ApplicationState.DISPLAY_RENDER);
			StateManager.pauseStates(ApplicationState.KEYBOARD);
			
			// choose a directory
			var file:File = AIR_ROOT.resolvePath(ONYX_LIBRARY_PATH);
			file.browseForOpen('Select the name and location of the MIDI file to load.');
			file.addEventListener(Event.SELECT, action);
			file.addEventListener(Event.CANCEL, action);
			
		}
				
		/**
		 * 	@private
		 */
		private function action(event:Event):void {
			
			if (event.type === Event.SELECT) {
				var file:File = event.currentTarget as File;

				// read the file
				MIDI_XML = new XML(readTextFile(file));
				var windows:XMLList = MIDI_XML.windows;
				
				for each(var registration:WindowRegistration in WindowRegistration.registrations) {
					if(	registration.name!='KEY MAPPING' && registration.name!='PERFORMANCE' ) {
					    var win:Window = WindowRegistration.getWindow(registration.name);
					    var name:String = registration.name.replace('_',' ');
						//win.loadXML(Midi,windows[name]);
					}
				}
				
				// highlights
				for (var i:Object in UIControl.parameters) {
					var control:UIControl = i as UIControl;
					if(control.getParameter().getMetaData(Midi.tag)) {
						Midi.controlsSet[control] = MIDI_HIGHLIGHT_SET;
					}
				}
						
			}
			
			StateManager.removeState(this);
		}
				
		/**
		 * 
		 */
		override public function terminate():void {
			
			//StateManager.resumeStates(ApplicationState.DISPLAY_RENDER);
			StateManager.resumeStates(ApplicationState.KEYBOARD);
			
		}
	}
}
