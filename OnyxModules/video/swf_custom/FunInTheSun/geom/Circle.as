package geom {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.core.IDisposable;

	public final class Circle extends Sprite implements IDisposable {
		
		public static const STAGE_WIDTH:int		= BITMAP_WIDTH;
		public static const STAGE_HEIGHT:int	= BITMAP_HEIGHT;

		public static var circles:Array			= [];
		
		private var _timer:Timer					= new Timer(1000);

		private var _bmp:BitmapData;
		private var _x:Number					= Math.random() * 20;
		private var _y:Number					= Math.random() * 20;
		private var _targetX:Number				= Math.random() * STAGE_WIDTH;
		private var _targetY:Number				= Math.random() * STAGE_HEIGHT;
		
		public function Circle(bmp:BitmapData):void {

			graphics.clear();

			graphics.beginFill((Math.random() < .5) ? 0x000000 : 0xFFFFFF, .75);
			graphics.drawCircle(0,0,10);
			graphics.endFill();
			
			cacheAsBitmap = true;

			circles.push(this);

			_bmp = bmp;
			
			x = Math.random() * STAGE_WIDTH;
			y = Math.random() * STAGE_HEIGHT;
			
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);

		}
		
		private function _onEnterFrame(event:Event = null):void {
			
			var targetX:Number = ((_targetX - x) / 80);
			var targetY:Number = ((_targetY - y) / 80);

			_x += targetX;
			_y += targetY;
			
			_x *= .95;
			_y *= .95;
			
			var num:Number = (Math.abs(_x) + Math.abs(_y)) / 5;
			
			scaleX = num;
			scaleY = num;
			
			x += _x;
			y += _y;
			
			var matrix:Matrix = new Matrix();
			matrix.scale(num, num);
			matrix.translate(x, y);
			
			_bmp.draw(this, matrix, null);
			
		}

		private function _onTimer(event:TimerEvent):void {

			_timer.stop();			
			_timer.delay = int(Math.random() * 8000) + 1;
			_timer.start();
			
			_targetX = Math.random() * STAGE_WIDTH;
			_targetY = Math.random() * STAGE_HEIGHT;
		}
		
		public function dispose():void {
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer = null;
			_bmp = null;
			
			graphics.clear();
		}
		
	}
}