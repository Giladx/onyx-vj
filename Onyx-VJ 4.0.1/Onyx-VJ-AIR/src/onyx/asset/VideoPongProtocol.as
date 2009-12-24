package onyx.asset {
	
	import flash.media.*;
	
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
			var folders:XML = vp.folders;
			if ( folders )
			{
				var response:uint = folders..ResponseCode;//0 if ok
				list.push( new VideoPongAsset( folders.listfolders.folder[0].foldername,true ) );
				//list.push(new VideoPongAsset("2nd"));
				//list.push(new VideoPongAsset("2nd"));
				
			}
			return list;
		}

	}
}