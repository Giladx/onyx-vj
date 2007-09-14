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
	
	import onyx.constants.ROOT;
	
	/**
	 * 	Window Registration
	 */
	public final class WindowRegistration {
		
		{	register(
				new WindowRegistration('FILE BROWSER',	Browser),
				new WindowRegistration('CONSOLE',		ConsoleWindow),
				new WindowRegistration('FILTERS',		Filters),
				new WindowRegistration('LAYERS',		LayerWindow),
				new WindowRegistration('DISPLAY',		DisplayWindow),
				new WindowRegistration('KEY MAPPING',	KeysWindow),
				new WindowRegistration('SETTINGS',		SettingsWindow),
				new WindowRegistration('CROSSFADER',	CrossFaderWindow),
				new WindowRegistration('MACROS',		MacroWindow)
			);
		}
		
		/**
		 * 	All window registrations
		 */
		public static const registrations:Array	= [];
		
		/**
		 * 	@private
		 * 	Stores the window registration name indexes
		 */
		private static const definition:Object	= {};
		
		/**
		 * 	Returns a window based on name
		 */
		public static function getWindow(name:String):WindowRegistration {
			return definition[name];
		}
		
		/**
		 * 	@private
		 * 	Registers windows
		 */
		public static function register(... rest:Array):void {
			
			for each (var reg:WindowRegistration in rest) {
				definition[reg.name] = reg;
				registrations.push(reg);
			}
			
		}
		
		/**
		 * 
		 */
		public static function initialize(state:WindowState):void {
			
			for each (var reg:WindowStateReg in state.windows) {

				var def:WindowRegistration = definition[reg.name];
				
				// create the window only if the registration exists
				if (def) {
					def.x		= reg.x,
					def.y		= reg.y,
					def.enabled = reg.enabled;
				}
			}
		}
		
		/**
		 * 	The name of the window to put on the button
		 */
		public var name:String;
		
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
		 * 	The definition for the window type
		 */
		internal var definition:Class;
		
		/**
		 * 	@private
		 * 	The actual window definition
		 */
		internal var window:Window;
		
		/**
		 * 	@constructor
		 */
		public function WindowRegistration(name:String, definition:Class):void {
			
			this.name			= name,
			this.definition		= definition;
			
		}
		
		/**
		 * 	Whether the window has been created or not
		 */
		public function get enabled():Boolean {
			return (window !== null);
		}
		
		/**
		 * 	Sets whether the window is visible or not
		 */
		public function set enabled(value:Boolean):void {
		
			// create the window
			if (value && !window) {
				
				window = ROOT.addChild(new definition(this)) as Window;
				window.x = x;
				window.y = y;
				
			// remove the window
			} else if (!value && window) {

				window.parent.removeChild(window);
				window.dispose();
				window = null;

			}
		}
		
		/**
		 * 	Returns index
		 */
		public function get index():int {
			return registrations.indexOf(this);
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return '[WindowRegistration: ' + name + ']';
		}
	}
}