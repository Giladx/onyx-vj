package {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/jesus800.png')]
	public final class AssetForPixelDistortion extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForPixelDistortion() {
			super(800, 600);
		}
		
	}
}