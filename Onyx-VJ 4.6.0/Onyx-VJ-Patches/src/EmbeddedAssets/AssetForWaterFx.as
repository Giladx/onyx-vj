package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/flyingtree.png')]
	public final class AssetForWaterFx extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForWaterFx() {
			super(800, 532);
		}
		
	}
}