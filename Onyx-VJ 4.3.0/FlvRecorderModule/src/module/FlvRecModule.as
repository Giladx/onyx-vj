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
	
	import flash.desktop.NotificationType;
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
		
		private var _realtime:Boolean		= false;

		private const frames:Array		= [];
		
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
				new ParameterInteger('maxframes', 'max frames', 24, 6000, maxframes),
				new ParameterBoolean('record', 'record'),
				new ParameterBoolean('realtime', 'realtime'),
				new ParameterStatus('status', 'status')
			);
			
		}
		
		/**
		 * 
		 */
		public function set record(value:Boolean):void {
			
			this.recording	= value;
			
			// pause?
			if ( !realtime ) Display.pause(!value);
			
			// if it's recording
			if (value) 
			{
				// clear all frames
				if ( !realtime ) frames.splice(0, frames.length);
				
				var date:Date = new Date();
				var dateFilename:String = date.getHours() + 'h' + date.getMinutes() + 'mn' + date.getSeconds() + (realtime ? "realtime" : "notrealtime");
				// FLV file open
				var flvFile:File = new File( AssetFile.resolvePath( 'library/recorded/' + dateFilename +'.flv' ) );
				myWriter = SimpleFlvWriter.getInstance();
				myWriter.createFile( flvFile, DISPLAY_WIDTH, DISPLAY_HEIGHT, DISPLAY_STAGE.frameRate );
				// add listener
				Display.addEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);
				
			} 
			else 
			{
				// remove listener
				Display.removeEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);				
				if ( realtime ) 
				{
					for ( var i:int=0; i < ( frames.length -1 ); i++ )
					{
						myWriter.saveFrame( frames.shift() );
					}
					
					frames.splice( 0, frames.length );
					// resume states
					Display.pause(false);
					
				}
				
				myWriter.closeFile();
				currentFrame = 0;
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
						
			// save the frame
			if ( realtime )
			{
				frames.push(Display.source.clone());
			}
			else
			{
				myWriter.saveFrame( Display.source.clone() );
			}
			// update frames
			parameters.getParameter('status').value = currentFrame++ + ' frames';
			
			if (currentFrame >= maxframes) {
				record = false;	
			}
			
			
		}

		private function ioErrorHandler( event:IOErrorEvent ):void
		{
			Console.output( 'FlvRecorderModule, An IO Error has occured: ' + event.text );
		}    

		/**
		 * 	@private
		 */
		public function get realtime():Boolean
		{
			return _realtime;
		}

		/**
		 * @private
		 */
		public function set realtime(value:Boolean):void
		{
			_realtime = value;
		}


	}
}