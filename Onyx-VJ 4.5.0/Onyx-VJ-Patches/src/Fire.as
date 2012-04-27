/**
 * 25-Line ActionScript Contest Entry
 *
 * Project: Fire
 * Author:  Bruce Jawn   (http://bruce-lab.blogspot.com/)
 * Date:    2009-1-10
*/
package
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Fire extends Patch
	{
		private var mx:Number = 0;
		private var my:Number = 0;
		private var Result:BitmapData;
		private var Buffer:BitmapData;
		private var Burning:BitmapData;
		private var Sourcemap:BitmapData;
		private var canvas:BitmapData;
		private var fire:Sprite;
		private var cnt:int = 0;
		private var points:Array;
		
		public function Fire():void
		{
			
			Result = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 128);
			Buffer = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 128);
			this.addChild(new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 128)));
			Burning = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x0);
			points = [new Point(0, 0), new Point(0, 0), new Point(0, 0), new Point((Math.random() * 2 - 1) / 3, Math.random() * 3 + 2), new Point(Math.random() * 2 - 1, Math.random() * 6 + 2), new Point(Math.random() * 2 - 1, Math.random() * 6 + 2)];
			fire = new Sprite();
			fire.graphics.beginGradientFill(GradientType.LINEAR, [0, 0xA20000, 0xFFF122, 0xFFFFFF, 0xF8FF1B, 0xC53C05, 0x000000], [0, 1, 1, 1, 1, 1, 1], [0, 64, 132, 186, 220, 250, 255], new Matrix(1.8686010037572895e-17, 0.1556396484375, -0.30517578125, 9.529865119162177e-18, 250, 127.5), SpreadMethod.PAD);
			fire.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x0);
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			addEventListener( MouseEvent.MOUSE_DOWN, mouseMove);
		} 
		override public function render(info:RenderInfo):void 
		{
			canvas.draw(fire);
			Sourcemap = Result.clone();
			if (++cnt % 10 == 1)
			{
				Sourcemap.fillRect(new Rectangle(Math.random() * DISPLAY_WIDTH, Math.random() * DISPLAY_HEIGHT, 6, 6), 255);
			}
			Result.applyFilter(Sourcemap, Result.rect, new Point(), new ConvolutionFilter(3, 3, [1, 1, 1, 1, 1, 1, 1, 1, 1], 9, 0));
			Result.draw(Result, new Matrix(), null, "add");
			Result.draw(Buffer, new Matrix(), null, "difference");
			Result.draw(Result, new Matrix(), new ColorTransform(0, 0, 0.9960937, 1, 0, 0, 2, 0));
			Result.merge(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 128), Result.rect, new Point(), 0, 0, 1, 0);
			//event.target.getChildAt(0).bitmapData.applyFilter(canvas, Result.rect, new Point(), new DisplacementMapFilter(Result, new Point(), 4, 4, 32, 32));
			Buffer = Sourcemap;
			for (var i:int = 0; i < 3; i++)
			{
				points[i].offset(points[i + 3].x, points[i + 3].y);
			}
			Burning.perlinNoise(30, 50, 3, 5, false, false, 1, true, [points[0], points[1], points[2]]);
			fire.filters = [new DisplacementMapFilter(Burning, new Point(0, 0), 1, 1, 10, 200, "clamp")];
			info.source.copyPixels( canvas, DISPLAY_RECT, ONYX_POINT_IDENTITY );
		}
		private function mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
			Sourcemap.fillRect(new flash.geom.Rectangle(mx - 4, my - 4, 8, 8), 255);
		}
	} //end of class
} //end of package

