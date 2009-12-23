package onyx.asset {
	
	import flash.media.*;
	
	import onyx.display.*;
	import onyx.plugin.*;
	
	import ui.window.VideopongWindow;
	
	public final class VideoPongProtocol implements IAssetProtocol {

		private var vpFoldersResponder:CallResponder;
		private var vp:VideoPong;
		private var sessiontoken:String;
		
		/**
		 * 
		 */
		private var _folders:XML;
		
		public function getContent(path:String, layer:Layer ):Content {
			return new ContentVideoPong(layer, path);
		}
		
		/**
		 * 
		 */
		public function getProtocolList(path:String):Array 
		{
			const list:Array = [];
			//var folders:XML = VideopongWindow.path;
			//var response:uint = folders..ResponseCode;//0 if ok
			list.push(new VideoPongAsset("1st"));
			//list.push(new VideoPongAsset("2nd"));
			//list.push(new VideoPongAsset("2nd"));
			return list;
		}
		public function foldersTreeHandler( event:ResultEvent ):void {
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			folders = XML(result);
			
			//var response:uint = folders..ResponseCode;//0 if ok
		}
		public function faultHandler( event:FaultEvent ):void {
			
			var faultString:String = event.fault.faultString;
			var faultDetail:String = event.fault.faultDetail;
			
			Console.output("VideoPongProtocol, faultHandler, faultString: "+faultString);  
			Console.output("VideoPongProtocol, faultHandler, faultDetail: "+faultDetail);  
			
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
		

	}
}