/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/sQD3
 */





package 
{    
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Lightning extends Patch
	{
		private const RANGE:int = 31; // 1,3,5,15,31,93,155,465
		private var _p:Point;
		private var _sp:Sprite;
		private var _ctf:ColorTransform;
		private var _canvas:BitmapData;
		private var _glow:BitmapData;
		private var mx:Number = 320;
		private var my:Number = 240;
		
		private var _rad:Number = 0.0;
		
		public function Lightning() {
			init();
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}
		
		private function init():void
		{
			_p = new Point( DISPLAY_WIDTH,DISPLAY_HEIGHT-DISPLAY_HEIGHT );
			//_p = new Point( W/2,H/2 );
			_sp = new Sprite();
			_sp.filters = [new GlowFilter(0xC9E6FC, 1, 10, 10, 4, 3, false, false)];
			_ctf = new ColorTransform(0.9, 0.96, 1, 0.9);
			_canvas = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,false,0);
			
			var bm:Bitmap = new Bitmap(_canvas, "auto", true);
			_glow = new BitmapData(DISPLAY_WIDTH / RANGE, DISPLAY_HEIGHT / RANGE, false, 0);
			
			var glowBm:Bitmap = new Bitmap(_glow, "never", true);
			glowBm.blendMode = "add";
			glowBm.scaleX = RANGE;
			glowBm.scaleY = RANGE;
			
			addChild(bm);
			addChild(glowBm);
		}
		private function mouseDown(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
			_p = new Point(mx, my);
		}			

		
		override public function render(info:RenderInfo):void  
		{
			var p:Point = new Point();
			var num:int = Math.random() * 5;
			p.x = _p.x;
			p.y = _p.y;
			//p.x = mouseX;
			//p.y = mouseY;
			_sp.graphics.clear();
			_sp.graphics.lineStyle(num, 0xFFFFFF, 1-(num / 10));
			_sp.graphics.moveTo(p.x, p.y);
			
			_rad += ( Math.random() * 90.0) * Math.PI / 180.0 * (Math.random() * 2.0 - 1.0);
			var rad:Number = _rad;
			var max:Number = 20.0;
			var speed:int;
			var noise:int;
			
			while( 0 <= p.x && p.x <= DISPLAY_WIDTH && 0 <= p.y && p.y <= DISPLAY_HEIGHT ){
				speed = Math.random() * 10;
				rad += Math.random() * max * Math.PI / 180.0 * (Math.random() * 2.0 - 1.0);
				noise = Math.random() * 8 - 4;
				p.x += Math.cos(rad) * speed + noise;
				p.y += Math.sin(rad) * speed + noise;
				_sp.graphics.lineTo(p.x, p.y);
			}
			
			_canvas.colorTransform(_canvas.rect, _ctf);
			_canvas.draw(_sp);
			_glow.draw(_canvas, new Matrix(1 / RANGE, 0, 0, 1 / RANGE));
			info.source.copyPixels(_glow, DISPLAY_RECT, ONYX_POINT_IDENTITY);

		}
	}
}