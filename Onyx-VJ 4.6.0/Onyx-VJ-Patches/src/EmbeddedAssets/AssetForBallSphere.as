package EmbeddedAssets {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='C:/Users/b.lane/AppData/Roaming/Onyx-VJ/Local Store/Onyx-VJ/library/ici50.png')]
	public final class AssetForBallSphere extends BitmapData {
		
		public function AssetForBallSphere() 
		{
			super(50, 50);
		}
		
	}
}
