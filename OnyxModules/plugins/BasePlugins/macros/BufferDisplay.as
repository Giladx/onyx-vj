package macros {
	
	import flash.utils.Dictionary;
	
	import onyx.constants.*;
	import onyx.display.IDisplay;
	import onyx.plugin.*;
	import onyx.display.Layer;
	import onyx.display.Display;
	import onyx.controls.ControlPlugin;
	import onyx.core.Plugin;
	import flash.display.BitmapData;
	import flash.events.Event;

	public final class BufferDisplay extends Macro {
		
		private var renderer:Plugin;
		private var bitmaps:Array		= [];
		private var current:int;
		private var save:Boolean		= true;
		
		override public function keyDown():void {
			
			var display:Display			= AVAILABLE_DISPLAYS[0];
			
			// get the renderer plugin being used
			var plugin:Plugin	= display.controls.getControl('renderer').value as Plugin;
			
			display.addEventListener(Event.ENTER_FRAME, _saveBitmap);
		}
		
		private function _saveBitmap(event:Event):void {
			var display:Display			= AVAILABLE_DISPLAYS[0];
			var len:int = bitmaps.length;
			if (len > 5) {
				var bitmap:BitmapData = bitmaps[current++ % len] 
				display.rendered.copyPixels(bitmap, BITMAP_RECT, POINT);
				
			// save every other 
			} else {
				if (save) {
					bitmaps.push(display.rendered.clone());
				}
				save = !save;
			}
		}
		
		override public function keyUp():void {
			var display:Display			= AVAILABLE_DISPLAYS[0];
			display.removeEventListener(Event.ENTER_FRAME, _saveBitmap);
			
			while (bitmaps.length) {
				var bitmap:BitmapData = bitmaps.shift() as BitmapData;
				bitmap.dispose();
			}
		}
	}
}