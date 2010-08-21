/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * Alchemy version by Mateusz Malczak ( http://segfaultlabs.com )
 * 
 */
package module {
	
	import cmodule.jpegencoder.CLibInit;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.bitmap.JPGEncoder;
		
	/**
	 * 
	 */
	public final class JpgRecModule extends Module {
				
		/**
		 * 	@private
		 */
		private var recording:Boolean		= false;
		
		/**
		 * 
		 */
		public var maxframes:int		= 600;
		
		/**
		 * 
		 */
		public var currentFrame:int		= 0;

		private var lib : Object; //alchemy library 
		private var timer:uint;

		/**
		 * 	@constructor
		 */
		public function JpgRecModule():void {
			
			// init ui
			super(new ModuleInterfaceOptions(null, 145, 100, 102, 101));
			
			// add parameters
			parameters.addParameters(
				new ParameterInteger('maxframes', 'max frames', 24, 600, maxframes),
				new ParameterBoolean('record', 'record'),
				new ParameterStatus('status', 'status')
			);
			
			// init alchemy object
			var init:CLibInit = new CLibInit(); //get library obejct
			lib = init.init(); // initialize library exported class  
		}
		
		/**
		 * 
		 */
		public function set record(value:Boolean):void {
			
			this.recording	= value;
			
			// pause?
			//Display.pause(!value);
			
			// if it's recording
			if (value) {
				
				// add listener
				Display.addEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);
				
			} else {
				
				// remove listener
				Display.removeEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);				
			}
			
			// 
			parameters.getParameter('status').value = currentFrame + ' frames';
			
		}
		
		/**
		 * 	@private
		 */
		private function saveHandler(... args:Array):void {
						
			// resume
			StateManager.resumeStates(ApplicationState.KEYBOARD);
			
		}
		
		/**
		 * 
		 */
		public function get record():Boolean {
			return recording;
		}
		
		/**
		 * 	@private
		 */
		private function saveFrame(event:Event):void {
						
			// update frames
			parameters.getParameter('status').value = currentFrame + ' frames';
			
			// Save JPG
			var jpgFile:File = new File( AssetFile.resolvePath( 'library/recorded/' + currentFrame++ +'.jpg' ) );
			var stream:FileStream = new FileStream();
			jpgFile.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			stream.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			stream.open( jpgFile, FileMode.WRITE );
			stream.writeBytes( alchemySync( Display.source.clone() ) );
			stream.close();
			
			if (currentFrame >= maxframes) {
				record = false;
			}
			
		}
		//jpg encoding
		/*private function encodeJPG( bd:BitmapData ):ByteArray
		{
			var jpgEncoder:JPGEncoder = new JPGEncoder();
			var bytes:ByteArray = jpgEncoder.encode(bd);
			return bytes;
		} */
		private function ioErrorHandler( event:IOErrorEvent ):void
		{
			Console.output( 'JpgRecorderModule, An IO Error has occured: ' + event.text );
		}    
		private function alchemySync( bd:BitmapData ):ByteArray
		{
			var ba:ByteArray;
			ba = bd.getPixels( bd.rect );
			ba.position = 0;
			var baout:ByteArray = new ByteArray();
			
			//timer = getTimer();
			
			lib.encode( ba, baout, bd.width, bd.height, 80 );
			
			//timer = flash.utils.getTimer() - timer;
			//Console.output( 'JPEG compression time (alchemy sync) : ' + timer + 'ms\nJPEG size : ' + baout.length );
			return baout;
		}
		
	}
}