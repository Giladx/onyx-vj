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
package onyx.asset.vp {
	
	import flash.utils.*;
	
	import mx.messaging.messages.IMessage;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import onyx.asset.*;
	import onyx.core.Console;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import services.videopong.*;
	
	/**
	 * 
	 */
	public final class VPAdapter implements IAssetAdapter {
		
		//private var console:Console = Console.getInstance();
		private var vpLoginResponder:CallResponder;
		private var vpFoldersResponder:CallResponder;
		private var vp:VideoPong;
		private var sessiontoken:String;
		/**
		 * 	Cache
		 */
		private static const cache:Object = {};
		
		/**
		 * 
		 */
		public static function getDirectoryCache(path:String):VPDirectoryQuery {
			return cache[path];
		}
		
		/**
		 * 
		 */
		public function VPAdapter():void {
			 
			//Call videopong webservice
			vp = new VideoPong();
			
			vpLoginResponder = new CallResponder();
			// addEventListener for response
			vpLoginResponder.addEventListener( ResultEvent.RESULT, loginHandler );
			vpLoginResponder.addEventListener( FaultEvent.FAULT, faultHandler );
			Console.output( "VideoPong Login" );
			//vp.operations
			vpLoginResponder.token = vp.login(  "onyxapi","login","batchass","vptest",0 );
		}
		/**
		 * 	Result from Login
		 */
		public function loginHandler( event:ResultEvent ):void {
			
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			var res:XML = XML(result);
			
			var response:uint = res..ResponseCode;//0 if ok 1 if not then it is a guest
			sessiontoken = res..SessionToken;
			
			Console.output("loginHandler, response: "+response);  
			trace("loginHandler, sessiontoken: "+sessiontoken);  
			// ask for folders tree
			vpFoldersResponder = new CallResponder();
			// addEventListener for response
			vpFoldersResponder.addEventListener( ResultEvent.RESULT, foldersTreeHandler );
			vpFoldersResponder.addEventListener( FaultEvent.FAULT, faultHandler );
			Console.output( "VideoPong Login" );
			//vp.operations
			vpFoldersResponder.token = vp.getfolderstree( "onyxapi", "getfolderstree", sessiontoken, "1" );
			
		}		
		public function foldersTreeHandler( event:ResultEvent ):void {
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			var res:XML = XML(result);
			
			var response:uint = res..ResponseCode;//0 if ok
			
		}
		public function faultHandler( event:FaultEvent ):void {
			
			var faultString:String = event.fault.faultString;
			var faultDetail:String = event.fault.faultDetail;
			
			Console.output("faultHandler, faultString: "+faultString);  
			Console.output("faultHandler, faultDetail: "+faultDetail);  
			
		}		
		/**
		 * 	Queries a directory
		 */
		public function queryDirectory(path:String, callback:Function):void {
			
			cache[path] = new VPDirectoryQuery(path, callback);
			
		}
		
		/**
		 * 	Resolves a path to content
		 */
		public function queryContent(path:String, callback:Function, layer:Layer, settings:LayerSettings, transition:Transition):void {
			new VPContentQuery(path, callback, layer, settings, transition);
		}
		
		/**
		 * 
		 */
		public function save(path:String, callback:Function, bytes:ByteArray, extension:String):void {
			//new VPSaveQuery(path, callback, bytes);
		}
		
		/**
		 * 
		 */
		public function queryFile(path:String, callback:Function):void {
			/*var query:AIRReadQuery = new AIRReadQuery(path, callback);
			query.query();*/
		}
		
		/**
		 * 
		 */
		public function browseForSave(callback:Function, title:String, bytes:ByteArray, extension:String):void {
			
		}
		
		/**
		 * 
		 */
		public function resolvePath(path:String):String {
			return "";
		}
		
		/**
		 * 
		 */
		public function quit():void {
			vpLoginResponder.removeEventListener( ResultEvent.RESULT, loginHandler );
			vpLoginResponder.removeEventListener( FaultEvent.FAULT, faultHandler );

		}
	}
}
