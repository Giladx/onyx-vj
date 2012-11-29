package core
{
	//import com.flashvisions.mobile.android.extensions.net.NetworkInfo;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	
	import services.remote.NetworkUtil;
	import services.remote.PeerToPeerConnection;
	
	import starling.events.Event;

	public class GlobalView extends Screen
	{
		private var header:Header;
		private var connect:Button;
		private var xFade:Button;
		private var blackFade:Button;
		private var moreFps:Button;
		private var lessFps:Button;
		private var bgndColor:Button;
		private var txt:Label;
		private var cnx:PeerToPeerConnection;

		//private var networkInfo:NetworkInfo = new NetworkInfo();			
		private var padLeft:int = 5;
		private var btnWidth:int = 180;

		public function GlobalView()
		{
		}
		
		override protected function draw():void
		{
			

			btnWidth = actualWidth/3;
			header.width = actualWidth;
			connect.x = padLeft;
			connect.y = header.height;
			connect.width = btnWidth;
			xFade.x = padLeft;
			xFade.y = header.height*2;
			xFade.width = btnWidth;
			bgndColor.x = padLeft;
			bgndColor.y = header.height*3;
			bgndColor.width = btnWidth;
			moreFps.x = actualWidth/2;
			moreFps.y = header.height;
			moreFps.width = btnWidth;
			lessFps.x = actualWidth/2;
			lessFps.y = header.height*2;
			lessFps.width = btnWidth;
			blackFade.x = actualWidth/2;
			blackFade.y = header.height*3;
			blackFade.width = btnWidth;
			txt.x = padLeft;
			txt.y = header.height*4;
		}
		
		override protected function initialize():void
		{
			header = new Header();
			header.title = "Onyx-VJ";
			addChild(header);
			
			connect = new Button();
			connect.label = "Connect";
			connect.addEventListener(Event.TRIGGERED, onConnect);
			connect.pivotX = connect.pivotY * 0.5;
			addChild(connect);
			
			xFade = new Button();
			xFade.label = "xFade";
			xFade.addEventListener(Event.TRIGGERED, handleAutoXFadeClick);
			xFade.pivotX = xFade.pivotY * 0.5;
			addChild(xFade);
			
			bgndColor = new Button();
			bgndColor.label = "Background color";
			bgndColor.addEventListener(Event.TRIGGERED, handleBgndColorClick);
			bgndColor.pivotX = bgndColor.pivotY * 0.5;
			addChild(bgndColor);
			
			moreFps = new Button();
			moreFps.label = "FPS +";
			moreFps.addEventListener(Event.TRIGGERED, handleFrameRateUpClick);
			moreFps.pivotX = moreFps.pivotY * 0.5;
			addChild(moreFps);
			
			lessFps = new Button();
			lessFps.label = "FPS -";
			lessFps.addEventListener(Event.TRIGGERED, handleFrameRateDownClick);
			lessFps.pivotX = lessFps.pivotY * 0.5;
			addChild(lessFps);
			
			blackFade = new Button();
			blackFade.label = "Fade to Black";
			blackFade.addEventListener(Event.TRIGGERED, handleFadeBlackClick);
			blackFade.pivotX = blackFade.pivotY * 0.5;
			addChild(blackFade);
			
			txt = new Label();
			addChild(txt);
		}
		
		private function onConnect(e:Event):void
		{
			cnx = PeerToPeerConnection.getInstance();
			PeerToPeerConnection.ipAddresses = NetworkUtil.getIpAddresses();
			cnx.connect();
			cnx.sendData( {type:"peername", value:"OnyxMobile-" + PeerToPeerConnection.ipAddresses} );
			/*header.title = "cnx:" +networkInfo.isNetworkConnected().toString() + " avail:" +networkInfo.isNetworkAvailable().toString();
			txt.text = networkInfo.getDetailedState().toString() + "\n" + networkInfo.getCoarseState().toString() + cnx.memberCount() ;*/
			txt.text = "connected: " + PeerToPeerConnection.isConnected + " members: " + cnx.memberCount();
			
		}
		
		protected function handleAutoXFadeClick(e:Event):void
		{
			cnx.sendData( {type:"toggle-cross-fader", value:1}  );
			//Onyx.nav.showScreen(Onyx.LAYER1);
		}
		protected function handleFrameRateUpClick(e:Event):void
		{
			cnx.sendData( {type:"frame-rate-increase", value:1}  );
		}
		
		protected function handleFrameRateDownClick(e:Event):void
		{
			cnx.sendData( {type:"frame-rate-decrease", value:0}  );
		}
		protected function handleFadeBlackClick(e:Event):void
		{
			cnx.sendData( {type:"fade-black", value:1}  );
		}
		protected function handleBgndColorClick(e:Event):void
		{
			Onyx.nav.showScreen(Onyx.BGNDCOLOR);
		}
	}
}