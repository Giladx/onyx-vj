/**
 * Copyright makc3d ( http://wonderfl.net/user/makc3d )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/wEW9
 */

// forked from nicoptere's rectangle match
package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class RectangleMatch extends Patch 
	{
		private var maxRadius:Number;
		private var sprite:Sprite;
		private var previousTime:Number     = 0.0;
		private var _delay:int    	 	= 500;
		private var _maxRectangles:int    	 	= 500;
		private var _nbRectangles:int    	 	= 0;
		private var candidates:Vector.<Candidate>;
		private var frame:Rectangle;
		
		public function RectangleMatch() 
		{
			frame = new Rectangle( 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT );
			sprite = new Sprite();
			addEventListener( MouseEvent.MOUSE_DOWN, reset );
			reset();
			parameters.addParameters(
				new ParameterInteger('delay', 'delay', 3, 5000, 500),
				new ParameterInteger('maxRectangles', 'maxRectangles', 1, 1000, 500)
			);			
		}
		
		private function reset( e:MouseEvent = null ):void 
		{
			_nbRectangles = 0;
			sprite.graphics.clear();
			/*sprite.graphics.beginFill( 0x333333 );
			sprite.graphics.drawRect( 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT );*/
				
			candidates = new Vector.<Candidate>();
			
		}
		override public function render(info:RenderInfo):void {
			
			if ( _nbRectangles < maxRectangles ) 
			{
				var time:int = getTimer();
				var dt:Number = time - previousTime;
				if ( dt > delay ) 
				{
					var rect:Rectangle = getRandomRect();
					
					var r:Rectangle = getRandomRect();
					drawRect( r, 0XFFCC00, .05 );
					
					var c:Candidate = new Candidate( r, _nbRectangles );
					c.compute( frame );
					candidates.push( c );
					c = candidates[ getClosest( frame, rect, candidates ) ];
					drawRect( c.r, 0xFF0000, .5 );
					drawRect( rect, 0x00FF00, .25 );
					_nbRectangles++ ;
					previousTime = time;
				}				
			}
			info.render( sprite );
		} 
		private function getClosest( frame:Rectangle, rect:Rectangle, list:Vector.<Candidate> ):uint 
		{
			
			var candidate:Candidate = new Candidate( rect, -1 );
			candidate.compute( frame );
			
			var mini:Number = Number.POSITIVE_INFINITY;
			var id:int = -1;
			var score:Number;
			for (var i:int = 0; i < list.length; i++) 
			{
				score = list[ i ].compare( candidate );
				if ( score < mini )
				{
					mini = score;
					if( id != -1 ) drawRect( list[ id ].r, 0xFFFFFF );
					id = list[ i ].id;
				}
			}
			
			return id;
			
		}
		
		private function drawRect(rect:Rectangle, color:uint, alpha:Number = .15 ):void 
		{
			
			sprite.graphics.lineStyle( 0, color );
			sprite.graphics.beginFill( color, alpha ); 
			sprite.graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
			sprite.graphics.endFill(); 
			
		}
		
		private function getRandomRect():Rectangle 
		{
			
			var rw:int = Math.random() * DISPLAY_WIDTH * .25;
			var rh:int = Math.random() * DISPLAY_HEIGHT * .25;
			
			return new Rectangle( Math.random() * ( DISPLAY_WIDTH - rw ), Math.random() * ( DISPLAY_HEIGHT - rh ), rw, rh );
		}

		public function get delay():int
		{
			return _delay;
		}

		public function set delay(value:int):void
		{
			_delay = value;
		}

		public function get maxRectangles():int
		{
			return _maxRectangles;
		}

		public function set maxRectangles(value:int):void
		{
			_maxRectangles = value;
		}

		
	}
	
}

import flash.geom.Point;
import flash.geom.Rectangle;
class Candidate
{
	public var char:String;
	public var id:int;
	public var r:Rectangle;
	public var indices:Vector.<int>;
	
	public function Candidate( r:Rectangle, id:int, char:String = '' )
	{
		this.r = r;
		this.id = id;
		this.char = char;
	}
	
	public function compute( frame:Rectangle ):void
	{
		var frameCenter:Point = new Point( frame.x + frame.width * .5, frame.y + frame.height * .5 );
		var frameRadius:Number = Math.sqrt( Math.pow( frame.width * .5, 2 ) + Math.pow( frame.height * .5 , 2 ) );
		
		var tl:Point = r.topLeft;
		var tr:Point = new Point( r.right, r.top );
		var br:Point = r.bottomRight;
		var bl:Point = new Point( r.left, r.bottom );
		
		var corners:Array = [ tl, tr, br, bl ];
		indices = new Vector.<int>();
		for each( var p:Point in corners )
		{
			indices.push( int( map( getAngle( frameCenter, p ), -Math.PI, Math.PI, 0, 360 ) ) );
		}
	}
	private function getAngle( p0:Point, p1:Point ):Number
	{
		return Math.atan2( p1.y - p0.y, p1.x - p0.x );
	}
	
	public function compare( other:Candidate ):Number
	{
		var score:Number = 0;
		
		// dafuq
		var dx:Number = r.width  - other.r.width;
		var dy:Number = r.height - other.r.height;
		var dd:Number = Point.distance (r.topLeft, r.bottomRight) - Point.distance (other.r.topLeft, other.r.bottomRight);
		score = dx * dx + dy * dy + 2 * dd * dd;
		
		return score;
	}
	
	private function normalize(value:Number, minimum:Number, maximum:Number):Number
	{
		return (value - minimum) / (maximum - minimum);
	}
	private function lerp(normValue:Number, minimum:Number, maximum:Number):Number
	{
		return minimum + (maximum - minimum) * normValue;
	}
	private function map(value:Number, min1:Number, max1:Number, min2:Number, max2:Number):Number
	{
		return lerp( normalize(value, min1, max1), min2, max2);
	}
}