package {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/flower.jpg')]
	public final class AssetForElasticImage extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForElasticImage() {
			super(960, 386);
		}
		
	}
}