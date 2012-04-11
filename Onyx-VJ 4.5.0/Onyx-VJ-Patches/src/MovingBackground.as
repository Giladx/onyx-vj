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
	
	public class MovingBackground extends Sprite {
		
		public function MovingBackground() {
			var g:Graphics = graphics;
			var mt:Function = g.moveTo;
			var lt:Function = g.lineTo;
			var ls:Function = g.lineStyle;
			var m:Object = Math;
			var r:Function = m.random;
			var s:Function = m.sin;
			var i:Number = 0;
			var o:Object = {};
			function f(e:Event):void{/* from here */
				!o.b?o.c=addChild(new Bitmap(o.b=new BitmapData(700,500,m,0))).rotationX=-45: o.b.perlinNoise(30+10*s(i),20+10*s(i+=0.003),1,9,!m,!m,4,m );
			}/* to here */
			addEventListener("enterFrame",f);
		}
	}
}