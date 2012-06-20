package {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/ballsphere.jpg')]
	public final class AssetForPixelDistortion extends BitmapData {
		
		public function AssetForPixelDistortion() {
			super(225, 225);
		}
		
	}
}