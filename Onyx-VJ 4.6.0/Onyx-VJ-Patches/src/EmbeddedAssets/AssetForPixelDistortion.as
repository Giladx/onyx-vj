package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='C:/Users/b.lane/AppData/Roaming/Onyx-VJ/Local Store/Onyx-VJ/library/champo/champofficiel.jpg')]
	public final class AssetForPixelDistortion extends BitmapData {
		
		public function AssetForPixelDistortion() {
			super(630, 353);
		}
		
	}
}