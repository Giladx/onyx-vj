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
 package onyx.net {
 	
 	import flash.events.*;
 	import flash.net.XMLSocket;
 	import flash.utils.*;
 	
 	import onyx.core.Console;
 	import onyx.errors.*;
 	import onyx.events.*;
 	import onyx.file.*;
 	import onyx.midi.*;

	/**
	 * 
	 */
	public class NthCmdClient extends NthPersistentClient {
		
		/**
		 * 	@private
		 */
		private static const instance:NthCmdClient = new NthCmdClient();

		/**
		 * 	@private
		 */
		private var _tosend:String;

		/**
		 * 	@private
		 */
		private var _path:String;

		/**
		 * 	@constructor
		 */
		public function NthCmdClient() {
			super();
			if ( instance ) {
				throw INVALID_CLASS_CREATION;
			}
		}
		
		public static function getInstance():NthCmdClient {
			return instance;
		}
		
		public function listMidiInputs():void {
	     	_sendXML("<list_midi_inputs/>");
		}
		
		public function listMidiOutput():void {
	     	_sendXML("<list_midi_outputs/>");
		}
		
		public function writeMidi(m:MidiMsg, deviceIndex:int = -1):void {
			var x:XML = m.toXML()
			// Ideally, this should add a 'deviceindex=#' attribute when
			// deviceIndex is specified.
	     	var s:String = "<write_midi>"+x.toXMLString()+"</write_midi>";
	     	_sendXML(s);
		}
		
		public function readFile(path:String):void {
			_path = path;
	     	_sendXML("<read_file><name>"+path+"</name></read_file>");
		}
		
		public function writeFile(path:String, data:String):void {
			_path = path;
	     	_sendXML("<write_file><name>"+path+"</name><data>"+escape(data)+"</data></write_file>");
		}
		
		public function writeFileBytes(path:String, bytes:ByteArray):void {
			_path = path;
			var writedata:String = "";
			bytes.position = 0;
			while ( bytes.bytesAvailable > 0 ) {
				var s:String = String.fromCharCode(bytes.readByte());
				writedata = writedata.concat(escape(s));
			}
	     	_sendXML("<write_file><name>"+path+"</name><data>"+writedata+"</data></write_file>");
		}
		
		public function listDir(path:String):void {
			_path = path;
	     	_sendXML("<list_dir><name>"+path+"</name></list_dir>");
		}
		
		private function _sendXML(s:String):void {
			if ( connected ) {
		     	this.send(s);
			} else {
				_tosend = s;
			}
		}
		
	    override protected function connectHandler(event:Event):void {
	    	super.connectHandler(event);
	    	Console.output("NthCmdClient is connected to NthServer...");
	    	if ( _tosend != null ) {
		     	this.send(_tosend);
		    }
	    }
	    
		override protected function closeHandler(event:Event):void {
			Console.output("NthCmdClient has been disconnected...");
			super.closeHandler(event);
		}

		override protected function dataHandler(event:DataEvent):void {
			
			var client:NthCmdClient = event.currentTarget as NthCmdClient;
			var path:String = client._path;
			
	        var x:XML = new XML(event.data);
	        
	       	// A read_file will produce <file_contents>
	       	// A write_file will produce an <ok>
	       	// A list_dir will produce a <directory>
	       	// A write_midi will produce an <ok>
	       	// An error will produce a <error>
	       	
	        var e:NthCmdEvent;
	        var fe:NthFileEvent;
	        
	        if ( x.localName() == "error" ) {
	        	e = new NthCmdEvent(NthCmdEvent.DONE);
	        	e.error = x.toString();
	        	dispatchEvent(e);
	        	return;
	        }
	        
	        if ( x.localName() == "ok" ) {
	        	e = new NthCmdEvent(NthCmdEvent.DONE);
	        	dispatchEvent(e);
	        	return;
	        }
	        
	        if ( x.localName() == "file_contents" ) {
	        	fe = new NthFileEvent(NthCmdEvent.DONE,x);
	        	fe.path = path;
				fe.fileData = unescape(x.toString());
	        	dispatchEvent(fe);
				return;
	        }
	        
	        if ( x.localName() == "directory" ) {
	        	fe = new NthFileEvent(NthCmdEvent.DONE,x);
	        	fe.path = path;
				// create the Folder
				var list:FolderList = new FolderList(path);
				for each (var f:XML in x.*) {
					var name:String = f.toString().toLowerCase();
					if ( f.localName() == "file" ) {
						list.files.push(new File(path + name, ''));
					} else if ( f.localName() == "dir" ) {
						if (name === '..') {
							name = path.substr(0, path.lastIndexOf('/', path.length - 2)) + '/';
						} else {
							name = path + "/" + name;
						}
						list.folders.push(new Folder(name));
					}
				}
				fe.folderList = list;
				dispatchEvent(fe);
				return;
			}
			
        	e = new NthCmdEvent(NthCmdEvent.DONE);
	       	e.error = "Unknown NthCmdClient response: "+x.localName();
	       	dispatchEvent(e);
	    }
	}
}