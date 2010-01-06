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
			Console.output( '--------------------------------\nVideoPongProtocol, start of getProtocolList' );
			const list:Array = [];
			// must login first
			var folders:XML = vp.folders;
			if ( folders )
			{
				var response:uint = folders..ResponseCode;//0 if ok
				//select only folders for the path eg:onyx-query://vdpong/all
				var folderList:XMLList;
				var subFolder:String = '';
				Console.output( 'VideoPongProtocol, path: ' + path );
				if ( path.length > 20 )
				{
					//var folderIdList:XMLList;
					var suffix:String = path.substr(20);
					Console.output( 'VideoPongProtocol, we are in a sub-folder: ' + suffix );
					var currentFolder:String = suffix.substr( suffix.indexOf('/') + 1 );
					Console.output( 'VideoPongProtocol, current folder: ' + currentFolder );
					folderList = folders.listfolders.folder.(@foldername==suffix).subfolder.folder; 
					if ( folderList.length() == 0 )
					{
						//no subfolders
						//add up folder button
						subFolder = suffix.substr( 0, suffix.indexOf('/') );
						Console.output( 'VideoPongProtocol, first / in the path at position: ' + path.indexOf('/') );
						Console.output( 'VideoPongProtocol, no subfolders, we add the up one folder button to return to: ' + subFolder );
						list.push( new VideoPongAsset( '', true, subFolder  ) );
						//list.push( new VideoPongAsset( '', true, subFolder  ) );
						//folderIdList = folders.listfolders.folder.(@foldername==subFolder).subfolder.folder.(@foldername==currentFolder); 
						trace(subFolder);
						// get assets from the selected folder
						var assetsList:XMLList = folders.listfolders.folder.(@foldername==subFolder).subfolder.folder.(@foldername==currentFolder).asset;
						trace(assetsList);
						if ( assetsList.length() >0 )
						{
							Console.output( 'VideoPongProtocol, number of assets: ' + assetsList.length() );
							
							for each ( var asset:XML in assetsList )
							{
								var vpAsset:AssetFile = new VPAsset( asset.@name, asset.@url+vp.sessiontoken, asset.@ext, asset.@thumb_url );
								list.push( vpAsset );
							}
						}
					}
					else
					{
						subFolder = folders.listfolders.folder.(@foldername==suffix).@foldername + '/';
						Console.output( 'VideoPongProtocol, subfolders exist, we first add the up one folder button to return to: ' + subFolder );
						//folderIdList = folders.listfolders.folder.(@foldername==suffix); 
						list.push( new VideoPongAsset( '', true ) );
					}
				}
				else
				{
					Console.output( 'VideoPongProtocol, root folder.' );
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
			Console.output( 'VideoPongProtocol, returning list\n--------------------------------' );
			
			return list;
		}

	}
}