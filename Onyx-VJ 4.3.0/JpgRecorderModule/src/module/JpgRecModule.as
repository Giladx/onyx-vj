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
 * 
 */
package module {
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
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
		//private const frames:Array		= [];
		
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
				
				// clear all frames
				//frames.splice(0, frames.length);
				
				// add listener
				Display.addEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);
				
			} else {
				
				// remove listener
				Display.removeEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);
				
				// build bytes
				/*var file:ONRFile		= new ONRFile();
				file.setFrames(frames);*/
				
				// pause states
				//Display.pause(true);
				
				// pause keyboard
				//StateManager.pauseStates(ApplicationState.KEYBOARD);
				
				// save
				//AssetFile.browseForSave(saveHandler, 'Where do you want to save the file to?', file.toByteArray(), 'onr');
				
			}
			
			// 
			parameters.getParameter('status').value = currentFrame + ' frames';
			
		}
		
		/**
		 * 	@private
		 */
		private function saveHandler(... args:Array):void {
			
			// resume states
			//Display.pause(false);
			
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
			
			// save the frame
			// frames.push(Display.source.clone());
			
			// update frames
			parameters.getParameter('status').value = currentFrame + ' frames';
			
			// Save JPG
			var jpgFile:File = new File( AssetFile.resolvePath( 'library/recorded/' + currentFrame++ +'.jpg' ) );
			var stream:FileStream = new FileStream();
			jpgFile.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			stream.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			stream.open( jpgFile, FileMode.WRITE );
			stream.writeBytes( encodeJPG( Display.source.clone() ) );
			stream.close();
			
			if (currentFrame >= maxframes) {
				record = false;
			}
			
		}
		//jpg encoding
		private function encodeJPG( bd:BitmapData ):ByteArray
		{
			var jpgEncoder:JPGEncoder = new JPGEncoder();
			var bytes:ByteArray = jpgEncoder.encode(bd);
			return bytes;
		} 
		private function ioErrorHandler( event:IOErrorEvent ):void
		{
			Console.output( 'JpgRecorderModule, An IO Error has occured: ' + event.text );
		}    
		
	}
}