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
package ui.window {
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import onyx.constants.ROOT;
	
	/**
	 * 	Window Registration
	 */
	public final class WindowRegistration {
		
		/**
		 * 	All window registrations
		 */
		public static const registrations:Array	= register(
			new WindowRegistration('FILE BROWSER',	Browser,			6, 318),
			new WindowRegistration('CONSOLE',		ConsoleWindow,		6, 561),
			new WindowRegistration('FILTERS',		Filters,			412, 318),
			new WindowRegistration('LAYERS',		LayerWindow,		0, 0),
			new WindowRegistration('MEMORY',		MemoryWindow,		614, 318, false),
			new WindowRegistration('DISPLAY',		DisplayWindow,		659, 580),
			new WindowRegistration('KEY MAPPING',	KeysWindow,			615, 319, false),
			new WindowRegistration('SETTINGS',		SettingsWindow,		200, 561),
			new WindowRegistration('CROSSFADER',	CrossFaderWindow,	411, 561)
		);
		
		/**
		 * 	Returns a window based on name
		 */
		public static function getWindow(name:String):WindowRegistration {
			return definition[name];
		}
		
		/**
		 * 	@private
		 * 	Stores the window registration name indexes
		 */
		private static var definition:Object;
		
		/**
		 * 	@private
		 * 	Registers windows
		 */
		private static function register(... rest:Array):Array {
			
			definition = {};
			
			for each (var reg:WindowRegistration in rest) {
				definition[reg.name] = reg;
			}
			
			return rest;
		}
		
		/**
		 * 	Creates the windows and menu buttons
		 */
		public static function createWindows():void {
			
			for each (var reg:WindowRegistration in registrations) {
				reg.visible = reg.enabled;
			}
			
		}
		
		/**
		 * 	The name of the window to put on the button
		 */
		public var name:String;
		
		/**
		 * 	@private
		 * 	The definition for the window type
		 */
		private var definition:Class;
		
		/**
		 * 	@private
		 * 	The actual window definition
		 */
		private var window:Window;
		
		/**
		 * 	The x location of the window
		 */
		public var x:int;
		
		/**
		 * 	The y location of the window
		 */
		public var y:int;
		
		/**
		 * 	@private
		 */
		public var enabled:Boolean;
		
		/**
		 * 	@constructor
		 */
		public function WindowRegistration(name:String, definition:Class, x:int, y:int, enabled:Boolean = true):void {
			
			this.name			= name,
			this.x				= x,
			this.y				= y,
			this.definition		= definition,
			this.enabled		= enabled;
			
		}
		
		/**
		 * 	Creates windows, etc
		 */
		public function set visible(value:Boolean):void {
			
			// create the window
			if (value && !window) {
				this.window = ROOT.addChild(new definition()) as Window;
				this.window.x = x;
				this.window.y = y;
				
			// remove the window
			} else if (!value && window) {

				window.parent.removeChild(window);
				window.dispose();
				window = null;

			}
		}
		
		/**
		 * 	Gets enabled
		 */
		public function get visible():Boolean {
			return (window !== null);
		}
		
		/**
		 * 	Returns index
		 */
		public function get index():int {
			return registrations.indexOf(this);
		}
	}
}