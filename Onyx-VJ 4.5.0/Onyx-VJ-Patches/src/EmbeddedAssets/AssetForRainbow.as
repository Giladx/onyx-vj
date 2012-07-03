package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	//[Embed(source='../assets/fox1037.png')]
	[Embed(source='../assets/logo225batchass.png')]
	public final class AssetForRainbow extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForRainbow() {
			super(225, 225);
		}
		
	}
}