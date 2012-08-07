/**
 * Copyright Nyarineko ( http://wonderfl.net/user/Nyarineko )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/4gvL
 */

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
		
	public class Brazil extends Patch
	{
		private const TF:Boolean = false; //transition mode
		private const OX:Number = DISPLAY_WIDTH / 2;
		private const OY:Number = DISPLAY_HEIGHT / 2;
		private const V:Number = 2;
		private const OBJ_MAX:Number = 60;
		private var max:uint = 20;
		private var amax:uint = 0;
		private var _canvas:BitmapData;
		private var _bmp:Bitmap;
		private var _sp:Sprite;
		private var _sr:Number;
		private var _vr:Number;
		private var first:Particle;
		
		//------------------------------------------------------
		//ã‚³ãƒ³ã‚¹ãƒˆãƒ©ã‚¯ã‚¿
		//------------------------------------------------------
		public function Brazil()
		{
			_sp = new Sprite();
			_canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x99000000);
			_bmp = new Bitmap(_canvas);
			_bmp.smoothing = true;
			_sp.addChild(_bmp);
			_sp.x = DISPLAY_WIDTH / 2;
			_sp.y = DISPLAY_HEIGHT / 2;
			
			init();
			addEventListener(MouseEvent.MOUSE_DOWN,onClick);

		}
		
		//------------------------------------------------------
		//åˆæœŸåŒ–
		//------------------------------------------------------
		private function init():void
		{
			_sr = 1;
			_vr = 0.00005;
			first = new Particle();
			var p:Particle = first;
			for(var i:uint = 0;i < max;i++){
				p.ang = i * 360 / max;
				p.vang = 1;
				p.r = 10;
				p.vr = 0;
				p.x = OX;
				p.y = OY;
				if(i != max - 1){
					p.next = new Particle();
					p = p.next;
				}
			}
		}
		
		override public function render(info:RenderInfo):void 
		{
			var sh:Shape = new Shape();
			var g:Graphics = sh.graphics;
			var ang:Number;
			var ax:Number;
			var ay:Number;
			var rr:Number;
			var anga:Number;
			var px:Number;
			var py:Number;
			var r:Number;
			var ran:Number;
			var p:Particle = first;
			var cnt:uint = 0;
			
			_canvas.lock();
			g.lineStyle(1,0xFFFFFF);
			while(p){
				cnt++;
				if(p.r > 400){
					p = p.next;
					continue;
				}
				ran =  Math.random();
				if(ran < 0.1){
					p.vang = 0;
					p.vr = V;
				}else if(ran < 0.2){
					p.vang = -V;
					p.vr = 0;
				}else if(ran < 0.3){
					p.vang = V;
					p.vr = 0;
				}else if(ran < 0.304 && amax < OBJ_MAX){
					var newP:Particle = new Particle();
					newP.ang = p.ang;
					if(p.vang == 0) newP.vang = 0;
					else newP.vang = (Math.random() < 0.5)?-1:1;
					newP.r = p.r;
					if(p.vang == 0) newP.vr = 1;
					else newP.vr = 0;
					newP.x = p.x;
					newP.y = p.y;
					newP.next = p.next;
					p.next = newP;
				}
				r = p.ang + p.vang;
				p.r = p.r + p.vr;
				
				g.moveTo(p.x,p.y);
				
				ang = Math.PI/180 * r;
				ax = p.r * Math.cos(ang);
				ay = p.r * Math.sin(ang);
				
				rr = Math.sqrt(ax * ax + ay * ay);
				
				anga = Math.PI/180 * (r - (r - p.ang) / 2);
				px = rr * Math.cos(anga);
				py = rr * Math.sin(anga);
				g.curveTo(px+OX, py+OY, ax+OX, ay+OY);
				
				p.x = ax+OX;
				p.y = ay+OY;
				
				p.ang = r;
				
				p = p.next;
			}
			if(_sr < 400 && TF){
				g.beginFill(0xFFFFFF);
				if(_vr < 8) _vr += _vr/30;
				_sr = _sr + _vr;
				g.drawCircle(OX,OY,_sr);
				g.endFill();
			}
			_canvas.draw(sh);
			g = null;
			sh = null;
			_canvas.unlock();
			amax = cnt;
			info.render(_sp);
		}
		
		private function onClick(e:MouseEvent):void
		{
			_canvas.lock();
			_canvas.fillRect(new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT), 0xFFFFFF);
			_canvas.unlock();
			init();
		}

	}
}

class Particle
{
	public var ang:Number;
	public var vang:Number;
	public var r:Number;
	public var vr:Number;
	public var x:Number;
	public var y:Number;
	public var next:Particle;
}