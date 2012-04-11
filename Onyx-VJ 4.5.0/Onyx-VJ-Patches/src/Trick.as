/**
 * Copyright 28inch ( http://wonderfl.net/user/28inch )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/yTam
 */

// forked from bradsedito's [ff]: Metaball

package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Trick extends Patch 
	{ 
		private var _numBlobs:uint = 3;        
		private var _blogPx:Array = new Array(5 ,5 , 20, 20);
		private var _blogPy:Array = new Array(10, 20, 30, 40);
		private var _blogDx:Array = new Array(1, 1, -1, -1);
		private var _blogDy:Array = new Array(-1, -1, -1, -1);
		private var _bmpData:BitmapData;
		private var _vx:Array = new Array();
		private var _vy:Array = new Array();
		private var _downFlg:Boolean = false;
		private var mx:int = 10;
		private var my:int = 10;
		private var timer:Timer;
		private var container:Sprite;
		
		public function Trick():void 
		{
			container = new Sprite();
			container.scaleX = container.scaleY = 6;
			_bmpData = new BitmapData(480,360);
			var bitmap:Bitmap = new Bitmap(_bmpData);
			//addChild(bitmap);	
			
			container.addChild(bitmap);
			
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			addEventListener( MouseEvent.MOUSE_UP, mouseUp );
			timer = new Timer(100);
			timer.addEventListener( TimerEvent.TIMER, draw );
			timer.start();
		}
		private function mouseDown(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
			_downFlg = true;
			
		}		
		private function mouseUp(event:InteractionEvent):void 
		{
			_downFlg = false;
			
		}		
		private function draw(e:TimerEvent):void
		{
			var x:uint, y:uint, i:uint;
			var color:uint, r:uint, g:uint, b:uint;
			
			for (i = 0; i < _numBlobs; ++i) 
			{
				if(_downFlg){
					_blogDx[i] += (int)(DISPLAY_WIDTH / 2 - mx) * 0.00001;
					_blogDy[i] += (int)(DISPLAY_HEIGHT / 2 - my) * 0.00001;
				}
				_blogPx[i] += _blogDx[i];
				_blogPy[i] += _blogDy[i];
				
				if (_blogPx[i] < 0) {
					_blogDx[i] = Math.random();
				}
				if (_blogPx[i] > _bmpData.width) {
					_blogDx[i] = -Math.random();
				}
				if (_blogPy[i] < 0) {
					_blogDy[i] = Math.random();
				}
				if (_blogPy[i] > _bmpData.height) {
					_blogDy[i]=-Math.random();
				}
				
				_vx[i] = new Array();
				for (x = 0; x < _bmpData.width; x++) {
					_vx[i][x] = int(Math.pow(_blogPx[i] - x, 2));
				}
				
				_vy[i] = new Array();
				for (y = 0; y < _bmpData.height; y++) {
					_vy[i][y] = int(Math.pow(_blogPy[i] - y, 2));
				}
			}
			
			_bmpData.lock();
			for (y = 0; y < _bmpData.height; y++) {
				for (x = 0; x < _bmpData.width; x++) {
					var m:int = 1;
					for (i = 0; i < _numBlobs; i++ ) {
						m += (10000 * (i + 2) * 3 / _numBlobs) / (_vy[i][y] + _vx[i][x] + 1);
					}
					
					r = Math.min(255, (m + y));
					g = Math.min(255, (m + x));
					b = Math.min(255, (x + m + y) / 2);
					color = r << 16 | g << 8 | b;
					
					_bmpData.setPixel(x, y, color);
				}
			}
			_bmpData.unlock();
		}
		override public function render(info:RenderInfo):void 		
		{		
			_bmpData.draw(container);
			info.render( container );
		}
	}
}
