/**
 * Copyright Saqoosha ( http://wonderfl.net/user/Saqoosha )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/71Zy
 */

package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class ForceField extends Patch {
		
		private static const ZERO_POINT:Point = new Point();
		
		private static const MAP_SCALE:Number = 0.25;
		private static const TRAIL_SCALE:Number = 2;
		private static const DRAW_SCALE:Number = 0.5;
		
		private var _timer:Timer;
		private var _seed:Number = Math.random();
		private var _offsets:Array = [new Point(), new Point()];
		private var _forcemap:BitmapData;
		private var _count:int = 0;
		
		private var _particles:Vector.<Particle>;
		private var _canvas:Shape;
		private var _fade:BitmapData;
		private var _darken:ColorMatrixFilter = new ColorMatrixFilter([
			1, 0, 0, 0, -2,
			0, 1, 0, 0, -2,
			0, 0, 1, 0, -2,
			0, 0, 0, 1, 0
		]);
		private var _blur:BlurFilter = new BlurFilter(2, 2, 1);
		
		private var _drawMatrix:Matrix = new Matrix(DRAW_SCALE, 0, 0, DRAW_SCALE, 0, 0);
		private var _drawColor:ColorTransform = new ColorTransform(0.1, 0.1, 0.1);
		private var color:ColorHSV = new ColorHSV(0, 0.5); 
		private var sprite:Sprite;
		private var mx:Number = 320;
		private var my:Number = 240;
		
		public function ForceField() 
		{
			sprite = new Sprite();
			_timer = new Timer(500, 0);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
			_forcemap = new BitmapData(DISPLAY_WIDTH * MAP_SCALE, DISPLAY_HEIGHT * MAP_SCALE, true, 0x0);
			//addChild(new Bitmap(_forcemap));
			
			_particles = new Vector.<Particle>();
			
			_fade = new BitmapData(DISPLAY_WIDTH * DRAW_SCALE, DISPLAY_HEIGHT * DRAW_SCALE, true, 0x0);
			var bm:Bitmap = sprite.addChild(new Bitmap(_fade, PixelSnapping.AUTO, true)) as Bitmap;
			bm.scaleX = bm.scaleY = 1 / DRAW_SCALE;
			
			_canvas = addChild(new Shape()) as Shape;
			_canvas.blendMode = BlendMode.ADD;
			addEventListener( MouseEvent.MOUSE_DOWN, onDown );
			addEventListener( MouseEvent.MOUSE_MOVE, onDown );

		}
		private function onDown(e:MouseEvent):void 
		{
			mx = e.localX; 
			my = e.localY; 			
		}	
		private function _onTimer(e:TimerEvent = null):void
		{
			var t:int = getTimer();
			_offsets[0].x = t / 20;
			_offsets[1].y = t / 35;
			_forcemap.perlinNoise(150, 150, 2, _seed, true, true, 3, false, _offsets);
		}
		
		override public function render(info:RenderInfo):void 
		{
			var n:int = 10;
			while (n--) {
				var a:Number = getTimer() / 1000 + Math.random() * Math.PI;
				color.h = (getTimer() / 20000) * 360;
				var p:Particle = new Particle(mx, my, Math.cos(a), Math.sin(a), color.value);
				_particles.push(p);
			}
			
			var g:Graphics = _canvas.graphics;
			g.clear();
			
			n = _particles.length;
			while (n--) {
				p = _particles[n];
				var c:uint = _forcemap.getPixel(p.x * MAP_SCALE, p.y * MAP_SCALE);
				p.vx += (((c >> 16) & 0xff) - 0x80) / 0x80 * 0.3;
				p.vy += (((c >> 8) & 0xff) - 0x80) / 0x80 * 0.3;
				p.x += p.vx;
				p.y += p.vy;
				p.life -= 0.005;
				if (p.life < 0 || p.x < -10 || p.x > DISPLAY_WIDTH || p.y < -10 || p.y > DISPLAY_HEIGHT) {
					_particles.splice(n, 1);
				} else {
					g.lineStyle(0, p.color, 0.5 * p.life);
					g.moveTo(p.x, p.y);
					g.lineTo(p.x - (p.x - p.px) * TRAIL_SCALE, p.y - (p.y - p.py) * TRAIL_SCALE);
					p.px = p.x;
					p.py = p.y;
				}
			}
			
			if (_count & 1) {
				_fade.lock();
				_fade.draw(_canvas, _drawMatrix, _drawColor, BlendMode.ADD);
				_fade.applyFilter(_fade, _fade.rect, ZERO_POINT, _blur);
				_fade.unlock();
			}
			if (_count & 0x4) {
				_onTimer();
			}
			_count++;
			info.render(sprite);
		}
	}
}



class Particle {
	public var x:Number = 0;
	public var y:Number = 0;
	public var px:Number = 0;
	public var py:Number = 0;
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var life:Number = 1;
	public var color:uint = 0xffffff;
	public function Particle(x:Number = 0, y:Number = 0, vx:Number = 0, vy:Number = 0, color:uint = 0xffffff) {
		this.x = this.px = x;
		this.y = this.py = y;
		this.vx = vx;
		this.vy = vy;
		this.color = color;
	}
}