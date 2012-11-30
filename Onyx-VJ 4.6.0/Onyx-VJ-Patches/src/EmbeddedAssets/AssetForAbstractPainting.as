package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	//[Embed(source='../assets/oeil.png')]
	[Embed(source='C:/Users/b.lane/AppData/Roaming/Onyx-VJ/Local Store/Onyx-VJ/library/ici.jpg')]
	public final class AssetForAbstractPainting extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForAbstractPainting() {
			super(720, 265);
		}
		
	}
}