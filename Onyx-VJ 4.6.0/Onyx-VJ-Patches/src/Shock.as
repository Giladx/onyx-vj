/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/9KRZ
 */

package
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Shock extends Patch
	{
		private var cnt:int = 0;
		private var trail:Bitmap;
		private var ovals:Array;
		private var color:uint; 
		private var mx:Number = 320;
		private var my:Number = 240;		
		private var sprite:Sprite;
		
		public function Shock():void
		{
			sprite = new Sprite();
			trail = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0));
			trail.filters = [new BlurFilter( 6,6,3 ) ];
			sprite.addChild(trail);
	
			ovals = new Array(101);
			color= 0xffffff * Math.random();
			for (var t:int = 0; t < 101; t++)
			{
				ovals[t] = new Sprite();
				var p:TextField = new TextField();
				ovals[t].addChild(p);
				sprite.addChild(ovals[t]);
			}
			ovals[0].y = -2 * t * Math.sin(my / 200 - 0.5) + 250;
			addEventListener( MouseEvent.MOUSE_DOWN, mouseCap );
			addEventListener( MouseEvent.MOUSE_MOVE, mouseCap );
		}

		private function mouseCap(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}		
		override public function render(info:RenderInfo):void  
		{
			cnt++;
			trail.bitmapData.draw(sprite);
			for (var t:Number = 1; t < 101; t++)
			{
				ovals[t].getChildAt(0).x = Math.sin(t / (5000) * Math.PI * cnt) * t * 2;
				ovals[t].getChildAt(0).y = Math.cos(t / (5000) * Math.PI * cnt) * t * 2;
				ovals[t].getChildAt(0).text = "|"; //Math.round(Math.random());
				ovals[t].getChildAt(0).textColor = color; 
				ovals[t].x += (ovals[t - 1].x - ovals[t].x) * 0.65;
				ovals[t].scaleY = Math.cos(mx / 200 - 0.5);
				ovals[t].y = -2 * t * Math.sin(my / 200 - 0.5) + 250;
			}
			ovals[0].x = mx;
			if ((cnt) % 50 == 0)
			{
				color = Math.random() * 0xffffff;
			}
			info.render(sprite);
		} //end of function

	} //end of class
} //end of package

