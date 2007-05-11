package ui.controls {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.utils.math.*;

	public final class UnClippedContainer extends Sprite {
		
		/**
		 * 	Display
		 */
		public function display(object:DisplayObject, addObject:DisplayObject):void {

			var local:Point = object.localToGlobal(POINT);
			super.x			= max(local.x, 0);
			super.y			= max(local.y, 0);
			
			STAGE.addChild(this);
			
			// add the item to this
			addChild(addObject);
		}
		
		/**
		 * 	Remove
		 */
		public function remove():void {
			
			// clear graphics
			graphics.clear();
			
			// remove everything
			if (super.parent) {
				STAGE.removeChild(this);
			}
			
			while (super.numChildren) {
				super.removeChildAt(0);
			}
		}
		
	}
}