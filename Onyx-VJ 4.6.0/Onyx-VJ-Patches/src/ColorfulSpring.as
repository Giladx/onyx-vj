/**
 * Copyright TIAGODJF ( http://wonderfl.net/user/TIAGODJF )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/psQk
 */

// forked from _ueueueueue's forked from: Colorful Spring Particle
/**
 * Copyright matsu4512 ( http://wonderfl.net/user/matsu4512 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/9nuR
 */

package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class ColorfulSpring extends Patch {
		private var array:Array = [];
		private var _n:int = 10;
		private var minDist:int = 5;
		private var _springAmount:Number = 0.0075;
		private var canvas:Bitmap, bmpData:BitmapData, sp:Sprite;
		private var tr:ColorTransform = new ColorTransform(0.97,0.97,0.995,1);
		
		public function ColorfulSpring() {
			
			/*parameters.addParameters(
				new ParameterInteger('n', 'spring count', 10, 50, _n),
				new ParameterNumber('springAmount', 'spring Amount', 0, 0.01, _springAmount, 1000)
			);*/
				
			sp = new Sprite();
			for(var i:int = 0; i < n; i++){
				var ball:Ball = new Ball(
					Math.random()*2-1,
					Math.random()*2-1,
					i * 18 + 30,
					0x990000
				);
				array.push(ball);
				ball.x = DISPLAY_WIDTH / 2 + (Math.random() * 10 - 5);
				ball.y = DISPLAY_HEIGHT / 2 + (Math.random() * 10 - 5);
				ball.rotationX = Math.random() * 360;
				ball.rotationY = Math.random() * 360;
				sp.addChild(ball);
			}
			
			bmpData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0xFF0FFFF);
			canvas = new Bitmap(bmpData);
			//addChild(canvas);
		}
		
		override public function render(info:RenderInfo):void {
			
			bmpData.colorTransform(bmpData.rect, tr);
			bmpData.draw(sp);
			
			var len:uint = n;
			while(len--) {
				var ball:Ball = array[len];
				ball.rotationX += ball.vx;
				ball.rotationY += ball.vy;
				ball.alpha += (ball.toAlpha-ball.alpha)/4;
				ball.toAlpha = 0;
				//if(ball.x < -20) ball.x = stage.stageWidth+20;
				//else if(ball.x > stage.stageWidth+20) ball.x = -20;
				//if(ball.y < -20) ball.y = stage.stageHeight+20;
				//else if(ball.y > stage.stageHeight+20) ball.y = -20;
			}
			
			sp.graphics.clear();
			for(var i:int = 0; i < n - 1; i++){
				var partA:Ball = array[i];
				for(var j:uint = i + 1; j < n; j++){
					var partB:Ball = array[j];
					spring(partA, partB);
				}
			}
			info.render(canvas);
		}
		
		private function spring(b1:Ball, b2:Ball):void{
			var dx:Number = b2.x - b1.x;
			var dy:Number = b2.y - b1.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			if(dist < minDist){                
				sp.graphics.lineStyle(1);
				var m:Matrix = new Matrix;
				m.createGradientBox(Math.abs(dx), Math.abs(dy), Math.atan2(dy,dx), Math.min(b1.x, b2.x), Math.min(b1.y, b2.y));
				sp.graphics.lineGradientStyle(GradientType.LINEAR, [b1.color, b2.color], [b1.alpha, b2.alpha],    [0,255], m);
				sp.graphics.moveTo(b1.x, b1.y);
				sp.graphics.lineTo(b2.x, b2.y);
				b1.toAlpha += 0.1;
				b2.toAlpha += 0.1;
				var ax:Number = dx * springAmount;
				var ay:Number = dy * springAmount;
				b1.vx += ax / b1.r;
				b1.vy += ay / b1.r;
				b2.vx -= ax / b2.r;
				b2.vy -= ay / b2.r;
			}
		}

		public function get n():int
		{
			return _n;
		}

		public function set n(value:int):void
		{
			_n = value;
		}

		public function get springAmount():Number
		{
			return _springAmount;
		}

		public function set springAmount(value:Number):void
		{
			_springAmount = value;
		}


	}
}

import flash.display.*;
import flash.filters.*;

class Ball extends Sprite {
	public var vx:Number, vy:Number, r:Number, toAlpha:Number, color:uint;
	
	public function Ball(vx:Number, vy:Number, r:Number, color:uint) {
		this.vx = vx; this.vy = vy; this.r = r; this.color = color;
		toAlpha = 0;
		
		graphics.lineStyle(1,0xFFFFFF);
		graphics.drawCircle(0, 0, r);
		filters = [new GlowFilter(color, 1, 6, 6 ,2), new BlurFilter(4,4)];
		blendMode = BlendMode.ADD;
	}
}
