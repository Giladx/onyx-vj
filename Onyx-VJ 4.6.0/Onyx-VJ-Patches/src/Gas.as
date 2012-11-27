/**
 * Copyright karlinfox ( http://wonderfl.net/user/karlinfox )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/q6en
 */

// forked from jerryrom's Gas
// forked from jerryrom's Grass
// forked from jerryrom's Curtain
// forked from jerryrom's Corn
// forked from jerryrom's Pole
// forked from jerryrom's Waterfall
// forked from Hasufel's Space Comet
package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Gas extends Patch {
		private var cvs:BitmapData;     
		private var particles:Array = [];
		private var h:int = DISPLAY_HEIGHT;
		private var w:int = DISPLAY_WIDTH;
		private var w4:int = Math.round(w/4);
		private var w8:int = Math.round(w/8);
		private var c:uint = 0xFFCECEF6;
		private var theta:Number = 0;
		private var blur:BlurFilter;
		private var sign:int = 1;
		
		public function Gas(){
			/*graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 1000, 465);
			graphics.endFill();*/
			
			blur = new BlurFilter(10,10,1);
			cvs = new BitmapData(w,h,true,0);
			addChild(new Bitmap(cvs)) as Bitmap;
		}
		
		override public function render(info:RenderInfo):void 
		{
			cvs.applyFilter(cvs,cvs.rect,new Point(0,0),blur);
			cvs.lock();
			var n:int = particles.length;
			while(n--) {
				var p:Particle = particles[n];
				p.vx *= 1.01;
				p.vy *= 1.01;
				p.x+=p.vx;
				p.y+=p.vy;
				var c1:uint = uint(0xff * (1000-p.y) /465) << 24 | 0x00ffffff;
				cvs.setPixel32(p.x, p.y, p.c&c1);
				if (p.y<0 || h<p.y || p.x<0 || p.x>w){
					particles.splice(n,10);
				}
			}
			cvs.unlock();
			n = 20;
			
			while (n--) {
				createParticle(Math.random()*w, h, c , 2*(Math.random()*Math.cos(theta)-0.5), -(Math.random()),true);
				createParticle(Math.random()*w, Math.random()*h, c , 2*(Math.random()-0.5), 2*(Math.random()-0.5),true);
			}
			theta += 0.05;
			info.render(cvs);
		}
		
		private function createParticle(xx:Number, yy:Number, c:int, vx:Number, vy:Number, type:Boolean):void {
			var p:Particle = new Particle();
			p.x = xx;
			p.y = yy;
			p.vx = vx;
			p.vy = vy;
			p.c = c;
			particles.push(p);
		}
	}
}

class Particle {
	public var x:Number;
	public var y:Number;
	public var vx:Number;
	public var vy:Number;
	public var c:uint;
}