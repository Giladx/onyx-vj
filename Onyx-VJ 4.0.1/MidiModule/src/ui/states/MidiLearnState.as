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
package ui.states {
	
	import events.*;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.utils.Dictionary;
	
	import midi.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;
	
	import ui.styles.*;
	
	public final class MidiLearnState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var _control:UserInterfaceControl;
		private static var nowDate:String;
		
		/**
		 * 	@private
		 */
		//private var _layer:UILayer;
		
		/**
		 * 	@private
		 * 	Store the transformations for all UIControls
		 */
		private var _storeTransform:Dictionary;
		
		/**
		 * 	@constructor
		 */
		public function MidiLearnState():void {
			var now:Date = new Date();
			var m:String = now.getHours().toString();
			var month:String = ( m.length == 1 ? "0" + m : m );
			var d:String = now.getMinutes().toString();
			var date:String = ( d.length == 1 ? "0" + d : d );
			nowDate = month + date;

			log('MidiLearnState constructor');
			super('MidiLearnState');
								
		}
		
		/**
		 * 	initialize
		 */
		override public function initialize():void {
			log('MidiLearnState initialize');
			// check for state registered, reload
			if(!StateManager.getStates('MidiLearnState')) {
				Console.output('reloaded');
				StateManager.loadState(this);
			}
			
			var controls:Dictionary = UserInterface.getAllControls();
			
			var i:Object;
			var control:UserInterfaceControl;
			var transform:Transform;
			
			_storeTransform = new Dictionary(true);
			
			if(!Midi.controlsSet) {
				Midi.controlsSet = new Dictionary(true);
							log('Midi.controlsSet creat');
	
			} else 	log('Midi.controlsSet exists');

			
			// Highlight all the controls
			for (i in controls) {
				control 					= i as UserInterfaceControl;
				transform					= control.transform;
				_storeTransform[control] 	= transform.colorTransform;
				transform.colorTransform	= MIDI_HIGHLIGHT;
			}		
			// Highlight already set
			var st:String;
			for (i in Midi.controlsSet) {
				if (i!='null') {
					control						= i as UserInterfaceControl;
					log('Midi.controlsSet i:' + i);
					transform					= control.transform;
					_storeTransform[control]	= Midi.controlsSet[control];
					transform.colorTransform	= _storeTransform[control];//MIDI_HIGHLIGHT_SET;
				}
				else log('Midi.controlsSet i null');
				st +=  i.toString() + ' ' + transform.colorTransform.greenOffset.toString();
			}
			log('control:' + st);
						
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true, 9999);
		}
		
		
		/**
		 * 	@private
		 */
		private function _onControlSelect(event:MouseEvent):void {
			log('_onControlSelect event tgt:' + event.target.toString());
			var clicked:DisplayObject = event.target as DisplayObject;

			_control = null;
			Midi.instance.removeEventListener(MidiEvent.DATA, _onMidi);

			while (clicked !== DISPLAY_STAGE) {
				
				log('clicked' + clicked.toString());
				if (clicked is UserInterfaceControl) {
					_control = clicked as UserInterfaceControl;
					log('clicked is UserInterfaceControl' );
					break;
				}
				
				clicked = clicked.parent;
				
			}
			
			// success, start the next process
			if (_control) {
				log('_control not null' );
				Midi.instance.addEventListener(MidiEvent.DATA, _onMidi);
				_control.addEventListener(KeyboardEvent.KEY_DOWN, _onKey);
				
				// un-highlight everything
				_unHighlight();
				
				// re-highlight the selected control
				var transform:Transform		= _control.transform;
				_storeTransform[_control]	= transform.colorTransform;
				transform.colorTransform	= MIDI_HIGHLIGHT;
							
			} else {
				// Clicked outside any control - abort learning
				StateManager.removeState(this);
			}
			// stop propagation
			event.stopPropagation();
		}
		private function _onMidi(event:MidiEvent):void {
				log('_onMidi:'+event.command+' data1:'+event.data1+' data2:'+event.data2 );
				// new register
				Midi.controlsSet[_control] = 
					Midi.registerControl(_control.getParameter(), event.midihash);
				log('_onMidi _control:'+_control+' event.midihash:'+event.midihash+' Midi.controlsSet[_control]:'+Midi.controlsSet[_control] );
					
				_control.transform.colorTransform = Midi.controlsSet[_control];
				
				// reset and wait for another midi control
				_control.removeEventListener(KeyboardEvent.KEY_DOWN, _onKey);
				StateManager.removeState(this);
				initialize();
						
		}
				
		/**
		 * 	Remove state
		 */
		override public function terminate():void {
			
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true);
			Midi.instance.removeEventListener(MidiEvent.DATA, _onMidi);
				
			_unHighlight();
	   		
	   		_storeTransform = null;
	   		
		}
		
		/**
		 * 	@private
		 */
		private function _onKey(event:KeyboardEvent):void {
					
			// if DELETE
			if(event.charCode == 127) {
				
				// if mapped
				if(_control.getParameter().getMetaData(Midi.tag)) {
					
					Midi.controlsSet[_control] = MIDI_HIGHLIGHT;
					Midi.unregisterControl(_control.getParameter().getMetaData(Midi.tag) as uint);
					
					StateManager.removeState(this);
					initialize();
						
				}
				
			}
			
		}

    	/**
    	 * 	@private
    	 */
		private function _unHighlight():void {
			
			var controls:Dictionary = UserInterface.getAllControls();
			for (var i:Object in controls) {
				var control:UserInterfaceControl	= i as UserInterfaceControl;
				var color:ColorTransform	= _storeTransform[control];
				if (color) {
					var transform:Transform		= control.transform;
					transform.colorTransform	= new ColorTransform(.1,1,1,.3);
					delete _storeTransform[control];
				}
			} 
			
		}
		public static function log( text:String, clear:Boolean=false ):void
		{
		    var file:File = File.applicationStorageDirectory.resolvePath( nowDate +  "midi.log" );
		    var fileMode:String = ( clear ? FileMode.WRITE : FileMode.APPEND );
		
		    var fileStream:FileStream = new FileStream();
		    fileStream.open( file, fileMode );
		
		    fileStream.writeUTFBytes( "MidiLearnState: " + text + "\n" );
		    fileStream.close();
		    
		}
		
	}
}