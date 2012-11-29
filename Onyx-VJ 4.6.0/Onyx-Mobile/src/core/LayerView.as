package core
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	
	import services.remote.P2PEvent;
	import services.remote.PeerToPeerConnection;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class LayerView extends Screen
	{
		private var header:Header;
		private var backButton:Button;
		//private var label:Label;
		private var nbLayers:uint;
		private var selectedLayer:uint;
		private var cnx:PeerToPeerConnection = PeerToPeerConnection.getInstance();

		public function LayerView()
		{
			

		}
		override protected function draw():void
		{
			header.width = actualWidth;

		}
		
		override protected function initialize():void
		{
			header = new Header();
			header.title = "Onyx-VJ Layer";
			addChild(header);
			
			backButton = new Button();
			backButton.label = "Back";
			backButton.addEventListener(Event.TRIGGERED, onBack);
			backButton.pivotX = backButton.pivotY * 0.5;
			//addChild(backButton);
			header.leftItems = new <DisplayObject>[backButton];
			
			cnx.addEventListener( P2PEvent.ON_RECEIVED, DataReceived );
			
		}
		private function DataReceived(dataRcvd:Object):void
		{
			var valueRcvd:Number;
			var typeRcvd:String;
			if ( dataRcvd.params && dataRcvd.params.type && dataRcvd.params.value )
			{
				valueRcvd = dataRcvd.params.value;
				typeRcvd = dataRcvd.params.type.toString();
				switch ( typeRcvd ) 
				{ 
					
					case "layers":
						nbLayers = valueRcvd;
						createLayerButtons();
						break;
					
					case "select-layer":
						selectedLayer = valueRcvd;
						break;
					
					default: 						
						break;
				}
				
			}
		}		
		
		private function createLayerButtons():void
		{
			for (var i:uint=0; i<nbLayers; i++)
			{
				var layerBtn:Button;
				layerBtn = new Button();
				layerBtn.label = i.toString();
				layerBtn.addEventListener(Event.TRIGGERED, onLayerBtn);
				layerBtn.pivotX = layerBtn.pivotY * 0.5;
				addChild(layerBtn);
			}
			
		}
		private function onLayerBtn(e:Event):void
		{
			trace("onLayerBtn");
		}
		private function onBack(e:Event):void
		{
			dispatchEventWith("complete");
			Onyx.nav.showScreen(Onyx.GLOBAL);
		}

	}
}