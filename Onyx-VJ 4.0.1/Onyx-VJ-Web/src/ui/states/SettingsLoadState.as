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
	
	import flash.desktop.*;
	import flash.display.*;
	import flash.errors.IOError;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import ui.controls.*;
	import ui.window.*;

	/**
	 * 
	 */
	public final class SettingsLoadState extends ApplicationState {

		/**
		 * 
		 */
		public static var SETTINGS_XML:XML;
				
		/**
		 * 
		 */
		override public function initialize():void {
			
			Console.output('*  LOADING SETTINGS  *\n');
			
			// load settings
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, settingsHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, settingsHandler);

			// this url is specific to videopong.net
			loader.load(new URLRequest('settings/settings.xml'));
			
			// create the output display
			Display			= new OutputDisplay();
			
		}
		private function settingsHandler(event:Event):void {
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, settingsHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, settingsHandler);
			
			if ( !(event is IOErrorEvent) ) 
			{
				try 
				{
					SETTINGS_XML = new XML(loader.data);
				} 
				catch (e:Error) 
				{
					Console.output( 'settingsHandler: ' + ( e.message ) );
				}
			}
			else
			{
				Console.output( 'settingsHandler, IO Error loading: ' + (event as IOErrorEvent).text );
			}
			// kill the state
			StateManager.removeState(this);
			
		}					

		/**
		 * 	@private
		 */
		private function quitHandler(event:Event):void {

			// start quit cycle
			StateManager.loadState(new QuitState());

		}
		
		/**
		 * 	
		 */
		public function applyCoreSettings():void {
			
			const core:XMLList	= SETTINGS_XML.core;
			var list:XMLList;
			
			// set default core settings
			if (core.hasOwnProperty('render')) {
				
				list = core.render;

				if (list.hasOwnProperty('bitmapData')) {
					Onyx.initialize(DISPLAY_STAGE, list.bitmapData.width, list.bitmapData.height, list.quality || StageQuality.MEDIUM);
				}
				
			}

			// add custom order for blendmodes
			if (core.hasOwnProperty('blendModes')) {
				
				list = core.blendModes;

				// remove all previous blend modes
				while (BlendModes.length) {
					BlendModes.pop();
				}
				
				// make new blend modes
				for each (var mode:XML in list.*) {
					BlendModes.push(String(mode.name()));
				}
				
			}
			
			list = core.cameras;
			if (list.length()) {
				ContentCamera.loadXML(list[0]);
			}
			list = core.videopong;
			if (list.length()) {
				ContentVideoPong.loadXML(list[0]);
			}
		}
	}
}