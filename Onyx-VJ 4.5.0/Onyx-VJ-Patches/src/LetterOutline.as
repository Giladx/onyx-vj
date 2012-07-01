/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/7YCf
 */

package  
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.text.Font;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	final public class LetterOutline extends Patch 
	{
		
		public var vOutline:Vector.<Point> = new Vector.<Point>();		
		public var textColor:uint = 0xffffff;		
		private var outline:BitmapData = null;
		private var _color:uint = 0xFF0000;
		public var glyphs:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
		private var drawTimer:Timer = null;
		private var sprite:Sprite;
		private var _size:int = 60;
		private var _text:String = "batchass";
		private var _font:Font;
		
		public function LetterOutline()
		{
			Console.output('LetterOutline');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			sprite = new Sprite();
			parameters.addParameters(
				new ParameterString('text', 'text'),
				new ParameterInteger( 'size', 'size:', 1, 300, _size ),
				new ParameterFont('font', 'font'),
				new ParameterColor('color', 'color'),
				new ParameterExecuteFunction('run', 'run')
			);	
			font = PluginManager.createFont('Arial') || PluginManager.fonts[0];
		}
		override public function render(info:RenderInfo):void {
			info.render(sprite);

		}
		public function run():void
		{
			var myText:SimpleText = new SimpleText(text,font.fontName,size,color);
			//sprite.addChild(myText);
			myText.y = myText.height;
			
			
			const TW:Number = myText.width;
			const TH:Number = myText.height;
			
			// Text -> BitmapData
			var bmd:BitmapData = new BitmapData(TW,TH,false,0);
			bmd.draw(myText);
			
			// getColor
			for (var w:int = myText.width - 1; w >= 0; w--) {
				for (var h:int = myText.height - 1; h >= 0; h--) {
					if(colorIsLike(bmd.getPixel(w,h),textColor)){
						if (!colorIsLike(bmd.getPixel(w+1,h),textColor) ||
							!colorIsLike(bmd.getPixel(w-1,h),textColor) ||
							!colorIsLike(bmd.getPixel(w,h+1),textColor) ||
							!colorIsLike(bmd.getPixel(w,h-1),textColor)) {
							vOutline.push(new Point(w,h));
							
						}
					}
					
				}
			}
			
			vOutline.reverse();
			
			//Convert outline to different parts
			var maxIterations:uint = 100000;
			
			var iterations:uint = 0; //guard against infinite loop
			while(vOutline.length > 0){
				
				if(vOutline[0] == null){
					vOutline.shift();
					continue;
				}
				
				var currentGlyph:Vector.<Point> = new Vector.<Point>();
				
				var currentPoint:Point = vOutline.shift();
				currentGlyph.push(currentPoint);
				
				var shouldContinue:Boolean = true;
				
				while(shouldContinue && iterations < maxIterations){
					
					
					shouldContinue = false;
					
					for(var index:uint = 0; index<vOutline.length; index++){
						
						if(vOutline[index] == null){
							continue;
						}
						
						if(
							arePointsCloseEnough(currentGlyph[currentGlyph.length - 1], vOutline[index]) ||
							(currentGlyph.length > 2 
								&& arePointsCloseEnough(currentGlyph[currentGlyph.length - 2], vOutline[index]) 
								&& arePointsCloseEnough(currentGlyph[currentGlyph.length - 1], currentGlyph[currentGlyph.length - 2])
							) ||
							false
						){
							currentGlyph.push(vOutline[index]);
							vOutline[index] = null;
							shouldContinue = true;
							continue;
						}else{
							//trace("No match", currentGlyph[currentGlyph.length - 1]);
						}
					}
				}
				glyphs.push(currentGlyph);
			}
			
			outline = new BitmapData(TW,TH,false,0x00000000);
			
			var bitmap:Bitmap = new Bitmap(outline);
			sprite.addChild(bitmap);
			
			drawTimer = new Timer(4, vOutline.length);
			drawTimer.addEventListener(TimerEvent.TIMER, drawNextPixel);
			drawTimer.start();		
		}
		private function colorIsLike(color1:uint, color2:uint):Boolean{
			var result:uint = colorDiff(color1, color2);
			return result <= 256;
		}
		
		public function colorDiff(color1:uint, color2:uint):uint{
			var rPart:uint = Math.abs(((color1 & 0xff0000) >> 16) - ((color2 & 0xff0000) >> 16));
			var gPart:uint = Math.abs(((color1 & 0x00ff00) >> 8)  - ((color2 & 0x00ff00) >> 8));
			var bPart:uint = Math.abs(((color1 & 0x0000ff) >> 0)  - ((color2 & 0x0000ff) >> 0));
			
			//trace(color1, color2, rPart, gPart, bPart);
			return rPart + gPart + bPart ;
		}
		
		private function arePointsCloseEnough(point1:Point, point2:Point):Boolean{
			var xdiff:uint = Math.abs(point1.x - point2.x);
			var ydiff:uint = Math.abs(point1.y - point2.y);
			return xdiff <= 1 && ydiff <= 1;
		}		
		
		public function drawNextPixel(e:TimerEvent):void {
			//trace(glyphs);
			if(glyphs.length <= 0){
				drawTimer.stop();
				return;
			}
			
			if(glyphs[0].length <= 0){
				glyphs.shift();
				return;
			}		
			
			outline.lock();
			
			var point:Point = glyphs[0].shift();
			//trace("drawing", point);
			//outline.setPixel(point.x, point.y, this.outlineColor);
			drawBitmapCircle(outline, point.x, point.y, 1.5, color);
			
			outline.unlock();			
		}
		
		public function drawBitmapCircle(target:BitmapData, cX:Number, cY:Number, r:Number, color:Number):void
		{
			var c:Shape = new Shape();
			c.graphics.beginFill( color );
			c.graphics.drawCircle( cX, cY, r );
			c.graphics.endFill();
			target.draw(c);
		}
		public function set size(value:int):void {
			_size = value;
		}
		
		public function get size():int{
			return _size;
		}

		public function set font(value:Font):void {
			_font = value;
		}

		public function get font():Font {
			return _font;
		}
		public function set color(value:uint):void {
			_color = value;
		}
		public function get color():uint {
			return _color;
		}
		public function set text(value:String):void {
			_text = value;
		}
		public function get text():String {
			return _text;
		}
	}
}

import flash.display.*;
import flash.text.*;
class SimpleText extends Sprite {
	public function SimpleText(message:String, fontName:String, fontSize:Number, fontColor:uint) {
		var tf:TextFormat = new TextFormat();
		tf.color = fontColor;
		tf.size = 8;
		tf.font = fontName;
		
		var txt:TextField = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.text = message;
		txt.selectable = false;
		txt.setTextFormat(tf);
		txt.scaleX = txt.scaleY = fontSize / 8;
		
		addChild(txt);
	}
}