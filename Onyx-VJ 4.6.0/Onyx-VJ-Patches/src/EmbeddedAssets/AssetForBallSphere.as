package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/ganesh75.png')]
	public final class AssetForBallSphere extends BitmapData {
		
		public function AssetForBallSphere() {
			super(75, 75);
		}
		
	}
}