/**
 * Copyright Flagfighter172 ( http://wonderfl.net/user/Flagfighter172 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/5L4s
 */

// forked from Flagfighter172's forked from: flash on 2010-3-18
// forked from poplaryy's flash on 2010-3-18
package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Poplaryy extends Patch
	{ 
		private var NUM:int = 500;
		private var p:Particle = new Particle();
		private var bd:BitmapData = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,true,0x00FFFF00);
		private var m:Matrix = new Matrix(1, 0, 0, 1,0,0);
		private var mx:Number = 320;
		private var my:Number = 240;
		private var bmp:Bitmap;
		private var container:Sprite;
		
		public function Poplaryy() 
		{
			Console.output('Poplaryy 4.0.493');
			Console.output('Credits to Poplaryy');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			container = new Sprite();
			//addChild(container);
			bmp = new Bitmap(bd);
			//bd.fillRect(bd.rect, 0);
			container.addChild(bmp);
			for ( var i:int = 0; i < NUM; i++ ) {
				var next:Particle = p;
				p = new Particle();
				p.next = next;
				container.addChild( p );
			}
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.MOUSE_UP, onUp);
			addEventListener(Event.MOUSE_LEAVE, onUp);
		}
		private var isDown:Boolean = false;
		private function onDown(e:MouseEvent):void {
			isDown = true;
			mx = e.localX; 
			my = e.localY; 
		}
		private function onUp(e:Event):void {
			isDown = false;
		}
		override public function render(info:RenderInfo):void 
		{
			var current:Particle = this.p;
			var p:Point = isDown?new Point(mx, my):null;
			do{
				current.update(p);
			} while ( current = current.next )
			bd.lock();
			bd.applyFilter(bd, bd.rect, new Point(), new ColorMatrixFilter([
				0.9994, 0, 0, 0, 0,
				0, 0.9994, 0, 0, 0,
				0, 0, 0.9994, 0, 0,
				0, 0, 0, 0.9994, 0,
			]));
			bd.draw(container);
			bd.applyFilter(bd, bd.rect, new Point(), new BlurFilter(4, 9, 5));
			bd.unlock();
			info.render( container );
		}		
	}	
}
import flash.display.*;
import flash.geom.Point;

class Particle extends Sprite {
	public var next:Particle;
	private var vx:Number;
	private var vy:Number;
	private var vz:Number;
	public function Particle() 
	{
		graphics.beginFill(0x8888| 0xFFFFFF * Math.random(), 1);
		graphics.drawRect(-1, -1, 2, 2);
		init();
	}
	private function init():void
	{
		var theta:Number = Math.random() * Math.PI * 2;
		var phi:Number = Math.random() * Math.PI; phi = - Math.PI * 0.35;
		// x,y,z: åˆæœŸä½ç½®ã®å˜ä½ãƒ™ã‚¯ãƒˆãƒ«
		var x:Number = Math.cos(theta); // æœ€åˆã‹ã‚‰ x ã‚’ä½¿ã†ã¨ãªã«ã‹ãŠã‹ã—ã„
		var y:Number = Math.sin(theta) * Math.cos(phi);
		var z:Number = Math.sin(theta) * Math.sin(phi);
		// px, py, pz: ãƒ©ãƒ³ãƒ€ãƒ é€Ÿåº¦
		var px:Number = Math.random() - 0.5;
		var py:Number = Math.random() - 0.5;
		var pz:Number = Math.random() - 0.5;
		// i: é€Ÿåº¦ã®åŽŸç‚¹æ–¹å‘ã®æˆåˆ†ã®å¤§ãã•
		var i:Number = px * x + py * y + pz * z;
		px -= i * x;
		py -= i * y;
		pz -= i * z;
		
		// i: ã‚¸ãƒ£ã‚¤ãƒ­ã®è»¸æ–¹å‘ã®æˆåˆ†ã®å¤§ãã•
		i = py * Math.sin(phi) - pz * Math.cos(phi);
		py -= i * Math.sin(phi);
		pz += i * Math.cos(phi);
		
		var p:Number = 1 / Math.sqrt(px * px + py * py + pz * pz);
		px *= p;
		py *= p;
		pz *= p;
		// px, py, pz: æ??è??å??å??äº?
		
		if ( (x * py - y * px) > 0 ) { // åº?æ??ã??é??è??æ??å??ã??å??ç??ã??zåº?æ??
			px *= -1;
			py *= -1;
			pz *= -1;
		}
		// å??ã??ã??æ??ã??ã??
		
		var r:Number = 130+Math.random() * Math.random()*130; // å??æ??å??å??
		var v:Number = Math.sqrt(r)*0.185; // å??æ??é??åº?
		this.x = 512 + r * x; // 232:wonderflç??ä??å??åº?æ??
		this.y = 400 + r * y;
		this.z = r * z;
		vx = px * v;
		vy = py * v;
		vz = pz * v;
		this.blendMode = "add";
	}
	public function update(p:Point):void {
		x += vx;
		y += vy;
		z += vz;
		if ( !p ) p = new Point(512, 400);
		var px:Number = x - p.x;
		var py:Number = y - p.y;
		var r:Number = 1000 / Math.pow(px*px+py*py+z*z,1.5);
		vx -= px * r;
		vy -= py * r;
		vz -= z * r;
		
		if( x > 1465 || x < -1000 ){
			init();
		}
	}
}