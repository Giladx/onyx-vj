package LayerFilters {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	[SWF(width='480', height='360', frameRate='24')]
	final public class LayerDraw extends Patch {
		
		private const shape:Shape			= new Shape();
		private const color:ColorTransform	= new ColorTransform(1,1,1,.38);
		private const filter:BlurFilter		= new BlurFilter(2,2)
		
		public var layer:Layer;
		public var mode:String				= 'lighten';
		public var size:int					= 180;
		public var followMouse:Boolean;
		
		/**
		 * 
		 */
		public var preblur:Number			= 2;
		
		/**
		 * 	@private
		 */
		private var _currentBlur:Number		= 0;
		
		/**
		 * 	@private
		 */
		private const source:BitmapData	= createDefaultBitmap();
		
		/**
		 * 
		 */
		public function LayerDraw():void {
			
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterBoolean('followMouse', 'followMouse'),
				new ParameterInteger('preblur', 'preblur', 0, 30, preblur),
				new ParameterInteger('size', 'size', 0, 250, size),
				new ParameterInteger('alph', 'alpha', 0, 100, color.alphaMultiplier),
				new ParameterBlendMode('mode', 'blend'),
				new ParameterExecuteFunction('clear', 'clear')
			)
			
			addEventListener(InteractionEvent.MOUSE_DOWN, mouseDown);
			
		}
		
		public function clear():void {
			source.fillRect(DISPLAY_RECT, 0x00000000);
		}
		
		public function set alph(value:int):void {
			color.alphaMultiplier = value / 100;
		}
		
		public function get alph():int {
			return color.alphaMultiplier * 100;
		}
		
		private function mouseDown(event:MouseEvent):void {
			addEventListener(InteractionEvent.MOUSE_MOVE, mouseMove);
			addEventListener(InteractionEvent.MOUSE_UP, mouseUp);
		}
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {

			_currentBlur	+= preblur;
			
			if (_currentBlur >= 2) {
				var factor:int = _currentBlur - 2;
				
				_currentBlur = 0;
				
				filter.blurX = factor + 2;
				filter.blurY = factor + 2;
				source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, filter);
			}
			
			source.draw(shape, null, color, mode);
			
			// copy
			info.source.copyPixels(source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
		
		/**
		 * 	@private
		 */
		private function mouseMove(event:MouseEvent):void {
			if (layer) {
				var graphics:Graphics		= shape.graphics;
				var matrix:Matrix			= new Matrix();
				
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
		
		/**
		 * 	@private
		 */
		private function mouseUp(event:MouseEvent):void {
			removeEventListener(InteractionEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(InteractionEvent.MOUSE_UP, mouseUp);
			
			shape.graphics.clear();
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			removeEventListener(InteractionEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(InteractionEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(InteractionEvent.MOUSE_UP, mouseUp);
			
			source.dispose();
			shape.graphics.clear();
		}
	}
}
