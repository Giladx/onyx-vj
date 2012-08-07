/**
 * Copyright Watanabe.Hiroki ( http://wonderfl.net/user/Watanabe.Hiroki )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/9Odu
 */

// forked from mousepancyo's SAKURA

package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import EmbeddedAssets.AssetForBallSphere;
	
	public class Sakura extends Patch
	{
		private const NUM_SAKURA:int = 25;
		private var _canvas:BitmapData;
		private var _ctf:ColorTransform;
		
		private var _dict:Dictionary = new Dictionary(true);
		
		private var _sakura:BitmapData;
		private var _sakuraList:Vector.<Sprite> = Vector.<Sprite>([]);
		private var sprite:Sprite;

		
		public function Sakura()
		{
			_sakura = new AssetForBallSphere();		
			sprite = new Sprite();
			addChild(sprite);
			_canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0);
			sprite.addChild(new Bitmap(_canvas));
			_ctf = new ColorTransform(.75, .75, .75);
			var n:int = NUM_SAKURA;
			while(n--){
				var sak:Sprite = new Sprite();
				var bmd:BitmapData = _sakura.clone();
				var bm:Bitmap = new Bitmap(bmd);
				sak.addChild(bm);
				bm.x = -bm.width * .5;
				bm.y = -bm.height * .5;
				sak.scaleX = sak.scaleY = Math.random() * 1.2 + .3;
				sak.x = Math.random() * 300 - 200;
				sak.y = Math.random() * -500 - 100;
				sak.filters = [new BlurFilter(4, 4)];
				sak.blendMode = "add";
				_dict[sak] = {vx:3 - sak.scaleX, vy:Math.random() * sak.scaleY + 1, inix:sak.x, iniy:sak.y};
				sprite.addChild(sak);
				_sakuraList.push(sak);
			}

		}

		
		private function fall(sak:Sprite):void
		{
			sak.rotationX += Math.random() * 10; 
			sak.rotationY += Math.random() * 10;
			var vx:Number = _dict[sak].vx;
			var vy:Number = _dict[sak].vy;
			vx = vx + (180 - (sak.rotationY % 360)) * .003;
			vy = vy - (180 - (sak.rotationX % 180)) * .008;
			sak.x += vx;
			sak.y += vy;
			if(sak.x > 500) sak.x = _dict[sak].inix;
			if(sak.y > 500) sak.y = _dict[sak].iniy;
		}
		

		override public function render(info:RenderInfo):void 
		{
			var n:int = NUM_SAKURA;
			while(n--){
				fall(_sakuraList[n]);
			}
			_canvas.lock();
			_canvas.draw(info.source);
			_canvas.applyFilter(_canvas, _canvas.rect, new Point(), new BlurFilter(16, 16));
			_canvas.colorTransform(_canvas.rect, _ctf);
			_canvas.unlock();
			info.render( sprite );
			
		}
	}
}

