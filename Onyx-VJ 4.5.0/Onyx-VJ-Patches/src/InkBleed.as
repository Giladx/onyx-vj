/**
 * Copyright aobyrne ( http://wonderfl.net/user/aobyrne )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/mPxa
 */

// forked from monodreamer's INK BLEED
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * <p>Ink Bleed</p>
	 * @author monoDreamer, aka ryo
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.2+
	 * @see 
	 */
	public class InkBleed extends Patch
	{
		private const BIG_ENOUGH_INT:int = 16 * 1024;
		private const BIG_ENOUGH_ROUND:Number = BIG_ENOUGH_INT + 0.5;
		private const SCX:int = 2;
		private const SCY:int = 2;
		private var DX:int = 1;
		private var DY:int = 1;
		
		private var _canvasData:Vector.<uint>;
		private var _canvas:BitmapData;
		private var _pnum:int;
		private var _dots:Vector.<Dot>;
		private var _cw:int;
		private var _ch:int;
		private var _px:int;
		private var _py:int;
		private var _isMouseDown:Boolean;
		private var _timer:Timer;
		private var mox:int;
		private var moy:int;
		private var factor:int = 1;
		/** Constructor */
		public function InkBleed():void
		{
			super();
			
			_cw = 640;//DISPLAY_WIDTH/factor;
			_ch = 480;//DISPLAY_HEIGHT/factor;
			_pnum = _cw * _ch;
			initTimer();
			initDots();
			initCanvas();
			addListeners();
			
			_timer.start();
		}
		protected function timerHandler($e:TimerEvent):void
		{
			var i:int = _pnum;
			while (--i>-1) {
				_dots[i].diffuse();
			}
		}
		
		override public function render(info:RenderInfo):void 
		{
			var d:Dot, i:int, c:uint;
			if (_isMouseDown) {
				i = _px + _py*_cw;
				//_dots[i].cur += 0x2f0;
				_dots[i].cur += 0x2f0;
				//trace( "0x2f0 : " + 0x2f0 );
			}
			var u:uint = uint(_dots.length * Math.random());
			_dots[u].cur = 640+480*0.25*(Math.random()+Math.random()+Math.random()+Math.random());
			i = _pnum;
			while (--i>-1) {
				c = _dots[i].cur;
				_canvasData[i] = (c > 0xff ? 0xff : c) << 24;
			}
			_canvas.setVector(_canvas.rect, _canvasData);
			info.render( _canvas );
		}
		
		protected function downHandler(e:MouseEvent):void
		{
			/*mox = (e.localX>>DX)/factor;
			moy = (e.localY>>DY)/factor;*/
			mox = e.localX;
			moy = e.localY;
			if (_canvas.rect.contains(mox, moy)) {
				_px = mox;
				_py = moy;
				_isMouseDown = true;
				addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			}
		}
		
		protected function moveHandler(e:MouseEvent):void
		{
			if(_isMouseDown) {
				/*mox = (e.localX>>DX)/factor;
				moy = (e.localY>>DY)/factor;*/
				mox = e.localX;
				moy = e.localY;
				if (_canvas.rect.contains(mox, moy))
				{
					t_efla(_px, _py, mox, moy, 0xff0000);
					_px = mox;
					_py = moy;
				}
			}
		}
		
		protected function upHandler(e:MouseEvent):void
		{
			_isMouseDown = false;
			removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		protected function t_efla($sx:int, $sy:int, $ex:int, $ey:int, $color:uint):void
		{
			var shortLen:int = $ey - $sy;
			var longLen:int = $ex - $sx;
			if (!longLen) if (!shortLen) return;
			var i:int, id:int, inc:int;
			var multDiff:Number;
			var idx:int;
			
			// TODO: check for this above, swap x/y/len and optimize loops to ++ and -- (operators twice as fast, still only 2 loops)
			if ((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31)) {
				if (shortLen < 0) {
					inc = -1;
					id = -shortLen & 3;
				} else {
					inc = 1;
					id = shortLen & 3;
				}
				multDiff = !shortLen ? longLen : longLen / shortLen;
				if (id) {
					idx = $sx + $sy*_cw;
					_dots[idx].cur += $color;
					
					i += inc;
					if (--id) {
						idx = roundPlus($sx + i * multDiff) + ($sy + i)*_cw;
						_dots[idx].cur += $color;
						i += inc;
						if (--id) {
							idx = roundPlus($sx + i * multDiff) + ($sy + i)*_cw;
							_dots[idx].cur += $color;
							i += inc;
						}
					}
				}
				
				while (i != shortLen) {
					idx = roundPlus($sx + i * multDiff) + ($sy + i) * _cw;
					_dots[idx].cur += $color;
					i += inc;
					idx = roundPlus($sx + i * multDiff) + ($sy + i) * _cw;
					_dots[idx].cur += $color;
					i += inc;
					idx = roundPlus($sx + i * multDiff) + ($sy + i) * _cw;
					_dots[idx].cur += $color;
					i += inc;
					idx = roundPlus($sx + i * multDiff) + ($sy + i) * _cw;
					_dots[idx].cur += $color;
					i += inc;
				}
			} 
			else {
				if (longLen < 0) {
					inc = -1;
					id = -longLen & 3;
				} else {
					inc = 1;
					id = longLen & 3;
				}
				multDiff = !longLen ? shortLen : shortLen / longLen;
				
				if (id) {
					idx = $sx + $sy * _cw;
					_dots[idx].cur += $color;
					i += inc;
					if (--id) {
						idx = $sx + i + roundPlus($sy + i * multDiff) * _cw;
						_dots[idx].cur += $color;
						i += inc;
						if (--id) {
							idx = $sx + i + roundPlus($sy + i * multDiff) * _cw;
							_dots[idx].cur += $color;
							i += inc;
						}
					}
				}
				
				while (i != longLen) {
					idx = $sx + i + roundPlus($sy + i * multDiff) * _cw;
					_dots[idx].cur += $color;
					i += inc;
					idx = $sx + i + roundPlus($sy + i * multDiff) * _cw;
					_dots[idx].cur += $color;
					i += inc;
					idx = $sx + i + roundPlus($sy + i * multDiff) * _cw;
					_dots[idx].cur += $color;
					i += inc;
					idx = $sx + i + roundPlus($sy + i * multDiff) * _cw;
					_dots[idx].cur += $color;
					
					i += inc;
				}
				
			}
		}
		
		protected function roundPlus($value:Number):int {
			return ($value + BIG_ENOUGH_ROUND) - BIG_ENOUGH_INT;
		}
		
		
		private function initTimer():void
		{
			_timer = new Timer(200);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		private function initCanvas():void
		{
			_canvas = new BitmapData(_cw, _ch, true, 0);
			_canvasData = _canvas.getVector(_canvas.rect);
			_canvasData.fixed = true;
			
			var map:BitmapData = new BitmapData(_cw * SCX, _ch *SCY);
			map.perlinNoise(map.width * .4, map.height * .4, 8, Math.random()*100, true, true, 1, true);
			
			var bmp:Bitmap = new Bitmap(_canvas);
			bmp.smoothing = true;
			bmp.scaleX = SCX;
			bmp.scaleY = SCY;
			bmp.filters = [new DisplacementMapFilter(map, new Point(), 1, 1, 32, 32, DisplacementMapFilterMode.CLAMP)];
			addChild(bmp);
			
			graphics.lineStyle(1);
			graphics.drawRect(0, 0, _cw * SCX, _ch * SCY);
			
		}
		
		private function addListeners():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		private function initDots():void
		{
			var absorbMap:BitmapData = new BitmapData(_cw, _ch, false, 0);
			absorbMap.perlinNoise(_cw/2, _ch/2, 5, _cw/2 * Math.random(), true, true, 1, true);
			absorbMap.colorTransform(absorbMap.rect, new ColorTransform(.2, .2, .2));
			var maxCapMap:BitmapData = new BitmapData(_cw, _ch, false, 0xffffff);
			maxCapMap.perlinNoise(_cw, _ch, 5, _cw/2 * Math.random(), true, true, 1, true);
			maxCapMap.colorTransform(maxCapMap.rect, new ColorTransform(1.8, 1.8, 1.8));
			var d:Dot, i:int = _pnum;
			
			_dots = new Vector.<Dot>(_pnum, true);
			while(--i>-1) {
				_dots[i] = new Dot();
			}
			
			var neighbors:Array;
			for (var my:int=0; my<_ch; my++)
			{
				for (var mx:int=0; mx<_cw; mx++)
				{
					i = mx + my*_cw;
					d = _dots[i];
					neighbors = [];
					d.abs = absorbMap.getPixel(mx, my) & 0xff;
					d.max = maxCapMap.getPixel(mx, my) & 0xff;
					
					if (mx>0) neighbors.push(_dots[i-1]);
					if (mx<_cw-1) neighbors.push(_dots[i+1]);
					if (my>0) neighbors.push(_dots[i-_cw]);
					if (my<_ch-1) neighbors.push(_dots[i+_cw]);
					
					d.setNeighbors(neighbors);
				}
			}
		}
		override public function dispose():void 
		{
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_canvasData = null;
			_canvas.dispose();
			_dots = null;
		}		
		
	}
}

class Dot
{
	public var max:uint;
	public var cur:uint;
	public var abs:uint;
	public var isOver:Boolean;
	
	public function setNeighbors($neighbors:Array):void
	{
		_neighbors = Vector.<Dot>($neighbors);
		_neighbors.fixed = true;
		_len = _neighbors.length;
	}
	
	public function diffuse():void
	{
		if (cur <= max) return;
		isOver = true;
		var d:Dot, l:int = _len;
		while (--l > -1) {
			d = _neighbors[l];
			if (d.isOver|| cur<d.abs) continue;
			d.cur += d.abs;
		}
		cur -= d.abs * .2;
	}
	
	private var _neighbors:Vector.<Dot>;
	private var _len:int;
}