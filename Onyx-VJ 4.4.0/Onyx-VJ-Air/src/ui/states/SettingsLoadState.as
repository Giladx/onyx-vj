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
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.system.Capabilities;
	import flash.utils.*;
	
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
			
			try {
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

			}

			// create the output display
			Display			= new OutputDisplay();
			
			// store screens
			const screens:Array			= Screen.screens;
			const singleScreen:Boolean	= (screens.length === 1);

			// if we have more than one screen present, we create a fullscreen output window
			// else we create a moveable window
			
			// create a new window to put the output window
			const options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.systemChrome	= singleScreen ? NativeWindowSystemChrome.ALTERNATE : NativeWindowSystemChrome.NONE;
			options.transparent		= false;
			options.type			= singleScreen ? NativeWindowType.UTILITY : NativeWindowType.LIGHTWEIGHT;
			
			// create the window
			const displayWindow:NativeWindow	= new NativeWindow(options);
			displayWindow.width				= DISPLAY_WIDTH;
			displayWindow.height			= DISPLAY_HEIGHT;
			displayWindow.alwaysInFront		= true;
			
			// no scale please thanks
			const stage:Stage				= displayWindow.stage;
			stage.align						= StageAlign.TOP_LEFT;
			stage.scaleMode 				= StageScaleMode.NO_SCALE;
			DISPLAY_STAGE.quality 			= stage.quality	= StageQuality.MEDIUM;
			
			// we need to put the new window onto the new screen
			if (singleScreen)
			{
				//displayWindow.bounds = new Rectangle( 100, 100, Capabilities.screenResolutionX - 200, Capabilities.screenResolutionY - 200 );
			}
			else
			{
				const screen:Screen			= screens[1];	
				displayWindow.bounds		= screen.bounds;
			}
			

			// listen for a close
			displayWindow.addEventListener(Event.CLOSING, quitHandler, false, 0, true);

			// add the display to our new window
			stage.addChild(Display as DisplayObject);

			// add the right display object
			// BL removed it!
			//const dsp:StartupDisplay	= new StartupDisplay();
			//stage.addChild(dsp);
			
			//dsp.width					= DISPLAY_WIDTH;
			//dsp.height					= DISPLAY_HEIGHT;
			
			// turn on hardware accelleration for the output window
			stage.fullScreenSourceRect	= new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			stage.displayState			= singleScreen ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN_INTERACTIVE;

			displayWindow.activate();

			
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
				
				var targetWidth:int 	= 320;
				var ratio:int 			= 1;
				var newWidth:int		= 320;
				var newHeight:int		= 240;
				if (list.hasOwnProperty('bitmapData'))
				{
					targetWidth = list.bitmapData.width;
					newWidth	= targetWidth;
					newHeight	= list.bitmapData.height;
				}
				//BL adapt bounds to real screen size
				const screens:Array			= Screen.screens;
				const singleScreen:Boolean	= (screens.length === 1);
				if ( !singleScreen )
				{
					const screen:Screen		= screens[1];
					if (targetWidth > screen.bounds.width) targetWidth = screen.bounds.width;
					ratio 					= screen.bounds.width / targetWidth;
					newWidth				= screen.bounds.width / ratio;
					newHeight				= screen.bounds.height / ratio;
					if (newHeight > screen.bounds.height) newHeight = screen.bounds.height;
					
					Onyx.initialize(DISPLAY_STAGE, newWidth, newHeight, list.quality || StageQuality.MEDIUM);
					
				}
				else
				{
					// only one screen
					if (list.hasOwnProperty('bitmapData'))
					{
						Onyx.initialize(DISPLAY_STAGE, newWidth, newHeight , list.quality || StageQuality.MEDIUM);
					}
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