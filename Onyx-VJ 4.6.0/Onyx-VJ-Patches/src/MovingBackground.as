/**
 * Copyright Saqoosha ( http://wonderfl.net/user/Saqoosha )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/uy0P
 */

// forked from Saqoosha's #tweetcoding template
// #tweetcoding: code something cool in <=140 characters of AS3
// More info: http://gskinner.com/playpen/tweetcoding.html

// http://twitter.com/Quasimondo/status/1223779411

package {
	
	import flash.display.*;
	import flash.events.Event;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class MovingBackground extends Patch {
		private var sprite:Sprite;
		private var g:Graphics = graphics;
		private var mt:Function = g.moveTo;
		private var lt:Function = g.lineTo;
		private var ls:Function = g.lineStyle;
		private var m:Object = Math;
		private var r:Function = m.random;
		private var s:Function = m.sin;
		private var i:Number = 0;
		private var o:Object = {};
		private var b:Bitmap;
		private var bd:BitmapData;
		
		public function MovingBackground() {
			bd = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,true,0);
			b = new Bitmap(bd);
			//b.rotation = -45;
			sprite = new Sprite();
			g = sprite.graphics;
			sprite.addChild(b)
		}
		override public function render(info:RenderInfo):void 
		{
			bd.perlinNoise(30+10*s(i),20+10*s(i+=0.003),1,9,!m,!m,4,m );
			info.render( sprite );		
		} 
	}
}