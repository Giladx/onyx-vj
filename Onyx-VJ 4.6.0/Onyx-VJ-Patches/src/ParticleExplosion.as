/**
 * Copyright Mier.Soleil ( http://wonderfl.net/user/Mier.Soleil )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/9nB9
 */

// forked from xoul's Particle
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class ParticleExplosion extends Patch
	{
		
		private const NUM_PARTICLES : int = 5000;
		private const SPEED : Number = 1;
		private const MAX_POWER : Number = 100;
		
		private var _canvas : BitmapData;  
		private var _pixels : Vector.<Object>;
		
		private var _alphaTransform : ColorTransform;
		private var _blurFilter : BlurFilter;
		
		private var _zeroPoint : Point;

		private var mx:int = 320;
		private var my:int = 240;
		public var color:uint			= 0xFF0000;
		
		public function ParticleExplosion()
		{
			parameters.addParameters( 
				new ParameterColor('color', 'color', color)
			);
			_canvas = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0 );
			
			_pixels = new Vector.<Object>( NUM_PARTICLES, true );
			
			for( var i : int = 0; i < NUM_PARTICLES; ++i )
			{
				var pixel : Object = {};
				pixel.x = Math.random() * 1280;
				pixel.y = Math.random() * 720;
				pixel.dx = 0;
				pixel.dy = 0;
				pixel.lastX = pixel.x;
				pixel.lastY = pixel.y;
				pixel.color = color;
				_pixels[i] = pixel;
			}
			
			_alphaTransform = new ColorTransform( 1, 1, 1, .9 );
			_blurFilter = new BlurFilter;
			_zeroPoint = new Point;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouse );
			addEventListener( MouseEvent.MOUSE_MOVE, onMouse );

		}
		
		override public function render(info:RenderInfo):void 
		{
			_canvas.lock();
			_canvas.applyFilter( _canvas, _canvas.rect, _zeroPoint, _blurFilter );
			_canvas.colorTransform( _canvas.rect, _alphaTransform );
			
			var pixel : Object;
			var angle : Number;
			for( var i : int = 0; i < NUM_PARTICLES; ++i )
			{
				pixel = _pixels[i];
				pixel.color = color;
				pixel.lastX = pixel.x;
				pixel.lastY = pixel.y;
				
				angle = Math.atan2( pixel.y - mx, pixel.x - my );
				pixel.dx -= SPEED * Math.cos( angle );
				pixel.dy -= SPEED * Math.sin( angle );
				
				pixel.x += pixel.dx;
				pixel.y += pixel.dy;
				
				pixel.dx *= .95;
				pixel.dy *= .95;
				
				drawLine( pixel.lastX, pixel.lastY, pixel.x, pixel.y, pixel.color );
			}
			
			//canvas.applyFilter( canvas, canvas.rect, new Point, blurFilter );
			
			_canvas.unlock();
			info.render( _canvas );	
		}
		
		private function onMouse( e : MouseEvent ) : void
		{
			var pixel : Object;
			var randAngle : Number;
			var randPower : Number;
			
			mx = e.localX/2;
			my = e.localY/2;
			for( var i : int = 0; i < NUM_PARTICLES; ++i )
			{
				pixel = _pixels[i];
				randAngle = Math.random() * ( Math.PI << 1 );
				randPower = Math.random() * MAX_POWER - ( MAX_POWER >> 1 );
				pixel.dx = randPower * Math.cos( randAngle );
				pixel.dy = randPower * Math.sin( randAngle );
			}
		}
		
		private function drawLine( startX : Number, startY : Number, endX : Number, endY : Number, color : Number ) : void
		{
			var dx : Number = endX - startX;
			var dy : Number = endY - startY;
			var a : Number;
			var b : Number;
			var tmp : Number;
			var len : Number;
			var i : int;
			
			if( getAbs( dx ) > getAbs( dy ) )
			{
				a = dy / dx;
				b = startY;
				
				if( startX > endX )
				{
					tmp = startX;
					startX = endX;
					endX = tmp;
					b = endY;
				}
				
				len = endX - startX;
				for( i = 0; i < len; ++i )
				{
					_canvas.setPixel( i + startX, i * a + b, color );
				}
			}
			else
			{
				a = dx / dy;
				b = startX;
				
				if( startY > endY )
				{
					tmp = startY;
					startY = endY;
					endY = tmp;
					b = endX;
				}
				
				len = endY - startY;
				for( i = 0; i < len; ++i )
				{
					_canvas.setPixel( i * a + b, i + startY, color );
				}
			}
		}
		
		private function getAbs( x : Number ) : Number
		{
			return x < 0 ? -x : x;
		}
	}
}