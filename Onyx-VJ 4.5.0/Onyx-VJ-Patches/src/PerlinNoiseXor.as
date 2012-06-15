/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 *  
 * 
 */
/**
 * Copyright codeonwort ( http://wonderfl.net/user/codeonwort )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/909w
 */

// forked from codeonwort's forked from: perlin noise xor
// forked from codeonwort's perlin noise xor
package {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class PerlinNoiseXor extends Patch {
		
		private var src1:BitmapData, src2:BitmapData;
		private var bd:BitmapData, temp:BitmapData;
		private var x0:Number = 0, y0:Number = 0, t0:Number = 0;
		private var x1:Number = 0, y1:Number = 0, t1:Number = 0;
		private const zero:Point = new Point();
		private var sprite:Sprite;
		private var mx:int=320;
		private var my:int=240;

		
		public function PerlinNoiseXor() {
			
			sprite = new Sprite();
			bd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false);
			temp = bd.clone();
			
			src1 = new BitmapData(DISPLAY_WIDTH+DISPLAY_WIDTH, DISPLAY_HEIGHT+DISPLAY_HEIGHT, false);
			src2 = new BitmapData(DISPLAY_WIDTH+DISPLAY_WIDTH, DISPLAY_HEIGHT+DISPLAY_HEIGHT, false);
			generate();
			
			sprite.addChild(new Bitmap(bd));
			addEventListener( MouseEvent.MOUSE_DOWN, generate );
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
		private function mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
		}
		private function generate(event:MouseEvent = null):void {
			var scalex0:Number = 1 + Math.random() * 3;
			var scaley0:Number = 1 + Math.random() * 3;
			temp.perlinNoise(DISPLAY_WIDTH/scalex0, DISPLAY_HEIGHT/scaley0, 6, Math.random() * 12321, true, true);
			src1.copyPixels(temp, temp.rect, new Point(0, 0));
			src1.copyPixels(temp, temp.rect, new Point(DISPLAY_WIDTH, 0));
			src1.copyPixels(temp, temp.rect, new Point(0, DISPLAY_HEIGHT));
			src1.copyPixels(temp, temp.rect, new Point(DISPLAY_WIDTH, DISPLAY_HEIGHT));
			
			var scalex1:Number = 1 + Math.random() * 3;
			var scaley1:Number = 1 + Math.random() * 3;
			temp.perlinNoise(DISPLAY_WIDTH/scalex1, DISPLAY_HEIGHT/scaley1, 6, Math.random() * 12321, true, true);
			src2.copyPixels(temp, temp.rect, new Point(0, 0));
			src2.copyPixels(temp, temp.rect, new Point(DISPLAY_WIDTH, 0));
			src2.copyPixels(temp, temp.rect, new Point(0, DISPLAY_HEIGHT));
			src2.copyPixels(temp, temp.rect, new Point(DISPLAY_WIDTH, DISPLAY_HEIGHT));
		}
		override public function render(info:RenderInfo):void {
		
			t0 += (Math.random() - .5) / 5;
			x0 += 5 * Math.cos(t0);
			y0 += 5 * Math.sin(t0);
			if(x0 >= DISPLAY_WIDTH) x0 -= DISPLAY_WIDTH
			else if(x0 < 0) x0 += DISPLAY_WIDTH;
			if(y0 >= DISPLAY_HEIGHT) y0 -= DISPLAY_HEIGHT
			else if(y0 < 0) y0 += DISPLAY_HEIGHT;
			
			var dx:Number = mx-465/2;
			var dy:Number = my-465/2;
			var d:Number = Math.sqrt(dx*dx + dy*dy) / 10;
			t1 = Math.atan2(dy, dx);
			//t1 += (Math.random() - .5) / 5
			x1 += d * Math.cos(t1);
			y1 += d * Math.sin(t1);
			if(x1 < 0) x1 += DISPLAY_WIDTH
			else if(x1 >= DISPLAY_WIDTH) x1 -= DISPLAY_WIDTH;
			if(y1 < 0) y1 += DISPLAY_HEIGHT
			else if(y1 >= DISPLAY_HEIGHT) y1 -= DISPLAY_HEIGHT;
			
			bd.copyPixels(src1, new Rectangle(x0, y0, DISPLAY_WIDTH, DISPLAY_HEIGHT), zero);
			temp.copyPixels(src2, new Rectangle(x1, y1, DISPLAY_WIDTH, DISPLAY_HEIGHT), zero);
			
			var dmf:DisplacementMapFilter = new DisplacementMapFilter(temp, zero, 4, 2, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			bd.applyFilter(bd, bd.rect, zero, dmf);
			info.render( sprite );
		}
	}
}