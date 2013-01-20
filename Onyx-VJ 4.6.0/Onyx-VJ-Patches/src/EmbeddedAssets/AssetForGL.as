package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../../assets/imgthe-fountain2.jpg')]
	public final class AssetForGL extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForGL() {
			super(320, 180);
		}
		
	}
}