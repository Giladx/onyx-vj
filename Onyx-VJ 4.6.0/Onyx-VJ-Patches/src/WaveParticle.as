/**
 * Copyright bbbluevelvet ( http://wonderfl.net/user/bbbluevelvet )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/eMKK
 */

// forked from ProjectNya's WaveParticle
////////////////////////////////////////////////////////////////////////////////
// WaveParticle
//
// [AS3.0] WaveParticleã«æŒ‘æˆ¦ï¼ (3)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=1564
// [AS3.0] FontLoaderã‚¯ãƒ©ã‚¹ã«æŒ‘æˆ¦ï¼ (1)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=1337
//
// http://clockmaker.jp/blog/2011/11/starling-framework-sample/
////////////////////////////////////////////////////////////////////////////////

package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class WaveParticle extends Patch 
	{
		private var container:Sprite;
		private var wave:Wavep;
		private var light:Light;
		
		public function WaveParticle() {
		
			Console.output('WaveParticle from bbbluevelvet ( http://wonderfl.net/user/bbbluevelvet )');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');

			container = new Sprite();

			wave = new Wavep(new Rectangle(0, 0, 465, 300));
			container.addChild(wave);
			wave.y = 182;
			
			light = new Light(new Rectangle(0, 0, 465, 465));
			container.addChild(light);
			light.y = 0;
			
			resize();
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( container );
		}
		private function resize(evt:Event = null):void 
		{
			var sw:uint = DISPLAY_WIDTH;
			var sh:uint = DISPLAY_HEIGHT;
			var cx:uint = uint(sw/2);
			var cy:uint = uint(sh/2);

			if (wave) {
				wave.scaleX = sw/465;
				wave.y = cy - 50;
				wave.start();
			}
			if (light) {
				light.resize(new Rectangle(0, 0, sw, sh));
				light.start();
			}
		}
		
	}
	
}


//////////////////////////////////////////////////
// Waveã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.ColorTransform;
import flash.filters.BlurFilter;
import flash.display.BlendMode;
import frocessing.math.PerlinNoise;
//import org.libspark.utils.GeomUtil;

class Wavep extends Sprite {
	private var rect:Rectangle;
	private var container:Sprite;
	private var bitmapData:BitmapData;
	private var bitmap:Bitmap;
	private var points:Array;
	private static var segments:uint = 5;
	private static var ratio:Number = 1/segments;
	private static var color:uint = 0xFFFFFF;
	private var perlin:PerlinNoise;
	private var t:Number = 0;
	private var c:uint = 0;
	private static var tightness:uint = 40;
	private static var colorTrans:ColorTransform;
	private static var blur:BlurFilter;
	private static var point:Point = new Point();
	
	public function Wavep(r:Rectangle) {
		rect = r;
		init();
	}
	
