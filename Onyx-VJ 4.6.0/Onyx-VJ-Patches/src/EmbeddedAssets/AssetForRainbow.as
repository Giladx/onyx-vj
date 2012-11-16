package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	//[Embed(source='../assets/fox1037.png')]
	//[Embed(source='../assets/logo225batchass.png')]
	[Embed(source='C:/Users/b.lane/AppData/Roaming/Onyx-VJ/Local Store/Onyx-VJ/library/champo/justrock.jpg')]
	public final class AssetForRainbow extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForRainbow() {
			super(512, 384);
		}
		
	}
}