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
	import flash.events.*;
	//import flash.filesystem.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import onyx.asset.*;
	import onyx.asset.air.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.utils.file.*;
	
	import ui.assets.StartupDisplay;
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
			
			/*try {
				var file:File		= new File(AssetFile.resolvePath('settings/settings.xml'));
				
				// load settings file
				if (!file.exists) {
					file = new File(AssetFile.resolvePath('settings/default.xml'));
					if (!file.exists) {
						throw new Error('Settings file doesn\'t exist');
					}
				}
				
				// read settings file
				SETTINGS_XML		= new XML(readTextFile(file));

				// create display width/height
				applyCoreSettings();
				
			} catch (e:Error) {

				Console.output('ERROR LOADING SETTINGS FILE:\n', e.message);

			}*/
			// load settings
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, settingsHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, settingsHandler);
			loader.load(new URLRequest('settings/settings.xml'));
			
			// create the output display
			Display			= new OutputDisplay();
			
			// store screens
			//const screens:Array			= Screen.screens;

			// if we have more than one screen present
			//if (screens.length > 1) {

				// create a new window to put the output window
				/*const options:NativeWindowInitOptions = new NativeWindowInitOptions();
				options.systemChrome	= NativeWindowSystemChrome.NONE;
				options.transparent		= false;
				options.type			= NativeWindowType.LIGHTWEIGHT;*/
				
				// create the window
				/*const displayWindow:NativeWindow	= new NativeWindow(options);
				displayWindow.width				= DISPLAY_WIDTH;
				displayWindow.height			= DISPLAY_HEIGHT;
				displayWindow.alwaysInFront		= true;*/
				
				// no scale please thanks
				/*const stage:Stage				= displayWindow.stage;
				stage.align						= StageAlign.TOP_LEFT;
				stage.scaleMode 				= StageScaleMode.NO_SCALE;
				DISPLAY_STAGE.quality 			= stage.quality	= StageQuality.MEDIUM;*/
				
				// we need to put the new window onto the new screen
				//const screen:Screen		= screens[1];
				//displayWindow.bounds	= screen.bounds;
				
				// listen for a close
				//displayWindow.addEventListener(Event.CLOSING, quitHandler, false, 0, true);

				// add the display to our new window
				//stage.addChild(Display as DisplayObject);

				// add the right display object
				/*const dsp:StartupDisplay	= new StartupDisplay();
				stage.addChild(dsp);
				
				dsp.width					= DISPLAY_WIDTH;
				dsp.height					= DISPLAY_HEIGHT;*/
				
				// turn on hardware accelleration for the output window
				//stage.fullScreenSourceRect	= new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
				//stage.displayState			= StageDisplayState.FULL_SCREEN_INTERACTIVE;
				
				//displayWindow.activate();
			//}

			// kill the state
			//StateManager.removeState(this);
		}
		private function settingsHandler(event:Event):void {
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, settingsHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, settingsHandler);
			
			if (!(event is ErrorEvent)) {
				try {
					SETTINGS_XML = new XML(loader.data);
				} catch (e:Error) {
					trace(e.message);
				}
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