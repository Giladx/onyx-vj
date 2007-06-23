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
package onyx.core {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.file.*;
	import onyx.midi.*;
	import onyx.plugin.*;
	import onyx.states.*;
	import onyx.utils.GCTester;
	
	use namespace onyx_ns;
	
	/**
	 * 	Core Application class that stores all layers, displays, and loaded plugins
	 */
	public final class Onyx extends EventDispatcher {
		
		/**
		 * 	@private
		 * 	Dispatcher
		 */
		onyx_ns static const instance:Onyx = new Onyx();
		
		/**
		 * 	
		 */
		public static function getInstance():EventDispatcher {
			return instance;
		}
		
		/**
		 * 	Initializes the Onyx engine
		 */
		public static function initialize(root:DisplayObjectContainer, adapter:FileAdapter = null):void {
			
			// store the flash root / stage objects
			ROOT	= root;
			STAGE	= root.stage;
			
			// initialize adapter
			FileBrowser.initialize(adapter);
		}
		
		/**
		 * 
		 */
		public static function loadPlugins():EventDispatcher {
	
			// create a timer so that objects can listen for events
			var timer:Timer = new Timer(0);
			timer.addEventListener(TimerEvent.TIMER, _onInitialize);
			timer.start();

			// return dispatcher
			return instance;
		}
		
		/**
		 * 	@private
		 * 	When initialized
		 */
		private static function _onInitialize(event:TimerEvent):void {
			
			var timer:Timer = event.currentTarget as Timer;
			timer.removeEventListener(TimerEvent.TIMER, _onInitialize);
			timer.stop();

			// start initialization
			StateManager.loadState(new InitializationState());
			
		}
		
		/**
		 * 	Registers plug-ins
		 */
		public static function registerPlugin(registration:Object):void {
			
			// check if the passed in object is a midi master or a plugin
			if (registration is Plugin) {
				
				var plugin:Plugin = registration as Plugin;
				
				if (plugin._definition) {
					
					// make sure it's uppercase
					plugin.name = plugin.name.toUpperCase();
	
					var object:IDisposable = plugin.getDefinition() as IDisposable;
					
					// test the type of object
					if (object is Filter) {
						
						Filter.registerPlugin(plugin);
						plugin.registerData('bitmap', object is IBitmapFilter);
						
					// register transition
					} else if (object is Transition) {
						
						Transition.registerPlugin(plugin);
	
					// register visualizer
					} else if (object is Visualizer) {
						
						Visualizer.registerPlugin(plugin);
						
					} else if (object is Macro) {
						
						Macro.registerPlugin(plugin);
						
					} else if (object is Renderer) {
						
						Renderer.registerPlugin(plugin);
						
					}
					
					// output a message
					Console.output('REGISTERING ' + plugin.name);
				}
			}
			/*
			 else if (registration is IMidiDispatcher) {
				Midi.registerMidiMaster(registration as IMidiDispatcher);
			}
			*/
		}

		/**
		 * 	Creates a display
		 * 	@param		The number of layers to create in the display
		 * 	@returns	Display
		 */
		public static function createDisplay(x:int = 0, y:int = 0, scaleX:Number = 1, scaleY:Number = 1):Display {
			
			var display:Display = new Display();
			display.displayX = x;
			display.displayY = y;
			display.scaleX = scaleX;
			display.scaleY = scaleY;
			
			ROOT.addChild(display);
			
			return display;
		}
		
		/**
		 * 
		 */
		override public function toString():String {
			return '[Display]';
		}
	}
}