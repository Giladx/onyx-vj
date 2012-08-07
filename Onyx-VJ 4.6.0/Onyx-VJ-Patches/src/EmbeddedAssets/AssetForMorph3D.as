package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/ball.png')]
	public final class AssetForMorph3D extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForMorph3D() {
			super(100, 100);
		}
		
	}
}