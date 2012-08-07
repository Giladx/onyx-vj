package  
{	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import onyx.asset.AssetFile;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class PngLoader extends Patch 
	{			
		private var _folder:String = 'assets/fox120/';
		private var sprite:Sprite;
		private var _speed:int	= 1000;
		private var ms:int;
		private var cnt:int	= 0;
		private var running:Boolean = false;
		private var bitmap:Bitmap;
		private var defaultBitmapData:BitmapData;
		
		public function PngLoader() {
			Console.output('PngLoader v 0.2 by Bruce LANE (http://www.batchass.fr)');
			sprite = new Sprite();
			defaultBitmapData = createDefaultBitmap();
			bitmap = new Bitmap( defaultBitmapData );
			sprite.addChild( bitmap );
			parameters.addParameters(
				new ParameterString('folder', 'folder', _folder),
				new ParameterInteger('speed', 'speed', 1, 5000, _speed),
				new ParameterExecuteFunction('load', 'load')
			);
			
			ms = getTimer();
		}
		override public function render(info:RenderInfo):void
		{
			if ( running )
			{
				
				if( getTimer() - speed > ms )
				{
					running = false;
					var imgFile:File = new File( AssetFile.resolvePath( 'library/'+ folder + cnt + '.png' ) );
					if ( imgFile.exists )
					{
						var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler);

						loader.load(new URLRequest(imgFile.url));
					}
					cnt++;
					ms = getTimer();	
				}			
			}
			info.render(sprite);
		}
		private function loadHandler(event:Event):void 
		{
			if ( !(event is IOErrorEvent) ) 
			{
				try 
				{
					var bmp:Bitmap = Bitmap(LoaderInfo(event.target).content);
					bmp.scaleX = bmp.scaleY = Math.min(DISPLAY_HEIGHT/bmp.height,DISPLAY_WIDTH/bmp.width);
					if ( DISPLAY_WIDTH/bmp.width > 1 || DISPLAY_HEIGHT/bmp.height > 1 )
					{
						// scale up
						if ( DISPLAY_WIDTH/bmp.width > DISPLAY_HEIGHT/bmp.height )
						{
							bmp.x = ( DISPLAY_WIDTH - bmp.width ) / 2;
						}
						else
						{
							bmp.y = ( DISPLAY_HEIGHT - bmp.height ) / 2;
						}
					}
					else
					{
						//scale down
						if ( DISPLAY_WIDTH/bmp.width > DISPLAY_HEIGHT/bmp.height )
						{
							bmp.x = ( DISPLAY_WIDTH - ( bmp.height * bmp.scaleX ) ) / 2;
						}
						else
						{
							bmp.y = ( DISPLAY_HEIGHT - ( bmp.width * bmp.scaleX ) ) / 2;
						}
					}
				
					sprite.addChild(bmp);
					// 24 bmp limit! workaround:
					if ( sprite.numChildren > 20 )
					{
						var bitmapData:BitmapData = new BitmapData(sprite.width, sprite.height, true, 0x00FFFFFF);
						bitmapData.draw(sprite);
						
						sprite.removeChildren();
						sprite = null;
						sprite = new Sprite();
						sprite.addChild(new Bitmap(bitmapData, "auto"));
					}
				} 
				catch (e:Error) 
				{
					Console.output( 'loadHandler: ' + ( e.message ) );
				}
			}
			else
			{
				Console.output( 'loadHandler, IO Error loading: ' + (event as IOErrorEvent).text );
			}
			running = true;
		}	
		public function load():void 
		{
			cnt = 0;
			running = true;
		}
		

		public function get folder():String
		{
			return _folder;
		}

		public function set folder(value:String):void
		{
			_folder = value;
		}

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}		
	}
}