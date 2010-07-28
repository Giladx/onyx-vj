/**
 * Copyright faseer ( http://wonderfl.net/user/faseer )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/8g7u
 */

package library.patches 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	[SWF(width='460', height='368', frameRate='24', backgroundColor='#FFFFFF')]
	public class WhirlFlower extends Patch
	{
		private var img:BitmapData;
		private var con:Sprite;
		private var xpos:Number = 240;
		private var ypos:Number = 240;
		
		public function WhirlFlower() 
		{
			Console.output('WhirlFlower');
			Console.output('Credits to http://wonderfl.net/user/faseer');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			createBG(0);
			
			img = createImage();
			
			con = createContainer(xpos, ypos);
			
			init(con, img, 20);
			
		}
		
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			var radius:Number = 50;
			xpos += radius - Math.random() * (radius * 2);
			ypos += radius - Math.random() * (radius * 2);
			if (xpos < 240 - radius) xpos = 240 - radius;
			else if (xpos > 240 + radius) xpos = 240 + radius;
			if (ypos < 240 - radius) ypos = 240 - radius;
			else if (ypos > 240 + radius) ypos = 240 + radius;
			
			var n:int = con.numChildren;
			var s:Sprite;
			for (var i:int = 0; i < n; ++i)
			{
				s = con.getChildAt(i) as Sprite;
				s.getChildAt(0).x = con.x - 240;
				s.getChildAt(0).y = con.y - 240;
				s.rotation += (con.x - 240) * i * .05;
			}
			
			con.x += (xpos - con.x) * .05;
			con.y += (ypos - con.y) * .05;
			info.source.copyPixels(img, DISPLAY_RECT, ONYX_POINT_IDENTITY);

		}
		
		private function init(con:Sprite, img:BitmapData, n:int):void
		{
			for (var i:int = 0; i < n; ++i)
			{
				var b:Bitmap = new Bitmap(img);
				b.x = -b.width * .5;
				b.y = -b.height * .1;
				//b.transform.colorTransform = new ColorTransform(1 /n* i, 1 /n* i, 1 /n* i);
				
				var s1:Sprite = new Sprite();
				s1.addChild(b);
				var s:Sprite = new Sprite();
				s.addChild(s1);
				
				var r:Number = (Math.PI / n) * i;
				s.x = Math.cos(r) * i;
				s.y = Math.sin(r) * i;
				s.scaleX =
					s.scaleY = 1.0 - .2 / n * i;
				s.rotation = r * 57.30;
				con.addChildAt(s,0);
			}
		}
		
		private function createContainer(x:Number, y:Number):Sprite
		{
			var s:Sprite = addChild(new Sprite()) as Sprite;
			s.x = x;
			s.y = y;
			return s;
		}
		private function createImage():BitmapData
		{
			var w:int = 50, h:int = 200;
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(w, h, 0);
			
			var gra:Shape = new Shape();
			gra.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, 0xFFFFFF], [0, 1], [50, 255], mat,'pad','rgb',.75);
			gra.graphics.drawRect(0, 0, w, h);
			gra.graphics.endFill();
			
			var bd:BitmapData = new BitmapData(w, h, true, 0);
			bd.perlinNoise(w/4, h/2, 1, Math.random()*0xFF, true, true, 7);
			bd.draw(gra, null, new ColorTransform(2,2,2,1),BlendMode.ADD);
			bd.draw(gra, null, null, BlendMode.ERASE);
			
			return bd;
		}
		private function createBG(color:uint):Shape
		{
			var s:Shape = addChild(new Shape()) as Shape;
			s.graphics.beginFill(color);
			s.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			s.graphics.endFill();
			return s;
		}
		
	}
}
