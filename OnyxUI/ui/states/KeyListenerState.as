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
	
	import flash.events.KeyboardEvent;
	import flash.utils.*;
	
	import onyx.constants.ROOT;
	import onyx.plugin.*;
	import onyx.states.ApplicationState;
	
	import ui.core.*;
	import ui.layer.UILayer;
	import flash.events.Event;
	import onyx.core.Plugin;
	
	// TBD, this should be a hash map to the key codes
	// - Keys should have down and up states
	// All key definitions should be mapped to macros (how do we deal with ui macros?)

	/**
	 * 	Listens for keyboard events
	 */
	public final class KeyListenerState extends ApplicationState {
		
		/**
		 * 	Stores all the key definitions
		 */
		public const definitions:Array		= [
			new KeyDefinition('SELECT_FILTER_UP', 'Select the previous filter in the current layer'),
			new KeyDefinition('SELECT_FILTER_DOWN', 'Select the next filter in the current layer'),
			new KeyDefinition('SELECT_LAYER_PREV', 'Select the previous layer'),
			new KeyDefinition('SELECT_LAYER_NEXT', 'Select the next layer'),
			new KeyDefinition('SELECT_PAGE_0', 'Select the basic controls page of all layers'),
			new KeyDefinition('SELECT_PAGE_1', 'Select the filters control page of all layers'),
			new KeyDefinition('SELECT_PAGE_2', 'Select the custom filters control page of all layers'),
			new KeyDefinition('SELECT_LAYER_0', 'Select layer 0'),
			new KeyDefinition('SELECT_LAYER_1', 'Select layer 1'),
			new KeyDefinition('SELECT_LAYER_2', 'Select layer 2'),
			new KeyDefinition('SELECT_LAYER_3', 'Select layer 3'),
			new KeyDefinition('SELECT_LAYER_4', 'Select layer 4'),
			new KeyDefinition('MACRO_1', 'Executes Macro 1'),
			new KeyDefinition('MACRO_2', 'Executes Macro 2'),
			new KeyDefinition('MACRO_3', 'Executes Macro 3'),
			new KeyDefinition('MACRO_4', 'Executes Macro 4'),
			new KeyDefinition('MACRO_5', 'Executes Macro 5'),
			new KeyDefinition('MACRO_6', 'Executes Macro 6'),
			new KeyDefinition('MACRO_7', 'Executes Macro 7'),
			new KeyDefinition('MACRO_8', 'Executes Macro 8'),
			new KeyDefinition('MACRO_9', 'Executes Macro 9'),
			new KeyDefinition('MACRO_10', 'Executes Macro 10'),
			new KeyDefinition('MACRO_11', 'Executes Macro 11'),
			new KeyDefinition('MACRO_12', 'Executes Macro 12')
		]
		
		public var SELECT_FILTER_UP:int		= 38;
		public var SELECT_FILTER_DOWN:int	= 40;
		
		public var SELECT_LAYER_PREV:int		= 37;
		public var SELECT_LAYER_NEXT:int		= 39;
		public var SELECT_PAGE_0:int			= 81;
		public var SELECT_PAGE_1:int			= 87;
		public var SELECT_PAGE_2:int			= 69;
		public var SELECT_LAYER_0:int			= 49;
		public var SELECT_LAYER_1:int			= 50;
		public var SELECT_LAYER_2:int			= 51;
		public var SELECT_LAYER_3:int			= 52;
		public var SELECT_LAYER_4:int			= 53;
		
		public var MACRO_1:int					= 112;
		public var MACRO_2:int					= 113;
		public var MACRO_3:int					= 114;
		public var MACRO_4:int					= 115;
		public var MACRO_5:int					= 116;
		public var MACRO_6:int					= 117;
		public var MACRO_7:int					= 118;
		public var MACRO_8:int					= 119;
		public var MACRO_9:int					= 120;
		public var MACRO_10:int					= 121;
		public var MACRO_11:int					= 122;
		public var MACRO_12:int					= 123;
		
		/**
		 * 
		 */
		private const keyUpHash:Object			= {};

		/**
		 * 
		 */
		public function KeyListenerState():void {
			super(KeyListenerState);
		}
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			// listen for keys
			ROOT.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);
			
		}
		
		/**
		 * 
		 */
		override public function pause():void {

			// remove listener
			ROOT.removeEventListener(KeyboardEvent.KEY_DOWN,	_onKeyPress);
			ROOT.removeEventListener(KeyboardEvent.KEY_UP,		_onKeyPress);
		}
		
		/**
		 * 	Terminates the keylistener
		 */
		override public function terminate():void {
		}
		
		/**
		 * 	@private
		 */
		private function _onKeyPress(event:KeyboardEvent):void {
			
			if (UIObject.selection is UILayer) {
				
				var layer:UILayer = UIObject.selection as UILayer;
				
				switch (event.keyCode) {
					case SELECT_LAYER_PREV:
						layer = UILayer.layers[layer.index - 1];
						if (layer) {
							UIObject.select(layer);
						}
						
						break;
					case SELECT_LAYER_NEXT:
						layer = UILayer.layers[layer.index + 1];
						if (layer) {
							UIObject.select(layer);
						}
	
						break;
					case SELECT_FILTER_UP:
						layer.selectFilterUp(true);
						break;
					case SELECT_FILTER_DOWN:
						layer.selectFilterUp(false);
						break;
					case SELECT_LAYER_0:
						UIObject.select(UILayer.layers[0]);
						break;
					case SELECT_LAYER_1:
						UIObject.select(UILayer.layers[1]);
						break;
					case SELECT_LAYER_2:
						UIObject.select(UILayer.layers[2]);
						break;
					case SELECT_LAYER_3:
						UIObject.select(UILayer.layers[3]);
						break;
					case SELECT_LAYER_4:
						UIObject.select(UILayer.layers[4]);
						break;
					case SELECT_PAGE_0:
					
						layer.selectPage(0);
						
						break;
					case SELECT_PAGE_1:
					
						layer.selectPage(1);
						
						break;
					case SELECT_PAGE_2:
					
						layer.selectPage(2);
						
						break;
					case MACRO_1:
						execMacro(MacroManager.ACTION_1, event.keyCode);
						break;
					case MACRO_2:
						execMacro(MacroManager.ACTION_2, event.keyCode);
						break;
					case MACRO_3:
						execMacro(MacroManager.ACTION_3, event.keyCode);
						break;
					case MACRO_4:
						execMacro(MacroManager.ACTION_4, event.keyCode);
						break;
					case MACRO_5:
						execMacro(MacroManager.ACTION_5, event.keyCode);
						break;
					case MACRO_6:
						execMacro(MacroManager.ACTION_6, event.keyCode);
						break;
					case MACRO_7:
						execMacro(MacroManager.ACTION_7, event.keyCode);
						break;
					case MACRO_8:
						execMacro(MacroManager.ACTION_8, event.keyCode);
						break;
					case MACRO_9:
						execMacro(MacroManager.ACTION_9, event.keyCode);
						break;
					case MACRO_10:
						execMacro(MacroManager.ACTION_10, event.keyCode);
						break;
					case MACRO_11:
						execMacro(MacroManager.ACTION_11, event.keyCode);
						break;
					case MACRO_12:
						execMacro(MacroManager.ACTION_12, event.keyCode);
						break;
					//default:
						//trace(event.keyCode);
						// break;
				}
			}
		}
		
		/**
		 * 	@private
		 */
		private function execMacro(plugin:Plugin, key:int):void {
			
			if (plugin && !keyUpHash[key]) {
				var macro:Macro = plugin.getDefinition() as Macro;
				macro.keyDown();
				ROOT.addEventListener(KeyboardEvent.KEY_UP, keyUp);
				keyUpHash[key] = macro;
			}
		}
		
		/**
		 * 
		 */
		private function keyUp(event:KeyboardEvent):void {
			var macro:Macro = keyUpHash[event.keyCode];
			if (macro) {
				macro.keyUp();
			}
			delete keyUpHash[event.keyCode];
			
			// if no key ups left, remove listener
			for each (var i:Macro in keyUpHash) {
				return;
			}
			ROOT.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
	}
}