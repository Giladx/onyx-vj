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
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import midi.Midi;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.UserInterface;
	import onyx.ui.UserInterfaceControl;
	import onyx.utils.file.*;
	import onyx.utils.string.*;
	
	import ui.styles.*;
	
	/**
	 * 
	 */
	public final class MidiLoadState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var data:BitmapData;
		
		/**
		 * 	@private
		 */
		private var dbSave:Boolean;
		private var xml:XML;
		
		/**
		 * 
		 */
		public static var MIDI_XML:XML;
		private static var nowDate:String;
		
		private var _control:UserInterfaceControl;
		private var controls:Dictionary;
		/**
		 * 	@constructor
		 */
		public function MidiLoadState():void {
			var now:Date = new Date();
			var m:String = now.getHours().toString();
			var month:String = ( m.length == 1 ? "0" + m : m );
			var d:String = now.getMinutes().toString();
			var date:String = ( d.length == 1 ? "0" + d : d );
			nowDate = month + date;
			super('MidiLoadState');
								
		}
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			if(!Midi.controlsSet) {
				Midi.controlsSet = new Dictionary(true);	
			}
			
			// pause rendering
			//StateManager.pauseStates(ApplicationState.DISPLAY_RENDER);
			StateManager.pauseStates(ApplicationState.KEYBOARD);
			
			controls = UserInterface.getAllControls();
			
			// choose a directory
			var file:File = new File(AssetFile.resolvePath(ONYX_LIBRARY_PATH));//AIR_ROOT.resolvePath(ONYX_LIBRARY_PATH);
			file.browseForOpen('Select the name and location of the MIDI file to load.');
			file.addEventListener(Event.SELECT, action);
			file.addEventListener(Event.CANCEL, action);
		}
				
		/**
		 * 	@private
		 */
		private function action(event:Event):void {
			
			if (event.type === Event.SELECT) {
				var file:File = event.currentTarget as File;

				// read the file
				MIDI_XML = new XML(readTextFile(file));
				var midiXML:XMLList = MIDI_XML.controls;
				
				/* for each(var registration:WindowRegistration in WindowRegistration.registrations) {
					if(	registration.name!='KEY MAPPING' && registration.name!='PERFORMANCE' ) {
					    var win:Window = WindowRegistration.getWindow(registration.name);
					    var name:String = registration.name.replace('_',' ');
						//win.loadXML(Midi,windows[name]);
					}
				} */
				//
				for (var i:Object in controls) {
					_control = i as UserInterfaceControl;
					if (_control.getParameter().getMetaData(Midi.tag)!=null) {
						log("Name:"+_control.getParameter().name);
						log("Value:"+_control.getParameter().value);
						log("getMetaData:"+_control.getParameter().getMetaData(Midi.tag));
						//log("MidiLoadState metadata:"+_control.getParameter().value);
						log("display:"+_control.getParameter().display);
						log("parent.id:"+_control.getParameter().parent.id);
						log("defaultValue:"+_control.getParameter().defaultValue);
						log("toXML:"+_control.getParameter().toXML());
						log("_____________________________________________");
						
					}
					/* else
						_control..getParameter().getMetaData(Midi.tag).='36864'; */
					//log("MidiLoadState metadata:"+_control.getParameter().target);
					//Console.output("MidiLoadState name:"+_control.getParameter().name);
					//_control.transform.colorTransform	= MIDI_HIGHLIGHT;
					if(_control.getParameter().getMetaData(Midi.tag)) {
						Midi.controlsSet[_control] = MIDI_HIGHLIGHT_SET;
						_control.transform.colorTransform = MIDI_HIGHLIGHT_SET;
					}
				}
				var x:XML;
				for (var p:String in Parameters.getGlobalRegisteredParameters()) {
					/* x = new XML( Parameters.getRegisteredParameter(p).toXML() );
					x.nodeValue = Parameters.getRegisteredParameter(p).getMetaData('midi');
					x.@paramspace = p;
					xml.appendChild(x); */
					log("_____________________________________________");
					log( "p.toString():"+p.toString());
					//log( "0.toXML():"+Parameters.getRegisteredParameter('0').toXML() );
					//log( "0.id:"+Parameters.getRegisteredParameter('0').id );
					log( "p.toXML():"+Parameters.getRegisteredParameter(p).toXML() );
					log( "p.id:"+Parameters.getRegisteredParameter(p).id );
					log( "pget.toString:"+Parameters.getRegisteredParameter(p).toString() );
					log( "duration:"+Parameters.getRegisteredParameter(p).getParameter('duration') );
					log( "brightness:"+Parameters.getRegisteredParameter(p).getParameter('brightness') );
					log( "id:"+Parameters.getRegisteredParameter(p).getParameter('id') );
					log( "name:"+Parameters.getRegisteredParameter(p).getParameter('name') );
					log( "parent:"+Parameters.getRegisteredParameter(p).getParameter('parent') );
					//log( "midi:"+Parameters.getRegisteredParameter('rotation').getParameter('rotation').getMetaData('midi') );
					//control.setMetaData(tag, midihash); tag=midi

					var x1:XML = <parameters/>
					x1.@paramspace = p;
					for (var par:String in Parameters.getRegisteredParameter(p) ) {
						log("par:"+par);
					//	x = new XML( Parameters.getRegisteredParameter(par).toXML() );
					//	x.appendChild( (Parameters.getRegisteredParameter(par) as Parameter).getMetaData('midi'));
					//	x1.appendChild(x);
					}
					//xml.appendChild(x1);
					//xml.appendChild(x1);
				}
				//xml.appendChild(x);				
				//writeTextFile(file, xml);
				/* Midi.controlsSet[_control] = 
					Midi.registerControl(_control.getParameter(), event.midihash);
				log('_onMidi _control:'+_control+' event.midihash:'+event.midihash+' Midi.controlsSet[_control]:'+Midi.controlsSet[_control] );
				 */	
				
						
			}
			
			StateManager.removeState(this);
		}
		private function log( text:String, clear:Boolean=false ):void
		{
		    var file:File = File.applicationStorageDirectory.resolvePath( nowDate +  "midiLoadState.log" );
		    var fileMode:String = ( clear ? FileMode.WRITE : FileMode.APPEND );
		
		    var fileStream:FileStream = new FileStream();
		    fileStream.open( file, fileMode );
		
		    fileStream.writeUTFBytes( "MidiLoadState : " + text + "\n" );
		    fileStream.close();
		    
		}
				
		/**
		 * 
		 */
		override public function terminate():void {
			
			//StateManager.resumeStates(ApplicationState.DISPLAY_RENDER);
			StateManager.resumeStates(ApplicationState.KEYBOARD);
			
		}
	}
}
