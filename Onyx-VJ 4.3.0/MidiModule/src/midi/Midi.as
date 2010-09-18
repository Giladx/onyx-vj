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
package midi {
	
	import events.MidiEvent;
	
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;
	import onyx.utils.string.*;
	
	import ui.states.*;
	import ui.styles.*;
	import ui.window.*;
					
	final public class Midi extends Module {
		
		public static const NOTE_OFF:int                  = 0x80;//128
		public static const NOTE_ON:int                   = 0x90;//144
        public static const POLYPHONIC_KEY_PRESSURE:int   = 0xa0;//160
        public static const CONTROL_CHANGE:int            = 0xb0;//176
        public static const PROGRAM_CHANGE:int            = 0xc0;//192 
        public static const KEY_PRESSURE:int              = 0xd0;//208
        public static const PITCH_WHEEL:int               = 0xe0;//224
        public static const SYSTEM_MESSAGE:int            = 0xe0;
                           
		/**
		 * 	Instance
		 */
		public static const instance:Midi 		= new Midi();
		private static const REUSABLE:MidiEvent	= new MidiEvent(MidiEvent.DATA);
		
		public static const tag:String	= 'midi';
		
		/**
		 * 	Move layer's MIDI
		 */
		private static var _moveEvents:int;
		private static var _layerFrom:Layer;
		private static var _layerTo:Layer;
		private static var _backupTo:Dictionary;
		
		/**
		 * 	Store styles for already set UIcontrol
		 */
		public static var controlsSet:Dictionary;
		
		/**
		 * 	Behavior/midihash crossmap
		 */
		private static var _map:Dictionary;
		
		/**
		 * 	Busy flag
		 */
		private static var busy:Boolean;
		        
		/**
		 * 	@constructor
		 */
		public function Midi():void {
			
			// check unique
			if (instance) {
				throw new Error('');
			}
						
			_map = new Dictionary(false);
			
			// add listeners
			_moveEvents = 0;
			for each(var layer:LayerImplementor in Display.layers) {
				layer.addEventListener(LayerEvent.LAYER_MOVE, _swapLayers);
				// add parameters listener
				for each(var ctrl:Parameter in layer.getProperties()) {
					ctrl.addEventListener(ParameterEvent.CHANGE, _parChanged);
				}
			}
			
			busy = false;
						
		}
									        

		public static function registerControl(control:Parameter, midihash:uint):ColorTransform {
			
			Console.output( "registerControl, midihash: " + midihash );

			if(control && midihash) {
             	// check if already have this midihash
				for (var val:Object in _map) {
					if(val==midihash.toString() ) {
						if (_map[val]) {
							controlsSet[(_map[val].control as Parameter).getMetaData(tag)] = MIDI_HIGHLIGHT;
							unregisterControl(midihash);
						}
					}
				}
								
	            // store the hash inside CONTROL
	            control.setMetaData(tag, midihash);
				//controlsSet[control] = MIDI_HIGHLIGHT_SET;
				
	            // based on the control and the command type, create behaviors
	            var behavior:IMidiControlBehavior;
	                                          
				switch((midihash>>8)&0xF0) {
					
					// toggle messages -- need to add note on, note off behavior
					case NOTE_OFF:
						break;
					case NOTE_ON:
						if (control is ParameterExecuteFunction) {
							behavior = new ExecuteBehavior(control as ParameterExecuteFunction);
						} else if (control is ParameterNumber) {
							behavior = new NumericBehavior(control as ParameterNumber);
						} else if (control is ParameterArray) {
							behavior = new NumericRange(control as ParameterArray);
						}
						_map[midihash] = behavior;
						break;
						
					// slider value messages
					case CONTROL_CHANGE: 
					case PITCH_WHEEL:
						if (control is ParameterNumber) {
							behavior = new NumericBehavior(control as ParameterNumber);
						} else if (control is ParameterArray) {
							behavior = new NumericRange(control as ParameterArray);
						}
						_map[midihash] = behavior;
				
						break;
						
					// system message -- what to do?
					case SYSTEM_MESSAGE:
						break;
				}
								
				//do style
				return MIDI_HIGHLIGHT_SET;
								
            }
            
            // error
            return null;
            
		}
		
		public static function unregisterControl(midihash:uint):void {
			if (_map[midihash]) {
				delete _map[midihash].control.getMetaData(tag);			
				delete _map[midihash];
			}           
		}
			
				
		/**
		 *  swap layers
		 **/
		public static function _swapLayers(event:LayerEvent):void {
			
			_moveEvents++;
                           
            if(_moveEvents==1) {
            	
            	_layerTo 	= event.target as LayerImplementor;
            	_backupTo 	= _backupControls(_layerTo.getProperties());
            		
            } else if(_moveEvents==2) {
            	
            	_layerFrom 	= event.target as LayerImplementor;	
            	
            	for each(var controlTo:Parameter in _layerTo.getProperties()) {
            		controlTo.setMetaData(tag, _layerFrom.getProperties().getParameter(controlTo.name).getMetaData(tag));
            		registerControl( controlTo,
            						 controlTo.getMetaData(tag) as uint );	
            	}
            	for each(var controlFrom:Parameter in _layerFrom.getProperties()) {
            		controlFrom.setMetaData(tag, _backupTo[controlFrom.name]);
            		registerControl( controlFrom,
            						 controlFrom.getMetaData(tag) as uint );
            	}
            		
            	_moveEvents = 0; 
            }
            
        }
        
		
		
		/**
		 *      RX/TX MIDI message to controller(via proxy)
		 */		
		public static function rxMessage(data:ByteArray):void {
			
			// this avoid loops on 2way communication: this tells that changes in parameter's value are coming from midi
			// so we avoid (see private _parChange()) to send back signal to midi controller in loop
			busy = true;
			
			var status:uint      = data.readUnsignedByte();
			var command:uint     = status&0xF0;
			var channel:uint     = status&0x0F; 
			var data1:uint       = data.readUnsignedByte(); // SC: if CC this contains MIDI Channel Number
			var data2:uint       = data.readUnsignedByte();
			
			var midihash:uint    = ((status<<8)&0xFF00) | data1&0xFF; // SC: was ((status<<8)&0xFF00);
			Console.output( "rx stat " + status + " cmd " + command + " chn " + channel + " d1 " + data1  + " d2 " + data2 + " hash " + midihash  );
			
			var behavior:IMidiControlBehavior = _map[midihash]; 
			
			
			if(behavior) {
				switch(command) {
					case NOTE_OFF:
						break;
					case NOTE_ON:
						behavior.setValue(data1);
						break;
					case PITCH_WHEEL:
						behavior.setValue(data1);
						break;
					case CONTROL_CHANGE: // SC: if CC then "channel" has values 0-15 for midi channels 1-16 
						behavior.setValue(data2);
						break;
					default:
						behavior.setValue(data1);
				}
			}
			
			if(instance.hasEventListener(MidiEvent.DATA)) {
				
				REUSABLE.command        = command;
				REUSABLE.channel        = channel;
				REUSABLE.data1          = data1;
				REUSABLE.data2          = data2;
				REUSABLE.midihash       = midihash;
				instance.dispatchEvent(REUSABLE);
				
			}
			
			// this tells that the incoming midi is up
			busy = false;
		}
		public static function txMessage(midihash:uint, value:Number):void {
			
			var bytes:ByteArray = new ByteArray();
			
			bytes[0] = ((midihash>>8)&0xFF);
			bytes[1] = midihash&0xFF;
			bytes[2] = value;
			
			PluginManager.modules['MIDI'].sendData(bytes);
			
		}  
		
		/**
		 *  parameter changed
		 **/
		public static function _parChanged(event:ParameterEvent):void {
		
			// ok, change is not coming from midi controller, so we send to it to allow 2way communication
			if(busy==false) {
				var par:Parameter = event.target as Parameter;
				Midi.txMessage(par.getMetaData('midi') as uint, event.value*127);
			}
						
		}
		
        private static function _backupControls(controls:Parameters):Dictionary {
			
        	var _hashes:Dictionary = new Dictionary(false);
        	for each(var control:Parameter in controls) {
        		_hashes[control.name] = control.getMetaData(tag); 
        	}
        	return _hashes;
        	
        }
		
		
		/**
		*	SC: to MIDI
		**/		
		public static function toXML():XML {
			
			var windows:XML = <windows />;
			var local:XML;
			var remote:XML;
						
			var control:Parameter;
			
			for each(var registration:WindowRegistration in WindowRegistration.registrations) {
				var win:Window = WindowRegistration.getWindow(registration.name);
				
				if(win != null) {
					var xml:XML = <window/>;
					xml.@name 	= registration.name;
					
					// DISPLAY
					if(win is DisplayWindow) { 
						
						var display:DisplayWindow = win as DisplayWindow;
						// remote controls
						remote = <remote/>;
						for each(control in Display.getParameters() ) {
							if(control.name!='channelMix') {
								remote.appendChild(toControlXML(control));
							}
						}
						xml.appendChild(remote);
						
						// local controls
						local = <local/>;
						for each(control in Display.getParameters()) {
							local.appendChild(toControlXML(control));
						}
						xml.appendChild(local);			
						
					// LAYERS
					} else if(win is LayerWindow) {
						for each (var layer:LayerImplementor in Display.layers) {
							xml.appendChild(toLayerXML(layer));
						}
						
					// BROWSER	
					//} else if(win is Browser) {
					
					//	var browser:Browser = win as Browser;
					//	xml = <{substituteBlanks('FILE BROWSER','_')}/>;
					
					// FILTERS
					} else if(win is Filters) {
					
						var filters:Filters = win as Filters;
					
					} else if(win is SettingsWindow) {
					
						var settings:SettingsWindow = win as SettingsWindow;
					
						// remote controls
						remote = <remote/>;
						for each(control in settings.getParameters()) {
							remote.appendChild(toControlXML(control));
						}
						xml.appendChild(remote);
					
					}
									
					windows.appendChild(xml);
				}
				
			}
				
			return windows;
				
		}
		
		public static function toLayerXML(layer:LayerImplementor):XML {
			
			var xml:XML = <layer/>;
			xml.@name = layer.index;
			
			// properties
			for each (var property:Parameter in layer.getProperties()) {
				xml.appendChild(toControlXML(property));
			}
			
			// customs
			/*var custom:XML = <CUSTOM/>;
			for each (var control:Parameter in layer.getParameters()) {
				custom.appendChild(toControlXML(control));
			}
			xml.appendChild(custom);*/
			
			// filters
			/*var filters:XML = <FILTERS/>;
			for each (var filter:Filter in layer.filters) {
				var f:XML = <{filter.name}/>;
				for each (var controlF:Parameter in filter.getParameters()) {
					f.appendChild(toControlXML(controlF));
				}
				filters.appendChild(f);
			}
			xml.appendChild(filters);*/
				
			return xml;
			
		}
		
		public static function toControlXML(control:Parameter):XML {
			
			var xml:XML = <control/>;
			xml.@name 	= control.name;

			if(control is ParameterProxy) {
				
				var proxy:ParameterProxy = control as ParameterProxy;
				xml.appendChild( toControlXML(proxy.controlX) );
				xml.appendChild( toControlXML(proxy.controlY) ); 
			
			} else {
			
				if(	control.getMetaData(tag)!=null && control.getMetaData(tag)!=0 ) {
					xml.@midi = control.getMetaData(tag);
				}
				
			}
						
			return xml;
			
		}
		
		/**
		*	SC: from MIDI
		**/
		public static function fromXML(x:XML):void {
			
			var midiXML:XMLList = x.windows;
			
			var layer:LayerImplementor;
			var control:Parameter;
			
			for each(var xml:XML in midiXML.children()) {
				
				var window:Window = WindowRegistration.getWindow(xml.@name);
				//var name:String = registration.name.replace('_',' ');
				//win.loadXML(Midi,windows[name]);
				
				// do parse xml		
				if(window is DisplayWindow) {
					
					var display:DisplayWindow = window as DisplayWindow;
					if(xml.hasOwnProperty('remote')) {
						for each (control in Display.getParameters()) {
							fromControlXML( control, xml.child('remote').child(control.name) );
						}
					}
					if(xml.hasOwnProperty('local')) {
						for each (control in Display.getParameters()) {
							//Console.output(control);
							fromControlXML( control, xml.child('local').child(control.name) );
						}
					}
					
				} else if(window is LayerWindow)  {
					
					for each (layer in Display.layers)
						fromLayerXML(layer,xml.layer.(@name == layer.index));
					
				} else if(window is SettingsWindow) {
					
					var settings:SettingsWindow = window as SettingsWindow;
					if(xml.hasOwnProperty('remote')) {
						for each (control in settings.getParameters()) {
							fromControlXML( control, xml.child('remote').child(control.name) );
						}
					}								
				}
				
			}					
		}
				
		public static function fromLayerXML(layer:LayerImplementor, xml:XMLList):void {
			
			var control:Parameter;
			var filter:Filter;
			
			// properties
			for each (control in layer.getProperties()) {
				fromControlXML( control, xml );
			}
			
			// customs
			/*if(layer.controls) {
				for each (control in layer.controls) {
					loadControlXML( control, xml.child(control.name) );
				}	
			}
			
			// filters
			if(layer.filters) {
				for each (filter in layer.filters) {
					for each (control in filter.controls) {
						loadControlXML( control, xml.child(control.name) );
					}	
				} 
			}*/				
		}
		
		public static function fromControlXML(control:Parameter, xml:XMLList):void {
			
			var controls:Dictionary = UserInterface.getAllControls();
			if(xml) {
				var hashXML:String = xml.control.(@name == control.name).@midi;

				// proxy				
				if(control is ParameterProxy) {
					var proxy:ParameterProxy = control as ParameterProxy;
					for each (control in proxy) {
						fromControlXML( control, xml.child(control.name) );
					}	
				// single
				} else {
					if(hashXML) {
						// register control
						//Midi.controlsSet[uic] = 
						//	Midi.registerControl(control, uint(parseInt(hashXML)));
						//control
						//uic.transform.colorTransform = Midi.controlsSet[uic];
						
						registerControl(control, uint(parseInt(hashXML)) );
					}
				}
				
			}
			
		}
		
	}
	
}
	