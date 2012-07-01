/**
 * Copyright GreekFellows ( http://wonderfl.net/user/GreekFellows )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/zjgl
 */

package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * ...
	 * @author Greek Fellows
	 */
	public class RubberLetter extends Patch 
	{
		private var array:Array;
		
		private var bd:BitmapData;
		private var b:Bitmap;
		private var s:Sprite;
		private var sprite:Sprite;
		
		private const UNIT:int = 1;
		
		public function RubberLetter():void 
		{			
			text("batchass\nrocks");
			
			// then draw that out with a new bitmap data
			var gfbd:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT);
			gfbd.draw(this); // it can't be gfbd.draw(gf) because then gf will shift to the top left corner
			
			// use an array to store the white 'visible' pixels of the text, using the bitmap data
			this.array = [];
			for (var ver:int = 0; ver < gfbd.height; ver += this.UNIT) {
				for (var hor:int = 0; hor < gfbd.width; hor += this.UNIT) {
					if (gfbd.getPixel(hor, ver) != 0xffffff) {
						this.array.push( { cx:hor, cy:ver, x:hor, y:ver, color:gfbd.getPixel(hor, ver) } );
					}
				}
			}
			
			// remove the logo because we won't use it anymore
			this.removeChildren();
			
			// accelerate the graphics by using bitmap data with render mode set to GUI
			bd = new BitmapData(800, 600);
			b = new Bitmap(bd);
			s = new Sprite();
			sprite = new Sprite();
			sprite.addChild(b);
		}
		
		override public function render(info:RenderInfo):void {
			s.graphics.clear();
			
			s.graphics.beginFill(0xffffff, 1);
			s.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			s.graphics.endFill();
			
			for (var ind:int = 0; ind < this.array.length; ind++) {
				// if mouse is close enough to the point
				var mp:Point = new Point(mouseX, mouseY);
				var pp:Point = new Point(this.array[ind].cx, this.array[ind].cy);
				var d:Number = Point.distance(mp, pp);
				var angle:Number = Math.atan2( (mp.y - pp.y) , (mp.x - pp.x) ) / Math.PI * 180 - 180;
				this.array[ind].x += (pp.x + Math.cos(angle * Math.PI / 180) * 100 - this.array[ind].x) / 5;
				this.array[ind].y += (pp.y + Math.sin(angle * Math.PI / 180) * 100 - this.array[ind].y) / 5;
				
				s.graphics.beginFill(0x000000, 1);
				s.graphics.drawRect(this.array[ind].x, this.array[ind].y, this.UNIT, this.UNIT);
				s.graphics.endFill();
			}
			
			bd.draw(s);
			info.render(sprite);
		}
		
		private function text(str:String):TextField {
			var tf:TextField = new TextField();
			tf.text = str;
			
			var fm:TextFormat = new TextFormat();
			fm.font = "Segoe UI Light";
			fm.size = 64;
			fm.align = "center";
			
			tf.setTextFormat(fm);
			
			tf.width = tf.textWidth;
			tf.height = tf.textHeight + 5;
			tf.x = DISPLAY_WIDTH / 2 - tf.textWidth / 2;
			tf.y = DISPLAY_HEIGHT / 2 - tf.textHeight / 2;
			
			sprite.addChild(tf);
			
			return tf;
		}
		
	}
	
}