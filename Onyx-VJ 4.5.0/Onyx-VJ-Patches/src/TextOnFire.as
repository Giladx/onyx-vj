/**
 * Copyright Saqoosha ( http://wonderfl.net/user/Saqoosha )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rolo
 */

package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import onyx.plugin.*;
	
	public class TextOnFire extends Patch {
		
		private static const ZERO_POINT:Point = new Point();
		
		private var _fireColor:BitmapData;
		private var _currentFireColor:int;
		
		private var _canvas:Sprite;
		private var _grey:BitmapData;
		private var _spread:ConvolutionFilter;
		private var _cooling:BitmapData;
		private var _color:ColorMatrixFilter;
		private var _offset:Array;
		private var _fire:BitmapData;
		private var _palette:Array;
		private var _zeroArray:Array;
		
		public function TextOnFire() {
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._onLoaded);
			loader.load(new URLRequest('http://saqoosha.net/lab/Moyasu/srcview/source/fire-color.png'), new LoaderContext(true));
		}
		
		private function _onLoaded(e:Event):void {
			this._fireColor = Bitmap(LoaderInfo(e.target).loader.content).bitmapData;
			
			this._canvas = new Sprite();
			this._canvas.graphics.beginFill(0x0, 0);
			this._canvas.graphics.drawRect(0, 0, 465, 465);
			this._canvas.graphics.endFill();
			this._canvas.addChild(this._createEmitter());
			
			this._grey = new BitmapData(465, 465, false, 0x0);
			this._spread = new ConvolutionFilter(3, 3, [0, 1, 0,  1, 1, 1,  0, 1, 0], 5);
			this._cooling = new BitmapData(465, 465, false, 0x0);
			this._offset = [new Point(), new Point()];
			this._fire = new BitmapData(465, 465, false, 0x0);
			this.addChild(new Bitmap(this._fire));
			
			this._createCooling(0.16);
			this._createPalette(this._currentFireColor = 0);
			
			this.addEventListener(Event.ENTER_FRAME, this._update);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this._onClick);
		}
		
		private function _onClick(e:MouseEvent):void {
			if (++this._currentFireColor == int(this._fireColor.height / 32)) {
				this._currentFireColor = 0;
			}
			this._createPalette(this._currentFireColor);
		}
		
		private function _createEmitter():DisplayObject {
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = new TextFormat('Verdana', 80, 0xffffff, true);
			tf.text = 'Wonderfl';
			tf.x = (465 - tf.width) / 2;
			tf.y = (465 - tf.height) / 2;
			return tf;
		}
		
		private function _createCooling(a:Number):void {
			this._color = new ColorMatrixFilter([
				a, 0, 0, 0, 0,
				0, a, 0, 0, 0,
				0, 0, a, 0, 0,
				0, 0, 0, 1, 0
			]);
		}
		
		private function _createPalette(idx:int):void {
			this._palette = [];
			this._zeroArray = [];
			for (var i:int = 0; i < 256; i++) {
				this._palette.push(this._fireColor.getPixel(i, idx * 32));
				this._zeroArray.push(0);
			}
		}
		
		private function _update(e:Event):void {
			this._grey.draw(this._canvas);
			this._grey.applyFilter(this._grey, this._grey.rect, ZERO_POINT, this._spread);
			this._cooling.perlinNoise(50, 50, 2, 982374, false, false, 0, true, this._offset);
			this._offset[0].x += 2.0;
			this._offset[1].y += 2.0;
			this._cooling.applyFilter(this._cooling, this._cooling.rect, ZERO_POINT, this._color);
			this._grey.draw(this._cooling, null, null, BlendMode.SUBTRACT);
			this._grey.scroll(0, -3);
			this._fire.paletteMap(this._grey, this._grey.rect, ZERO_POINT, this._palette, this._zeroArray, this._zeroArray, this._zeroArray);
		}
	}
}