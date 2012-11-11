package {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import services.remote.*;
	
	/**
	 * 	PenDraw
	 */
	public class PenDraw extends Patch {
		
		private const source:BitmapData		= createDefaultBitmap();
		private const filter:BlurFilter		=  new BlurFilter(0, 0);
		private var last:Point				= new Point(0, 0);
		
		private var _currentBlur:Number		= 0;
		private var _blur:BlurFilter;
		private var _begin:Boolean			= false;
		
		public var lineColor:uint			= 0x7E53B5;
		public var fillColor:uint			= 0x7E53B5;
		public var preblur:Number			= 0;
		public var size:int					= 3;
		public var type:String				= 'line';
		public var fill:Boolean				= true;
		public var line:Boolean				= true;
		public var alph:Number				= 1;
		
		private var dlc:DirectLanConnection = DirectLanConnection.getInstance("Onyx-Desktop");
		private var _pressure:uint = 10;	
		private var _xyp:uint = 10;	
		private var _xy:uint = 10;	
		private var sprite:Sprite;
		private var _x:int = 200;
		private var _y:int = 200;
		/**
		 * 	@constructor
		 */
		public function PenDraw():void {
			
			sprite = new Sprite();
			
			parameters.addParameters( 
				new ParameterArray('type', 'type', ['line', 'square', 'circle'], type),
				new ParameterInteger('size', 'size', 2, 30, size),
				new ParameterNumber('alph', 'alpha', 0, 1, alph),
				new ParameterColor('lineColor', 'lineColor'),
				new ParameterColor('fillColor', 'fillColor'),
				new ParameterBoolean('fill', 'draw fill'),
				new ParameterBoolean('line', 'draw line'),
				new ParameterNumber('preblur',	'preblur', 0, 30, 0, 10)
			);
			
			addEventListener(InteractionEvent.MOUSE_DOWN, mouseDown);
			dlc.addEventListener( DLCEvent.ON_RECEIVED, DataReceived );
			dlc.connect("60000");
			Console.output('PenDraw v0.02 by Bruce LANE (http://www.batchass.fr)');
		}
		
		protected function DataReceived(dataReceived:Object):void
		{
			// received
			switch ( dataReceived.params.type.toString() ) 
			{ 
				case "xyp":
					_xyp = dataReceived.params.value;
					_x = _xyp / 1048576;
					_y = (_xyp % 1048576) / 1024;
					_pressure = (_xyp % 1048576) % 1024;
					_draw(_x, _y, _pressure);
					break;
				case "xy":
					_xy = dataReceived.params.value;
					_x = _xy / 1048576;
					_y = _xy % 1048576;
					last.x = _x;
					last.y = _y;					
					break;
				case "color":
					fillColor = lineColor = dataReceived.params.value;					
					break;
				default: 
					break;
			}
		}

		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			
			addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
			last.x = event.localX;
			last.y = event.localY;
			
			_mouseMove(event);
		}
		
		/**
		 * 	@private
		 */
		private function _mouseMove(event:MouseEvent):void {
		
			_draw(event.localX, event.localY, size);
			
		}
		private function _draw(x:int, y:int, pressure:int):void {

			if (line) {
				sprite.graphics.lineStyle(pressure/50 +1 , lineColor, alph);
			}
			if (fill) {
				sprite.graphics.beginFill(fillColor, alph);
			}
			switch (type) {
				case 'circle':
					sprite.graphics.drawCircle(x, y, pressure/50 +1);
					break;
				case 'square':
					sprite.graphics.drawRect(x - pressure / 2, y - pressure / 2, pressure, pressure);
					break;
				case 'line':
					sprite.graphics.moveTo(last.x, last.y);
					sprite.graphics.lineTo(x, y);
					break;
			}
			
			last.x = x;
			last.y = y;
		}
		/**
		 * 	@private
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
			
			source.draw(sprite);
			
			// blit to the layer
			info.copyPixels(source);
			//info.render(sprite);
		}
		
		/**
		 * 	@private
		 */
		private function _mouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		}
		
		/**
		 * 	Called when the item is destroyed
		 */
		override public function dispose():void {
			
			source.dispose();
			
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
		}
	}
}