package plugins.filters {
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;

	public final class Pixelate extends Filter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var _temp:BitmapData				= new BitmapData(40, 30, true, 0x00000000);
		
		/**
		 * 	@private
		 */
		private var _blendTransform:ColorTransform	= new ColorTransform(1,1,1,1);
		
		/**
		 * 
		 */
		private var _matrix:Matrix					= new Matrix();
		
		/**
		 * 	@constructor
		 */
		public function Pixelate():void {
			
			parameters.addParameters(
				new ParameterInteger('amount', 'amount', 2, 20, 4),
				new ParameterNumber('alpha', 'alpha', 0, 1, 1),
				new ParameterNumber('scale', 'scale', 0, 2, 1)
			)
		}
		
		/**
		 * 
		 */
		public function set amount(value:int):void {
			if (_temp) {
				_temp.dispose();
			}
			if (value > 0) {
				_temp = new BitmapData(DISPLAY_WIDTH / value, DISPLAY_HEIGHT / value, true, 0x00000000);
			}
		}
		
		public function get amount():int {
			return DISPLAY_WIDTH / _temp.width;
		}
		
		public function applyFilter(source:BitmapData):void {
			var matrix:Matrix = new Matrix();
			matrix.scale(_temp.width / DISPLAY_WIDTH, _temp.height / DISPLAY_HEIGHT);

			_temp.draw(source, matrix);
			
			matrix.invert();
			matrix.concat(_matrix);
			
			source.draw(_temp, matrix, _blendTransform);
		}
		
		/**
		 * 
		 */
		public function get alpha():Number {
			return _blendTransform.alphaMultiplier;
		}
		
		/**
		 * 
		 */
		public function set alpha(value:Number):void {
			_blendTransform.alphaMultiplier = value;
		}
		
		/**
		 * 
		 */
		public function set scale(value:Number):void {
			_matrix.a = _matrix.d = value;
		}
		
		/**
		 * 
		 */
		public function get scale():Number {
			return _matrix.a;
		}

		/**
		 * 
		 */
		override public function dispose():void {
			_temp.dispose();
			_temp = null;
		}

	}
}