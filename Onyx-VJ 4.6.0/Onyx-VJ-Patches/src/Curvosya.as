/**
 * Copyright GreekFellows ( http://wonderfl.net/user/GreekFellows )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/fvOM
 */

package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Curvosya extends Patch {

		public var s:Sprite;
		
		public function Curvosya() {

			s = new Sprite();
			
			for (var it:int = 0; it < 100; it++) {
				var c:Curvos = new Curvos();
				c.x = Math.random() * DISPLAY_WIDTH;
				c.y = Math.random() * DISPLAY_HEIGHT;
				s.addChild(c);
			}
		}
		
		override public function render(info:RenderInfo):void  {
			if (s.numChildren < 100) {
				for (var num:int = 0; num < 100 - s.numChildren; num++) {
					var c:Curvos = new Curvos();
					c.x = Math.random() * DISPLAY_WIDTH;
					c.y = Math.random() * DISPLAY_HEIGHT;
					s.addChildAt(c, 0);
				}
			}

			info.render(s);
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;

import onyx.plugin.DISPLAY_HEIGHT;
import onyx.plugin.DISPLAY_WIDTH;

class Curvos extends Sprite {
	public var array:Array;
	public var color:uint = Math.floor(Math.random() * 0xffffff);
	
	public var ax:Number = 0;
	public var ay:Number = 0;
	
	public function Curvos() {
		vertices();
	}
	
	public function vertices():void {
		array = [];
		
		var total:int = 10;
		for (var it:int = 0; it < total; it++) {
			array.push({x:0, y:0, angle:it / total * 360, r:Math.random() * 150, dr:0, maxr:200, minr:20});
		}
		
		draw();
		
		this.addEventListener(Event.ENTER_FRAME, curvos);
	}
	
	public function curvos(e:Event):void {
		this.x += ax;
		this.y += ay;
		
		ax += (Math.random() * 100 - 50) / 100;
		ay += (Math.random() * 100 - 50) / 100;
		
		if (this.x > DISPLAY_WIDTH + this.width / 2 || this.x < - this.width / 2 || this.y > DISPLAY_HEIGHT + this.height / 2 || this.y < - this.height / 2) {
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME, curvos);
		}
		
		for (var ci:int = 0; ci < array.length; ci++) {
			array[ci].r += array[ci].dr;
			
			array[ci].dr += Math.floor(Math.random() * 100 - 50) / 100;
			
			if (array[ci].r > array[ci].maxr) array[ci].dr = - Math.abs(array[ci].dr);
			if (array[ci].r < array[ci].minr) array[ci].dr = Math.abs(array[ci].dr);
			
			if (array[ci].dr > 10) array[ci].dr = 5;
			if (array[ci].dr < -10) array[ci].dr = -5;
			
			array[ci].x = Math.cos(array[ci].angle * Math.PI / 180) * array[ci].r;
			array[ci].y = Math.sin(array[ci].angle * Math.PI / 180) * array[ci].r;
		}
		
		draw();
	}
	
	public function draw():void {
		this.graphics.clear();

		this.graphics.beginFill(color, 1);
		this.graphics.moveTo(array[0].x + (array[1].x - array[0].x) / 2, array[0].y + (array[1].y - array[0].y) / 2);
		for (var di:int = 1; di < array.length - 1; di++) {
			this.graphics.curveTo(array[di].x, array[di].y, array[di].x +(array[di + 1].x - array[di].x) / 2, array[di].y + (array[di + 1].y - array[di].y) / 2);
		}
		this.graphics.curveTo(array[array.length - 1].x, array[array.length - 1].y, array[array.length - 1].x + (array[0].x - array[array.length - 1].x) / 2, array[array.length - 1].y + (array[0].y - array[array.length - 1].y) / 2);
		this.graphics.curveTo(array[0].x, array[0].y, array[0].x + (array[1].x - array[0].x) / 2, array[0].y + (array[1].y - array[0].y) / 2);
	}
}