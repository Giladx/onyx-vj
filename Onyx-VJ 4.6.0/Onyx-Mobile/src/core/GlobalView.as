package core
{
	import com.flashvisions.mobile.android.extensions.net.NetworkInfo;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	
	import services.remote.DirectLanConnection;
	
	import starling.events.Event;

	public class GlobalView extends Screen
	{
		private var header:Header;
		private var connect:Button;
		private var xFade:Button;
		private var txt:Label;
		//private var cnx:DirectLanConnection = DirectLanConnection.getInstance("OnyxMobile");
		private var cnx:DirectLanConnection = DirectLanConnection.getInstance();

		private var networkInfo:NetworkInfo = new NetworkInfo();			

		public function GlobalView()
		{
		}
		
		override protected function draw():void
		{
			header.width = actualWidth;
			connect.x = 10;
			connect.y = header.height;
			xFade.x = 10;
			xFade.y = header.height*2;
			txt.x = 10;
			txt.y = header.height*3;
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
			
			txt = new Label();
			addChild(txt);
		}
		
		private function onConnect(e:Event):void
		{
			cnx.connect();
			header.title = "cnx:" +networkInfo.isNetworkConnected().toString() + " avail:" +networkInfo.isNetworkAvailable().toString();
			txt.text = networkInfo.getDetailedState().toString() + "\n" + networkInfo.getCoarseState().toString() ;
			trace("connected: " + cnx.isConnected + " members: " + cnx.memberCount() + " group: " + cnx.groupInfo() );
		}
		protected function handleAutoXFadeClick(e:Event):void
		{
			cnx.sendData( {type:"toggle-cross-fader", value:1}  );
			Onyx.nav.showScreen(Onyx.LAYER1);
		}
	}
}