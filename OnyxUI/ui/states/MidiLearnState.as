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
		 * 	initialize
		 */
		override public function initialize():void {
			// Highlight all the controls
			for (var i:Object in UIControl.controls) {
				var control:UIControl = i as UIControl;
				UIControl.controls[control] = control.transform.colorTransform;
				control.transform.colorTransform = MIDI_HIGHLIGHT;
			}
			
			STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true, 9999);
		}

		/**
		 * 	@private
		 */
		private function _onControlSelect(event:MouseEvent):void {
			
			var objects:Array		= STAGE.getObjectsUnderPoint(new Point(STAGE.mouseX, STAGE.mouseY));
			
			// look for UIControls
			_control = null;
			
			for each (var object:DisplayObject in objects) {
				_control = object.parent as UIControl;
				if (_control) {
					break;
				}
			}
			
			// stop propagation
			event.stopPropagation();
			
			// Unhighlight everything except selected control
			_unHighlight(_control);
			
			if ( _control === null ) {
				
				// Clicked outside any control - abort learning
				StateManager.removeState(this);
			} else {

				// Wait for a MIDI noteon or controller event
	    		MIDI.addEventListener(MidiMsg.NOTEON,_onNoteOn);
	    		MIDI.addEventListener(MidiMsg.NOTEOFF,_onNoteOff);
	    		MIDI.addEventListener(MidiMsg.CONTROLLER,_onController);
	  		}
		}
		
		/**
		 * 	@private
		 */
		private function _onNoteOn(e:MidiEvent):void {
			if ( _control is ButtonControl ) {
				MIDI.registerNoteOn(_control.control,e.deviceIndex,e.midimsg as MidiNoteOn);
			} else {
				Console.output("You need to map a MIDI controller to that control!");
			}
			StateManager.removeState(this);
		}
		
		/**
		 * 	@private
		 */
		private function _onNoteOff(e:MidiEvent):void {
			if ( _control is ButtonControl ) {
				MIDI.registerNoteOff(_control.control,e.deviceIndex,e.midimsg as MidiNoteOff);
			} else {
				Console.output("You need to map a MIDI controller to that control!");
			}
			StateManager.removeState(this);
		}
		
		/**
		 * 	@private
		 */
		private function _onController(e:MidiEvent):void {
			if ( _control is SliderV || _control is DropDown || _control is ButtonControl ) {
				MIDI.registerController(_control.control,e);
			} else {
				Console.output("That control can't be mapped!");
			}
			StateManager.removeState(this);
		}
		
		/**
		 * 	Remove state
		 */
		override public function terminate():void {
			
			STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true);
			
			MIDI.removeEventListener(MidiMsg.NOTEON,_onNoteOn);
			MIDI.removeEventListener(MidiMsg.NOTEOFF,_onNoteOff);
   			MIDI.removeEventListener(MidiMsg.CONTROLLER,_onController);

	   		_unHighlight();
		}

    	/**
    	 * 	@private
    	 */
		private function _unHighlight(exclude:Object = null):void {
			for (var i:Object in UIControl.controls) {
				if ( i != exclude ) {
					var control:UIControl = i as UIControl;
					control.transform.colorTransform = UIControl.controls[control] || new ColorTransform();
					UIControl.controls[control] = null;
				}
			}
		}
		
	}
}