package onyx.asset {
	
	import flash.media.*;
	
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
					//var url:String = VideoPongAsset.assetsUrl;// folders.listfolders.folder.(@foldername==path.substr(20)).@url;
					folderList = folders.listfolders.folder.(@foldername==path.substr(20)).subfolder.folder; 
					if ( folderList.length() == 0 )
					{
						//no subfolders
						var suffix:String = path.substr(20);
						subFolder = suffix.substr( 0, path.indexOf('/') );
						list.push( new VideoPongAsset( '', true, subFolder ) );
						trace(subFolder);
					}
					else
					{
						subFolder = folders.listfolders.folder.(@foldername==path.substr(20)).@foldername + '/';
						list.push( new VideoPongAsset( '', true ) );
					}
					//folderList = folders.listfolders.folder.(foldername.toString().search(path.substr(20)) > -1).folder; 
				}
				else
				{
					folderList = folders.listfolders.folder;
					//OK all folders: var folderList:XMLList = folders..folder;
				}
					
				
				//var folderList:XMLList = folders..(folder.toString().search("public") > -1).folder;
				//var folderList:XMLList = folders..folder.(folder.toString().search("public") > -1);
				//loop on resulting xmllist
				for each ( var folder:XML in folderList )
				{
					//folder.@foldername = folder.foldername;
					
					list.push( new VideoPongAsset( folder.@foldername, true, subFolder, folder.@url ) );
				}
			}
			else
			{
				Console.output( 'VideoPongProtocol, no folders found, please login first.' );
			}
			return list;
		}

	}
}