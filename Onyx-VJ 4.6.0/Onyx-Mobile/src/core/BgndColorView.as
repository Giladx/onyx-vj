package core
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import services.remote.PeerToPeerConnection;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	
	public class BgndColorView extends Screen
	{
		private var header:Header;
		private var backButton:Button;
		//private var label:Label;
		private var color:uint = 0x444444;
		private var cnx:PeerToPeerConnection = PeerToPeerConnection.getInstance();
		private var colorBd:BitmapData;
		private var colorBmp:Bitmap;
		private var image:Image;

		[Embed(source = "../../assets/colorpicker.png")]
		private const Picker:Class;
		
		public function BgndColorView()
		{
		}
		override protected function draw():void
		{
			header.width = actualWidth;
			image.y = header.height;
		}
		
		override protected function initialize():void
		{
			header = new Header();
			header.title = "Onyx-VJ background color";
			addChild(header);
			
			backButton = new Button();
			backButton.label = "Back";
			backButton.addEventListener(Event.TRIGGERED, onBack);
			backButton.pivotX = backButton.pivotY * 0.5;
			header.leftItems = new <DisplayObject>[backButton];
			
			colorBmp = new Picker();
			colorBd = colorBmp.bitmapData;
			var texture:Texture = Texture.fromBitmap(colorBmp);
			image = new Image(texture);
			addChild(image);
			
			image.touchable = true;		
			image.addEventListener(TouchEvent.TOUCH, BgColorHandler);
		}
		
		private function onBack(e:Event):void
		{
			dispatchEventWith("complete");
			Onyx.nav.showScreen(Onyx.GLOBAL);
		}
		private function BgColorHandler(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(image, TouchPhase.ENDED);
			
			if (!touch) return;
			var location:Point = touch.getLocation(image);
			var clr:uint = colorBd.getPixel32(location.x,location.y);
			
			cnx.sendData( {type:"backgroundcolor", value:clr} );
			cnx.sendData( {type:"x-y", value:location.x * 1048576 + location.y} );
		}
	}
}