/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.ui.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.file.*;
	import onyx.file.http.*;
	import onyx.system.*;
	import onyx.utils.array.*;
	
	import ui.assets.*;
	import ui.core.*;
	import ui.macros.*;
	import ui.states.*;
	import ui.window.*;
	
	[SWF(width="1024", height="740", backgroundColor="#141515", frameRate='24')]
	public class OnyxUI extends Sprite {
		
		/**
		 * 	@constructor
		 */
		public function OnyxUI():void {
			
			// load settings
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, settingsHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, settingsHandler);
			loader.load(new URLRequest('settings/settings.xml'));

		}
		
		private function settingsHandler(event:Event):void {
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, settingsHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, settingsHandler);
			
			if (!(event is ErrorEvent)) {
				try {
					Settings.xml = new XML(loader.data);
				} catch (e:Error) {
				}
			}
			
			var stage:Stage = this.stage;
			
			// no scale please thanks
			stage.align		= StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality	= StageQuality.MEDIUM;
			
			// store default icons
			File.CAMERA_ICON		= new AssetCamera();
			File.VISUALIZER_ICON	= new AssetVisualizer();
			
			var rootpath:String = this.loaderInfo.url;
			rootpath			= rootpath.substr(0, rootpath.lastIndexOf('/'));
			
			// init
			var manager:UIManager = new UIManager();
			manager.initialize(
				rootpath,
				stage,
				stage,
				new HTTPAdapter(),
				new SystemAdapter(),
				'plugins/'
			);
			
			// change width
			DISPLAY.displayX	= stage.stageWidth - 640;
			DISPLAY.scaleX		= 2;
			DISPLAY.scaleY		= 2;

			// test stage width
			if (stage.stageWidth <= 1024) {
				DISPLAY.visible		= false;
			}
			
			// hide items
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			contextMenu	= menu;
		}		
	}
}