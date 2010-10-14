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
package core {
	
	import core.ID;
	
	import events.SoundEvent;
	
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
	//import ui.window.*;
	
	import sound.ISoundControlBehavior;
	
	final public class Sound extends Module {
		
		public static const SOUND_LOW:int               = 0x01;
		public static const SOUND_MID:int              	= 0x02;
        public static const SOUND_HIGH:int   			= 0x03;
                                   
		/**
		 * 	Instance
		 */
		public static const instance:Sound 			= new Sound();
		private static const REUSABLE:SoundEvent	= new SoundEvent(SoundEvent.SOUND,new ByteArray());
				
		/**
		 * 	Move layer's SOUND
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
		 * 	Behavior/soundhash crossmap
		 */
		private static var _map:Dictionary;
		
		        
		/**
		 * 	@constructor
		 */
		public function Sound():void {
			
			// check unique
			if (instance)
				throw new Error('');
						
			_map = new Dictionary(false);
			
			// add listeners
			_moveEvents = 0;
			//for each(var layer:LayerImplementor in Display.layers)
			//	layer.addEventListener(LayerEvent.LAYER_MOVE, _swapLayers);
			
		}
									        

		public static function registerControl(control:Parameter, soundhash:uint):ColorTransform {
			
			if(control && soundhash) {
            	
            	// check if alredy have this soundhash
				for (var val:Object in _map) {
					if(val==soundhash.toString() ) {
						if (_map[val]) {
							controlsSet[(_map[val].control as Parameter).getMetaData(ID)] = SOUND_HIGHLIGHT;
							unregisterControl(soundhash);
						}
					}
				}
								
	            // store the hash inside CONTROL
	            control.setMetaData(ID, soundhash);
				controlsSet[control] = SOUND_HIGHLIGHT_SET(soundhash);
				
	            // create behaviors
	            var behavior:ISoundControlBehavior;

				if (control is ParameterNumber)
					behavior = new NumericBehavior(control as ParameterNumber);
				else if (control is ParameterArray)
					behavior = new NumericRange(control as ParameterArray);
				
				_map[soundhash] = behavior;
				
				//do style
				return controlsSet[control];

            }
            
            // error
            return null;
            
		}
		
		public static function unregisterControl(soundhash:uint):void {
			if (_map[soundhash]) {
				delete _map[soundhash].control.getMetaData(ID);			
				delete _map[soundhash];
			}           
		}
			
				
		/**
		 *  swap layers
		 **/
		/*public static function _swapLayers(event:LayerEvent):void {
			
			_moveEvents++;
                           
            if(_moveEvents==1) {
            	
            	_layerTo 	= event.target as LayerImplementor;
            	_backupTo 	= _backupControls(_layerTo.getProperties());
            		
            } else if(_moveEvents==2) {
            	
            	_layerFrom 	= event.target as LayerImplementor;	
            	
            	for each(var controlTo:Parameter in _layerTo.getProperties()) {
            		controlTo.setMetaData(ID, _layerFrom.getProperties().getParameter(controlTo.name).getMetaData(ID));
            		registerControl( controlTo,
            						 controlTo.getMetaData(ID) as uint );	
            	}
            	for each(var controlFrom:Parameter in _layerFrom.getProperties()) {
            		controlFrom.setMetaData(ID, _backupTo[controlFrom.name]);
            		registerControl( controlFrom,
            						 controlFrom.getMetaData(ID) as uint );
            	}
            		
            	_moveEvents = 0; 
            }
            
        }*/
        
		
		public static function onSound():void {
			var midihash:uint;
			var behavior:ISoundControlBehavior = _map[midihash];	
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
			
				if(	control.getMetaData(ID)!=null && control.getMetaData(ID)!=0 ) {
					xml.@midi = control.getMetaData(ID);
				}
				
			}
						
			return xml;
			
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
				
				if(hashXML) {
					// proxy				
					if(control is ParameterProxy) {
						var proxy:ParameterProxy = control as ParameterProxy;
						for each (control in proxy) {
							fromControlXML( control, xml.child(control.name) );
						}	
					// single
					} else {
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
	