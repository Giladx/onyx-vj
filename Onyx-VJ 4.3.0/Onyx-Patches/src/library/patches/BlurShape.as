/**
 * Copyright faseer ( http://wonderfl.net/user/faseer )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/7wEE
 */

package library.patches {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	[SWF(width='460', height='368', frameRate='24', backgroundColor='#FFFFFF')]
	public class BlurShape extends Patch
	{
		
		public var canvas:BitmapData;
		public var drawHere:BitmapData;
		public var mat:Matrix;
		private var bitmap:Bitmap;
		
		private var grad:Shape = new Shape();
		private var offsets:Array = [new Point()];
		
		
		public function BlurShape()
		{
			Console.output('BlurShape');
			Console.output('Credits to http://wonderfl.net/user/faseer');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			/*parameters.addParameters(
				new ParameterColor('lineColor', 'Color'),
				new ParameterInteger( 'particlesnum', '# of particles', 1, 1000, _particlesnum )
			)*/ 
			canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT,false,0x000000);
			drawHere = new BitmapData(canvas.width, canvas.height, false, 0x000000);//FFFFFF);
			bitmap = new Bitmap(canvas);
			addChild(bitmap);
			//drawGradient(grad, canvas.width*.8);
		}
				
		public function drawGradient(s:Shape, size:Number):void
		{
			var m:Matrix = new Matrix();
			m.createGradientBox(size, size);
			
			s.graphics.clear();
			s.graphics.beginGradientFill(
				GradientType.RADIAL,
				[0x000000, 0x808080], // colors
				[       0,        1], // alphas
				[       0,      255], // ratios
				m, // matrix
				'pad', 'rgb', 0
			);
			s.graphics.drawRect(0, 0, size, size);
			s.graphics.endFill();
		}

		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			offsets[0].x++;
			offsets[0].y++;
			
			var f:Number = Math.PI / 180 * .1;//.33;
			var fx:Number = offsets[0].x * f;
			var fy:Number = offsets[0].y * f;
			drawHere.perlinNoise( drawHere.width * Math.cos(fx), drawHere.height * Math.sin(fy), 1, 1, false, false, 7, false, offsets);
			
			drawHere.draw(grad, null, new ColorTransform(2, 2, 2, 1, 255, 255, 255), BlendMode.ADD);
			drawHere.draw(grad, null, null, BlendMode.OVERLAY);

			mat = new Matrix();
			mat.scale(canvas.width / drawHere.width, canvas.height / drawHere.height);

			canvas.draw(drawHere, mat);
			canvas.colorTransform(drawHere.rect, new ColorTransform(Math.random()*0.4+0.6,Math.random()*0.4+0.6,Math.random()*0.4+0.6,1,0,0,0,0));
			info.source.copyPixels(canvas, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
		
	}
}
