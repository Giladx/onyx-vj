/**
 * Copyright actionscriptbible ( http://wonderfl.net/user/actionscriptbible )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rXEC
 */

package plugins.filters {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
		
	use namespace onyx_ns;
	
	public final class BadReception extends Filter implements IBitmapFilter {
		
		protected var noise:BitmapData;
		
		protected var shader:Shader;
		protected var shaderFilter:ShaderFilter;
		
		protected var smoothRandomNoise:BitmapData;
		protected var pointers:Vector.<Point>;
		protected var rands:Vector.<Number>;
		
		[Embed(source='../filters/pixelbender/badreception.pbj', mimeType='application/octet-stream')]
		private var AssetBadReception:Class;
		
		public function BadReception() {
			noise = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0);
			
			smoothRandomNoise = new BitmapData(300, 10, true, 0);
			smoothRandomNoise.perlinNoise(Math.random()*100, Math.random()*100, 4,
				int((new Date()).date) * int(1000*Math.random()), true, true, 7);
			pointers = new Vector.<Point>(12);
			rands = new Vector.<Number>(12);
			for (var i:int = 0; i < 12; i++)
				pointers[i] = (new Point(
					Math.random()*smoothRandomNoise.width,
					Math.random()*smoothRandomNoise.height));

			shader = new Shader( new AssetBadReception() as ByteArray );
			shaderFilter = new ShaderFilter(shader);
			shader.data.noiseImage.input = noise;
			shader.data.srcImage.input = noise; 
			shader.data.dimensions.value = [noise.width, noise.height];

		}


		public function applyFilter(bitmapData:BitmapData):void {
		
			if (shader) 
			{
				noise.noise(getTimer(), 0, 255, 7, true);
				for (var i:int = 0; i < pointers.length; i++) {
					var p:Point = pointers[i];
					p.x = (int(p.x) + 2*(1+i)) % smoothRandomNoise.width;
					rands[i] = smoothRandomNoise.getPixel(p.x, p.y) / 0x00ffffff;
				}
				
				var sd:ShaderData = shader.data;
				sd.noisyHDisplace.value = [Math.pow(rands[2],4)*40];
				sd.vRoll.value = [rands[0] * 80 - 20];
				sd.channelSplit.value = [rands[3] * 40 - 10];
				sd.sinHDisplaceAmplitudes.value = [20.0, 2.0, 1.0];
				sd.sinHDisplaceFrequencies.value = [rands[2]*2+0.4, rands[10]*4+4, rands[11]*8+8];
				sd.sinHDisplace.value = [Math.pow(rands[2], 8) * 100];
				sd.noiseLayer.value = [Math.pow(rands[10], 4) * 0.8];
				sd.blackoutThresh.value = [rands[2]*0.3];			
			}
			bitmapData.applyFilter(bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY, shaderFilter);
		}

		override public function dispose():void {
			
		}
	}
}