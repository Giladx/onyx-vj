package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='C:/Users/b.lane/AppData/Roaming/Onyx-VJ/Local Store/Onyx-VJ/library/ici.png')]
	public final class AssetForBox2DImages extends BitmapData {

		public function AssetForBox2DImages() {
			super(192, 192);
		}
		
	}
}