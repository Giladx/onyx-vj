package onyx.asset {
	
	import flash.media.*;
	
	import mx.messaging.messages.IMessage;
	import mx.rpc.events.ResultEvent;
	
	import onyx.core.Console;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import services.videopong.VideoPong;
	
	public final class VideoPongProtocol implements IAssetProtocol {

		private const vp:VideoPong = VideoPong.getInstance();
		
		/**
		 * 
		 */
		
		public function getContent(path:String, layer:Layer ):Content {
			return new ContentVideoPong(layer, path);
		}
		
		/**
		 * 
		 */
		public function getProtocolList(path:String):Array 
		{
			const list:Array = [];
			// must login first
			var folders:XML = vp.folders;
			if ( folders )
			{
				var response:uint = folders..ResponseCode;//0 if ok
				//select only folders for the path eg:onyx-query://vdpong/all
				var folderList:XMLList;
				var subFolder:String = '';
				if ( path.length > 20 )
				{
					var folderIdList:XMLList;
					var suffix:String = path.substr(20);
					var currentFolder:String = suffix.substr( path.indexOf('/') + 1 );
					folderList = folders.listfolders.folder.(@foldername==suffix).subfolder.folder; 
					if ( folderList.length() == 0 )
					{
						//no subfolders
						list.push( new VideoPongAsset( '', true, subFolder ) );
						subFolder = suffix.substr( 0, path.indexOf('/') );
						folderIdList = folders.listfolders.folder.(@foldername==subFolder).subfolder.folder.(@foldername==currentFolder); 
						trace(subFolder);
					}
					else
					{
						subFolder = folders.listfolders.folder.(@foldername==suffix).@foldername + '/';
						folderIdList = folders.listfolders.folder.(@foldername==suffix); 
						list.push( new VideoPongAsset( '', true ) );
					}
					if ( folderIdList.length() > 0 )
					{
						var folderId:String = folderIdList.@folderid;
						vp.vpGetAssets( folderId, getAssetsHandler );
						
					}
				}
				else
				{
					folderList = folders.listfolders.folder;
					//OK all folders: var folderList:XMLList = folders..folder;
				}
				//loop on resulting xmllist
				for each ( var folder:XML in folderList )
				{
					list.push( new VideoPongAsset( folder.@foldername, true, subFolder ) );
				}
			}
			else
			{
				Console.output( 'VideoPongProtocol, no folders found, please login first.' );
			}
			return list;
		}
		public function getAssetsHandler( event:ResultEvent ):void {
			var ack:IMessage = event.message;
			trace(ack.body.toString() );
			var result:String =	ack.body.toString();
			var assets:XML = XML(result);
			
			trace( assets..ResponseCode );//0 if ok
			var assetsList:XMLList;
			assetsList = assets.listassets.asset;
			//loop on resulting xmllist
			for each ( var asset:XML in assetsList )
			{
				trace( asset.@id );
				//list.push( new VideoPongAsset( asset.@name ) );
			}
		}

	}
}