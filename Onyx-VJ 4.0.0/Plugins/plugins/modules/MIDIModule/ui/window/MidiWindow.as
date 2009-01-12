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
package ui.window {
	 
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import module.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.core.*;
	import ui.states.*;
	import ui.text.*;
	
	use namespace onyx_ns;
		
	/**
	 * 	The MIDI window
	 */
	public final class MidiWindow extends Window { //implements IParameterObject {
		
		/**
		 * 	@private
		 */
		private static const options:UIOptions = new UIOptions();
		
		/**
		 * 	@private
		 */
		//private var _hostControl:TextControl;
		//private var _portControl:TextControl;
		//private var _connectControl:ButtonControl;
				
		/**
		 * 	@private
		 */
		private var _learnMIDI:TextButton;
		private var _loadMIDI:TextButton;
		private var _saveMIDI:TextButton;
		private var _fileMIDI:StaticText;
		
		/**
		 * 	@private
		 * 	returns controls
		 */
		//private const parameters:Parameters	= new Parameters(this as IParameterObject,
		//	new ParameterString('host', 'host','127.0.0.1'),
		//	new ParameterString('port', 'port','10000'),
		//	new ParameterExecuteFunction('connect', 'connect')
		//);
		
		/**
		 * 	@constructor
		 */
		public function MidiWindow():void {
			
			super( null,false,1,1);
			init();
					
		}
		
		private function init():void {
			
			_learnMIDI = new TextButton(options, 'learn');
			_loadMIDI = new TextButton(options, 'load');
			_saveMIDI = new TextButton(options, 'save');
			_fileMIDI = new StaticText();
			_fileMIDI.text = 'MIDI FILE';
			
			//_hostControl			= Factory.getNewInstance(TextControl) as TextControl;
			//_portControl			= Factory.getNewInstance(TextControl) as TextControl;
			//_connectControl			= Factory.getNewInstance(ButtonControl) as ButtonControl;
			//_hostControl.initialize(parameters.getParameter('host'), options,'host');
			//_portControl.initialize(parameters.getParameter('port'), options,'port');
			//_connectControl.initialize(parameters.getParameter('connect'), options,'connect');
									
			addChildren(
				//_hostControl,						3,				10,
				//_portControl,						options.width+6,10,
				//_connectControl,					options.width+6,30,
				_fileMIDI,							3,				60,
				new AssetLine(99),					3,				70,
				_learnMIDI,							3,				73,
				_loadMIDI,							options.width+6,73,
				_saveMIDI,							options.width+6,85
			);
			
			// listeners
			_learnMIDI.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_loadMIDI.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_saveMIDI.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
		}		
		
		/**
		 * 
		 */
		//public function getParameters():Parameters {
		//	return parameters
		//}
		
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			switch (event.currentTarget) {
				case _learnMIDI:
					learn();
					break;
				 case _loadMIDI:
					load();
					break;
				case _saveMIDI:
					save();
					break;
			}
			event.stopPropagation();
		}
		
		/**
		 * 
		 */
		private function learn():void {
            StateManager.loadState(new MidiLearnState());
        }
        private function load():void {
            StateManager.loadState(new MidiLoadState());
        }
		private function save():void {
            StateManager.loadState(new MidiSaveState());
        }
        
        /**
		 * 	@private
		 */
		/*private function _onFileSaved(query:AssetQuery):void {
			Console.output(query.path + ' saved.');
		}*/			
      	
      	
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			_learnMIDI = null;
			_loadMIDI = null;
			_saveMIDI = null;

		}
		
	}
	
}