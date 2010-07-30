/**
 * Copyright jozefchutka ( http://wonderfl.net/user/jozefchutka )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/y0Ta
 */

package library.patches
{
	// read more and download pbk file here:
	// http://blog.yoz.sk/2010/06/anaglyphs-with-pixel-bender-and-depth-map
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ShaderFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	[SWF(width="465", height="465", frameRate="30", backgroundColor="#FFFFFF")]
	
	public class Anaglyphs extends Sprite
	{
		private var sourcePath:String = "http://blog.yoz.sk/examples/pixelBenderDisplacement/";
		
		private var index:int = -1;
		private var sources:Array = [
			{image:"mountain.jpg", map:"mountainMap.jpg"},
			{image:"zbuffer2.jpg", map:"zbuffer2Map.jpg"},
			{image:"face.jpg", map:"faceMap.jpg"},
			{image:"china.jpg", map:"chinaMap.jpg"},
			{image:"zbuffer1.jpg", map:"zbuffer1Map.jpg"},
			{image:"zbuffer3.jpg", map:"zbuffer3Map.jpg"},
			{image:"building.jpg", map:"buildingMap.jpg"},
			{image:"greece.jpg", map:"greeceMap.jpg"},
			{image:"prague.jpg", map:"pragueMap.jpg"}
		]
		
		private var shaderLoader:URLLoader = new URLLoader();
		private var shaderURL:String = "displacementMapAnaglyph.pbj";
		private var shader:Shader;
		private var filter:ShaderFilter;
		
		private var imageLoader:Loader = new Loader();
		private var imageLegend:Bitmap = new Bitmap();
		
		private var mapLoader:Loader = new Loader();
		private var mapLegend:Bitmap = new Bitmap();
		
		private var glassesLoader:Loader = new Loader();
		
		private var imageContainer:Sprite = new Sprite();
		private var shape:Sprite = new Sprite();
		
		public function Anaglyphs():void
		{
			imageContainer.x = 200;
			imageContainer.y = 100;
			addChild(imageContainer);
			
			shape.graphics.beginFill(0, 0);
			shape.graphics.drawRect(0, 0, 300, 200);
			shape.graphics.endFill();
			addChild(shape);
			
			shaderLoader.dataFormat = URLLoaderDataFormat.BINARY;
			shaderLoader.load(new URLRequest(sourcePath + shaderURL));
			shaderLoader.addEventListener(Event.COMPLETE, shaderComplete);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			addEventListener(MouseEvent.CLICK, changeSource);
			changeSource();
			
			glassesLoader.load(new URLRequest(sourcePath + "glasses.jpg"));
			glassesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, glassesComplete);
			addChild(glassesLoader);
		}
		
		private function changeSource(... rest):void
		{
			index = index + 1 >= sources.length ? 0 : index + 1;
			var source:Object = sources[index];
			
			var type:String = Event.COMPLETE;
			var context:LoaderContext = new LoaderContext(true);
			
			if(imageLoader)
				imageLoader.unload();
			
			var imageRequest:URLRequest = new URLRequest(sourcePath + source.image);
			imageLoader.load(imageRequest, context);
			imageLoader.contentLoaderInfo.addEventListener(type, imageComplete);
			imageContainer.addChild(imageLoader);
			
			if(mapLoader)
				mapLoader.unload();
			
			var mapRequest:URLRequest = new URLRequest(sourcePath + source.map);
			mapLoader.load(mapRequest, context);
			mapLoader.contentLoaderInfo.addEventListener(type, mapComplete);
		}
		
		private function glassesComplete(event:Event):void
		{
			glassesLoader.y = 200 - glassesLoader.height;
		}     
		
		private function shaderComplete(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.currentTarget);
			shader = new Shader(loader.data as ByteArray);
			
			/*
			default = optimized anaglyphs matrixes for red-cyan glasses
			shader.data.matrixLeft = [0.0, 0.0, 0.0, 0.7, 0.0, 0.0, 0.3, 0.0, 0.0];
			shader.data.matrixRight = [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0];
			*/
			
			filter = new ShaderFilter(shader);
			testComplete();
		}
		
		private function imageComplete(event:Event):void
		{
			imageLoader.x = -imageLoader.width / 2;
			imageLoader.y = -imageLoader.height / 2;
			testComplete();
			
			var image:Bitmap = Bitmap(imageLoader.content)
			imageLegend.bitmapData = image.bitmapData.clone();
			imageLegend.width = 100;
			imageLegend.height = imageLegend.bitmapData.height
				* imageLegend.width / imageLegend.bitmapData.width;
			addChild(imageLegend); 
		}
		
		private function mapComplete(event:Event):void
		{
			testComplete();
			
			var map:Bitmap = Bitmap(mapLoader.content)
			mapLegend.bitmapData = map.bitmapData.clone();
			mapLegend.width = 100;
			mapLegend.height = mapLegend.bitmapData.height 
				* mapLegend.width / mapLegend.bitmapData.width;
			mapLegend.x = 200 - mapLegend.width;
			addChild(mapLegend); 
		}
		
		private function testComplete():void
		{
			if(!filter || !imageLoader.content || !mapLoader.content)
				return;
			
			shader.data.map.input = Bitmap(mapLoader.content).bitmapData;
		}
		
		private function enterFrame(event:Event):void
		{
			if(!filter || !imageLoader.content || !mapLoader.content)
				return;
			
			var dx:Number = (300 / 2 - mouseX);
			var dy:Number = (200 / 2 - mouseY);
			
			imageContainer.rotationX -= (imageContainer.rotationX + dy / 15) / 10;
			imageContainer.rotationY -= (imageContainer.rotationY - dx / 15) / 10;
			
			shader.data.dx.value = [10];
			shader.data.dy.value = [0];
			
			imageLoader.filters = [filter];
		}
	}
}