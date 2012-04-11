/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/iDDk
 */

package  
{    
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class NeuronFight extends Patch
	{   
		public static const NUM_STARS:int = 200;
		private var _con:Constellation;        
		private var _display:BitmapData;
		private var _blur:BlurFilter = new BlurFilter(12,12, 2); 
		private var _ct:ColorTransform = new ColorTransform(1, 1, 1, .90);
		private var _pt:Point = new Point();
		private var _hsv:ColorHSV;
		private var mx:Number = 320;
		private var my:Number = 240;
		
		public function NeuronFight() 
		{
			_hsv = new ColorHSV();
			_display = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000); 
			//addChild(new Bitmap(_display));
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			initConstellation();
		}
		
		private function initConstellation():void 
		{
			_con = new Constellation(NUM_STARS);
		}
		private function mouseDown(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}		
		override public function render(info:RenderInfo):void  
		{
			_con.update(mx, my);
			_hsv.h = getTimer() / 50;
			_ct.color = _hsv.value;
			_display.colorTransform(_display.rect, _ct);
			_display.applyFilter(_display, _display.rect, _pt, _blur);
			
			_display.draw(_con);
			info.source.copyPixels(_display, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
	}
}

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

import onyx.plugin.DISPLAY_HEIGHT;
import onyx.plugin.DISPLAY_WIDTH;

class Star extends Shape {
	
	public var xv:Number;
	public var yv:Number;
	public var diameter:Number = 0.0;
	public var inside:Number = 0.0;
	public var minD:Number;
	public var maxD:Number;
	public var id:int;
	public var age:int;
	public var connected:Vector.<Boolean>;
	public var dx:Number;
	public var dy:Number;
	public var mag:Number;
	public var ext:Number;
	
	public var thisPoint:SimplePoint = new SimplePoint();
	public var targetPoint:SimplePoint = new SimplePoint();
	public var linePoint:SimplePoint = new SimplePoint();
	
	public var drawline:Boolean = false;
	
	private var numStars:int;
	
	public function Star(id:int, x:Number, y:Number, xv:Number, yv:Number, numStars:int) {
		
		this.x = x; 
		this.y = y;
		this.xv = xv;
		this.yv = yv;
		this.id = id;
		this.numStars = numStars;
		
		age = int(Math.random() * 500.0);
		
		connected = new Vector.<Boolean>(numStars, true);
		for (var i:int = 0; i < numStars; i++) connected[i] = false;
		
		minD = 20.0;
		maxD = 60.0;
	}
	
	public function setTarget(x:Number = 0.0, y:Number = 0.0):void 
	{
		targetPoint.x = x;
		targetPoint.y = y;
		//targetPoint.z = z;
	}
	
	public function update():void {
		if (inside > 0.0) inside -= .20;
		
		graphics.clear();
		graphics.beginFill(0xFFFFFF, .25);
		graphics.drawCircle(0, 0, inside * .75);
		
		var f1:Number = Math.sin(age * 0.05) * 0.4 + 0.6;
		
		thisPoint.x = x;
		thisPoint.y = y;
		
		var dx:Number = thisPoint.x - targetPoint.x;
		var dy:Number = thisPoint.y - targetPoint.y;
		var d:Number = Math.sqrt(dx * dx + dy * dy);
		diameter += (remap(d, 20.0, 60.0, minD, maxD) * f1 - diameter) * .75;
		
		var i:int = numStars;
		while(i--) {
			if (i != id) {
				
				var s:Star = Constellation.stars[i];
				
				var xd:Number = s.x - x;
				var yd:Number = s.y - y;
				var d2:Number = xd * xd + yd * yd;
				var rad:Number = s.diameter / 2.0 + diameter / 2.0;
				
				if (d2 < rad * rad) {
					
					springAdd(s.x, s.y, rad);
					
					xv += (s.xv - xv) * 0.01;
					yv += (s.yv - yv) * 0.01;
					
					if (d2 < maxD * maxD && inside > 1 && s.inside > 1) {
						var p:Point = this.globalToLocal(new Point(s.x, s.y));
						linePoint.x = p.x;
						linePoint.y  = p.y;
						graphics.lineStyle(0, 0x061861, (maxD - Math.sqrt(d2)) / 150);
						graphics.moveTo(0, 0);
						graphics.lineTo(linePoint.x, linePoint.y);
					}
					
					if (!connected[i]) {
						inside +=  1.5 * (diameter / maxD / 2 );
						connected[i] = true;
					}
					
				} else {
					connected[i] = false;
				}
			}
		}
		if (inside < 0) inside = 0.1;
		if (inside > 5) inside = 5.0;
	}
	
	
	public function display():void {
		x += xv;
		y += yv;
		
		var rad:Number = diameter / 2.0;
		if (x < rad) x = rad;
		if (x > 465 - rad) x = (465 - rad);
		if (y < rad) y = rad;
		if (y > 465 - rad) y = (465 - rad);
		
		xv *= 0.85;
		yv *= 0.85;
		
		age++;
	}
	
	private function remap(dist:Number, minDist:Number, maxDist:Number, clampMinDist:Number, clampMaxDist:Number):Number {
		if (dist < minDist) return clampMinDist;
		if (dist > maxDist) return clampMaxDist;
		return (clampMinDist + (dist - minDist) * (clampMaxDist - clampMinDist) / (maxDist - minDist));
	}
	
	private function springAdd(tx:Number, ty:Number, rad:Number):void {
		dx = (tx - x);
		dy = (ty - y);
		if ((dx != 0.0) || (dy != 0.0)) {
			mag = Math.sqrt(dx * dx + dy * dy);
			ext = (mag - rad);
			xv += dx / mag * ext * 0.13;
			yv += dy / mag * ext * 0.13;
		}
	}
}


class Constellation extends Sprite {
	
	private var NUM_STARS:int;
	public static var stars:Vector.<Star>;
	
	public function Constellation(numStars:int = 200):void {
		NUM_STARS = numStars;
		
		init();
	}
	
	private function init():void {    
		stars = new Vector.<Star>(NUM_STARS, true);
		
		conceiveStars();
	}
	
	private function conceiveStars():void {
		for (var i:int = 0; i < NUM_STARS; i++) {
			stars[i] = new Star(i, random(DISPLAY_WIDTH), random(DISPLAY_HEIGHT), random(10.0, -10.0), random(10.0, -10.0), NUM_STARS);
			addChild(stars[i]);
		}
	}
	
	public function update(targetX:Number, targetY:Number):void 
	{
		var i:int = NUM_STARS;
		while (i--) {
			var s:Star = stars[i];
			s.setTarget(targetX, targetY);
			s.display();
			s.update();
		}
	}
	
	private function random(max:Number, min:Number = 0, decimals:int = 0):Number 
	{
		if (min > max) return NaN;
		var rand:Number = Math.random() * (max - min) + min;
		var d:Number = Math.pow(10, decimals);
		return ~~((d * rand) + 0.5) / d;
	}
}

class SimplePoint {
	
	public var x:Number;
	public var y:Number;
	
	public function SimplePoint(xx:Number = 0.0, yy:Number = 0.0) {
		x = xx;
		y = yy;
	}
}