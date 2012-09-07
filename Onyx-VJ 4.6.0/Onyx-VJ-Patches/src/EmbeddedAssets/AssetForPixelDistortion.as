package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/clark630x353.jpg')]
	public final class AssetForPixelDistortion extends BitmapData {
		
		public function AssetForPixelDistortion() {
			super(630, 353);
		}
		
	}
}