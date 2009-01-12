package plugins.filters {
	
	import flash.display.BitmapData;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class FrameSkip extends Filter implements IBitmapFilter {
		
		public var skip:int	 			= 2;
		public var randomize:Boolean	= true;
		private var skipCount:int		= 0;
		
		private var buffer:BitmapData;

		/**
		 * 
		 */		
		public function FrameSkip():void {
			parameters.addParameters(
				new ParameterInteger('skip', 'skip', 0, 12, skip),
				new ParameterBoolean('randomize', 'randomize')
			);
		}
		
		override public function initialize():void {
			buffer = createDefaultBitmap();
		}
		
		public function applyFilter(source:BitmapData):void {
			
			if (skipCount-- <= 0) {
				buffer.copyPixels(source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
				if (randomize) {
					skipCount = Math.random() * skip;
				} else {
					skipCount = skip;
				}
			} else if (buffer) {
				source.copyPixels(buffer, DISPLAY_RECT, ONYX_POINT_IDENTITY);
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			super.dispose();
			if (buffer) {
				buffer.dispose();
			}
		}
	}
}