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
package onyx.utils.updater 
{
	import air.update.ApplicationUpdater;
	import air.update.events.DownloadErrorEvent;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import onyx.core.Console;
	
	public final class OnyxAIRUpdate 
	{

		protected static var appUpdater:ApplicationUpdater;
		protected static var isInstallPostponed:Boolean = false;
		public static var appName:String = '';
		public static var updateDescription:String = '';
		public static var installedVersion:String = '';
		public static var updateVersion:String = '';
	
		/**
		 * 	checks website for update
		 */
		public static function checkForUpdate():void 
		{ 
			installedVersion = getApplicationVersion();
			Console.output( 'checkForUpdate' );
			appUpdater = new ApplicationUpdater();
			setApplicationVersion(); // Find the current version so we can show it below  
			// Configuration stuff - see update framework docs for more details  
			appUpdater.updateURL = "http://www.batchass.fr/onyxvj/updateonyx.xml"; // Server-side XML file describing update  
			appUpdater.addEventListener( UpdateEvent.INITIALIZED, updaterInitializedHandler ); // Once initialized, run onUpdate  
			appUpdater.addEventListener( ErrorEvent.ERROR, updaterErrorHandler  ); // If something goes wrong, run onError  
			appUpdater.addEventListener( StatusUpdateEvent.UPDATE_STATUS, updaterStatusHandler );
			appUpdater.addEventListener( StatusUpdateErrorEvent.UPDATE_ERROR, updaterErrorHandler );			
			appUpdater.initialize(); // Initialize the update framework  
		} 
		
		/**
		 * 	
		 */
	
		protected static function updaterDownloadStartHandler( event: UpdateEvent ):void
		{
			Console.output(  "Update download started. Please wait..." );
		}

		/**
		 * 	
		 */
		
		private static function updaterDownloadCompleteHandler( event: UpdateEvent ):void
		{
			// avoid auto install
			// because ( appUpdater.isInstallUpdateVisible ) doesn't work
			event.preventDefault();
			isInstallPostponed = true;
			//updateBtn.visible = false;
			Console.output( "Update downloaded, it will be installed on next Razuna Desktop launch." );
			appUpdater.installUpdate();
		}
		
		/**
		 * 	
		 */
		
		private static function updaterStatusHandler( event : StatusUpdateEvent ):void
		{	
			var updateAvailable:Boolean = event.available;
			Console.output( "updaterStatusHandler, updateAvailable:" + updateAvailable );
			
			if ( updateAvailable )
			{
				//updateBtn.visible = true;
				// avoid auto download
				// because ( appUpdater.isDownloadUpdateVisible ) doesn't work
				event.preventDefault();				
				Console.output( "updaterStatusHandler, getApplicationName:" + getApplicationName() );
				appName = getApplicationName() || getApplicationName();
				Console.output( "updaterStatusHandler, appName:" + appName );
				updateVersion = event.version;
				Console.output( "updaterStatusHandler, updateVersion:" + updateVersion );
				updateDescription = getUpdateDescription( event.details );
				Console.output( "Onyx-VJ " + installedVersion + " New version " + updateVersion + " is available, click on Update button!" );
			}
			else 
			{
				Console.output( "updaterStatusHandler, no update available" );
			}
		}
		
		/**
		 * 	
		 */
		
		public static function downloadUpdate():void
		{
			appUpdater.addEventListener( UpdateEvent.DOWNLOAD_START, updaterDownloadStartHandler );
			appUpdater.addEventListener( UpdateEvent.DOWNLOAD_COMPLETE, updaterDownloadCompleteHandler );			
			appUpdater.addEventListener( UpdateEvent.BEFORE_INSTALL, updaterBeforeInstallHandler );
			appUpdater.addEventListener( DownloadErrorEvent.DOWNLOAD_ERROR, updaterErrorHandler );
			appUpdater.downloadUpdate();
		}
		
		/**
		 * 	
		 */
		
		protected static function getUpdateDescription( details: Array ):String
		{
			var text:String = "";
			
			if (details.length == 1)
			{
				text = details[0][1];
				Console.output( "getUpdateDescription, text: " + text );
			} 
			
			return text;
		}
		
		/**
		 * 	
		 */
		
		private static function updaterBeforeInstallHandler( event: UpdateEvent ):void
		{
			if ( isInstallPostponed )
			{
				event.preventDefault();
				isInstallPostponed = false;
			}
			
		}
		
		/**
		 * 	
		 */
		
		private static function getApplicationVersion():String
		{
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			return appXML.ns::version; 
		}
		
		/**
		 * 	
		 */
		
		private static function getApplicationName():String
		{
			var applicationName: String;
			var xmlNS:Namespace = new Namespace("http://www.w3.org/XML/1998/namespace");
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			// filename is mandatory
			var elem:XMLList = appXML.ns::filename;
			// use name is if it exists in the application descriptor
			if ((appXML.ns::name).length() != 0)
			{
				elem = appXML.ns::name;
			}
			// See if element contains simple content
			if (elem.hasSimpleContent())
			{
				applicationName = elem.toString();
			}
			
			return applicationName;
		}
		
		/**
		 * 	
		 */
		
		private static function cleanUp( e:Event ):void 
		{  
			if ( appUpdater )
			{
				appUpdater.removeEventListener( UpdateEvent.INITIALIZED, updaterInitializedHandler );
				appUpdater.removeEventListener( StatusUpdateEvent.UPDATE_STATUS, updaterStatusHandler );
				appUpdater.removeEventListener( UpdateEvent.DOWNLOAD_START, updaterDownloadStartHandler );
				appUpdater.removeEventListener( UpdateEvent.DOWNLOAD_COMPLETE, updaterDownloadCompleteHandler );
				appUpdater.removeEventListener( UpdateEvent.BEFORE_INSTALL, updaterBeforeInstallHandler );
				appUpdater.removeEventListener( ErrorEvent.ERROR, updaterErrorHandler );
				appUpdater.removeEventListener( DownloadErrorEvent.DOWNLOAD_ERROR, updaterErrorHandler );
				appUpdater.removeEventListener( StatusUpdateErrorEvent.UPDATE_ERROR, updaterErrorHandler );
				appUpdater = null;
			}
		}
		
		/**
		 * 	
		 */
		
		private static function updaterErrorHandler (event:ErrorEvent):void 
		{  
			Console.output( "appUpdater,onError: " + event.toString() );  
		}  
		
		/**
		 * 	
		 */
		
		private static function updaterInitializedHandler(event:UpdateEvent):void 
		{  
			isInstallPostponed = false;
			appUpdater.checkNow(); // Go check for an update now  
		}  

		/**
		 * 	
		 */
		
		private static function setApplicationVersion():void 
		{  
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;  
			var ns:Namespace = appXML.namespace();  
			Console.output( "Onyx-VJ version: " + appXML.ns::version ); 
		} 
		
		
	}
	
}