package
{
	import com.bit101.components.*;
	import com.magicalhobo.utils.PenTablet;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import services.remote.NetworkUtil;
	import services.remote.P2PEvent;
	import services.remote.PeerToPeerConnection;
	
	/*
	Use this cmd file to generate exe
	SET AIR_SDK=%USERPROFILE%\Documents\flex_sdk_4.6.0.23201B
	SET ANE_PATH=..\..\PenTabletLib\bin
	
	"%AIR_SDK%\bin\adtpause.bat" -package -XnoAneValidate -storetype pkcs12 -keystore test.p12 -storepass test -target native OnyxPenTablet OnyxPenTablet-app.xml OnyxPenTablet.swf -extdir "%ANE_PATH%"
	
	*/
	[SWF(frameRate="60",width="1024",height="800",backgroundColor="#141515")]
	public class OnyxPenTablet extends Sprite
	{
		private var tablet:PenTablet;
		private var cnx:PeerToPeerConnection = PeerToPeerConnection.getInstance();
		private var ctime:Number = 0;
		private var ms:int = 100;
		private var pressure:uint = 512;
		private var xyp:uint;
		private var xy:uint;
		private var toSend:Array = new Array();
		private var loader:Loader;
		private var color:uint;
		private var bgImage:Sprite;
		private var canvas:Sprite;
		private var controls:Sprite;
		private var padBottom:int = 25;
		private var padLeft:int = 5;
		private var UseDetectedColor:Boolean = true;
		private var UsePressure:Boolean = true;
		//Minimal comps
		private var DrawColor:ColorChooser;
		private var LoadImageButton:PushButton;
		private var ClearButton:PushButton;
		private var UseDetectedColorCheckBox:CheckBox;
		private var UsePressureCheckBox:CheckBox;
		private var OutputMessage:Label;
		private var PressureValue:InputText;
		private var msValue:InputText;
		
		public function OnyxPenTablet()
		{
			cnx = PeerToPeerConnection.getInstance();
			PeerToPeerConnection.ipAddresses = NetworkUtil.getIpAddresses();
			cnx.connect();
			toSend.push({cmd:"peername",value:"OnyxPenTablet"});
			
			ctime = getTimer();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			bgImage = new Sprite();
			addChild(bgImage);
			canvas = new Sprite();
			addChild(canvas);
			controls = new Sprite();
			addChild(controls);
			
			DrawColor = new ColorChooser(controls, padLeft, stage.stageHeight - padBottom, 0xFF0000 , DrawColorHandler );
			DrawColor.usePopup = true;
			DrawColor.popupAlign = ColorChooser.TOP;
			padLeft += 20+DrawColor.width;
			
			LoadImageButton = new PushButton(controls, padLeft, stage.stageHeight - padBottom, "open image" , LoadImageButtonHandler );
			padLeft += 10+LoadImageButton.width;
			ClearButton = new PushButton(controls, padLeft, stage.stageHeight - padBottom, "clear drawing" , ClearButtonHandler );
			padLeft += 10+ClearButton.width;
			UseDetectedColorCheckBox = new CheckBox(controls, padLeft, stage.stageHeight - padBottom, "use detected color" , UseDetectedColorHandler );
			UseDetectedColorCheckBox.selected = true;
			padLeft += 10+UseDetectedColorCheckBox.width;
			PressureValue = new InputText(controls, padLeft, stage.stageHeight - padBottom, pressure.toString(), PressureValueHandler);
			padLeft += 10+PressureValue.width;
			UsePressureCheckBox = new CheckBox(controls, padLeft, stage.stageHeight - padBottom, "use pressure" , UsePressureHandler );
			UsePressureCheckBox.selected = true;
			padLeft += 10+UsePressureCheckBox.width;
			msValue = new InputText(controls, padLeft, stage.stageHeight - padBottom, ms.toString(), msValueHandler);
			padLeft += 10+msValue.width;
			OutputMessage = new Label(controls, padLeft, stage.stageHeight - padBottom);
			log('OnyxPenTablet version 0.9.007');			
			
			tablet = new PenTablet();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(Event.ENTER_FRAME, loop);

		}
		
		private function DrawColorHandler(e:Event):void 
		{
		}
		private function LoadImageButtonHandler(e:Event):void 
		{
			loadImage();			
		}
		private function ClearButtonHandler(e:Event):void 
		{
			canvas.graphics.clear();
		}
		private function PressureValueHandler():void
		{
			if (!UsePressure) pressure = int(PressureValue.text);
		}
		private function msValueHandler():void
		{
			ms = int(msValue.text);
			log('buffer is ' + msValue.text + 'ms');	
		}
		private function UsePressureHandler(e:Event):void 
		{
			UsePressure = UsePressureCheckBox.selected;
			log('UsePressure' + UsePressure);	

		}
		private function UseDetectedColorHandler(e:Event):void 
		{
			UseDetectedColor = UseDetectedColorCheckBox.selected;
			log('UseDetectedColor' + UseDetectedColor);	
		}
		protected function loop(event:Event):void
		{
			if ( getTimer() - ctime > ms ) 
			{
				log('queue length: ' + toSend.length.toString() )
				ctime = getTimer();
				if ( toSend.length > 0 )
				{
					cnx.sendData( {type:toSend[0].cmd, value:toSend[0].value}  );					
					toSend.shift();
				}				
			}
		}
		private function getColor(x:int,y:int):void
		{
			if (UseDetectedColor) 
			{
				var bd:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight);
				bd.draw(stage);
				var b:Bitmap = new Bitmap(bd);
				color = b.bitmapData.getPixel(x, y);				
				DrawColor.value = color;
			}
			else
			{
				color = DrawColor.value;
			}
			toSend.push({cmd:"color",value:color});
			
		}
		
		protected function mouseDownHandler(ev:MouseEvent):void
		{
			if (ev.localY < stage.stageHeight - padBottom - 10)
			{
				canvas.graphics.moveTo(ev.localX, ev.localY);
				getColor(ev.localX, ev.localY);
				xy = ev.localX * 1048576 + ev.localY;
				toSend.push({cmd:"xy",value:xy});
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);			
			}
		}
		protected function mouseMoveHandler(ev:MouseEvent):void
		{		
			try
			{
				getColor(ev.localX, ev.localY);
				if (UsePressure)
				{
					pressure = tablet.getPressure();	
					if (pressure<100) pressure = 100;
					PressureValue.text = pressure.toString();				
				}
				else
				{
					pressure = int(PressureValue.text);
				}
				xyp = ev.localX * 1048576 + ev.localY * 1024 + pressure;
				toSend.push({cmd:"xyp",value:xyp});
			}
			catch(e:*)
			{
				log('Error: '+e);
			}
			
			canvas.graphics.lineStyle(pressure/30, color);
			canvas.graphics.lineTo(mouseX, mouseY);
		}
		
		protected function mouseUpHandler(ev:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function log(message:String):void
		{
			OutputMessage.text = message;
		}
		private function loadImage():void
		{		
			var file:File = File.documentsDirectory;
			file.browseForOpen('Select the image file to load.', [new FileFilter("All Images", "*.jpg;*.jpeg;*.gif;*.png")]);
			file.addEventListener(Event.SELECT, action);
			file.addEventListener(Event.CANCEL, action);
		}
		private function action(event:Event):void 
		{
			if (event.type === Event.SELECT) 
			{
				var file:File = event.currentTarget as File;
				loader = new Loader();
				var urlReq:URLRequest = new URLRequest(file.url);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
				loader.load(urlReq);
			}
		}
		private function imgLoaded(event:Event):void
		{
			var bmp:Bitmap = new Bitmap();
			bmp = loader.content as Bitmap;
			bgImage.addChild(bmp);
		}
	}
}