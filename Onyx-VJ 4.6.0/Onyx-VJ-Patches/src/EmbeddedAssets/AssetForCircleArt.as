package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='C:/Users/b.lane/AppData/Roaming/Onyx-VJ/Local Store/Onyx-VJ/library/ici.jpg')]
	public final class AssetForCircleArt extends BitmapData {
		
		public function AssetForCircleArt() {
			super(720, 265);
		}
		
	}
}