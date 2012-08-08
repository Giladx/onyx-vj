package plugins.filters {
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import onyx.plugin.Filter;
	import onyx.plugin.IBitmapFilter;

	public final class Scroller extends Filter implements IBitmapFilter {
		
		private var scrollX:int	= 0;
		private var scrollY:int	= 0;
		
		public var speedX:int	= 5;
		public var speedY:int	= 0;
		
		private var buffer:BitmapData;
		
		public function Scroller():void {
			super(true);
		}
		
		override public function initialize():void {
			buffer = createDefaultBitmap();
		}
		
		public function applyFilter(source:BitmapData):void {
			scrollX = (scrollX + speedX) % DISPLAY_WIDTH,
			scrollY = (scrollY + speedY) % DISPLAY_HEIGHT;
			
			if (scrollX < 0) {
				scrollX = (DISPLAY_WIDTH + scrollX);
			}
			
			if (scrollY < 0) {
				scrollY = (DISPLAY_HEIGHT + scrollY);
			}
			
			var rect1:Rectangle, rect2:Rectangle, rect3:Rectangle;
			
			// empty the buffer
			buffer.fillRect(DISPLAY_RECT, 0);
			
			// create the rects
			rect1 = new Rectangle(DISPLAY_WIDTH - scrollX,scrollY,scrollX,DISPLAY_HEIGHT - scrollY);
			// rect2 = new Rectangle(scrollX,DISPLAY_HEIGHT - scrollY, DISPLAY_WIDTH - scrollX, scrollY);
			
			// scroll the bitmap
			buffer.copyPixels(source, rect1, new Point(0, scrollY));
			// buffer.copyPixels(source, rect2, new Point(scrollX, 0));
			
			// source.fillRect(DISPLAY_RECT, 0);
			source.scroll(scrollX, scrollY);
			source.draw(buffer);
			//source.draw(buffer, new Matrix(1,0,0,1,rect1.width - DISPLAY_WIDTH));
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			buffer.dispose();
			super.dispose();
		}
	}
}