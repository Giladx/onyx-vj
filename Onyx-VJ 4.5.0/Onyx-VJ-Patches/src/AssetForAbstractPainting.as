package {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	[Embed(source='../assets/flower.jpg')]
	public final class AssetForAbstractPainting extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForAbstractPainting() {
			super(800, 801);
		}
		
	}
}