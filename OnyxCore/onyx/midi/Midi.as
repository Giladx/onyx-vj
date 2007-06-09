/** 
 * Copyright (c) 2007, www.onyx-vj.com
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
package onyx.midi {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.display.Display;
	import onyx.errors.*;
	import onyx.events.*;
	import onyx.display.*;
	import onyx.net.*;
	import onyx.utils.math.*;

 	/**
 	 * 	Base Midi Class
 	 */
	public class Midi extends EventDispatcher implements IControlObject {
		
		/**
		 * 
		 */
		public static function registerMidiMaster(module:IMidiDispatcher):void {
			MIDI._client = module;
			MIDI.start();
		}

		/**
		 * 	@private
		 */
		private var _controls:Controls;

		/**
		 * 	@private
		 */
		private var _client:IMidiDispatcher;

		/**
		 * 	@private
		 */
		private var _map:Array = new Array();

		/**
		 * 	@constructor
		 */
		public function Midi():void {
			
			if (MIDI) {
				throw INVALID_CLASS_CREATION;
			}
			
			/*
			_controls = new Controls(this,
				new ControlRange('listen', 'midi control', BOOLEAN)
			);
			*/
			_controls = new Controls(this);
		}
		
		/**
		 * 	Register layers to listen for
		 */
		public function registerLayers(layers:Array):void {
			for each (var layer:Layer in layers) {
				layer.addEventListener(LayerEvent.LAYER_UNLOADED,_layerUnloaded);
			}
		}
		
		/**
		 * 	@private
		 */
		private function _layerUnloaded(event:LayerEvent):void {
			
			/*
			
			var target:Layer = event.currentTarget as Layer;
			var disp:Display = Display.getDisplay(0);
			
			target.removeEventListener(LayerEvent.LAYER_UNLOADED,_layerUnloaded);
			
			var layers:Array = disp.layers;
			for (var i:int=0; i<layers.length; i++){
				if (target == layers[i])
					break;
			}
			if (i == layers.length){
				trace("Couldn't find layer in _layerUnloaded!?");
				return;
			}
			// Remove maps for any constrols whose name begin
			// with this layer name.
			var layerName:String = i.toString();
			var lookfor:String = layerName + ".";
			for each (var m:MidiMap in _map) {
				var nm:String = disp.getNameOfControl(m.control);
				if ( nm.indexOf(lookfor) >= 0 ) {
					_removeMapForControl(m.control);
				}
			}
			*/
		}
		
		/**
		 * 	Starts listening for midi events
		 */
		public function start():void {
			_client.addEventListener(MidiMsg.NOTEON, _onNoteonoff);
			_client.addEventListener(MidiMsg.NOTEOFF, _onNoteonoff);
			_client.addEventListener(MidiMsg.CONTROLLER, _onController);
//			_client.connect();
		}
		
		/**
		 * 	Stops listening for midi events
		 */
		public function stop():void {
			_client.removeEventListener(MidiMsg.NOTEON, _onNoteonoff);
			_client.removeEventListener(MidiMsg.NOTEOFF, _onNoteonoff);
			_client.removeEventListener(MidiMsg.CONTROLLER, _onController);
		}
		
		/**
		 * 	@private
		 * 	Remove map (need documentation)
		 */
		private function _removeMapForControl(c:Control):void {
			for ( var i:int = 0; i<_map.length; i++ ) {
				if ((_map[i] as MidiMap).control == c) {
						break;
				}
			}
			if ( i < _map.length) {
				_map.splice(i,1);
			}
		}
		
		/**
		 * 
		 */
		private function _onController(e:MidiEvent):void {
			for each (var m:MidiMap in _map) {
				if ( m is MidiMapController ) {
					if ( ! m.matchesEvent(e) || m.control == null ) {
						continue;
					}
					var mc:MidiController = e.midimsg as MidiController;
					var f:Number = mc.value / 127.0;
					var c:Control = m.control;
					if ( c is ControlNumber ) {
						var cn:ControlNumber = c as ControlNumber;
						cn.value = cn.min + (cn.max - cn.min) * f;
					} else if ( c is ControlInt ) {
						var ci:ControlInt = c as ControlInt;
						ci.value = ci.min + (ci.max - ci.min) * f;
					} else if ( c is ControlRange ) {
						// TBD: DH: I removed control range min and mix
						// this should use the DropDown.index;
						// midi should actually live in the UI
						
						// var cd:ControlRange = c as ControlRange;
						// var i:int = int(round(cd.min + (cd.max - cd.min) * f));
						// cd.value = cd.data[i];
					} else if ( c is ControlExecute ) {
						// For MIDI controllers attached to an execute control (i.e. 
						// a pushbutton), it will only fire if the controller matches
						// the exact control value that was learned.
						var ce:ControlExecute = c as ControlExecute;
						ce.execute();
					} else {
						throw "MidiMapController doesn't know how to handle that type of control";
					}
				}
			}
		}
		
		public function _onNoteonoff(e:MidiEvent):void {
			var noteoff:MidiNoteOff = e.midimsg as MidiNoteOff;
			for each (var m:MidiMap in _map) {
				if ( m is MidiMapNoteOff ) {
					if ( ! m.matchesEvent(e) || m.control == null ) {
						continue;
					}
					var c:Control = m.control;
					if ( c is ControlExecute ) {
						var ce:ControlExecute = c as ControlExecute;
						ce.execute();
					} else {
						throw "MidiMapNote doesn't know how to handle that type of control";
					}
				}
			}
		}
		
		/**
		 *  public
		 */
		public function registerController(c:Control, e:MidiEvent):void {
			var any:Boolean = true;
			// If we're registering something that is triggered,
			// we don't want to match *any* controller messages, we
			// just want to match the exact value of this one.
			if ( c is ControlExecute ) {
				any = false;
			}
			var m:MidiMapController = new MidiMapController(
				e.deviceIndex, any, e.midimsg as MidiController);
			_registerMap(c,m);
		}
		
		public function registerNoteOn(c:Control, di:uint, n:MidiNoteOn):void {
			_registerMap(c,new MidiMapNoteOn(di, n));
		}
		
		public function registerNoteOff(c:Control, di:uint, n:MidiNoteOff):void {
			_registerMap(c,new MidiMapNoteOff(di, n));
		}
		
		public function dispose():void {
			stop();
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function toXML():XML {
			
			/*
			var disp:Display = Display.getDisplay(0);
			var x:XML = <midi/>;
			for each (var m:MidiMap in _map) {
				var fullControlname:String = disp.getNameOfControl(m.control);
				if (fullControlname == null) {
					trace("Unable to find name of control!? ",m.control);
					continue;
				}
				if ( m is MidiMapController ) {
					var mc:MidiMapController = m as MidiMapController;
					x.appendChild( <mapcontroller>
								<control>{fullControlname}</control>
								<deviceIndex>{mc.deviceIndex}</deviceIndex>
								<channel>{mc.channel}</channel>
								<controller>{mc.controller}</controller>
								<value>{mc.value}</value>
								<anyvalue>{mc.anyvalue}</anyvalue>
								</mapcontroller> );
				} else if ( m is MidiMapNoteOn ) {
					var mon:MidiMapNoteOn = m as MidiMapNoteOn;
					x.appendChild( <mapnoteon>
								<control>{fullControlname}</control>
								<deviceIndex>{mon.deviceIndex}</deviceIndex>
								<channel>{mon.note.channel}</channel>
								<pitch>{mon.note.pitch}</pitch>
								</mapnoteon> );
				} else if ( m is MidiMapNoteOff) {
					var moff:MidiMapNoteOff = m as MidiMapNoteOff;
					x.appendChild( <mapnoteoff>
								<deviceIndex>{moff.deviceIndex}</deviceIndex>
								<channel>{moff.note.channel}</channel>
								<pitch>{moff.note.pitch}</pitch>
								<control>{fullControlname}</control>
								</mapnoteoff> );
				}
			}
			return x;
			*/
			return null;
		}
		
		public function loadXML(xml:XMLList):void {
			var x:XML;
			for each (x in xml.mapcontroller) {
				_registerMapByName(x.control,MidiMapController.fromXML(x));
			}
			for each (x in xml.mapnoteon) {
				_registerMapByName(x.control,MidiMapNoteOn.fromXML(x));
			}
			for each (x in xml.mapnoteoff) {
				_registerMapByName(x.control,MidiMapNoteOff.fromXML(x));
			}
		}
		
		private function _registerMap(c:Control, m:MidiMap):void {
			_removeMapForControl(c);
			m.control = c;
			_map.push(m);
		}
		
		private function _registerMapByName(controlName: String, m:MidiMap):void {
			/* var display:Display = Display.getDisplay(0);
			var c:Control = display.getControlByName(controlName);
			if ( c == null ) {
				throw "Unable to find control="+controlName;
			}
			_registerMap(c,m);
			*/
		}
	}
}