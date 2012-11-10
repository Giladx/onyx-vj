package
{
	import com.magicalhobo.utils.PenTablet;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import services.remote.DirectLanConnection;
	/*
	Use this cmd file to generate exe
	SET AIR_SDK=%USERPROFILE%\Documents\flex_sdk_4.6.0.23201B
	SET ANE_PATH=..\..\PenTabletLib\bin
	
	"%AIR_SDK%\bin\adtpause.bat" -package -XnoAneValidate -storetype pkcs12 -keystore test.p12 -storepass test -target native OnyxPenTablet OnyxPenTablet-app.xml OnyxPenTablet.swf -extdir "%ANE_PATH%"
	
	*/
	[SWF(frameRate="60",width="800",height="600",backgroundColor="#141515")]
	public class OnyxPenTablet extends Sprite
	{
		private var output:TextField;
		private var tablet:PenTablet;
		private var cnx:DirectLanConnection = DirectLanConnection.getInstance("PenTablet");
		
		public function OnyxPenTablet()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			output = new TextField();
			output.width = stage.stageWidth;
			output.height = stage.stageHeight;
			output.mouseEnabled = false;
			
			addChild(output);
			
			log('OnyxPenTablet start');			
			cnx.connect("60000");
			
			tablet = new PenTablet();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			log('Context: '+PenTablet.context + ' connected:' + cnx.isConnected);
			if (cnx.isConnected)
			{
				cnx.sendData( {type:"toggle-cross-fader", value:1}  );
				
			}
		}
		
		protected function mouseDownHandler(ev:MouseEvent):void
		{
			/*log('x: '+mouseX);
			cnx.sendData( {type:"x", value:mouseX}  );
			cnx.sendData( {type:"y", value:mouseY}  );*/
			graphics.moveTo(mouseX, mouseY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		protected function mouseMoveHandler(ev:MouseEvent):void
		{
			var pressure:uint = 512;
			var xyp:uint;
			try
			{
				pressure = tablet.getPressure();
				/*log('Pressure: '+pressure);
				cnx.sendData( {type:"x", value:ev.localX}  );//mouseX
				cnx.sendData( {type:"y", value:ev.localY}  );//mouseY
				cnx.sendData( {type:"pressure", value:pressure}  );*/
				xyp = ev.localX * 1048576 + ev.localY * 1024 + pressure + 1;
				cnx.sendData( {type:"xyp", value:xyp}  );
			}
			catch(e:*)
			{
				log('Error: '+e);
			}
			
			graphics.lineStyle(pressure/50,120+pressure/23);//0x00AAAA);
			graphics.lineTo(mouseX, mouseY);
		}
		
		protected function mouseUpHandler(ev:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function log(message:String):void
		{
			output.text = message + '\n' + output.text;
		}
	}
}