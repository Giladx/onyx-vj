package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.display.*;

	[SWF(width='320', height='240', frameRate='24')]
	public class LayerDraw extends Sprite implements IControlObject {
		
		private var _controls:Controls;
		private var bitmap:Bitmap;
		private var shape:Shape;
		private var color:ColorTransform;
		
		public var mode:String			= 'lighten';
		public var layer:ILayer;
		public var size:int				= 50;
		public var followMouse:Boolean;
		
		private var _blur:BlurFilter;
		
		public function LayerDraw():void {
			color	= new ColorTransform();
			shape	= new Shape();
			bitmap	= new Bitmap(BASE_BITMAP());
			
			_controls = new Controls(this,
				new ControlLayer('layer', 'layer'),
				new ControlBoolean('followMouse', 'followMouse'),
				new ControlInt('preblur', 'preblur', 0, 30, 0),
				new ControlInt('size', 'size', 0, 100, 50),
				new ControlInt('alph', 'alpha', 0, 100, 100),
				new ControlBlend('mode', 'blend'),
				new ControlExecute('clear', 'clear')
			)
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			addChild(bitmap);
		}
		
		public function set preblur(value:int):void {
			if (value > 0) {
				_blur = new BlurFilter(value, value);
			} else {
				_blur = null;
			}
		}
		
		public function get preblur():int {
			return _blur ? _blur.blurX : 0; 
		}
		
		public function clear():void {
			bitmap.bitmapData.fillRect(BITMAP_RECT, 0x00000000);
		}
		
		public function set alph(value:int):void {
			color.alphaMultiplier = value / 100;
		}
		
		public function get alph():int {
			return color.alphaMultiplier * 100;
		}
		
		private function mouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		private function mouseMove(event:MouseEvent):void {
			if (layer) {
				var graphics:Graphics	= shape.graphics;
				var bitmap:BitmapData	= this.bitmap.bitmapData;
				var matrix:Matrix		= new Matrix();
				
				var x:Number				= event.localX;
				var y:Number				= event.localY;
				
				if (followMouse) {
					matrix.translate(-event.localX,-event.localY);
				}
				
				graphics.clear();
				graphics.beginBitmapFill(layer.source, matrix);
				graphics.drawCircle(event.localX, event.localY, size);
				graphics.endFill();
			}
		}
		
		private function enterFrame(event:Event):void {
			var source:BitmapData	= this.bitmap.bitmapData;
			
			if (_blur) {
				source.applyFilter(source, BITMAP_RECT, POINT, _blur);
			}
			
			source.draw(shape, null, color, mode);
		}
		
		private function mouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			shape.graphics.clear();
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
	}
}
