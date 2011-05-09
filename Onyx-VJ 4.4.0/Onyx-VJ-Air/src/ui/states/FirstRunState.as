/**
 * Copyright (c) 2003-2011 "Onyx-VJ Team" which is comprised of:
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
	import flash.system.*;
	
	import onyx.asset.*;
	import onyx.asset.air.*;
	import onyx.asset.vp.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.utils.file.*;
	
	import ui.core.UserInterfaceAPI;

	/**
	 * 
	 */
	public final class FirstRunState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		public static const INIT_FILE:File = new File('app-storage:/folder.ini'); 
		
		/**
		 * 
		 */
		override public function initialize():void {
			
			// initialize the screens
			initWindow();
			
			// check if file exists
			if (INIT_FILE.exists) {
				var path:String = readTextFile(INIT_FILE);
				var file:File	= new File(path);
				checkAppFolders(file);
			} else {
				return openSaveDialog();
			}

		}
		
		/**
		 * 	@private
		 */
		private function openSaveDialog():void {
			
			var file:File = File.documentsDirectory;
			file.addEventListener(Event.SELECT, action);
			file.addEventListener(Event.CANCEL, action);
			
			Console.output('*  CHOOSE YOUR USER FOLDER  *\nTHIS IS WHERE VIDEO LIBRARY WILL BE STORED\n');

			file.browseForDirectory(
				'Select a location to create the Onyx-VJ Library folder.'
			); 
		}
		
		/**
		 * 	@private
		 */
		private function initWindow():void {
			
			// grab the stage
			var stage:Stage				= DISPLAY_STAGE;
		
			// stage.align					= StageAlign..TOP;
			// no scale please thanks
			stage.scaleMode 			= StageScaleMode.NO_SCALE;
			stage.nativeWindow.bounds	= (Screen.screens[0] as Screen).bounds;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			// slam the input monitor to 0,0
			var window:NativeWindow		= stage.nativeWindow;
			window.x					= 0;
			window.y					= 0;
			//base these values on Onyx-AIR-Main Main.as: [SWF(width="1400", height="850",
			window.width				= 1284; 
			window.height				= 830;
							
			// activate the window
			DISPLAY_STAGE.nativeWindow.activate();
			
		}
		
		/**
		 *	@private 
		 */
		private function action(event:Event):void {
			
			var file:File = event.currentTarget as File;
			file.removeEventListener(Event.SELECT, action);
			file.removeEventListener(Event.CANCEL, action);

			// it was cancelled, quit
			if (event.type === Event.CANCEL) {
				
				StateManager.loadState(new QuitState());
				
			} else {
				
				// move all the non-app items into selected folder
				checkAppFolders((file.name == 'Onyx-VJ' && file.isDirectory) ? file : file.resolvePath('Onyx-VJ/'));

			}		
		}
		
		/**
		 * 	@private
		 */
		private function checkAppFolders(folder:File):void {
			
			var dispatched:Boolean = false;
			// folder already exists, don't do anything, just write out the location
			if (!folder.exists) {
				
				Console.output('Creating: ', folder.name);
				
				// create the directory
				folder.createDirectory();
				
			}
			
			// initialize all the adapters
			Onyx.initializeAdapters(new VPAdapter(folder.nativePath), new UserInterfaceAPI());
			Onyx.initializeAdapters(new AIRAdapter(folder.nativePath), new UserInterfaceAPI());
			
			// need to verify all the files exist
			var appDirectory:File	= new File('app:/root/');
			if ( !appDirectory.exists )
			{
				Console.output( "FirstRunState, Error does not exist: " + appDirectory.nativePath );
			}
			else
			{
				Console.output( "FirstRunState, app:/root/ exist: " + appDirectory.nativePath );
				var copyFiles:Array		= getDirectoryTree(appDirectory, filter);
				
				// loop and copy folders
				for each (var file:File in copyFiles) 
				{
					try
					{
						var path:String		= getRelativePath(appDirectory, file);
						var dest:File		= folder.resolvePath(path);
						
						// check for disabled file
						var disIndex:int	= path.lastIndexOf(dest.type);
						if (disIndex >= 0) {
							var disFile:File	= folder.resolvePath(path.substr(0, disIndex) + '-disabled' + dest.type);
							if (disFile.exists) {
								continue;
							}
						}
						
						// check for new file
						if (!dest.exists || dest.modificationDate < file.modificationDate) {
							
							// output only one
							if (!dispatched) {
								Console.output('*  COPYING DEFAULT FILES  *\n');
								dispatched = true;
							}
							
							Console.output('FirstRunState, Copying: ', path);
							file.copyTo(dest, true);
						}
					}
					catch ( e:Error )
					{	
						Console.output( 'Error checkAppFolders file operations: ' + e.message );
					}

				}
				// now create the ini file
				writeTextFile(INIT_FILE, folder.nativePath);
				
			}			
		
			// kill the state
			StateManager.removeState(this);
		}
		
		/**
		 * 	@private
		 */
		private function filter(file:File):Boolean {
			return (file.nativePath.indexOf('.svn') === -1);
		}
	}
}