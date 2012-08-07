package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/ganesh_1.jpg')]
	public final class AssetForPixelDistortion extends BitmapData {
		
		public function AssetForPixelDistortion() {
			super(1024, 768);
		}
		
	}
}