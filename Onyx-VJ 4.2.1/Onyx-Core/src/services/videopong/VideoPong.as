/** 
 * This is a generated sub-class of _VideoPong.as and is intended for behavior
 * customization.  This class is only generated when there is no file already present
 * at its target location.  Thus custom behavior that you add here will survive regeneration
 * of the super-class. 
 **/

package services.videopong
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import onyx.asset.AssetFile;
	import onyx.core.Console;
	
	[Event(name="loggedin", type="flash.events.TextEvent")]
	[Event(name="foldersloaded", type="flash.events.TextEvent")]
	
	public class VideoPong extends EventDispatcher
	{
		/**
		 * 	@private
		 */
		private static var _username:String;
		private static var _pwd:String;
		private static var _domain:String;
		private var _folders:XML;
		private var _assets:XML;
		private var _folderResponse:uint;
		private var _loginResponse:uint;
		private var _sessiontoken:String;
		private var _fullUserName:String;
		private var _appkey:String;
		
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
			_username = 'username';
			_pwd = 'password';
			_domain = '';
			
			super();
		}
		
		/**
		 * Login
		 */
		public function vpLogin():void 
		{
			
			//Call videopong webservice
			var url:String = domain + '/api/login/' + username + '/' + pwd;
			var request:URLRequest = new URLRequest( url );
			//request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, loginHandler );
			loader.addEventListener( IOErrorEvent.IO_ERROR, loginHandler ); 
			loader.load( request );
			
		}		
		/**
		 * 	Result from Login
		 */
		public function loginHandler( event:Event ):void {
			
			//Console.output( 'Videopong, loginHandler, response: ' + result );
			
			if (event is ErrorEvent) 
			{
				Console.output( 'Videopong login error: ' + (event as IOErrorEvent).text );
			}
			else
			{ 
				var result:String =	event.currentTarget.data;
				var res:XML = XML(result);
				loginResponse = res..ResponseCode;//0 if ok 1 if not then it is a guest
				sessiontoken = res..SessionToken;
				fullUserName = res..UserName;
				Console.output( 'Videopong login ok: ' + fullUserName );
				var tEvent:TextEvent = new TextEvent("loggedin");
				tEvent.text = fullUserName;
				dispatchEvent( tEvent );
				
				// ask for folders tree
				loadFoldersAndAssets();
			}
		}	
		
		public function loadFoldersAndAssets():void
		{
			//var url:String = 'http://www.videopong.net/api/getfolderstreeassets/' + sessiontoken;
			var url:String = domain + '/api/getfolderstreeassets/' + sessiontoken;
			//Console.output( 'Videopong loading folders with url: ' + domain + '/api/getfolderstreeassets/' );  
			var request:URLRequest = new URLRequest( url );
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, foldersTreeHandler );
			loader.addEventListener( IOErrorEvent.IO_ERROR, foldersTreeHandler ); 
			loader.load( request );
		}
		public function foldersTreeHandler( event:Event ):void
		{
			if (event is ErrorEvent) 
			{
				Console.output( 'Videopong foldersTree error: ' + (event as IOErrorEvent).text );
			}
			else
			{
				var result:String =	event.currentTarget.data;
				folders = XML(result);
				
				folderResponse = folders..ResponseCode;//0 if ok
				Console.output( "Videopong folders loaded" ); 
				
				if ( folderResponse == 0 ) 
				{
					var tEvent:TextEvent = new TextEvent("foldersloaded");
					tEvent.text = "Folders and assets tree loaded";
					dispatchEvent( tEvent );
					//AssetFile.queryDirectory('onyx-query://vdpong', updateList);
				}
			}
		}
		
		/**
		 * getAssets based on folderId
		 */
		public function vpGetAssets( folderId:String ):XMLList {
			var assetsList:XMLList;
			assetsList = assets.asset.(@folderid == folderId);
			return assetsList;
		}		
		public function faultHandler( event:Event ):void {
			
			var faultString:String = event.currentTarget.toString();
			
			Console.output( "Videopong faultHandler: " + faultString );  
			
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
		
		public function get domain():String
		{
			return _domain;
		}
		
		public function set domain(value:String):void
		{
			_domain = value;
		}

		public function get pwd():String
		{
			return _pwd;
		}
		
		public function set pwd(value:String):void
		{
			_pwd = value;
		}
		public function get fullUserName():String
		{
			return _fullUserName;
		}
		
		public function set fullUserName(value:String):void
		{
			_fullUserName = value;
		}
		public function get username():String
		{
			return _username;
		}
		
		public function set username(value:String):void
		{
			_username = value;
		}
		public function get appkey():String
		{
			return _appkey;
		}
		
		public function set appkey(value:String):void
		{
			_appkey = value;
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
			
			
		}
	
	}
}