	private function init():void {
		bitmapData = new BitmapData(rect.width, rect.height, true, 0x00FFFFFF);
		bitmap = new Bitmap(bitmapData);
		addChild(bitmap);
		container = new Sprite();
		addChild(container);
		container.alpha = 0.4;
		container.filters = [new BlurFilter(2, 2, 3)];
		perlin = new PerlinNoise();
		colorTrans = new ColorTransform(1, 1, 1, 0.6, 0, 0, 0, 0);
		blur = new BlurFilter(8, 8, 3);
		blendMode = BlendMode.HARDLIGHT;
	}
	public function start():void {
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
	}
	private function update(evt:Event):void {
		container.graphics.clear();
		for (var n:uint = 0; n < 6; n++) {
			var offset:Number = (n < 3) ? n*0.25 : (n + 1)*0.25;
			setup(offset);
			draw();
		}
		bitmapData.lock();
		bitmapData.draw(container, null, colorTrans, BlendMode.LAYER, rect, true);
		bitmapData.applyFilter(bitmapData, rect, point, blur);
		bitmapData.unlock();
	}
	private function setup(offset:Number):void {
		points = new Array();
		points.push(new Point(- rect.width*ratio, rect.height*0.5));
		for (var n:uint = 1; n <= segments + 1; n++) {
			var px:Number = n*rect.width*ratio;
			var py:Number = (perlin.noise(n*0.25, t + offset)*0.8 + 0.1)*rect.height;
			points.push(new Point(px - rect.width*ratio, py));
		}
		t += 0.002;
		points.push(new Point(rect.width*(1 + ratio), rect.height*0.5));
		points.unshift(points[0]);
		points.push(points[points.length - 1]);
	}
	private function draw():void {
		container.graphics.lineStyle(0, color, 0.5);
		container.graphics.moveTo(points[0].x, points[0].y);
		for (var p:uint = 0; p < points.length - 3; p++) {
			var p0:Point = points[p];
			var p1:Point = points[p + 1];
			var p2:Point = points[p + 2];
			var p3:Point = points[p + 3];
			for (var s:uint = 1; s < tightness + 1; s++) {
				//var px:Number = GeomUtil.spline(p0.x, p1.x, p2.x, p3.x, s/tightness);
				//var py:Number = GeomUtil.spline(p0.y, p1.y, p2.y, p3.y, s/tightness);
				var px:Number = spline(p0.x, p1.x, p2.x, p3.x, s/tightness);
				var py:Number = spline(p0.y, p1.y, p2.y, p3.y, s/tightness);
				container.graphics.lineTo(px, py);
			}
		}
	}
	private function spline(p0:Number, p1:Number, p2:Number, p3:Number, t:Number):Number {
		var v0:Number = (p2 - p0) * 0.5;
		var v1:Number = (p3 - p1) * 0.5;
		var t2:Number = t * t;
		var t3:Number = t2 * t;
		return (2 * p1 - 2 * p2 + v0 + v1) * t3 + ( -3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1;
	}
	
}


//////////////////////////////////////////////////
// Lightã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.filters.BlurFilter;
import flash.display.BlendMode;

class Light extends Sprite {
	private var rect:Rectangle;
	private var container:Sprite;
	private var particles:Array;
	private var timer:Timer;
	private static var interval:uint = 50;
	
	public function Light(r:Rectangle) {
		rect = r;
		init();
	}
	
	private function init():void {
		particles = new Array();
		container = new Sprite();
		addChild(container);
		container.filters = [new BlurFilter(4, 4, 3)];
		blendMode = BlendMode.ADD;
	}
	public function start():void {
		create();
		timer = new Timer(interval);
		timer.addEventListener(TimerEvent.TIMER, create, false, 0, true);
		timer.start();
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
	}
	private function create(evt:TimerEvent = null):void {
		var radius:uint = uint(Math.random()*6 + 2);
		var particle:Particle = new Particle(radius);
		particle.x = (Math.random()*0.8 + 0.1)*rect.width;
		particle.y = (Math.random()*0.3 + 0.4)*rect.height;
		particle.initialize(uint(Math.random()*20) + 100);
		particle.vx = (Math.random() - 0.5)*2;
		particle.vy = Math.random()*5 - 1;
		particle.acceleration = Math.random()*0.01 + 0.996;
		container.addChild(particle);
		particles.push(particle);
	}
	private function update(evt:Event):void {
		for (var n:String in particles) {
			var particle:Particle = particles[n];
			if (particle) particle.update();
			if (particle.life < 0 || particle.y < 0 || particle.y > rect.height) {
				if (container.contains(particle)) container.removeChild(particle);
				particle = null;
				delete particles[n];
			}
		}
	}
	public function resize(r:Rectangle):void {
		rect = r;
	}
	
}


//////////////////////////////////////////////////
// Particleã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.geom.Matrix;
import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.InterpolationMethod;

class Particle extends Sprite {
	private var radius:uint;
	private static var colors:Array = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
	private static var alphas:Array = [1, 0.8, 0];
	private static var ratios:Array = [0, 153, 255];
	private var matrix:Matrix;
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var acceleration:Number = 1;
	private var max:uint = 100;
	public var life:int = max;
	private var _scale:Number = 1;
	
	public function Particle(r:uint) {
		radius = r;
		init();
	}
	
	public function init():void {
		draw();
	}
	public function initialize(m:uint):void {
		max = m;
		life = max;
	}
	public function update():void {
		life --;
		x += vx;
		y -= vy;
		vy *= acceleration;
		scale = life/max;
	}
	public function get scale():Number {
		return _scale;
	}
	public function set scale(value:Number):void {
		_scale = value;
		scaleX = scaleY = _scale;
		alpha = _scale;
	}
	private function draw():void {
		matrix = new Matrix();
		matrix.createGradientBox(radius*2, radius*2, 0, - radius, - radius);
		graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();
	}
	
}

