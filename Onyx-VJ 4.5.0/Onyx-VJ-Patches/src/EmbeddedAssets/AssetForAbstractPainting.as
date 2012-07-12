package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/oeil.png')]
	public final class AssetForAbstractPainting extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForAbstractPainting() {
			super(50, 50);
		}
		
	}
}