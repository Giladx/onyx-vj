/**
 * Copyright actionscriptbible ( http://wonderfl.net/user/actionscriptbible )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/x4rz
 */

package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class DynamicFlower extends Patch {
		protected var r:Number; //radius
		protected var shape:Shape;
		
		public function DynamicFlower() {
			shape = new Shape();
			shape.x = DISPLAY_WIDTH / 2;
			shape.y = DISPLAY_HEIGHT / 2;
			//addChild(shape);
			r = Math.min(DISPLAY_WIDTH, DISPLAY_HEIGHT) * 0.3;
		}
		
		override public function render(info:RenderInfo):void {
			var w:Number = int(30 * ((mouseX / DISPLAY_WIDTH) - 0.5));
			var r2:Number = 2 * ((mouseY / DISPLAY_HEIGHT) - 0.5)
			r2 = r * 3 * Math.pow(r2, 3);
			shape.graphics.clear();
			shape.graphics.beginFill(0xff00cc);
			for (var t:Number = 0; t < Math.PI * 2; t += 0.03) {
				var x:Number = r * Math.cos(t) + r2 * Math.cos(t * w);
				var y:Number = r * Math.sin(t) + r2 * Math.sin(t * w);
				if (t == 0) shape.graphics.moveTo(x, y);
				shape.graphics.lineTo(x, y);
			}
			shape.graphics.endFill();
			info.render( shape );
		}
		override public function dispose():void {
			shape = null;
		}
	}
}