package core
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class Layer1View extends Screen
	{
		private var header:Header;
		private var backButton:Button;
		//private var label:Label;

		public function Layer1View()
		{
			

		}
		override protected function draw():void
		{
			header.width = actualWidth;
			/*backButton.x = 10;
			backButton.y = header.height;*/
		}
		
		override protected function initialize():void
		{
			header = new Header();
			header.title = "Onyx";
			addChild(header);
			
			backButton = new Button();
			backButton.label = "Back";
			backButton.addEventListener(Event.TRIGGERED, onBack);
			backButton.pivotX = backButton.pivotY * 0.5;
			//addChild(backButton);
			header.leftItems = new <DisplayObject>[backButton];
			
			
		}
		
		private function onBack(e:Event):void
		{
			dispatchEventWith("complete");
			Onyx.nav.showScreen(Onyx.GLOBAL);
		}

	}
}