package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	//[Embed(source='../assets/oeil.png')]
	[Embed(source='C:/Users/b.lane/AppData/Roaming/Onyx-VJ/Local Store/Onyx-VJ/library/anabel/gtr34.jpg')]
	public final class AssetForAbstractPainting extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForAbstractPainting() {
			super(50, 50);
		}
		
	}
}