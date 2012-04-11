/**
 * Copyright codeonwort ( http://wonderfl.net/user/codeonwort )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/oprm
 */

package plugins.visualizer
{
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.*;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public final class VerticalVisualizer extends Visualizer 
	{
		
		private var vol:Number = 1;
		
		private var bd:BitmapData;
		private var dst:BitmapData;
		private var effectTimer:int = 0;
		private var bmp:Bitmap;
		private var ary:Array = [];
		
		public function VerticalVisualizer() 
		{
			//bd = new BitmapData(512, 256, false, 0x000000);
			bd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000);
			dst = bd.clone();
			bmp = new Bitmap(dst);
			bmp.rotationY = 40;
			bmp.rotationX = 20;
			bmp.x = -40;
			bmp.y = 10;
			bmp.z = -100;
			
			for(var i:int=0 ; i <256 ; i++) ary[i] = i;
			directShuffle(ary, 1000);
		}
		

		
		private const zero:Point = new Point;

		override public function render(info:RenderInfo):void 
		{
			var analysis:Array	= SpectrumAnalyzer.getSpectrum(true);
			var count:Number = SpectrumAnalyzer.leftPeak + SpectrumAnalyzer.rightPeak;
			var peak:Number = Math.max(SpectrumAnalyzer.leftPeak, SpectrumAnalyzer.rightPeak);
			//Console.output("length:"+analysis.length+" leftPeak: "+SpectrumAnalyzer.leftPeak+" rightPeak:"+SpectrumAnalyzer.rightPeak);
			directShuffle(ary, peak * 8);
			oneSort() ; oneSort();
			if(count > 1.2 * vol){
				bd.scroll(0, -16);
				effectTimer = 16;
			}
			else
			{
				bd.scroll(0, -peak * 4);
			}
			draw();
			
			if(effectTimer > 0)
			{
				BitmapEffect.halo(bd, bd.rect, dst, zero, Math.max(1, int(6 * effectTimer/16)), 80, 0.731, 0.5, 1.03, false,0xd43e0a);
				bmp.rotationY = 40 - effectTimer;
				effectTimer -= 2;
			}
			else
			{
				dst.copyPixels(bd, bd.rect, zero);
				bmp.rotationY = 40;
			}
			
			vol = Math.max(vol * 0.97, count);
			info.render(bmp);
		}
		
		private var bottomR:Rectangle = new Rectangle(0, 256-10, 512, 10);
		private var bottomP:Point = new Point(0, 254);
		private function draw():void {
			var c:int;
			for(var i:int=0 ; i<256 ; i++)
			{
				c = ary[i] << 16;
				bd.setPixel(i*4, DISPLAY_HEIGHT, c);
				bd.setPixel(i*4, DISPLAY_HEIGHT-1, c);
				bd.setPixel(i*4+1, DISPLAY_HEIGHT, c);
				bd.setPixel(i*4+1, DISPLAY_HEIGHT-1, c);
			}
		}
		private function oneSort():void {
			var min:int = -1, temp:int;
			for(var i:int=0 ; i<256 ; i++) if(ary[i] != i){ min = i ; break }
			if(min != -1) for(i= 0 ; i<256 ; i++){
				if(ary[i] == min){
					temp = ary[min];
					ary[min] = min;
					ary[i] = temp;
					break;
				}
			}
		}
		
	}
}

function directShuffle(array:Array, count:uint):void {
	var temp:*, x:int, y:int;
	for(var i:int=0 ; i<count ; i++){
		x = integer(array.length);
		y = integer(array.length);
		temp = array[x];
		array[x] = array[y];
		array[y] = temp;
	}
}

function integer(num:int):int {
	return int(Math.random() * num);
}

import flash.display.BitmapData
	
	import flash.filters.BlurFilter
	import flash.filters.ColorMatrixFilter
	import flash.filters.DisplacementMapFilter
	import flash.geom.ColorTransform
	import flash.geom.Rectangle
	import flash.geom.Matrix
	import flash.geom.Point
	
	internal class BitmapEffect {
		
		private static const DEGREE_TO_RAD:Number = Math.PI / 180;
		private static const zero:Point = new Point;
		private static const blur4:BlurFilter = new BlurFilter(4, 4);
		private static const blur8:BlurFilter = new BlurFilter(8, 8);
		private static const halfAlphaCT:ColorTransform = new ColorTransform(1,1,1, 0.5);
		private static const blackCMF:ColorMatrixFilter
		=  new ColorMatrixFilter( [1/3, 1/3, 1/3, 0, 0, 1/3, 1/3, 1/3, 0, 0, 1/3, 1/3, 1/3, 0, 0,  0, 0, 0, 1, 0] );
		
		/**
		 * @see codeonwort.display.BitmapEffect#monochrome()
		 */
		public static function halo(src:BitmapData, srcRect:Rectangle, dst:BitmapData, dstPoint:Point,
									steps:uint, threshold:uint=127,
									centerX:Number=0.5, centerY:Number=0.5,
									scaleFactor:Number=1.02,
									isMonochrome:Boolean=false,
									haloColor:uint=0xffffff,
									haloBlendMode:String="layer",
									haloTexture:BitmapData=null):void {
			if(steps == 0){
				dst.copyPixels(src, src.rect, dstPoint);
				return;
			}
			
			var cx:Number = centerX * srcRect.width + 0.5 / srcRect.width;
			var cy:Number = centerY * srcRect.height + 0.5 / srcRect.height;
			var mat:Matrix = new Matrix;
			
			var temp:BitmapData = new BitmapData(srcRect.width, srcRect.height, true,
				0xff000000 | (haloTexture ? 0 : haloColor));
			
			if(haloTexture){
				if(haloTexture.width == temp.width && haloTexture.height && temp.height){
					temp.copyPixels(haloTexture, haloTexture.rect, zero, null, null, true);
				}else{
					var texMat:Matrix = new Matrix;
					texMat.scale(temp.width / haloTexture.width, temp.height / haloTexture.height);
					temp.draw(haloTexture, texMat);
				}
			}
			
			if(isMonochrome){
				temp.threshold(src, src.rect, zero, "<", threshold, 0x00000000, 0xff);
			}else{
				var temp2:BitmapData = new BitmapData(srcRect.width, srcRect.height, true, 0xffffffff);
				temp2.applyFilter(src, srcRect, zero, blackCMF);
				temp.threshold(temp2, temp2.rect, zero, "<", threshold, 0x00000000, 0xff);
				temp2.dispose();
			}
			
			for(var i:int=0 ; i<steps ; i++){
				mat.translate(-cx, -cy);
				mat.scale(scaleFactor, scaleFactor);
				mat.translate(cx, cy);
				temp.draw(temp, mat, halfAlphaCT);
			}
			temp.applyFilter(temp, temp.rect, zero, blur8);
			
			dst.copyPixels(src, srcRect, dstPoint);
			dst.draw(temp, new Matrix, null, haloBlendMode);
			temp.dispose();
		}
		
	}
