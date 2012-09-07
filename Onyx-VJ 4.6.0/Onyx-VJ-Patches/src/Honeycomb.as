/**
* Copyright subironn ( http://wonderfl.net/user/subironn )
* GNU General Public License, v3 ( http://www.gnu.org/licenses/quick-guide-gplv3.html )
* Downloaded from: http://wonderfl.net/c/2FXG
*/

// forked from poke's Honeycomb generator
/*
* In response to StackOverflow question:
* â€œDrawing an honeycomb with as3â€
* http://stackoverflow.com/questions/2887725//2888919#2888919
*/
package
{
	import flash.display.Sprite;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Honeycomb extends Patch
	{
		private var sprite:Sprite;

		public function Honeycomb ()
		{
			sprite = new Sprite();
			Hexagon.scale = 1;
			
			// draw honeycomb with 60 cells
			drawComb( 60 );
		}
		
		private function drawComb ( n:uint ):void
		{
			var colors:Array = new Array( 0x33CC33, 0x006699, 0xCC3300, 0x663399, 0xFF9900, 0x336666 );
			var sectors:Array = new Array(
				new Array( 2, 0 ),
				new Array( 1, 1 ),
				new Array( -1, 1 ),
				new Array( -2, 0 ),
				new Array( -1, -1 ),
				new Array( 1, -1 ) );
			
			var w:Number = 0.50 * Hexagon.hxWidth;
			var h:Number = 0.75 * Hexagon.hxHeight;
			var r:uint, p:uint, s:uint;
			var hx:Hexagon;
			
			for ( var i:uint = 0; i <= n; i++ )
			{
				r = getRadius( i );
				p = getPosition( i, r );
				s = getSector( i, r, p );
				
				// create hexagon
				if ( r == 0 )
					hx = new Hexagon( 0xCCCCCC );
				else
					hx = new Hexagon( colors[s] );
				
				hx.x = (DISPLAY_WIDTH / 2) + w * ( r * sectors[s][0] - ( p % r ) * ( sectors[s][0] - sectors[ ( s + 1 ) % 6 ][0] ) );
				hx.y = (DISPLAY_HEIGHT / 2) + h * ( r * sectors[s][1] - ( p % r ) * ( sectors[s][1] - sectors[ ( s + 1 ) % 6 ][1] ) );
				sprite.addChild( hx );
			}
		}
		
		private function getRadius ( i:uint ):uint
		{
			var r:uint = 0;
			
			while ( i > r * 6 )
				i -= r++ * 6;
			
			return r;
		}
		
		private function getPosition ( i:uint, r:uint ):uint
		{
			if ( r == 0 )
				return i;
			
			while ( r-- > 0 )
				i -= r * 6;
			
			return i - 1;
		}
		
		private function getSector ( i:uint, r:uint, s:uint ):uint
		{
			return Math.floor( s / r );
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );		
		} 
	}
}

import flash.display.Shape;

class Hexagon extends Shape
{
	public static var hxWidth:Number = 90;
	public static var hxHeight:Number = 100;
	
	private static var _scale:Number = 1;
	
	public function Hexagon ( color:uint )
	{
		graphics.beginFill( color );
		graphics.lineStyle( 3, 0xFFFFFF );
		graphics.moveTo(   0, -50 );
		graphics.lineTo(  45, -25 );
		graphics.lineTo(  45,  25 );
		graphics.lineTo(   0,  50 ),
		graphics.lineTo( -45,  25 );
		graphics.lineTo( -45, -25 );
		graphics.lineTo(   0, -50 );
		
		this.scaleX = this.scaleY = _scale;
	}
	
	public static function set scale ( value:Number ):void
	{
		_scale = value;
		hxWidth = value * 90;
		hxHeight = value * 100;
	}
	
	public static function get scale ():Number
	{
		return _scale;
	}
}