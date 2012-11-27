/**
 * Copyright clockmaker ( http://wonderfl.net/user/clockmaker )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/AwiA
 */

// forked from clockmaker's 3D Flow Simulation
// forked from clockmaker's Interactive Liquid 10000
// forked from clockmaker's Liquid110000 By Vector
// forked from munegon's forked from: forked from: forked from: forked from: Liquid10000
// forked from Saqoosha's forked from: forked from: forked from: Liquid10000
// forked from nutsu's forked from: forked from: Liquid10000
// forked from nutsu's forked from: Liquid10000
// forked from zin0086's Liquid10000
package {
	/**
	 * 3D ã®æµä½“ã«è¢«å†™ç•Œæ·±åº¦ã‚’åŠ ãˆã¦ã¿ã¾ã—ãŸ
	 * 200ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«
	 */    
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Liquid3D extends Patch {
		private const NUM_PARTICLE:uint = 200;
		private const BLUR_AMOUNT:int = 32;
		
		private var bmpData:BitmapData = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000 );
		private var forceMap:BitmapData = new BitmapData( DISPLAY_WIDTH/2, DISPLAY_HEIGHT/2, false, 0x000000 );
		private var randomSeed:uint = Math.floor( Math.random() * 0xFFFF );
		private var particleList:Vector.<Particle> = new Vector.<Particle>(NUM_PARTICLE, true);
		private var rect:Rectangle = new Rectangle( 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT );
		private var seed:Number = Math.floor( Math.random() * 0xFFFF );
		private var offset:Array = [new Point(), new Point()];
		private var colorTransform:ColorTransform = new ColorTransform( 0.94, .88, .92, 1.0 );
		private var timer:Timer;
		private var world:Sprite = new Sprite();
		private var blurArr:Vector.<BitmapData> = new Vector.<BitmapData>(BLUR_AMOUNT, true);
		
		public function Liquid3D() {
			 
			//addChild(new Bitmap( bmpData )) as Bitmap;
			//addChild(new Bitmap( forceMap )) as Bitmap;
			
			// ãƒ•ã‚©ãƒ¼ã‚¹ãƒžãƒƒãƒ—ã®åˆæœŸåŒ–ã‚’ãŠã“ãªã„ã¾ã™
			resetFunc();
			
			// æ™‚é–“å·®ã§ãƒ•ã‚©ãƒ¼ã‚¹ãƒžãƒƒãƒ—ã¨è‰²å¤‰åŒ–ã®å…·åˆã‚’å¤‰æ›´ã—ã¦ã„ã¾ã™
			var timer:Timer = new Timer(1000)
			timer.addEventListener(TimerEvent.TIMER, resetFunc);
			timer.start();
			
			// ã°ã‹ã—ã‚’ãƒ—ãƒ¬ãƒ¬ãƒ³ãƒ€ãƒªãƒ³ã‚°
			var dummy:Sprite = new Sprite();
			dummy.graphics.beginFill(0xFFFFFF,0.6);
			dummy.graphics.lineStyle(2, 0xFFFFFF);
			dummy.graphics.drawCircle(32, 32, 10);
			
			//stage.quality = StageQuality.BEST;
			var i:int = BLUR_AMOUNT;
			while (i--)
			{
				dummy.filters = [new BlurFilter(i, i, 5)];
				blurArr[i] = new BitmapData(60, 60, true, 0x0);
				blurArr[i].draw(dummy);
			}
			
			// ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã‚’ç”Ÿæˆã—ã¾ã™
			for (i = 0; i < NUM_PARTICLE; i++) {
				var px:Number = Math.random() * DISPLAY_WIDTH;
				var py:Number = Math.random() * DISPLAY_HEIGHT;
				var pz:Number = Math.random() * DISPLAY_WIDTH * 2 - DISPLAY_HEIGHT;
				particleList[i] = new Particle(px, py, pz, blurArr[0]);
				world.addChild(particleList[i]);
			}

		}
		
		override public function render(info:RenderInfo):void {
			
			var len:uint = particleList.length;
			var col:Number;
			
			for (var i:uint = 0; i < len; i++) {
				
				var dots:Particle = particleList[i];
				
				col = forceMap.getPixel( dots.x >> 1, dots.y >> 1);
				dots.ax += ( (col >> 8 & 0xff) - 128 ) * .0005;
				dots.ay += ( (col >> 4  & 0xff) - 128 ) * .0005;
				dots.az += ( (col >> 16  & 0xff) - 128 ) * .0005;
				dots.vx += dots.ax;
				dots.vy += dots.ay;
				dots.vz += dots.az;
				dots.x += dots.vx;
				dots.y += dots.vy;
				dots.z += dots.vz;
				
				var _posX:Number = dots.x;
				var _posY:Number = dots.y;
				var _posZ:Number = dots.z;
				
				var depth:int = BLUR_AMOUNT / 2 - (_posZ + DISPLAY_WIDTH) / 930 * BLUR_AMOUNT | 0;
				depth = (depth ^ (depth >> 31)) - (depth >> 31); // Math.absã®é«˜é€ŸåŒ–ã­
				dots.bitmap.bitmapData = blurArr[depth];
				
				dots.ax *= .92;
				dots.ay *= .92;
				dots.az *= .96;
				dots.vx *= .88;
				dots.vy *= .88;
				dots.vz *= .92;
				
				( _posX > DISPLAY_WIDTH ) ? dots.x = 0 :
					( _posX < 0 ) ? dots.x = DISPLAY_WIDTH : 0;
				( _posY > DISPLAY_HEIGHT ) ? dots.y = 0 :
					( _posY < 0 ) ? dots.y = DISPLAY_HEIGHT : 0;
				( _posZ > DISPLAY_WIDTH ) ? dots.z = -DISPLAY_WIDTH :
					( _posZ < -DISPLAY_WIDTH ) ? dots.z = DISPLAY_WIDTH : 0;
			}
			
			bmpData.colorTransform(rect, colorTransform);
			bmpData.draw(world);
			info.render(bmpData);
		}
		
		private function resetFunc(e:Event = null):void{
			forceMap.perlinNoise(DISPLAY_WIDTH/2, DISPLAY_HEIGHT/2, 3, seed, false, false, 1|2|4|0, false, offset );
			offset[0].x += 1.5;
			offset[1].y += 1;
			seed = Math.floor( Math.random() * 0xFFFFFF );
		}
	}
}

import flash.display.*;

class Particle extends Sprite{
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var vz:Number = 0;
	public var ax:Number = 0;
	public var ay:Number = 0;
	public var az:Number = 0;
	public var bitmap:Bitmap = new Bitmap();
	
	function Particle( x:Number, y:Number, z:Number, bmpData:BitmapData ) {
		this.x = x;
		this.y = y;
		this.z = z;
		addChild(bitmap);
		
		this.bitmap.bitmapData = bmpData;
		
		scaleX = 0.25;
		scaleY = 0.25;
	}
}