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
				var folderList:XMLList = folders..folder;
				//var folderList:XMLList = folders.(folder=="all").folder;
				//loop on resulting xmllist
				for each ( var folder:XML in folderList )
				{
					//folder.@foldername = folder.foldername;
					
					list.push( new VideoPongAsset( folder.@foldername,true ) );
				}
			}
			else
			{
				Console.output( 'VideoPongProtocol, no folders found' );
			}
			return list;
		}

	}
}