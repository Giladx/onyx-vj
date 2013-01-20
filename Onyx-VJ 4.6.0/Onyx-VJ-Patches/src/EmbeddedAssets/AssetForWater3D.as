package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../../assets/AssetForWater3D.jpg')]
	public final class AssetForWater3D extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForWater3D() {
			super(200, 200);
		}
		
	}
}