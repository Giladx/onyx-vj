package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../../assets/paintbg1024.jpg')]
	public final class AssetForImageDots extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForImageDots() {
			super(1024, 768);
		}
		
	}
}