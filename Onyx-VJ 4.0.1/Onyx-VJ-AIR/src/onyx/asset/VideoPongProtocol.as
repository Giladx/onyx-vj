package onyx.asset {
	
	import flash.display.Loader;
	import flash.media.*;
	
	import onyx.display.*;
	import onyx.plugin.*;
	
	public final class VideoPongProtocol implements IAssetProtocol {
		
		/**
		 * 
		 */
		public function getContent(path:String, layer:Layer ):Content {
			return new ContentVideoPong(layer, path);
		}
		
		/**
		 * 
		 */
		public function getProtocolList(path:String):Array {
			const list:Array = [];
				list.push(new VideoPongAsset("1st"));
				list.push(new VideoPongAsset("2nd"));
			return list;
		}
	}
}