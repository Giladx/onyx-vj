/**
 * Copyright takun336 ( http://wonderfl.net/user/takun336 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/hNvo
 */

// forked from yuuganisakase's Fermat's Spiral
//
//you perceive that particles move to center but this is just illusion.
//move the slider to change the roatation speed.
//
//è¶…é«˜é€Ÿå›žè»¢ã•ã›ã‚‹ã¨å¸ã„è¾¼ã‚“ã§ã„ã‚‹ã‚ˆã†ã«è¦‹ãˆã‚‹ï¼
//

package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
		
	public class Spiral extends Patch
	{
		private var theta:Number;
		private var holder:Sprite;
		private var layer:Bitmap;
		private var g:Shape;
		private var rotationSpeed:Number = 0.05;
		private const BmSize:Number = 700;
		private var bitmapData:BitmapData;
		
		public function Spiral():void 
		{
			Console.output('Spiral adapted by Bruce LANE (http://www.batchass.fr)');
			bitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00);

			layer = new Bitmap(bitmapData);
			
			holder = new Sprite();

			holder.addChild(layer);
			
			g = new Shape();
			
			theta = 0;
			onClick();
			addEventListener(MouseEvent.MOUSE_UP, onClick);
		}
		
		private function drawFermat(c:Number = 0):void
		{
			
			if (c > 120) return;
			var r:Number;
			var p:Point;
			if (c >= 0) {
				r = 32 * Math.sqrt(c);
				p = Point.polar(r, c);
			}
			g.graphics.lineStyle(3, 0xffffff);
			g.graphics.drawCircle(p.x, p.y, 1);
			g.graphics.drawCircle( -p.x, -p.y, 1);
			//bitmapData.draw(g, new Matrix(1,0,0,1,BmSize/2, BmSize/2));
			bitmapData.draw(g, new Matrix(1,0,0,1,DISPLAY_WIDTH/2,DISPLAY_HEIGHT/2));
			g.graphics.clear(); 
		}
		private function rotate():void
		{
			holder.rotation += rotationSpeed;
		}
		private function onClick(e:Event = null):void 
		{
			
			layer.x = layer.y = -(BmSize)/2;

			rotationSpeed += 0.1;
			
			g.graphics.clear();
			g.graphics.lineStyle(3, 0xffffff);
		}
		
		override public function render(info:RenderInfo):void {
			drawFermat(theta);
			rotate();
			
			if (theta < 1) theta += 0.02;
			else theta += 0.1;

			info.render( holder );
		}		
	}
	
}