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
package ui.states {
	
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.*;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.states.*;
	
	import ui.controls.ColorPicker;
	import ui.core.*;
	import ui.window.*;

	/**
	 * 	Load settings
	 */
	public final class SettingsLoadState extends ApplicationState {

		/**
		 * 	Path
		 */
		public static const PATH:String = 'settings/settings.xml';
		
		/**
		 * 
		 */
		public var startupWindowState:String;
		
		/**
		 * 	@constructor
		 */
		public function SettingsLoadState():void {
			super(SettingsLoadState);
		}

		/**
		 * 
		 */
		override public function initialize():void {
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,			_onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR,	_onLoad);
			loader.load(new URLRequest(PATH));
		}
		
		/**
		 * 	@private
		 */
		private function _onLoad(event:Event):void {
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(IOErrorEvent.IO_ERROR,	_onLoad);
			loader.removeEventListener(Event.COMPLETE,			_onLoad);
			
			try {
				var xml:XML = new XML(loader.data);
			} catch (e:Error) {
				return Console.error(e);
			}

			parse(xml);
		}

		/**
		 * 	@private
		 * 	Parses the settings
		 */
		private function parse(xml:XML):void {
			
			var core:XMLList	= xml.core;
			var list:XMLList;
			
			// set default core settings
			if (core.hasOwnProperty('render')) {
				
				list = core.render;
				
				if (list.hasOwnProperty('bitmapData')) {
					BITMAP_WIDTH	= list.bitmapData.width;
					BITMAP_HEIGHT	= list.bitmapData.height;
					BITMAP_RECT		= new Rectangle(0, 0, BITMAP_WIDTH, BITMAP_HEIGHT);
				}
				
				if (list.hasOwnProperty('quality')) {
					STAGE.quality = list.quality;
				}
			}

			// add custom order for blendmodes
			if (core.hasOwnProperty('blendModes')) {
				
				list = core.blendModes;

				// remove all previous blend modes
				while (BLEND_MODES.length) {
					BLEND_MODES.pop();
				}
				
				// make new blend modes
				for each (var mode:XML in list.*) {
					BLEND_MODES.push(String(mode.name()));
				}
				
			}
			
			var uiXML:XMLList	= xml.ui;
			
			if (uiXML.hasOwnProperty('swatch')) {
				list = uiXML.swatch;
				
				try {
					var colors:Array = [];
					for each (var color:uint in list.*) {
						colors.push(color);
					}
					ColorPicker.registerSwatch(colors);
				} catch (e:Error) {
					Console.error(e);
				}
				
			}
			
			// stored keys
			if (uiXML.hasOwnProperty('keys')) {
				
				list = uiXML.keys;
				
				// map keys
				for each (var key:XML in list.*) {
					try {
						KeyListenerState[key.name()] = key;
					} catch (e:Error) {
						Console.error(e);
					}
				}
			}
			
			// macros
			if (uiXML.hasOwnProperty('macro')) {
				
				list = uiXML.macro;
				
				// map keys
				for each (var macro:XML in list.*) {
					try {
						var name:String = macro.name();
						var value:String = macro.toString();
						var plugin:Plugin = Macro.getDefinition(value.toUpperCase());
						
						if (plugin) {
							MacroManager[name.toUpperCase()] = plugin;
						}
						
						// KeyListenerState[key.name()] = key;
					} catch (e:Error) {
						Console.error(e);
					}
				}
			}
			
			// parse states
			if (uiXML.hasOwnProperty('states')) {

				// set the startup window state
				startupWindowState = uiXML.states.@['startup-state'];
				
				list = uiXML.states;
				for each (var stateXML:XML in list.*) {
					var windows:Array		= [];

					for each (var regXML:XML in stateXML.windows.*) {
						
						switch (regXML.name().toString()) {
							case 'window':
								windows.push(new WindowStateReg(String(regXML.toString()), regXML.@x, regXML.@y));
								break;
						}
					}

					WindowState.register(new WindowState(String(stateXML.name), windows));
				}
				
			}
			
			// kill myself
			StateManager.removeState(this);
		}
	}
}