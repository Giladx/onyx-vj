package onyx.asset { 
	
	import flash.media.*;
	
	import onyx.asset.vp.VPAsset;
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
			//Console.output( '--------------------------------\nVideoPongProtocol, start of getProtocolList' );
			const list:Array = [];
			// must login first
			var folders:XML = vp.folders;
			if ( folders )
			{
				trace(folders.toString().substr(0,550));
				var response:uint = folders..ResponseCode;//0 if ok
				//select only folders for the path eg:onyx-query://vdpong/all
				var folderList:XMLList;
				var subFolder:String = '';
				var assetsList:XMLList;
				//Console.output( 'VideoPongProtocol, path: ' + path );
				if ( path.length > 20 )
				{
					var suffix:String = path.substr(20);
					//Console.output( 'VideoPongProtocol, we are in a sub-folder: ' + suffix );
					var currentFolder:String = suffix.substr( suffix.indexOf('/') + 1 );
					//Console.output( 'VideoPongProtocol, current folder: ' + currentFolder );
					folderList = folders.listfolders.folder.(@foldername==suffix).subfolder.folder; 
					if ( folderList.length() == 0 )
					{
						//no subfolders
						//add up folder button
						subFolder = suffix.substr( 0, suffix.indexOf('/') );
						//Console.output( 'VideoPongProtocol, no subfolders, we add the up one folder button to return to: ' + subFolder );
						list.push( new VideoPongAsset( '', true, subFolder  ) );
						assetsList = folders.listfolders.folder.(@foldername==subFolder).subfolder.folder.(@foldername==currentFolder).asset;
					}
					else
					{
						subFolder = folders.listfolders.folder.(@foldername==suffix).@foldername + '/';
						//Console.output( 'VideoPongProtocol, subfolders exist, we first add the up one folder button to return to: ' + subFolder );
						list.push( new VideoPongAsset( '', true ) );
						assetsList = folders.listfolders.folder.(@foldername==suffix).asset;
						trace(assetsList.length());
					}
				}
				else
				{
					//Console.output( 'VideoPongProtocol, root folder.' );
					folderList = folders.listfolders.folder;
					assetsList = folders.listfolders.asset;
					//OK all folders: var folderList:XMLList = folders..folder;
				}
				// get assets from the selected folder
				if ( assetsList.length() >0 )
				{
					//if ( DEBUG::SPLASHTIME==0 ) Console.output( 'VideoPongProtocol, number of assets: ' + assetsList.length() );
					
					for each ( var asset:XML in assetsList )
					{
						//Console.output( asset.@name + '_'+asset.@url + ''+asset.@thumb_url );
						var vpAsset:AssetFile = new VPAsset( asset.@name, asset.@url, asset.@thumb_url );
						list.push( vpAsset );
					}
				}
				//loop on resulting xmllist
				for each ( var folder:XML in folderList )
				{
					list.push( new VideoPongAsset( folder.@foldername, true, subFolder ) );
				}
			}
			else
			{
				Console.output( 'VideoPongProtocol, no folders found, please login first or have a valid sessiontoken.' );
			}
			
			return list;
		}

	}
}