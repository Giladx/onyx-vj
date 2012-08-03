/**
 * Copyright Voiceshek ( http://wonderfl.net/user/Voiceshek )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/iRhx
 */

// forked from k3lab's Another Planet
package 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Planet extends Patch {
		private var canvas:BitmapData;
		private var circle_Array:Array = [];
		private var reset:Array = [];
		private var cirlce_Num:int = 10000; 
		private var color:ColorTransform = new ColorTransform(1, 1, 1, 1, -10, -35 * 20, -15 * 2); 
		private var planet:Sprite;
		private var mx:Number = 320;
		private var my:Number = 240;

		public function Planet():void {
			
			createPos();
			setting();
			addEventListener( MouseEvent.MOUSE_DOWN, startDraw );
			addEventListener( MouseEvent.MOUSE_MOVE, startDraw );
		}
		private function startDraw(evt:MouseEvent):void {
			mx = evt.localX; 
			my = evt.localY; 		
		}
		private function createPos():void {
			for (var i:int = 0; i < cirlce_Num; i++) {
				var p:Particle = new Particle()
				p.x = Math.random() * DISPLAY_WIDTH;
				p.y = Math.random() * DISPLAY_HEIGHT;
				circle_Array[i] = p;
				var r:Number = i / cirlce_Num * 2 * Math.PI / 10;
				var resetPos:Object = { x: Math.cos(r * 100) * 100 + 240, y:Math.sin(r * 100) * 100 + 240 };
				reset[i]=resetPos;
			}
		}
		private function setting():void {
			canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0);
			//addChild(new Bitmap(canvas)) as Bitmap;	
			planet= addChild(new Sprite()) as Sprite;
			planet.graphics.beginGradientFill(GradientType.RADIAL,[0xF56800,0xFF0000],[0.1,0.4],[10,255],null,"pad","rgb",0)
			planet.graphics.drawCircle(0, 0, 100);
			planet.graphics.endFill();
			planet.x = 240;
			planet.y = 240;
		}
		override public function render(info:RenderInfo):void {
			canvas.lock();
			canvas.colorTransform(canvas.rect, color); 
			for (var i:int = 0; i < cirlce_Num; i++) {
				var p:Particle = circle_Array[i];
				var r:Number = Math.PI * p.r / 180;
				var posX:Number = Math.sin(r) * p.n * mx/100;
				var posY:Number = -(Math.cos(r)) * p.n * my/100;
				p.x += posX;
				p.y += posY;
				p.n += 0.09;
				if (p.x > DISPLAY_WIDTH || p.x < 0 || p.y > DISPLAY_HEIGHT || p.y < 0) {
					p.x = reset[i].x;
					p.y = reset[i].y;
					p.n = 0;
				}
				canvas.setPixel(p.x, p.y, 0xFFFFFF);
			}
			canvas.unlock();
			info.render(canvas);
		}
	}
}

class Particle {
	public var r:int;
	public var n:Number;
	public var x:Number;
	public var y:Number;
	public function Particle() {
		r = Math.random() * 360;
		n = 0;
		x = 0;
		y = 0;
	}	
}