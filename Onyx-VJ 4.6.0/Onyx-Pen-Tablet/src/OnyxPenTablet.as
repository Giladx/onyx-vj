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
	
	[SWF(frameRate="60",width="800",height="600",backgroundColor="#141515")]
	public class OnyxPenTablet extends Sprite
	{
		private var output:TextField;
		private var tablet:PenTablet;
		private var cnx:DirectLanConnection = DirectLanConnection.getInstance("PenTablet");
		
		public function OnyxPenTablet()
		{
			cnx.connect("60000");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			output = new TextField();
			output.width = stage.stageWidth;
			output.height = stage.stageHeight;
			output.mouseEnabled = false;
			
			tablet = new PenTablet();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			addChild(output);
			log('Context: '+PenTablet.context + ' connected:' + cnx.isConnected);
			if (cnx.isConnected)
			{
				cnx.sendData( {type:"toggle-cross-fader", value:1}  );
				
			}
		}
		
		protected function mouseDownHandler(ev:MouseEvent):void
		{
			cnx.sendData( {type:"x", value:mouseX}  );
			graphics.moveTo(mouseX, mouseY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		protected function mouseMoveHandler(ev:MouseEvent):void
		{
			var pressure:uint = 512;
			try
			{
				pressure = tablet.getPressure();
				log('Pressure: '+pressure);
				cnx.sendData( {type:"pressure", value:pressure}  );
			}
			catch(e:*)
			{
				log('Error: '+e);
			}
			graphics.lineStyle(pressure/50);
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