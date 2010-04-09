package filters
{
	import flash.geom.Matrix;
	


	public final class MatrixEffect extends Filter {
		
		private var _matrix:Matrix	= new Matrix();
		
		public function MatrixEffect():void {
			super(
				true,
				new ParameterNumber('a', 'a', -5, 5, 1),
				new ParameterNumber('b', 'b', -5, 5, 0),
				new ParameterNumber('c', 'c', -5, 5, 0),
				new ParameterNumber('d', 'd', -5, 5, 1)
			);
		}
		
		public function set a(value:Number):void {
			_matrix.a = value;
			content.matrix = _matrix;
		}

		public function set b(value:Number):void {
			_matrix.b = value;
			content.matrix = _matrix;
		}

		public function set c(value:Number):void {
			_matrix.c = value;
			content.matrix = _matrix;
		}

		public function set d(value:Number):void {
			_matrix.d = value;
			content.matrix = _matrix;
		}
		
		public function get a():Number {
			return _matrix.a;
		}

		public function get b():Number {
			return _matrix.b;
		}

		public function get c():Number {
			return _matrix.c;
		}

		public function get d():Number {
			return _matrix.d;
		}
		
		override public function dispose():void {
			if (content) {
				content.matrix = null;
			}
		}
		
	}
}