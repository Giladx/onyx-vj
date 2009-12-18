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
	
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import onyx.asset.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import services.videopong.*;
	
	/**
	 * 
	 */
	public final class VPAdapter implements IAssetAdapter {
		
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
			var vp:VideoPong = new VideoPong();
			
			var vpCallResponder:CallResponder = new CallResponder();
			// addEventListener for response
			vpCallResponder.addEventListener( ResultEvent.RESULT, loginHandler );
			vpCallResponder.addEventListener( FaultEvent.FAULT, faultHandler );
			//vp.operations
			vpCallResponder.token = vp.login(  "onyxapi","login","batchass","vptest",0 );
		}
		/**
		 * 	Result from Login
		 */
		public function loginHandler( event:ResultEvent ):void {
			
			var response:uint = event.result.Response.ResponseCode;//0 if ok
			var sess:String = event.result.Response.SessionToken;
			
			trace("loginHandler, res: "+response);  
			trace("loginHandler, sess: "+sess);  
			
		}		
		public function faultHandler( event:FaultEvent ):void {
			
			var faultString:String = event.fault.faultString;//0 if ok
			var faultDetail:String = event.fault.faultDetail;
			
			trace("faultHandler, faultString: "+faultString);  
			trace("faultHandler, faultDetail: "+faultDetail);  
			
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
			
		}
	}
}
