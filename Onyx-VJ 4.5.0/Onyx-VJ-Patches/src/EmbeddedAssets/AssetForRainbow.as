package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/fox1037.png')]
	public final class AssetForRainbow extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForRainbow() {
			super(100, 100);
		}
		
	}
}