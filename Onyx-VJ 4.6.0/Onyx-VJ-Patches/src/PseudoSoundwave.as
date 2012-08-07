/**
 * Copyright shapevent ( http://wonderfl.net/user/shapevent )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/2xQo
 */

package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class PseudoSoundwave extends Patch {
		private var a:Number = 0.02;
		private var b:Number = .9998;
		
		private var xn1:Number = 5;
		private var yn1:Number = 0;
		private var xn:Number, yn:Number;
		
		private var scale:Number = 10;
		private var iterations:Number = 20000;
		private var step:Number;
		
		private var canvas:BitmapData;
		
		private var circle:Sprite = new Sprite();
		private var pnt:Point = new Point();
		private var dot:BitmapData;
		
		public function PseudoSoundwave() {
			
			step = DISPLAY_WIDTH / iterations;
			canvas = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0xEFEFEF );
			dot = new BitmapData(4,4,true, 0x00005500);
			with(circle.graphics) beginFill(0, 0.3), drawCircle(2,2,1);
			
			dot.draw(circle);
			
		}
		override public function render(info:RenderInfo):void {
			
				 
			canvas.fillRect(canvas.rect, 0xEFEFEF);
			
			a = mouseY / 1000;
			xn1 = mouseX / 30;
			yn1 = 0;
			for (var i:int = 0; i<iterations; i++){
				xn = xn1;
				yn = yn1;
				xn1 = b * yn + f(xn);
				yn1 = -xn + f(xn1);
				pnt.x = i * step;
				pnt.y = 250 + yn1 * scale;
				canvas.copyPixels(dot, dot.rect, pnt, null, null, true);
				
			}
			info.render(canvas);
		}
		private function f(x:Number):Number{
			var x2:Number = x * x;
			return a * x + (2 * (1 - a) * x2) / (1 + x2);
		}
	}
}