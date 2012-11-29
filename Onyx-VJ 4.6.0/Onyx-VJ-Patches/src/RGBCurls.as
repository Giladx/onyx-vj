/**
 * Copyright umhr ( http://wonderfl.net/user/umhr )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/6Wfx
 */

package
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class RGBCurls extends Patch
	{
		private var _mousePoint:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();	
		private var _count:int;	
		private var _bitmap:Bitmap;
		
		private var _shape:Shape = new Shape();
		private var mx:Number = 320;
		private var my:Number = 240;
		
		private const FADE:ColorTransform = new ColorTransform(1, 1, 1, 1, -0x6, -0x6, -0x6);
		
		public function RGBCurls()
		{
			Console.output('RGBCurls from http://wonderfl.net/c/6Wfx adapted by Bruce LANE (http://www.batchass.fr)');
			_bitmap = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000));
			_bitmap.filters = [new BlurFilter(8,8)];
			
			var point:Point = new Point(mx, my);
			
			for (var i:int = 0; i < 3; i++) 
			{				
				var vector:Vector.<Point> = new Vector.<Point>();			
				for (var j:int = 0; j < 3; j++) {				
					vector[j] = point;				
				}			
				_mousePoint[i] =vector;		
			}
			addEventListener( MouseEvent.MOUSE_DOWN, onDown );
			addEventListener( MouseEvent.MOUSE_MOVE, onDown );

		}
		override public function render(info:RenderInfo):void		
		{		
			_count++;
			
			for (var i:int = 0; i < 3; i++) {
				
				var inertiaPoint:Point = _mousePoint[i][0].subtract(_mousePoint[i][1]).add(_mousePoint[i][0]);			
				var radian:Number = _count / 6 + Math.PI * 2 * i / 3;			
				var r:Number = 5 * ( 1+ 4* Math.sin(_count / 12));			
				var mousePoint:Point = new Point(mx + Math.cos(radian) * r , my + Math.sin(radian) * r);			
				inertiaPoint.x = inertiaPoint.x * 0.97 + mousePoint.x * 0.03;			
				inertiaPoint.y = inertiaPoint.y * 0.97 + mousePoint.y * 0.03;			
				_mousePoint[i].unshift(inertiaPoint);			
				_mousePoint[i].length = 3;			
			}		
			draw(_mousePoint);	
			info.render(_bitmap);
		}
	
		private function draw(mousePoint:Vector.<Vector.<Point>>):void {
			
			_shape.graphics.clear();
			
			var colors:Array = [0xFF0000, 0x00FF00, 0x0000FF];
			
			for (var i:int = 0; i < 3; i++) {			
				_shape.graphics.lineStyle(16, colors[i]);			
				var m0:Point = Point.interpolate(mousePoint[i][0], mousePoint[i][1], 0.5);			
				var m1:Point = Point.interpolate(mousePoint[i][1], mousePoint[i][2], 0.5);			
				_shape.graphics.moveTo(m0.x, m0.y);			
				_shape.graphics.curveTo(mousePoint[i][1].x, mousePoint[i][1].y, m1.x, m1.y);			
			}	
			_bitmap.bitmapData.colorTransform(_bitmap.bitmapData.rect, FADE);		
			_bitmap.bitmapData.draw(_shape, null, null, "add");		
		}
		private function onDown(e:MouseEvent):void {
			mx = e.localX; 
			my = e.localY; 			
		}
	}
}
