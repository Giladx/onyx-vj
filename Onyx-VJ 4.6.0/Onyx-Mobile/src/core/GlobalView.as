package core
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	
	import services.remote.DirectLanConnection;
	
	import starling.events.Event;

	public class GlobalView extends Screen
	{
		private var header:Header;
		private var connect:Button;
		private var xFade:Button;
		private var cnx:DirectLanConnection = DirectLanConnection.getInstance("OnyxMobile");

		public function GlobalView()
		{
			
		}
		
		override protected function draw():void
		{
			header.width = actualWidth;
			connect.x = 10;
			connect.y = header.height;
		}
		
		override protected function initialize():void
		{
			header = new Header();
			header.title = "Onyx";
			addChild(header);
			
			connect = new Button();
			connect.label = "Connect";
			connect.addEventListener(Event.TRIGGERED, onConnect);
			connect.pivotX = connect.pivotY * 0.5;
			addChild(connect);
			
			xFade = new Button();
			xFade.label = "xFade";
			xFade.addEventListener(Event.TRIGGERED, handleAutoXFadeClick);
			xFade.pivotX = connect.pivotY * 0.5;
			addChild(xFade);
			
				
		}
		
		private function onConnect(e:Event):void
		{
			trace("connect");
			cnx.connect("60000");
		}
		protected function handleAutoXFadeClick(e:Event):void
		{
			cnx.sendData( {type:"toggle-cross-fader", value:1}  );
		}
	}
}