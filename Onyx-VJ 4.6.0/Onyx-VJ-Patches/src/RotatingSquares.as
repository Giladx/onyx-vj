package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * ...
	 * @author Anton Ã„lgmyr
	 */
	public class RotatingSquares extends Patch 
	{
		private var parts:Array;
		private var canvas:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x000000);
		private var bf:BlurFilter = new BlurFilter(8, 8, 1);
		private var cmf:ColorMatrixFilter = new ColorMatrixFilter(
			[1, 0, 0, 0, 0,
				0, 1, 0, 0, 0,
				0, 0, 1, 0, 0,
				0, 0, 0, 0.85, 0]
		);
		private var partSpr:Sprite;
		private var rad:Number = 6;
		private var sprite:Sprite;
		private var mx:Number = 320;
		private var my:Number = 240;		
	
		public function RotatingSquares():void 
		{
			sprite = new Sprite();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			doStuff();
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			mx = e.localX;
			my = e.localY;
			addEventListener(Event.ENTER_FRAME, drawFrame);
		}
		
		private function mouseUp(e:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, drawFrame);
		}
		
		private function doStuff():void {
			partSpr = new Sprite();
			partSpr.graphics.beginFill(0xFFFFFF);
			partSpr.graphics.drawRect(-rad, -rad, 2*rad, 2*rad);
			partSpr.graphics.endFill();
			
			parts = new Array();
			
			//stage.addChild(new Bitmap(canvas));

		}
		
		private function drawFrame(e:Event):void {
			var angle:Number; var size:Number = 10*Math.random()+2;
			
			for (var iters:int = 0; iters < 2; iters++) {
				var r:Number = Math.random();
				var g:Number = (1 - r) * Math.random();
				var b:Number = 1 - r - g;
				
				var CT:ColorTransform = new ColorTransform(r, g, b);
				
				angle = 2 * Math.PI * Math.random();
				parts.push( [mx, my, size * Math.cos(angle), size * Math.sin(angle), 0, Math.random()*0.3, CT, Math.random()*.6 + .75] );
			}
			
			
		}
		override public function render(info:RenderInfo):void 
		{			
			canvas.lock();
			
			canvas.applyFilter(canvas, canvas.rect, new Point(0, 0), bf);
			canvas.applyFilter(canvas, canvas.rect, new Point(0, 0), cmf);
			
			for (var i:int; i < parts.length; ++i) {
				parts[i][0] += parts[i][2];
				parts[i][1] += ( parts[i][3] += 0.327 );
				parts[i][4] += parts[i][5];
				
				if ( parts[i][0] < 0 || parts[i][0] > DISPLAY_WIDTH) {
					parts[i][2] = -parts[i][2];
					parts[i][0] += 2*parts[i][2];
				}
				
				var M:Matrix = new Matrix();
				
				M.scale(parts[i][7], parts[i][7]);
				M.rotate(parts[i][4]);
				M.translate(parts[i][0], parts[i][1]);
				
				canvas.draw( partSpr, M, parts[i][6]);
				
				if (parts[i][1] > DISPLAY_HEIGHT) {
					parts[i] = parts[parts.length - 1];
					parts.length--;
				}
			}
			
			canvas.unlock();
			info.render( canvas );
		}
	}
}