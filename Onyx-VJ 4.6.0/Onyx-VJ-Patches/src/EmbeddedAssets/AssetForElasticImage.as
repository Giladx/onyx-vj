package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/flower.jpg')]
	//[Embed(source='../assets/wh.png')]
	public final class AssetForElasticImage extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForElasticImage() {
			super(800, 801);
		}
		
	}
}