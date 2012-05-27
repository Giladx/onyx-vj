/**
 * Copyright nontsu ( http://wonderfl.net/user/nontsu )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/K7nd
 */

// forked from kkstudio2007's forked from: è²¼ãƒ­ãƒ¯ forked from: Hello World!!!
// forked from otias's è²¼ãƒ­ãƒ¯ forked from: Hello World!!!
// forked from otias's è²¼ã‚Šçµµ forked from: Hello World!!!
//forked from: nitoyon's ""Hello World!!!"

package{
	import caurina.transitions.Tweener;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.text.TextField;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class DotTypo extends Patch{
		private var bd:BitmapData;
		private var canvas:Sprite;
		
		public function DotTypo():void{
			var tf:TextField = new TextField();
			tf.textColor = 0x000000;
			tf.text = " warehouse meet crossover";
			tf.autoSize = "left";
			
			bd = new BitmapData(tf.width, tf.height, false, 0xFFFFFF);
			bd.draw(tf);
			
			canvas = new Sprite();
			
			
			var a:Array = new Array();
			for(var i:int = 0; i < bd.width; i++){
				for(var j:int = 0; j < bd.height; j++){
					Tweener.addTween(randomize(canvas.addChild(new Rect(bd.getPixel(i, j)))), 
						{
							x: i * 9,
							y: j * 9,
							scaleX: 1,
							scaleY: 1,
							alpha: 1,
							delay: 0.7 + Math.random() * 4,
							time: 1
						}
					);
				}
			}
		}
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			info.render( canvas );		
		} 
		private function randomize(d:DisplayObject):DisplayObject{
			d.x = Math.random() * DISPLAY_WIDTH;
			d.y = Math.random() * DISPLAY_HEIGHT;
			d.alpha = 0;
			return d;
		}
	}
}


import flash.display.*;
import flash.geom.ColorTransform;

class Rect extends Shape{
	public function Rect(color:uint):void{
		if(color >= 0xC5C5C5) { return; }
		graphics.lineStyle(2, 0xFFFFFF);
		graphics.beginFill(color);
		graphics.drawRect(0, 0, 10, 10);
		graphics.endFill();
		var ct:ColorTransform = transform.colorTransform;
		ct.redOffset = 10;
		ct.greenOffset = -100;
		ct.blueOffset = 135;
		transform.colorTransform = ct;
		blendMode = BlendMode.LAYER;
		rotation = Math.random() * 45;
		scaleX = scaleY = 45;
	}
}
