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
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.*;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.midi.Midi;
	import onyx.plugin.*;
	import onyx.states.*;
	import onyx.utils.string.parseBoolean;
	
	import ui.controls.ColorPicker;
	import ui.window.WindowRegistration;

	/**
	 * 	Load settings
	 */
	public final class SettingsLoadState extends ApplicationState {

		/**
		 * 	Path
		 */
		public static const PATH:String = 'settings/settings.xml';

		/**
		 * 	@constructor
		 */
		public function SettingsLoadState():void {
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
			
			// see if MIDI should be listening by default
			// if (core.hasOwnProperty('midi')) {
			// 	MIDI.listen = parseBoolean(core.midi.enabled);
			// }

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
			
			// re-order the filters based on settings
			if (xml.hasOwnProperty('filters')) {
				
				list = xml.filters.order.filter;
				
				for each (var filter:XML in list.*) {
					var plugin:Plugin = Filter.getDefinition(filter.@name);
					
					// make sure the plugin exists
					if (plugin) {
						plugin.index = filter.@index;
					}
				}
				
			}
			
			if (xml.hasOwnProperty('swatch')) {
				list = xml.swatch;
				
				try {
					for each (var color:uint in list.*) {
						ColorPicker.registerSwatch(color);
					}
				} catch (e:Error) {
					trace(1, e);
				}
				
			}
			
			// stored keys
			if (xml.hasOwnProperty('keys')) {
				
				list = xml.keys;
				
				// map keys
				for each (var key:XML in list.*) {
					try {
						KeyListenerState[key.name()] = key;
					} catch (e:Error) {
						Console.error(e.message);
					}
				}
			}
			
			// set window locations / enabled
			if (xml.hasOwnProperty('windows')) {
				
				list = xml.windows;
				
				for each (var windowXML:XML in list.*) {
					var reg:WindowRegistration = WindowRegistration.getWindow(windowXML.@name);
					if (reg) {
						reg.x		= windowXML.@x;
						reg.y		= windowXML.@y;
						reg.enabled = parseBoolean(windowXML.@enabled);
					}
				}
				
			}

			var macro:Plugin = Macro.macros[0] as Plugin;
			if (macro) {
				
				// map macros
				// KeyListenerState.ACTION_MACRO_1 = macro.getDefinition() as Macro;
			
			}
			
			// kill myself
			StateManager.removeState(this);
		}
	}
}