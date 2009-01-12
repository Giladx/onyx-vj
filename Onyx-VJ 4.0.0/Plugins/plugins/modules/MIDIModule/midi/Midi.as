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
	
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.display.*;
	import onyx.events.LayerEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.string.*;
	
	import ui.states.*;
	import ui.styles.*;
	import ui.window.*;
					
	final public class Midi extends Module {
		
		public static const NOTE_OFF:int                  = 0x80;
		public static const NOTE_ON:int                   = 0x90;
        public static const POLYPHONIC_KEY_PRESSURE:int   = 0xa0;
        public static const CONTROL_CHANGE:int            = 0xb0; 
        public static const PROGRAM_CHANGE:int            = 0xc0; 
        public static const KEY_PRESSURE:int              = 0xd0; 
        public static const PITCH_WHEEL:int               = 0xe0;
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
			}
			
		}
				
		/**
		 *    Receive MIDI message from controller(via proxy)
		 */
		public static function receiveMessage(data:ByteArray):void {
			
            var status:uint      = data.readUnsignedByte();
			var command:uint     = status&0xF0;
			var channel:uint     = status&0x0F; 
			var data1:uint       = data.readUnsignedByte();
			var data2:uint       = data.readUnsignedByte();
		      
		    var midihash:uint    = ((status<<8)&0xFF00) | data1&0xFF;
			
			var behavior:IMidiControlBehavior = _map[midihash]; 
										
			if(behavior) {
			     switch(command) {
	                case NOTE_OFF:
	                case NOTE_ON:
	                    behavior.setValue(data1);
	                    break;
	                case CONTROL_CHANGE:
	                    behavior.setValue(data2);
	                    break;
	                
	                default:
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
		}	
				
		/**
         *      Send MIDI message to controller(via proxy)
         */
        public static function sendMessage(midihash:uint, value:int):void {
            
            var bytes:ByteArray = new ByteArray();
            
            bytes[0] = ((midihash>>8)&0xFF);
            bytes[1] = (midihash&0xFF);
            bytes[2] = (value);
            
            PluginManager.modules['MIDI'].sendData(bytes);
            
        }    
        
		/**
		 * 
		 */
		public static function registerControl(control:Parameter, midihash:uint):ColorTransform {
						
			if(control && midihash) {
            	
            	// check if alredy have this midihash
				for (var val:Object in _map) {
					if(val==midihash.toString()) {
						controlsSet[(_map[val].control as Parameter).getMetaData('ui')] = MIDI_HIGHLIGHT;
						unregisterControl(midihash);
					}
				}
								
	            // store the hash inside CONTROL
	            control.setMetaData(tag, midihash);
	                 
	            // based on the control and the command type, create behaviors
	            var behavior:IMidiControlBehavior;
	                                          
				switch((midihash>>8)&0xF0) {
					
					// toggle messages -- need to add note on, note off behavior
					case NOTE_OFF:
					case NOTE_ON:
					
						if (control is ParameterExecuteFunction) {
							behavior = new ExecuteBehavior(control as ParameterExecuteFunction);
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
		
		/**
		 * 
		 */
		public static function unregisterControl(midihash:uint):void {
			
			delete _map[midihash].control.getMetaData(tag);			
			delete _map[midihash];
			           
		}
			
		/**
		 * 
		 */
		public static function getControlFromHash(midihash:uint):Parameter {
			
			return _map[midihash].control; 
			           
		}
		
		/**
		 *  swap layers
		 **/
		public static function _swapLayers(event:LayerEvent):void {
            
            _moveEvents++;
                           
            if(_moveEvents==1) {
            	
            	_layerTo 	= event.target as LayerImplementor;
            	_backupTo 	= _backupControls(_layerTo.getParameters());
            		
            } else if(_moveEvents==2) {
            	
            	_layerFrom 	= event.target as LayerImplementor;	
            	
            	for each(var controlTo:Parameter in _layerTo.getParameters()) {
            		controlTo.setMetaData(tag, _layerFrom.getParameters().getParameter(controlTo.name).getMetaData(tag));
            		registerControl( controlTo,
            						 controlTo.getMetaData(tag) as uint );	
            	}
            	for each(var controlFrom:Parameter in _layerFrom.getParameters()) {
            		controlFrom.setMetaData(tag, _backupTo[controlFrom.name]);
            		registerControl( controlFrom,
            						 controlFrom.getMetaData(tag) as uint );
            	}
            		
            	_moveEvents = 0; 
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
		public static function toXML(from:Object):XML {
			
			return toWindowXML(from as Window);
			
		}
		
		public static function toWindowXML(window:Window):XML {
			
			var xml:XML;
			var local:XML;
			var remote:XML;
			
			var control:Parameter;
												
			if(window is DisplayWindow) { 
				
				var display:DisplayWindow = window as DisplayWindow;
					
				xml = <DISPLAY/>;
				// remote controls
				remote = <remote/>;
				for each(control in display.display.getParameters() ) {
					if(control.name!='channelMix') {
						remote.appendChild(toControlXML(control));
					}
				}
				xml.appendChild(remote);
				// local controls
				local = <local/>;
				for each(control in display.display.getParameters()) {
					local.appendChild(toControlXML(control));
				}
				xml.appendChild(local);			
				
			} else if(window is LayerWindow) {
				
				xml = <LAYERS/>;
				for each (var layer:LayerImplementor in Display.layers) {
					xml.appendChild(toLayerXML(layer));
				}
			
			} /* else if(window is Browser) {
				
				var browser:Browser = window as Browser;
				
				xml = <{substituteBlanks('FILE BROWSER','_')}/>;
				
			} else if(window is Filters) {
				
				var filters:Filters = window as Filters;
				
				xml = <FILTERS/>;
			
			} */ else if(window is SettingsWindow) {
				
				var settings:SettingsWindow = window as SettingsWindow;
				
				xml = <SETTINGS/>;
				// remote controls
				remote = <remote/>;
				for each(control in settings.getParameters()) {
					remote.appendChild(toControlXML(control));
				}
				xml.appendChild(remote);
												
			} else {
				//xml = <{window..title}/>
				xml = window.toXML();
			}
			
			return xml;
			
		}
		
		public static function toLayerXML(layer:LayerImplementor):XML {
			
			var label:String = 'layer';
			var xml:XML = <{label.concat(layer.index)}/>;
			
			// properties
			for each (var property:Parameter in layer.getProperties()) {
				xml.appendChild(toControlXML(property));
			}
			
			// customs
			var custom:XML = <CUSTOM/>;
			for each (var control:Parameter in layer.getParameters()) {
				custom.appendChild(toControlXML(control));
			}
			xml.appendChild(custom);
			
			// filters
			var filters:XML = <FILTERS/>;
			for each (var filter:Filter in layer.filters) {
				var f:XML = <{filter.name}/>;
				for each (var controlF:Parameter in filter.getParameters()) {
					f.appendChild(toControlXML(controlF));
				}
				filters.appendChild(f);
			}
			xml.appendChild(filters);
				
			return xml;
			
		}
		
		public static function toControlXML(control:Parameter):XML {
			
			var name:String = control.name;
			
			var xml:XML = <{name}/>;
			
			if(control is ParameterProxy) {
				
				var proxy:ParameterProxy = control as ParameterProxy;
				xml.appendChild( toControlXML(proxy.controlX) );
				xml.appendChild( toControlXML(proxy.controlY) ); 
			
			} else {
			
				if(	control.getMetaData(tag)!=null && control.getMetaData(tag)!=0 ) {
					xml.appendChild( control.getMetaData(tag) );
				}
				
			}
						
			return xml;
			
		}
		
		/**
		*	SC: load MIDI
		**/
		public static function loadXML(window:Window, xml:XMLList):void {
						
			// do parse xml
			loadWindowXML(window,xml);
					
		}
		
		public static function loadWindowXML(window:Window, xml:XMLList):void {
			
			var layer:LayerImplementor;
			var control:Parameter;
			
			if(window is DisplayWindow) {
				
				var display:DisplayWindow = window as DisplayWindow;
				if(xml.hasOwnProperty('remote')) {
					for each (control in display.display.getParameters()) {
						loadControlXML( control, xml.child('remote').child(control.name) );
					}
				}
				if(xml.hasOwnProperty('local')) {
					for each (control in display.display.getParameters()) {
						loadControlXML( control, xml.child('local').child(control.name) );
					}
				} 
				
			} else if(window is LayerWindow)  {
				
				for each (layer in Display.layers) {
					loadLayerXML( layer, xml.child('layer'+layer.index) );
				}
				
			} else if(window is SettingsWindow) {
				
				var settings:SettingsWindow = window as SettingsWindow;
				if(xml.hasOwnProperty('remote')) {
					for each (control in settings.getParameters()) {
						loadControlXML( control, xml.child('remote').child(control.name) );
					}
				}								
			}
			
		}
		
		public static function loadLayerXML(layer:LayerImplementor, xml:XMLList):void {
			
			var control:Parameter;
			var filter:Filter;
			
			// properties
			for each (control in layer.getProperties()) {
				loadControlXML( control, xml.child(control.name) );
			}
			
			// customs
			/* if(layer.controls) {
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
			} */
						
		}
		
		public static function loadControlXML(control:Parameter, xml:XMLList):void {
			
			if(xml) {
				var hashXML:String = xml.toString();
				
				// proxy				
				if(control is ParameterProxy) {
					var proxy:ParameterProxy = control as ParameterProxy;
					for each (control in proxy) {
						loadControlXML( control, xml.child(control.name) );
					}	
				// single
				} else {
					if(hashXML) {
						// store hash
						control.setMetaData(tag, uint(parseInt(hashXML)) );
						// register control
						registerControl(control, uint(parseInt(hashXML)) );
					}
				}
				
			}
			
		}
		
	}
}