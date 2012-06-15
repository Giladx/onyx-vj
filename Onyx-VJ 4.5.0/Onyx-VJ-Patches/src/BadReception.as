/**
 * Copyright actionscriptbible ( http://wonderfl.net/user/actionscriptbible )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rXEC
 */

package {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class BadReception extends Patch {
		protected var holder:Sprite;
		protected var video:Video;
		protected var testPattern:Loader;
		protected var noise:BitmapData;
		
		protected var shader:Shader;
		protected var shaderFilter:ShaderFilter;
		
		protected var smoothRandomNoise:BitmapData;
		protected var pointers:Vector.<Point>;
		protected var rands:Vector.<Number>;
		
		public function BadReception() {
			noise = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0);
			holder = new Sprite();
			video = new Video(DISPLAY_WIDTH/2, DISPLAY_HEIGHT/2);
			video.scaleX = video.scaleY = 2;
			/*var camera:Camera = Camera.getCamera();
			camera.setMode(DISPLAY_WIDTH/2, DISPLAY_HEIGHT/2, stage.frameRate, false);
			video.attachCamera(camera);*/
			testPattern = new Loader();
			testPattern.blendMode = BlendMode.ADD;
			testPattern.alpha = 0;
			holder.addChild(video);
			holder.addChild(testPattern);
			addChild(holder);
			
			smoothRandomNoise = new BitmapData(300, 10, false, 0);
			smoothRandomNoise.perlinNoise(Math.random()*100, Math.random()*100, 4,
				int((new Date()).date) * int(1000*Math.random()), true, true, 7);
			pointers = new Vector.<Point>(12);
			rands = new Vector.<Number>(12);
			for (var i:int = 0; i < 12; i++)
				pointers[i] = (new Point(
					Math.random()*smoothRandomNoise.width,
					Math.random()*smoothRandomNoise.height));
			
			var PBJURL:String = "http://actionscriptbible.com/files/badreception.pbj";
			var loader:URLLoader = new URLLoader(new URLRequest(PBJURL));
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onBytecodeLoaded);
			
			var IMGURL:String = "http://actionscriptbible.com/files/testpattern.jpg";
			testPattern.load(new URLRequest(IMGURL));
			testPattern.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
		}
		protected function onBytecodeLoaded(event:Event):void {
			shader = new Shader(URLLoader(event.target).data);
			shaderFilter = new ShaderFilter(shader);
			shader.data.noiseImage.input = noise;
			shader.data.srcImage.input = noise; 
			shader.data.dimensions.value = [noise.width, noise.height];
			
			/*stage.fullScreenSourceRect = noise.rect;
			stage.addEventListener(MouseEvent.CLICK, onFullScreen);
			stage.addEventListener(Event.ENTER_FRAME, go);*/
		}
		protected function onImageLoaded(event:Event):void {
			testPattern.width = noise.width;
			testPattern.height = noise.height;
		}

		override public function render(info:RenderInfo):void 
		{
			if (shader) 
			{
				noise.noise(getTimer(), 0, 255, 7, true);
				for (var i:int = 0; i < pointers.length; i++) {
					var p:Point = pointers[i];
					p.x = (int(p.x) + 2*(1+i)) % smoothRandomNoise.width;
					rands[i] = smoothRandomNoise.getPixel(p.x, p.y) / 0x00ffffff;
				}
				
				var sd:ShaderData = shader.data;
				testPattern.alpha = Math.max(0, rands[6] * 3 - 2);
				sd.noisyHDisplace.value = [Math.pow(rands[2],4)*40];
				sd.vRoll.value = [rands[0] * 80 - 20];
				sd.channelSplit.value = [rands[3] * 40 - 10];
				sd.sinHDisplaceAmplitudes.value = [20.0, 2.0, 1.0];
				sd.sinHDisplaceFrequencies.value = [rands[2]*2+0.4, rands[10]*4+4, rands[11]*8+8];
				sd.sinHDisplace.value = [Math.pow(rands[2], 8) * 100];
				sd.noiseLayer.value = [Math.pow(rands[10], 4) * 0.8];
				sd.blackoutThresh.value = [rands[2]*0.3];
				holder.filters = [shaderFilter];
				info.render( holder );
				
			}
		}
		override public function dispose():void {
			holder = null;
		}
	}
}