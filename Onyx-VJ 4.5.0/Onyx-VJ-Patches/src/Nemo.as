/**
 * Copyright codeonwort ( http://wonderfl.net/user/codeonwort )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/kYiI
 */

// forked from gameegg's Particle Puzzle
package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Nemo extends Patch 
	{
		
		private var bitd:BitmapData;
		private var bit:Bitmap;
		private var box:Array = [];
		private var colorTrans:ColorTransform = new ColorTransform(1,1,1, 0.5);
		
		public function Nemo() 
		{
			bitd = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,false,0x0);
			bit = new Bitmap(bitd);
			addChild(bit);
			
			buildBox();
			
			//addEventListener("mouseDown",md);
		}
		
		private function buildBox():void 
		{
			var txt:TextField = new TextField();
			txt.autoSize = "left";
			txt.text = "Jumble Groove";
			txt.setTextFormat(new TextFormat("Calibri", 60,0xff0000,true));
			
			var temp:BitmapData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0xffffff);
			temp.perlinNoise(DISPLAY_WIDTH/2, DISPLAY_HEIGHT/2, 8, Math.random()*10000, true, true, 2);
			temp.draw( txt, new Matrix(1,0,0,1, .5*(DISPLAY_WIDTH-txt.width), .5*(DISPLAY_HEIGHT-txt.height)) );
			
			var xx:int, yy:int;
			for(var i:int = 0; i<DISPLAY_WIDTH/2; ++i)
			{
				for(var j:int = 0; j<DISPLAY_HEIGHT/2; ++j)
				{
					xx = 1 + 2*i;
					yy = 1 + 2*j;
					if(temp.getPixel(xx, yy) == 0x0) continue;
					var dot:Dot = new Dot( new Point(xx, yy) );
					dot.color = 0x3c278b + temp.getPixel(xx, yy);
					box.push(dot);
				}
			}
			
			temp.dispose();
		}
		
		override public function render(info:RenderInfo):void 
		{
			bitd.colorTransform(bitd.rect, colorTrans);
			
			for(var k:int=0;k<box.length;++k)
			{
				box[k].update();
				box[k].update();
				//box[k].update();
				bitd.setPixel( box[k].x, box[k].y, box[k].color);
			}
			info.render( bitd );
		}
		
		private function md(e:MouseEvent):void 
		{
			for(var k:int=0;k<box.length;++k)
			{
				box[k].init();
			}
		}
		
	}
	
}

import flash.geom.Point;
import onyx.core.*;
import onyx.plugin.*;

internal class Dot 
{
	
	public var targetPoint:Point
	public var x:Number=0;
	public var y:Number=0;
	public var a:Boolean=false;
	public var c:Boolean=false;
	public var end:Boolean=false;
	public var color:uint;
	
	public function Dot(itargetPoint:Point) 
	{
		targetPoint = itargetPoint.clone();
		color = 0x0000ff;
		init();
	}
	
	public function update():void
	{
		if(!end)
		{
			if((a&&c) || (!a&&!c))
			{
				if(x < targetPoint.x) 
				{
					x++;
					if(x >= targetPoint.x)
					{
						if(!a && !c) c = true
						else if(a && c) end = true;
					}
					
				}
				else if(x >= targetPoint.x)
				{
					x--;
					if(x < targetPoint.x)
					{
						if(!a && !c) c = true
						else if(a && c) end = true;
					}
				}
			}
			if((a&&!c) || (!a&&c))
			{
				if(y < targetPoint.y)
				{
					y++;
					if(y >= targetPoint.y)
					{
						if(a && !c) c = true
						else if(!a && c) end = true;
					}
				}
				else if(y >= targetPoint.y) 
				{
					y--;
					if(y < targetPoint.y)
					{
						if(a && !c) c = true
						else if(!a && c) end = true;
					}
				}
			}
		}
		else 
		{
			x = targetPoint.x;
			y = targetPoint.y;
		}
	}
	
	public function init():void
	{
		end = false;
		a = false;
		c = false;
		if(Math.random()<0.5) x = -int(Math.random()*DISPLAY_WIDTH);
		else x = DISPLAY_WIDTH+int(Math.random()*DISPLAY_WIDTH);
		if(Math.random()<0.5) y = -int(Math.random()*DISPLAY_HEIGHT);
		else y = DISPLAY_HEIGHT+int(Math.random()*DISPLAY_HEIGHT);
		
		if(Math.random()*8 < 2) 
		{
			x = -int(Math.random()*DISPLAY_WIDTH);
			y = int(Math.random()*DISPLAY_HEIGHT);
		}
		else if(Math.random()*8 < 4)
		{
			x = DISPLAY_WIDTH + int(Math.random()*DISPLAY_WIDTH);
			y = int(Math.random()*DISPLAY_HEIGHT);
		}
		else if(Math.random()*8 < 6)
		{
			x = int(Math.random()*DISPLAY_WIDTH);
			y = DISPLAY_HEIGHT+int(Math.random()*DISPLAY_HEIGHT);
		}
		else if(Math.random()*8 < 6)
		{
			x = int(Math.random()*DISPLAY_WIDTH);
			y = -int(Math.random()*DISPLAY_HEIGHT);
		}
		
		if(Math.random()<0.5) a=true;
	}
	
}
