/**
 * Copyright ic_yas ( http://wonderfl.net/user/ic_yas )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/1gzM
 */

// forked from yonatan's Light Effect
// forked from http://zozuar.org/las3rfl/node/97

package {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class LightEffect extends Patch {
		private var base:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0);
		private var rot:BitmapData  = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0);
		private var canvas:Bitmap = new Bitmap(base);
		private var mtx:Matrix = new Matrix;
		private var blur:BlurFilter = new BlurFilter;
		private var dst:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0);
		private var mx:int = 320;
		private var my:int = 240;
		private var _rotspeed:Number = 0.007;
		private var rota:Number				= 0;
	
		public function LightEffect() {
			parameters.addParameters(
				new ParameterNumber('rotspeed', 'rotspd', -1, 1, rotspeed, 1000)
			);
			
			var c:uint;
			var r:Rectangle = new Rectangle(0, 0, 32, 32);
			for(var x:int = 0; x < 5; x++) {
				for(var y:int = 0; y < 5; y++) {
					c = 1 | x*0x100 | y*0x10000;
					r.x = DISPLAY_WIDTH/4 + x*50;
					r.y = DISPLAY_WIDTH/4 + y*50;
					base.fillRect(r, c);
				}
			}
			addEventListener( MouseEvent.MOUSE_DOWN, startDraw );
			addEventListener( MouseEvent.MOUSE_MOVE, startDraw );
		}
		private function startDraw(evt:MouseEvent) : void 
		{
			mx = evt.localX; 
			my = evt.localY; 		
		}	
		
		private function process(src:BitmapData, cx:Number, cy:Number):BitmapData {
			var dst:BitmapData = this.dst;
			mtx.identity();
			mtx.translate(-DISPLAY_WIDTH * 1/512, -DISPLAY_HEIGHT * 1/512);
			mtx.translate(cx, cy);
			mtx.scale(257/256, 257/256);
			var cnt:int = 8;
			var tmp:BitmapData;
			src.lock(); dst.lock();
			while(cnt--) {
				mtx.concat(mtx);
				dst.copyPixels(src, src.rect, src.rect.topLeft);
				dst.draw(src, mtx, null, "add");
				dst.applyFilter(dst, dst.rect, dst.rect.topLeft, blur);
				tmp = src;
				src = dst;
				dst = tmp;
			}
			src.unlock(); dst.unlock();
			return src;
		}
		
		override public function render(info:RenderInfo):void {
			mtx.identity();
			mtx.translate(-DISPLAY_WIDTH/2, -DISPLAY_HEIGHT/2);
			//mtx.rotate(getTimer() / 1000);
			rota += rotspeed;
			mtx.rotate(rota);
			mtx.translate(DISPLAY_WIDTH/2, DISPLAY_HEIGHT/2);
			rot.fillRect(rot.rect, 0);
			rot.draw(base, mtx);
			canvas.bitmapData = process(rot, 0.5 - mx/DISPLAY_WIDTH, 0.5 - my/DISPLAY_HEIGHT);
			info.render(canvas);
		}

		public function get rotspeed():Number
		{
			return _rotspeed;
		}

		public function set rotspeed(value:Number):void
		{
			_rotspeed = value;
		}

	}
}