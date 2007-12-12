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
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.utils.Dictionary;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.midi.*;
	import onyx.net.*;
	import onyx.states.*;
	
	import ui.controls.*;
	import ui.styles.*;

	public final class MidiLearnState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var _control:UIControl;
		
		/**
		 * 	@private
		 * 	Store the transformations for all UIControls
		 */
		private var _storeTransform:Dictionary;
		
		/**
		 * 	initialize
		 */
		override public function initialize():void {
			
			var controls:Dictionary = UIControl.controls;
			_storeTransform = new Dictionary(true);
			
			// Highlight all the controls
			for (var i:Object in controls) {
				var control:UIControl		= i as UIControl;
				var transform:Transform		= control.transform;
				_storeTransform[control]	= transform.colorTransform;
				transform.colorTransform	= MIDI_HIGHLIGHT;
			}
			
			STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true, 9999);
		}

		/**
		 * 	@private
		 */
		private function _onControlSelect(event:MouseEvent):void {
			
			var clicked:DisplayObject = event.target as DisplayObject;

			_control = null;
			Midi.instance.removeEventListener(MidiEvent.DATA, _onMidi);

			while (clicked !== STAGE) {
				
				if (clicked is UIControl) {
					_control = clicked as UIControl;
					break;
				}
				
				clicked = clicked.parent;
			}
			
			// success, start the next process
			if (_control) {
				
				Midi.instance.addEventListener(MidiEvent.DATA, _onMidi);
				
				// un-highlight everything except selected control
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
				
		/**
		 * 	Remove state
		 */
		override public function terminate():void {
			
			STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true);
			Midi.instance.removeEventListener(MidiEvent.DATA, _onMidi);
	   		_unHighlight();
	   		
	   		_storeTransform = null;
	   		
		}
		
		/**
		 * 	@private
		 */
		private function _onMidi(event:MidiEvent):void {
			
			Midi.registerControl(_control.control, event.deviceIndex, event.command, event.control);
			StateManager.removeState(this);

		}

    	/**
    	 * 	@private
    	 */
		private function _unHighlight():void {
			
			var controls:Dictionary = UIControl.controls;
			
			for (var i:Object in controls) {
				var control:UIControl	= i as UIControl;
				var color:ColorTransform	= _storeTransform[control];
				if (color) {
					var transform:Transform		= control.transform;
					transform.colorTransform	= color;
					delete _storeTransform[control];
				}
			} 
		}
		
	}
}