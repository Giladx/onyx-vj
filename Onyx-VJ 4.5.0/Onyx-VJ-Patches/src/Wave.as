/**
 * Copyright Saqoosha ( http://wonderfl.net/user/Saqoosha )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/19lm
 */

package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Wave extends Patch {
		
		private static const SCALE:Number = 1;
		
		private static const ZERO_POINT:Point = new Point(0, 0);
		private static const ZERO_ARRAY:Array = new Array(256);
		
		private var _target:Sprite;
		private var _square:Shape;
		private var _canvas:BitmapData;
		private var _final:BitmapData;
		private var _drawMtx:Matrix;
		private var _filters:Array;
		private var _emboss:BitmapFilter;
		private var _waveMap:Array;
		private var _phongMap:Array;
		private var mx:int=320;
		private var my:int=240;
		
		public function Wave() {
			_canvas = new BitmapData(DISPLAY_WIDTH / SCALE, DISPLAY_HEIGHT / SCALE, false, 0x0);
			_final = _canvas.clone();
			var bm:Bitmap = addChild(new Bitmap(_final)) as Bitmap;
			bm.scaleX = bm.scaleY = SCALE;
			//			_target = addChild(new Sprite()) as Sprite;
			_target = new Sprite();
			var sh:Shape = _target.addChild(new Shape()) as Shape;
			var g:Graphics = sh.graphics;
			g.beginFill(0xffffff);
			//			g.drawRect(-50, -50, 100, 100);
			g.drawEllipse(-50, -50, 100, 100);
			g.endFill();
			sh.x = 320;
			sh.y = 240;
			sh.alpha = 1;
			_square = sh;
			_drawMtx = new Matrix(1 / SCALE, 0, 0, 1 / SCALE, 0, 0);
			
			_filters = [];
			_filters.push(new BlurFilter(16, 16, BitmapFilterQuality.LOW));
			var a:Number = 1;
			var b:Number = -0;
			_filters.push(new ColorMatrixFilter([
				a, 0, 0, 0, b,
				0, a, 0, 0, b,
				0, 0, a, 0, b,
				0, 0, 0, 1, 0
			]));
			
			_emboss = new ConvolutionFilter(3, 3, [
				2, 0, 0,
				0, -1, 0,
				0, 0, -1
			], 3, 0x80);
			
			
			_waveMap = [];
			var n:int = 256;
			var c:int;
			while (n--) {
				c = int((Math.sin(n / 256 * Math.PI * 6) + 1) * 0x7f);
				_waveMap.push((c << 16) | (c << 8) | c);
			}
			
			_phongMap = _createPhongMap(0xffffff, 20, 0x00aaff, 0x00000);
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
		private function mouseMove(event:MouseEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}	
		private function _createPhongMap(specular:uint = 0xffffff, power:int = 50, diffuse:uint=0x808080, ambient:uint=0x000000):Array {
			var col:Array = [];
			const sr:int = (specular >> 16) & 0xff;
			const sg:int = (specular >> 8) & 0xff;
			const sb:int = specular & 0xff;
			const dr:int = (diffuse >> 16) & 0xff;
			const dg:int = (diffuse >> 8) & 0xff;
			const db:int = diffuse & 0xff;
			const ar:int = (ambient >> 16) & 0xff;
			const ag:int = (ambient >> 8) & 0xff;
			const ab:int = ambient & 0xff;
			var i:int = 256;
			var ks:Number, kd:Number;
			while (i--) {
				ks = Math.pow(Math.cos(i / 256 * Math.PI / 2), power);
				kd = 1 - (i / 256);
				col.push(
					(Math.min(0xff, ar + kd * dr + ks * sr) << 16) |
					(Math.min(0xff, ag + kd * dg + ks * sg) << 8) |
					(Math.min(0xff, ab + kd * db + ks * sb))
				);
			}
			return col;
		}
		
		override public function render(info:RenderInfo):void 
		{
			_square.x = mx;
			_square.y = my;
			_canvas.draw(_target, _drawMtx);
			for each(var f:BitmapFilter in _filters) {
				_canvas.applyFilter(_canvas, _canvas.rect, ZERO_POINT, f);
			}
			_final.draw(_canvas);
			_final.paletteMap(_final, _final.rect, ZERO_POINT, _waveMap, ZERO_ARRAY, ZERO_ARRAY);
			var n:int = 3;	while (n--)	_waveMap.push(_waveMap.shift());
			_final.applyFilter(_final, _final.rect, ZERO_POINT, _emboss);
			_final.paletteMap(_final, _final.rect, ZERO_POINT, _phongMap, ZERO_ARRAY, ZERO_ARRAY);
			info.render(_final);

		}
		
	}
	
}
