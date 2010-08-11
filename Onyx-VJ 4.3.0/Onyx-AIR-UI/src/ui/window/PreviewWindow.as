package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	
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

		/**
		 * 	@private
		 */
		private var bothButton:TextButton;
		
		/**
		 * 	@private
		 */
		private var channelAButton:TextButton;
		
		/**
		 * 	@private
		 */
		private var channelBButton:TextButton;
		
		/**
		 * 	@private
		 */
		private var maximizeButton:TextButton;
		
		private var _current:int = 0;

		/**
		 * 	Constructor
		 */
		public function PreviewWindow(reg:WindowRegistration):void {
			
			super(reg, true, 490, 395);
			
			var options:UIOptions		= new UIOptions();
			options.height				= 12,
				options.width				= 65;
			
			bothButton		= new TextButton(options, 'OUTPUT');
			channelAButton	= new TextButton(options, 'CHANNEL A');
			channelBButton		= new TextButton(options, 'CHANNEL B');
			maximizeButton		= new TextButton(options, 'FULLSCREEN');
			
			bothButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			channelAButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			channelBButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			maximizeButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			
			bothButton.x		= 4;
			bothButton.y		= 17;
			channelAButton.x	= 86;
			channelAButton.y	= 17;
			channelBButton.x	= 168;
			channelBButton.y	= 17;
			maximizeButton.x	= 250;
			maximizeButton.y	= 17;
			
			// add
			addChild(bothButton);
			addChild(channelAButton);
			addChild(channelBButton);
			addChild(maximizeButton);
			preview.x		= 5;
			preview.y		= 30;
			preview.width	= 480; //Math.min(480, DISPLAY_WIDTH);
			preview.height	= 360; //Math.min(360, DISPLAY_HEIGHT);
			addChild(preview);
			
			// add listeners			
			addEventListener(MouseEvent.MOUSE_DOWN,			mouseHandler);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,	mouseHandler);
			addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,	mouseHandler);

			// make draggable
			DragManager.setDraggable(this);
			
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
				case bothButton:
					_current = 0;
					break;
				case channelAButton:
					_current = 1;
					break;
				case channelBButton:
					_current = 2;
					break;
				case maximizeButton:
					_current = 0;
					preview.width	= 1200; 
					preview.height	= 760;
					preview.parent.width = 1300;
					preview.parent.height = 800;
					preview.parent.x = 10;
					preview.parent.y = 10;
					
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

		/**
		 * 	@private
		 */
		public function get current():int
		{
			return _current;
		}

	}
}