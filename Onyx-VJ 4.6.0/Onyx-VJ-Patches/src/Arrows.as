/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/6Ux2
 */

package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Arrows extends Patch 
	{
		private var forceMap:BitmapData = new BitmapData( DISPLAY_WIDTH/2, DISPLAY_HEIGHT/2, false, 0x000000 );
		private var randomSeed:uint = Math.floor( Math.random() * 0xFFFF );
		private var seed:Number = Math.floor( Math.random() * 0xFFFF );
		private var offset:Array = [new Point(), new Point()];
		private var timer:Timer;
		private var buffer:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0);//false : white... TODO
		private var screen:Bitmap = new Bitmap(buffer);
		private var particleList:Array = [];     
		private var _blkBmpd:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT,true,0x08);
		private var _destPoint:Point = new Point();
		private var _blurFilter:BlurFilter = new BlurFilter(8,8);
		private var _drawBmpd:BitmapData;
		
		public function Arrows()
		{         			
			resetFunc();
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, resetFunc);
			timer.start();
			
			var dummy:Sprite = new Sprite();
			//var dummyBg:Sprite = new Sprite();
			var dummyHolder:Sprite = new Sprite();
			dummy.graphics.beginFill(0x003399, 1);
			dummy.graphics.drawPath(Vector.<int>([1,2,2,2,2,2,2,2]), Vector.<Number>([-9,-7,-3,-7,-3,-11,9,-4,-3,3,-3,-1,-9,-1,-9,-7]));

			dummyHolder.addChild(dummy);
			dummy.scaleX = dummy.scaleY = 0.7;
			
			var temp:BitmapData;
			var rect:Rectangle;
			var matrix:Matrix = new Matrix();
			var j:int = ALPHA_STEPS;
			while(j--) {
				var i:int = ROT_STEPS;
				var k:int = j * ROT_STEPS;
				dummy.alpha = j / (ALPHA_STEPS-1);
				//dummy.filters = dummyBg.filters = [new BlurFilter(4.0*(1.0 - j / (ALPHA_STEPS-1)),4.0*(1.0 - j / (ALPHA_STEPS-1)),3)];
				while (i--) {
					matrix.identity();
					matrix.rotate( ( 360 / ROT_STEPS * i )* Math.PI / 180);
					matrix.translate(11, 11);
					temp = new BitmapData(22, 22, true, 0x0);
					temp.draw(dummyHolder, matrix);
					rotArr[i+k] = new DisplayImage(temp, 11, 11);
				}
			}
			
			for (i = 0; i < NUM_PARTICLE; i++) {particleList[i] = new Arrow(Math.random() * DISPLAY_WIDTH, Math.random() * DISPLAY_HEIGHT);}
			addChild(screen);                                                    
		}
		override public function render(info:RenderInfo):void 
		{
			var len:int = particleList.length;
			var arrow:Arrow;
			buffer.lock();
			
			//buffer.draw(_blkBmpd);
			buffer.applyFilter(buffer, buffer.rect, _destPoint, _blurFilter);
			buffer.colorTransform(buffer.rect, new ColorTransform(1, 1, 1, 1, 20, 10, 10, 0));
			
			particleList.sortOn("speed", Array.NUMERIC);
			for (var i:int = 0; i < len; i++) {
				arrow = particleList[i];
				arrow.step(forceMap.getPixel( arrow.x >> 1, arrow.y >> 1));
				buffer.copyPixels(arrow.img.bmp, arrow.img.bmp.rect, new Point(arrow.x-arrow.img.cx, arrow.y-arrow.img.cy));
			}
			buffer.unlock();
			info.render( buffer );	
		}
		
		private function resetFunc(e:Event = null):void {
			forceMap.perlinNoise(117, 117, 3, seed, false, true, 6, false, offset);
			
			offset[0].x += 1.5;
			offset[1].y += 1;
			seed = Math.floor( Math.random() * 0xFFFFFF );
		}
	}
}

import flash.display.*;
import flash.geom.*;

import onyx.plugin.*;

const NUM_PARTICLE:uint = 2000;
const ROT_STEPS:int = 128;
const ALPHA_STEPS:int = 20;
var rotArr:Vector.<DisplayImage> = new Vector.<DisplayImage>(ROT_STEPS * ALPHA_STEPS, true);
var multiplyConst:Number = 64 / Math.PI;

class DisplayImage {
	
	public var bmp:BitmapData;
	public var rect:Rectangle;
	public var cx:int, cy:int;
	
	function DisplayImage(bmp:BitmapData, cx:int, cy:int) {
		this.bmp = bmp;
		this.rect = bmp.rect;
		this.cx = cx;
		this.cy = cy;
		trimming();
	}
	
	private function trimming():void {
		var rect:Rectangle = bmp.getColorBoundsRect(0xFF000000, 0x00000000);
		var temp:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
		cx -= rect.x;
		cy -= rect.y;
		temp.copyPixels(bmp, rect, new Point(0, 0));
		bmp = temp;
	}
}

class Arrow {
	
	public var img:DisplayImage;
	public var x:int, y:int;
	public var vx:Number = 0, vy:Number = 0, ax:Number = 0, ay:Number = 0;
	public var rot:int = 0, speed:int = 0;
	
	function Arrow(x:int, y:int) {
		this.x = x;
		this.y = y;
	}
	
	public function step(col:uint):void {
		ax += ( (col      & 0xff) - 0x80 ) * .0005;
		ay += ( (col >> 8 & 0xff) - 0x80 ) * .0005;
		vx += ax;
		vy += ay;
		x += vx;
		y += vy;
		
		var dir:Number = Math.atan2( vy, vx );
		rot = (128 + dir * multiplyConst) & 127;
		speed = Math.min(ALPHA_STEPS-1, (vx*vx + vy*vy) >> 1); // *0.5
		img = rotArr[rot + ROT_STEPS * speed];
		
		ax *= .96;
		ay *= .96;
		vx *= .92;
		vy *= .92;
		
		( x > DISPLAY_WIDTH ) ? x = 0 : ( x < 0 ) ? x = DISPLAY_WIDTH : 0;
		( y > DISPLAY_HEIGHT ) ? y = 0 : ( y < 0 ) ? y = DISPLAY_HEIGHT : 0;
	}
}