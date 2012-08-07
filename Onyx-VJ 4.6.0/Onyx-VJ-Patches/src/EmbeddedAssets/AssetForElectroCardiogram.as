package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/arbremarron.jpg')]
	public final class AssetForElectroCardiogram extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForElectroCardiogram() {
			super(800, 532);
		}
		
	}
}