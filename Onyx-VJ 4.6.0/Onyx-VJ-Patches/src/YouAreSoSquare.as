
/**
 * Copyright nulldesign ( http://wonderfl.net/user/nulldesign )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/xjdM
 */

/**
 ä½•ãƒ¶æœˆã¶ã‚Šã ã‚ã†ãƒ»ãƒ»ãƒ»
 */
package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class YouAreSoSquare extends Patch
	{
		private var _max:uint = 150;
		private var _min:uint = 10;
		private var _timer:Timer;
		private var _list:Array;
		private var sprite:Sprite;
		
		public function YouAreSoSquare():void
		{
			sprite = new Sprite();	
			_list = [];
			
			var _bg:Sprite = new Sprite();
			_bg.graphics.beginFill( 0 );
			_bg.graphics.drawRect( 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT );
			//addChild(_bg);
			
			var _x:uint = Math.floor( Math.random() * DISPLAY_WIDTH );
			var _y:uint = Math.floor( Math.random() * DISPLAY_HEIGHT );
			var _w:uint = Math.floor( Math.random() * ( _max - _min ) + _min );
			var _h:uint = _w;
			_list.push( new Cell( _x, _y, _w, _h ) );
			
			_timer = new Timer( 10 );
			_timer.addEventListener( TimerEvent.TIMER, _onTimer );
			_timer.start();

			
		}
		
		private function _onTimer( e:TimerEvent ):void
		{
			var _pop:Cell = _list.shift() as Cell;
			if( _pop )
			{
				sprite.addChild( _pop );
				
				var _size:uint;
				var _pop0:Cell;
				if( _pop.width > _min )
				{
					_size = Math.floor( Math.random() * _pop.width * .8 );
					_pop0 = new Cell(
						_pop.x - _pop.width * .5,
						_pop.y - _pop.height * .5,
						_size,
						_size
					);
					_list.push( _pop0 );
					_size = Math.floor( Math.random() * _pop.width * .8 );
					_pop0 = new Cell(
						_pop.x + _pop.width * .5,
						_pop.y + _pop.height * .5,
						_size,
						_size
					);
					_list.push( _pop0 );
					_size = Math.floor( Math.random() * _pop.width * .8 );
					_pop0 = new Cell(
						_pop.x - _pop.width * .5,
						_pop.y + _pop.height * .5,
						_size,
						_size
					);
					_list.push( _pop0 );
					_size = Math.floor( Math.random() * _pop.width * .8 );
					_pop0 = new Cell(
						_pop.x + _pop.width * .5,
						_pop.y - _pop.height * .5,
						_size,
						_size
					);
					_list.push( _pop0 );
				}
			} else {
				var _x:uint = Math.floor( Math.random() * DISPLAY_WIDTH );
				var _y:uint = Math.floor( Math.random() * DISPLAY_HEIGHT );
				var _w:uint = Math.floor( Math.random() * ( _max - _min ) + _min );
				var _h:uint = _w;
				Cell.Color = Math.floor( Math.random() * 0xFFFFFF );
				_list.push( new Cell( _x, _y, _w, _h ) );
			}

			
			
		}
		override public function render(info:RenderInfo):void 
		{
			info.render(sprite);
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;
import caurina.transitions.*;

class Cell extends Sprite
{
	
	public static var Color:uint = 0xFFFFFF;
	
	public function Cell(_x:uint,_y:uint, _w:uint, _h:uint ):void
	{
		this.x = _x;
		this.y = _y;
		this.alpha = 0;
		this.graphics.lineStyle( 1, Color, .4, false, "none" );
		this.graphics.beginFill( Color, .2 );
		//this.graphics.drawRoundRect( -_w*.5, -_h*.5, _w, _h, 3, 3 );
		this.graphics.drawRect( -_w*.5, -_h*.5, _w, _h );
		//this.graphics.drawCircle( 0, 0, _w*.5 );
		
		Tweener.addTween( this, {alpha: 1, time: .5 } );
		Tweener.addTween( this, { delay: 5, alpha: 0, time: 2, onComplete: deleteCell } );
	}
	
	private function deleteCell():void
	{
		
		//this.parent.removeChild( this );
	}
}