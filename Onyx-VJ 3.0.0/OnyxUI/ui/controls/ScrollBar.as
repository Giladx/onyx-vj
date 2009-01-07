package ui.controls {
	
	import flash.display.Sprite;
	
	import ui.styles.*;

	public final class ScrollBar extends Sprite {
	
		/**
		 * 	@constructor
		 */	
		public function ScrollBar():void {
			graphics.beginFill(SCROLLBAR_COLOR);
			graphics.drawRect(0,0,6,100);
			graphics.endFill();
		}
	}
}