package filters {
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.plugin.Filter;
	import onyx.plugin.IBitmapFilter;
	import onyx.utils.math.*;
	
	public final class Kaliedoscope extends Filter implements IBitmapFilter {
		
		private var diag:Number;
		private var _alpha:ColorTransform	= new ColorTransform();
		private var _slices:int				= 9;
		
		private var nudge:Number			= 0.09;
		private var sclfact:Number			= 0;
		private var rot:Number				= 0;
		private var r:Number				= 0;
		private var r2:Number				= 0;
		private var sh1:Number				= 0;
		private var sh2:Number				= 0;
		private var scl:Number				= 1;
		private var m:Matrix				= new Matrix();

		public var rotate1:Boolean			= true;
		public var rotate2:Boolean			= true;
		public var rotate3:Boolean			= true;
		public var flip:Boolean				= false;
		public var singleview:Boolean		= true;
		public var rotspeed1:Number			= 0.007;
		public var rotspeed2:Number		= -0.003;
		public var rotspeed3:Number		= -0.005;

		private var angle:Number;
		private var stampImage:BitmapData;
		
		private var mat1:Matrix;
		private var mat2:Matrix;
		private var mat3:Matrix;
		private var mat4:Matrix;
		
		/**
		 * 	@constructor
		 */
		public function Kaliedoscope():void {
			super(false,
				new ControlInt('slices', 'slices', 1, 40, 15),
				new ControlInt('alpha', 'alpha', 0, 100, 100),
				new ControlBoolean('rotate1', 'rotate1'),
				new ControlBoolean('rotate2', 'rotate2'),
				new ControlBoolean('rotate3', 'rotate3'),
				new ControlBoolean('flip', 'flip'),
				new ControlBoolean('singleview', 'singleview'),
				new ControlNumber('rotspeed1', 'rotspd1', -1, 1, 0.007, { multiplier: 1000}),
				new ControlNumber('rotspeed2', 'rotspd2', -1, 1, 0.007, { multiplier: 1000}),
				new ControlNumber('rotspeed3', 'rotspd3', -1, 1, 0.007, { multiplier: 1000})
			);
		}
		
		public function set alpha(value:int):void {
			_alpha.alphaMultiplier = value / 100;
		}
		
		public function get alpha():int {
			return _alpha.alphaMultiplier * 100;
		}
		
		public function set slices(value:int):void {
			_slices = value;
			angle	= PI / value;
		}
		
		public function get slices():int {
			return _slices
		}
		
		override public function initialize():void {
			
			stampImage = BASE_BITMAP();
			diag = sqrt(2 * BITMAP_HEIGHT * BITMAP_HEIGHT) * .62;
			mat1 = new Matrix(0.5, 0, 0, 0.5);
			mat2 = new Matrix(-0.5, 0, 0, 0.5, BITMAP_WIDTH);
			mat3 = new Matrix(0.5, 0, 0, -0.5, 0, BITMAP_HEIGHT);
			mat4 = new Matrix(-0.5, 0, 0, -0.5, BITMAP_WIDTH, BITMAP_HEIGHT);
			
			slices = _slices;

		}
		
		public function applyFilter(source:BitmapData):void {
			
			var slice:Shape = new Shape();
			
			stampImage.fillRect(BITMAP_RECT, 0x00000000);
			stampImage.draw(source, mat1);
			stampImage.draw(source, mat2);
			stampImage.draw(source, mat3);
			stampImage.draw(source, mat4);
			
			source.fillRect(BITMAP_RECT, 0x00000000);
			
			if (rotate1) {
				r += rotspeed1;
			}
			if (rotate2) {
				r2 -= rotspeed2;
			}
			if (rotate3) {
				rot += rotspeed3;
			}
			for (var i:int = 0; i<=_slices; i++) {
				m.identity();
				m.b += sh1;
				m.c += sh2;
				m.rotate(r2);
				m.translate(2*10/scl, 2*10/scl+i*sclfact*10);
				m.rotate(r);
				m.scale(scl, scl);
				
				var graphics:Graphics = slice.graphics;
				graphics.lineStyle();
				graphics.moveTo(0, 0);
				graphics.beginBitmapFill(stampImage, m);
				graphics.lineTo(cos((angle+nudge)-PI/2)*diag, sin((angle+nudge)-PI/2)*diag);
				graphics.lineTo(cos(-(angle+nudge)-PI/2)*diag, sin(-(angle+nudge)-PI/2)*diag);
				graphics.lineTo(0, 0);
				graphics.endFill();
				m.identity();
				if (flip && i%2 == 1) {
					m.scale(-1, 1);
				}
				m.rotate(rot+i*angle*2);
				m.translate(BITMAP_WIDTH*0.5, BITMAP_HEIGHT*0.5);
				
				source.draw(slice, m);
			}
			
		}
		
	}
}