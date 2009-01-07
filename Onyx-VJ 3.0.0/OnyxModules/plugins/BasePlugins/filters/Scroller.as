package filters {
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
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
			buffer = BASE_BITMAP();
		}
		
		public function applyFilter(source:BitmapData):void {
			scrollX = (scrollX + speedX) % BITMAP_WIDTH,
			scrollY = (scrollY + speedY) % BITMAP_HEIGHT;
			
			if (scrollX < 0) {
				scrollX = (BITMAP_WIDTH + scrollX);
			}
			
			if (scrollY < 0) {
				scrollY = (BITMAP_HEIGHT + scrollY);
			}
			
			var rect1:Rectangle, rect2:Rectangle, rect3:Rectangle;
			
			// empty the buffer
			buffer.fillRect(BITMAP_RECT, 0);
			
			// create the rects
			rect1 = new Rectangle(BITMAP_WIDTH - scrollX,scrollY,scrollX,BITMAP_HEIGHT - scrollY);
			// rect2 = new Rectangle(scrollX,BITMAP_HEIGHT - scrollY, BITMAP_WIDTH - scrollX, scrollY);
			
			// scroll the bitmap
			buffer.copyPixels(source, rect1, new Point(0, scrollY));
			// buffer.copyPixels(source, rect2, new Point(scrollX, 0));
			
			// source.fillRect(BITMAP_RECT, 0);
			source.scroll(scrollX, scrollY);
			source.draw(buffer);
			//source.draw(buffer, new Matrix(1,0,0,1,rect1.width - BITMAP_WIDTH));
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