/** 
 * This is a generated sub-class of _VideoPong.as and is intended for behavior
 * customization.  This class is only generated when there is no file already present
 * at its target location.  Thus custom behavior that you add here will survive regeneration
 * of the super-class. 
 **/
 
package services.videopong
{
	import mx.messaging.messages.IMessage;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import onyx.core.Console;
	import onyx.plugin.Display;
	
	public class VideoPong extends _Super_VideoPong
	{
		/**
		 * 	@private
		 */
		private static var _username:String;
		private static var _pwd:String;
		private var _folders:XML;
		private var _assets:XML;
		private var _folderResponse:uint;
		private var _loginResponse:uint;
		private var vpLoginResponder:CallResponder;
		private var vpFoldersResponder:CallResponder;
		private var vpAssetsResponder:CallResponder;
		private var _sessiontoken:String;

		/**
		 * 	VideoPong class instance
		 */
		private static const vpInstance:VideoPong = new VideoPong();
		
		/**
		 * 	Returns the VideoPong instance (singleton)
		 *  to avoid multiple instances
		 */
		public static function getInstance():VideoPong {
			return vpInstance;
		}

		// Constructor
		public function VideoPong()
		{
			super();
		}
	               
		/**
		 * Login
		 */
		public function vpLogin():void {
			
			//Call videopong webservice
			//vp = new VideoPong();
			//Display.pause(true);//TODO: remove!
			vpLoginResponder = new CallResponder();
			// addEventListener for response
			vpLoginResponder.addEventListener( ResultEvent.RESULT, loginHandler );
			vpLoginResponder.addEventListener( FaultEvent.FAULT, faultHandler );
			//Console.output( "VideopongWindow, VideoPong Login" );
			//vp.operations
			vpLoginResponder.token = login( "onyxapi", "login", username, pwd, 0 );
		}		
		/**
		 * 	Result from Login
		 */
		public function loginHandler( event:ResultEvent ):void {
			
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			var res:XML = XML(result);
			
			loginResponse = res..ResponseCode;//0 if ok 1 if not then it is a guest
			sessiontoken = res..SessionToken;
			
			Console.output( "VideopongWindow, loginHandler, response: " + loginResponse );  
			// ask for folders tree
			vpFoldersResponder = new CallResponder();
			// addEventListener for response
			vpFoldersResponder.addEventListener( ResultEvent.RESULT, foldersTreeHandler );
			vpFoldersResponder.addEventListener( FaultEvent.FAULT, faultHandler );
			//vp.operations
			vpFoldersResponder.token = getfolderstreeassets( "onyxapi", "getfolderstreeassets", sessiontoken, "1" );
			
		}		
		public function foldersTreeHandler( event:ResultEvent ):void {
			
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			folders = XML(result);
			
			folderResponse = folders..ResponseCode;//0 if ok
			Console.output( "VideopongWindow, foldersTreeHandler, ResponseCode: " + folderResponse );  
			//if ( folderResponse == 0 ) retrieveAssets();
			
		}
		/**
		 *  retrieveAssets based on folders xml result
		 */
		/*private function retrieveAssets( ):void 
		{
			var folderList:XMLList = folders..folder; // all folders
			vpAssetsResponder = new CallResponder();
			// addEventListener for response
			vpAssetsResponder.addEventListener( ResultEvent.RESULT, getAssetsHandler );
			vpAssetsResponder.addEventListener( FaultEvent.FAULT, faultHandler );

			assets = <assets />;
			//loop on resulting xmllist
			for each ( var folder:XML in folderList )
			{
				trace("calling getassets with folderid: " + folder.@folderid );
				vpAssetsResponder.token = getassets( "onyxapi", "getassets", folder.@folderid, sessiontoken );
				vpAssetsResponder.token.folderid = folder.@folderid;
			}			
		}*/		
		/**
		 *  
		 */
		/*public function getAssetsHandler( event:ResultEvent ):void {
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			var assetsXML:XML = XML(result);
			
			trace( assetsXML..ResponseCode );//0 if ok
			var assetsList:XMLList;
			assetsList = assetsXML.listassets.asset;
			//loop on resulting xmllist
			for each ( var asset:XML in assetsList )
			{
				trace( asset.@id );
				asset.@["folderid"] = event.token.folderid;
				assets.appendChild( asset );
			}
			trace("assets from folderid: " + event.token.folderid + "=" + assets);
		}*/
		/**
		 * getAssets based on folderId
		 */
		public function vpGetAssets( folderId:String ):XMLList {
			var assetsList:XMLList;
			assetsList = assets.asset.(@folderid == folderId);
			return assetsList;
		}		
		public function faultHandler( event:FaultEvent ):void {
			
			var faultString:String = event.fault.faultString;
			var faultDetail:String = event.fault.faultDetail;
			
			Console.output("VideopongWindow, faultHandler, faultString: "+faultString);  
			Console.output("VideopongWindow, faultHandler, faultDetail: "+faultDetail);  
			
		}	
		public function get folders():XML
		{
			return _folders;
		}
		
		public function set folders(value:XML):void
		{
			_folders = value;
		}
		
		public function get sessionToken():String
		{
			return sessiontoken;
		}
		
		public function set sessionToken(value:String):void
		{
			sessiontoken = value;
		}
		
		public function get pwd():String
		{
			return _pwd;
		}
		
		public function set pwd(value:String):void
		{
			_pwd = value;
		}
		
		public function get username():String
		{
			return _username;
		}
		
		public function set username(value:String):void
		{
			_username = value;
		}

		public function get folderResponse():uint
		{
			return _folderResponse;
		}

		public function set folderResponse(value:uint):void
		{
			_folderResponse = value;
		}

		public function get loginResponse():uint
		{
			return _loginResponse;
		}

		public function set loginResponse(value:uint):void
		{
			_loginResponse = value;
		}

		public function get sessiontoken():String
		{
			return _sessiontoken;
		}

		public function set sessiontoken(value:String):void
		{
			_sessiontoken = value;
		}

		public function get assets():XML
		{
			return _assets;
		}

		public function set assets(value:XML):void
		{
			_assets = value;
		}
		/**
		 * 	@public
		 */
		public function dispose():void {
			
			if ( vpLoginResponder )
			{
				if ( vpLoginResponder.hasEventListener( ResultEvent.RESULT ) ) vpLoginResponder.removeEventListener( ResultEvent.RESULT, loginHandler );
				if ( vpLoginResponder.hasEventListener( FaultEvent.FAULT ) ) vpLoginResponder.removeEventListener( FaultEvent.FAULT, faultHandler );
			}
			if ( vpFoldersResponder )
			{
				if ( vpFoldersResponder.hasEventListener( ResultEvent.RESULT ) ) vpFoldersResponder.removeEventListener( ResultEvent.RESULT, foldersTreeHandler );
				if ( vpFoldersResponder.hasEventListener( FaultEvent.FAULT ) ) vpFoldersResponder.removeEventListener( FaultEvent.FAULT, faultHandler );
			}
			/*if ( vpAssetsResponder )
			{
				if ( vpAssetsResponder.hasEventListener( ResultEvent.RESULT ) ) vpAssetsResponder.removeEventListener( ResultEvent.RESULT, getAssetsHandler );
				if ( vpAssetsResponder.hasEventListener( FaultEvent.FAULT ) ) vpAssetsResponder.removeEventListener( FaultEvent.FAULT, faultHandler );
			}*/
			
		}


	}
}
