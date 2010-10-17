package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.plugin.*;
	
	import ui.controls.TextButton;
	import ui.controls.UIOptions;
	import ui.core.DragManager;
	
	public final class PreviewWindow extends Window {
		
		/**
		 * 	@private
		 */
		private const preview:Bitmap	= new Bitmap(Display.source, PixelSnapping.ALWAYS, true);
	
		private const channelA:Bitmap	= new Bitmap(Display.channelA, PixelSnapping.ALWAYS, true);
		private const channelB:Bitmap	= new Bitmap(Display.channelB, PixelSnapping.ALWAYS, true);
		
		/**
		 * 	@private
		 */
		private var maximizeButton:TextButton;
		private var maximized:Boolean = false;
		
		private var toggleA:TextButton;
		private var toggleB:TextButton;
		
		/**
		 * 	Constructor
		 */
		public function PreviewWindow(reg:WindowRegistration):void {
			
			super(reg, true, 490, 400);
			
			var options:UIOptions		= new UIOptions();
			options.height				= 12,
			options.width				= 65;
			
			maximizeButton	= new TextButton(options, 'Toggle size');
			toggleA			= new TextButton(options, 'CH A');
			toggleB			= new TextButton(options, 'CH B');
			
			maximizeButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			toggleA.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			toggleA.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, handlerCh);
			toggleA.addEventListener(MouseEvent.MOUSE_UP, handlerCh);
			toggleB.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			toggleB.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, handlerCh);
			toggleB.addEventListener(MouseEvent.MOUSE_UP, handlerCh);
			
			maximizeButton.x	= 4,
			maximizeButton.y	= 18;
			toggleA.x 			= 72,
			toggleA.y 			= 18;
			toggleB.x 			= 140,
			toggleB.y 			= 18;
			
			// add
			addChild(maximizeButton);
			addChild(toggleA);
			addChild(toggleB);
			
			preview.x		= 5;
			preview.y		= 35;
			preview.width	= 480; //Math.min(480, DISPLAY_WIDTH);
			preview.height	= 360; //Math.min(360, DISPLAY_HEIGHT);
			addChild(preview);
			
			channelA.alpha  = 1;
			channelA.x		= 5;
			channelA.y		= 35;
			channelA.width	= 240;
			channelA.height	= 180;
			addChild(channelA);
			
			channelB.alpha  = 1;
			channelB.x		= 5;
			channelB.y		= 215;
			channelB.width	= 240;
			channelB.height	= 180;
			addChild(channelB);
			
			// add listeners			
			addEventListener(MouseEvent.MOUSE_DOWN,			mouseHandler);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,	mouseHandler);
			addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,	mouseHandler);
			
			
			// make draggable
			DragManager.setDraggable(this);
			
		}
		
		private function handlerCh(event:MouseEvent):void {
			switch(event.type) {
				case MouseEvent.MOUSE_WHEEL:
					if((event.currentTarget.parent as TextButton).label=='CH A')
						channelA.alpha += event.delta/100; 
					else if((event.currentTarget.parent as TextButton).label=='CH B')
						channelB.alpha += event.delta/100;
					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:
					Console.output(event.target);
					event.target.addEventListener(MouseEvent.MOUSE_WHEEL, handlerCh);
					break;
				case MouseEvent.MOUSE_UP:	
					event.target.removeEventListener(MouseEvent.MOUSE_WHEEL, handlerCh);
			}
		}
		
		/**
		 * 	Handles mouse clicks on preview windows
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
				case MouseEvent.MIDDLE_MOUSE_DOWN:

					DISPLAY_STAGE.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,	mouseHandler);
					DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:

					DISPLAY_STAGE.addEventListener(MouseEvent.RIGHT_MOUSE_UP,	mouseHandler);
					DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
				case MouseEvent.MOUSE_UP:

					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP,			mouseHandler);
					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
				case MouseEvent.MIDDLE_MOUSE_UP:
				
					DISPLAY_STAGE.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,	mouseHandler);
					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
				case MouseEvent.RIGHT_MOUSE_UP:
				
					DISPLAY_STAGE.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,	mouseHandler);
					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
			}
		}
		/**
		 * handles clicks on buttons
		 */
		private function handler(event:MouseEvent):void {
			switch (event.currentTarget) {
				case maximizeButton:
					if ( maximized ) {
						maximized 		= false;
						preview.width	= 480; 
						preview.height	= 360;
						preview.parent.width = 580;
						preview.parent.height = 400;

					} else	{
						maximized 		= true;
						preview.width	= 1200; 
						preview.height	= 760;
						preview.parent.width = 1300;
						preview.parent.height = 800;
						preview.parent.x = 10;
						preview.parent.y = 10;
					}
					break;
				case toggleA:
					channelA.visible = !channelA.visible;
					break;
				case toggleB:
					channelB.visible = !channelB.visible;
					break;
			}
		}		
		/**
		 * 
		 */
		override public function dispose():void {
			
			// remove listeners
			removeEventListener(MouseEvent.MOUSE_DOWN,				mouseHandler);
			removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,		mouseHandler);
			removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,		mouseHandler);

			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP,				mouseHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,		mouseHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,		mouseHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,			mouseHandler);
			
			//
			super.dispose();
		}
	}
}