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
 * Uses SimpleFlvWriter from Lee Felarca
 * http://www.zeropointnine.com/blog
 * 
 */
package module {
	
	import com.zeropointnine.SimpleFlvWriter;
	
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
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
		
	/**
	 * 
	 */
	public final class FlvRecModule extends Module {
				
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
		private var myWriter:SimpleFlvWriter;

		/**
		 * 	@constructor
		 */
		public function FlvRecModule():void {
			
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
				
				// FLV file open
				var flvFile:File = new File( AssetFile.resolvePath( 'library/recorded/' + currentFrame++ +'.flv' ) );
				myWriter = SimpleFlvWriter.getInstance();
				myWriter.createFile(flvFile, DISPLAY_WIDTH, DISPLAY_HEIGHT, DISPLAY_STAGE.frameRate );//,  120);
				// add listener
				Display.addEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);
				
			} else {
				
				myWriter.closeFile();
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
			
			myWriter.saveFrame( Display.source.clone() );
			
			if (currentFrame >= maxframes) {
				record = false;	
			}
			
		}

		private function ioErrorHandler( event:IOErrorEvent ):void
		{
			Console.output( 'FlvRecorderModule, An IO Error has occured: ' + event.text );
		}    

		
	}
}