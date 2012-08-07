/**
 * Copyright awef ( http://wonderfl.net/user/awef )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/wPP9
 */

// forked from awef's å›žè»¢ãƒã‚¹ãƒˆ
// ã§ã‹ãã—ãŸ
// rotationZã˜ã‚ƒãªãã¦rotationã‚’ã„ã˜ã‚‹ã‚ˆã†ã«ã—ãŸ
// Tweenerã‹ã‚‰TweenMaxã«ã—ãŸ
package
{
	import flash.display.Sprite;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class OeilDuCyclone extends Patch
	{
		private var sprite:Sprite;

		public function OeilDuCyclone()
		{
			sprite = new Sprite();
			sprite.addChild(new ball(DISPLAY_WIDTH / 2, DISPLAY_HEIGHT / 2, 400));
		}
		override public function render(info:RenderInfo):void {
			
			info.render(sprite);
		}
	}
}

import flash.display.Sprite;
import gs.TweenMax;
import gs.easing.*;

class ball extends Sprite
{
	function ball(arg_x:int, arg_y:int, arg_r:uint)
	{
		x = arg_x;
		y = arg_y;
		
		graphics.beginFill(0xFFFFFF);
		graphics.drawCircle(0, 0, arg_r /10 * 8);
		graphics.endFill();
		graphics.beginFill(0);
		graphics.drawCircle(0, arg_r /10 * 2, arg_r /10 * 8);
		graphics.endFill();
		
		TweenMax.to(this, Math.random() * 3 + 3, { rotation : 360, loop : 0, ease : Linear.easeNone } );
		
		if(arg_r >= 10)
			addChild(new ball(0, arg_r /10 * 2, arg_r / 10 * 8))
	}
}