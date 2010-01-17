package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.events.*;
	import onyx.plugin.*;
	
	public final class PreviewWindow extends Window {
		
		/**
		 * 	@private
		 */
		private const preview:Bitmap	= new Bitmap(Display.source, PixelSnapping.ALWAYS, true);

		/**
		 * 	Constructor
		 */
		public function PreviewWindow(reg:WindowRegistration):void {
			
			super(reg, true, 490, 385);
			
			preview.x		= 5;
			preview.y		= 20;
			preview.width	= 480; //Math.min(480, DISPLAY_WIDTH);
			preview.height	= 360; //Math.min(360, DISPLAY_HEIGHT);
			addChild(preview);
			
			// add listeners			
			addEventListener(MouseEvent.MOUSE_DOWN,			mouseHandler);

			
		}
		
		/**
		 * 	@private
		 */
		private function mouseHandler(event:MouseEvent):void {
			
			var e:InteractionEvent = new InteractionEvent(event.type);
			
			e.localX	= preview.mouseX;
			e.localY	= preview.mouseY;
			
			// forward the event
			Display.forwardEvent(e);
			
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
				
					DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE,	mouseHandler);
					DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP,		mouseHandler);
			
					break;
				case MouseEvent.MOUSE_UP:

					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP,			mouseHandler);
					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			// remove listeners
			removeEventListener(MouseEvent.MOUSE_DOWN,				mouseHandler);

			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP,				mouseHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,			mouseHandler);
			
			//
			super.dispose();
		}
	}
}