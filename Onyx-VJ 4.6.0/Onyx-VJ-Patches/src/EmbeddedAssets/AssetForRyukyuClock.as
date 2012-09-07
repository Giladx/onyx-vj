package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/logo225batchass.png')]
	public final class AssetForRyukyuClock extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForRyukyuClock() {
			super(224, 225);
		}
		
	}
}