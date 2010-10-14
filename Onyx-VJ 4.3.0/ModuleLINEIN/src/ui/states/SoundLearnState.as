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
	import flash.geom.*;
	import flash.utils.Dictionary;
	import flash.ui.Keyboard;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;
	
	import ui.styles.*;

	import core.Sound;
	
	public final class SoundLearnState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var _control:UserInterfaceControl;
		
		/**
		 * 	@private
		 */
		//private var _layer:UILayer;
		
		/**
		 * 	@private
		 * 	Store the transformations for all UIControls
		 */
		private var _storeTransform:Dictionary;
		
		private var SOUND_TRANSFORM:ColorTransform;
		private var soundhash:int;
		
		/**
		 * 	@constructor
		 */
		public function SoundLearnState(key:uint):void {
			super('SoundLearnState');
			
		}
		
		/**
		 * 	initialize
		 */
		override public function initialize():void {

			// check for state registered, reload
			if(!StateManager.getStates('SoundLearnState')) {
				Console.output('reloaded');
				StateManager.loadState(this);
			}
			
			soundhash = -1;
			
			var controls:Dictionary = UserInterface.getAllControls();
			
			var i:Object;
			var control:UserInterfaceControl;
			var transform:Transform;
			
			_storeTransform = new Dictionary(true);
			
			if(!Sound.controlsSet)
				Sound.controlsSet = new Dictionary(true);
			

			// Highlight all the controls
			for(i in controls) {
				control 					= i as UserInterfaceControl;
				transform					= control.transform;
				_storeTransform[control] 	= transform.colorTransform;
				transform.colorTransform	= SOUND_HIGHLIGHT;
			}		
			// Highlight already set
			for(i in Sound.controlsSet) {
				if (i!='null') {
					control						= i as UserInterfaceControl;
					transform					= control.transform;
					_storeTransform[control]	= Sound.controlsSet[control];
					transform.colorTransform	= _storeTransform[control];
				}
			}
			
			DISPLAY_STAGE.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyPressed);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, true, 9999);
		}	
		
		private function _onKeyPressed(event:KeyboardEvent):void {
			// select if low,mid,high
			switch(event.keyCode) {
				case Keyboard.C:	soundhash = Sound.SOUND_HIGH;
									break;
				case Keyboard.X:	soundhash = Sound.SOUND_MID;
									break;
				case Keyboard.Z:	soundhash = Sound.SOUND_LOW;
									break;
				default :			soundhash = -1;
	
			}
			DISPLAY_STAGE.addEventListener(KeyboardEvent.KEY_UP, _onKeyReleased);

		}
		
		private function _onKeyReleased(event:KeyboardEvent):void {
			soundhash = -1;
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			
			var clicked:DisplayObject = event.target as DisplayObject;
			
			_control = null;
			
			
			while (clicked !== DISPLAY_STAGE) {
				
				if (clicked is UserInterfaceControl) {
					_control = clicked as UserInterfaceControl;
					break;
				}
				
				clicked = clicked.parent;
				
			}
			
			if (_control) {
				if(soundhash>-1) {
					// success, new register
					Sound.controlsSet[_control] = Sound.registerControl(_control.getParameter(), soundhash);
					_control.transform.colorTransform = Sound.controlsSet[_control];
				} else {
					// if no key down (or wrong key down) unregister control
					if(Sound.controlsSet[_control]!=null) {
						Sound.controlsSet[_control] = SOUND_HIGHLIGHT;
					}
					_control.transform.colorTransform = SOUND_HIGHLIGHT;
				}
			} else {
				// Clicked outside any control - abort learning
				StateManager.removeState(this);
			}
			
			// stop propagation
			event.stopPropagation();
						
		}
		
		override public function terminate():void {
			
			DISPLAY_STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyPressed);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, true);
				
			_unHighlight();
	   		
	   		_storeTransform = null;
	   		
		}
		
				
    	private function _unHighlight():void {
			
			var controls:Dictionary 			= UserInterface.getAllControls();
			
			for (var i:Object in controls) {
				var control:UserInterfaceControl = i as UserInterfaceControl;
				var color:ColorTransform	= _storeTransform[control];
				if (color) {
					var transform:Transform		= control.transform;
					transform.colorTransform	= new ColorTransform(1,1,1,1);
					delete _storeTransform[control];
				}
			} 
		}
		
		
	}
}