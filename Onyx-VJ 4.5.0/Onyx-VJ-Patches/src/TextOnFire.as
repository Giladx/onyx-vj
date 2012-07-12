/**
 * Copyright Saqoosha ( http://wonderfl.net/user/Saqoosha )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rolo
 */

package {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import EmbeddedAssets.AssetForBallSphere;
	
	public class TextOnFire extends Patch {
		
		private static const ZERO_POINT:Point = new Point();
		
		private var _fireColor:BitmapData;
		private var _currentFireColor:int;
		private var _clr:int = 0x116633;
		
		private var _canvas:Sprite;
		private var _grey:BitmapData;
		private var _spread:ConvolutionFilter;
		private var _cooling:BitmapData;
		private var _color:ColorMatrixFilter;
		private var _offset:Array;
		private var _fire:BitmapData;
		private var _palette:Array;
		private var _zeroArray:Array;
		private var tf:TextField = new TextField();
		private var format:TextFormat = new TextFormat('Verdana', 80, clr, true);
		private var _text:String = 'batchass';
		
		public function TextOnFire() {
			Console.output('TextOnFire adapted by Bruce LANE (http://www.batchass.fr)');
			
			parameters.addParameters(
				new ParameterString('text', 'text')
			);
			
			_fireColor = new AssetForBallSphere();  
			
			_canvas = new Sprite();
			/*_canvas.graphics.beginFill(0x0, 0);
			_canvas.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			_canvas.graphics.endFill();*/
			_canvas.addChild(_createEmitter());
			
			_grey = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x0);
			_spread = new ConvolutionFilter(3, 3, [0, 1, 0,  1, 1, 1,  0, 1, 0], 5);
			_cooling = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x0);
			_offset = [new Point(), new Point()];
			_fire = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x0);
			//addChild(new Bitmap(_fire));
			
			_createCooling(0.16);
			_createPalette(_currentFireColor = 0);
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onClick);
		}
		
		private function _onClick(e:MouseEvent):void {
			if (++_currentFireColor == int(_fireColor.height / 32)) {
				_currentFireColor = 0;
			}
			_createPalette(_currentFireColor);
		}
		
		private function _createEmitter():DisplayObject {
			
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = new TextFormat('Verdana', 80, clr, true);
			tf.text = text;
			tf.x = (DISPLAY_WIDTH - tf.width) / 2;
			tf.y = (DISPLAY_HEIGHT - tf.height) / 2;
			return tf;
		}
		
		private function _createCooling(a:Number):void {
			_color = new ColorMatrixFilter([
				a, 0, 0, 0, 0,
				0, a, 0, 0, 0,
				0, 0, a, 0, 0,
				0, 0, 0, 1, 0
			]);
		}
		
		private function _createPalette(idx:int):void {
			_palette = [];
			_zeroArray = [];
			for (var i:int = 0; i < 256; i++) {
				_palette.push(_fireColor.getPixel(i, idx * 32));
				_zeroArray.push(0);
			}
		}
		
		override public function render(info:RenderInfo):void {
			_grey.draw(_canvas);
			_grey.applyFilter(_grey, _grey.rect, ZERO_POINT, _spread);
			_cooling.perlinNoise(50, 50, 2, 982374, false, false, 0, true, _offset);
			_offset[0].x += 2.0;
			_offset[1].y += 2.0;
			_cooling.applyFilter(_cooling, _cooling.rect, ZERO_POINT, _color);
			_grey.draw(_cooling, null, null, BlendMode.SUBTRACT);
			_grey.scroll(0, -3);
			_fire.paletteMap(_grey, _grey.rect, ZERO_POINT, _palette, _zeroArray, _zeroArray, _zeroArray);
			info.render(_grey);
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			tf.text = _text;
			tf.defaultTextFormat = format;		
		}
		public function set clr(value:uint):void {
			_clr = value;
			format = new TextFormat('Verdana', 80, _clr, true);
			tf.defaultTextFormat = format;	
		}

		public function get clr():uint {
			return _clr;
		}
	}
}