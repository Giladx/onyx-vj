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
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.*;
	
	import onyx.constants.ROOT;
	import onyx.plugin.*;
	import onyx.states.ApplicationState;
	
	import ui.core.KeyDefinition;
	import ui.core.UIManager;
	import ui.layer.UILayer;
	
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
			/*
			DH: TBD
			DEFERRED TIL POST 3.03

			new KeyDefinition('ACTION_1', 'Executes Macro 1'),
			new KeyDefinition('ACTION_2', 'Executes Macro 2'),
			new KeyDefinition('ACTION_3', 'Executes Macro 3'),
			new KeyDefinition('ACTION_4', 'Executes Macro 4'),
			new KeyDefinition('ACTION_5', 'Executes Macro 5'),
			new KeyDefinition('ACTION_6', 'Executes Macro 6'),
			new KeyDefinition('ACTION_7', 'Executes Macro 7'),
			new KeyDefinition('ACTION_8', 'Executes Macro 8'),
			new KeyDefinition('ACTION_9', 'Executes Macro 9'),
			new KeyDefinition('ACTION_10', 'Executes Macro 10'),
			new KeyDefinition('ACTION_11', 'Executes Macro 11'),
			new KeyDefinition('ACTION_12', 'Executes Macro 12')
			*/
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
		
		/* 	DH: TBD
			DEFERRED to post 3.0.3

		public var ACTION_1:int					= 112;
		public var ACTION_2:int					= 113;
		public var ACTION_3:int					= 114;
		public var ACTION_4:int					= 115;
		public var ACTION_5:int					= 116;
		public var ACTION_6:int					= 117;
		public var ACTION_7:int					= 118;
		public var ACTION_8:int					= 119;
		public var ACTION_9:int					= 120;
		public var ACTION_10:int				= 121;
		public var ACTION_11:int				= 122;
		public var ACTION_12:int				= 123;
		

			
			public var ACTION_MACRO_1:Macro;
			public var ACTION_MACRO_2:Macro;
			public var ACTION_MACRO_3:Macro;
			public var ACTION_MACRO_4:Macro;
			public var ACTION_MACRO_5:Macro;
			public var ACTION_MACRO_6:Macro;
			public var ACTION_MACRO_7:Macro;
			public var ACTION_MACRO_8:Macro;
			public var ACTION_MACRO_9:Macro;
			public var ACTION_MACRO_10:Macro;
			public var ACTION_MACRO_11:Macro;
			public var ACTION_MACRO_12:Macro;
		 */
		
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
			ROOT.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);
			
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
			
			var layer:UILayer;
			
			switch (event.keyCode) {
				case SELECT_LAYER_PREV:
					layer = UILayer.layers[UILayer.selectedLayer.index - 1];
					if (layer) {
						UILayer.selectLayer(layer);
					}
					
					break;
				case SELECT_LAYER_NEXT:
					layer = UILayer.layers[UILayer.selectedLayer.index + 1];
					if (layer) {
						UILayer.selectLayer(layer);
					}

					break;
				case SELECT_FILTER_UP:
					UILayer.selectedLayer.selectFilterUp(true);
					break;
				case SELECT_FILTER_DOWN:
					UILayer.selectedLayer.selectFilterUp(false);
					break;
				case SELECT_LAYER_0:
					UILayer.selectLayer(UILayer.layers[0]);
					break;
				case SELECT_LAYER_1:
					UILayer.selectLayer(UILayer.layers[1]);
					break;
				case SELECT_LAYER_2:
					UILayer.selectLayer(UILayer.layers[2]);
					break;
				case SELECT_LAYER_3:
					UILayer.selectLayer(UILayer.layers[3]);
					break;
				case SELECT_LAYER_4:
					UILayer.selectLayer(UILayer.layers[4]);
					break;
				case SELECT_PAGE_0:
				
					UILayer.selectedLayer.selectPage(0);
					
					break;
				case SELECT_PAGE_1:
				
					UILayer.selectedLayer.selectPage(1);
					
					break;
				case SELECT_PAGE_2:
				
					UILayer.selectedLayer.selectPage(2);
					
					break;
					
				default:
					// trace(event.keyCode);
					// break;
			}
		}

	}
}