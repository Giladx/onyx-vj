/**
 * Copyright mutantleg ( http://wonderfl.net/user/mutantleg )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/vZ0Z
 */

package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Proxy;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Silhouette extends Patch
	{
		
		private var screen:BitmapData;
		private var pic:Bitmap;
		private var mx:Number = 320;
		private var my:Number = 240;
		private var point:Point = new Point(0,0);
		private var filt:BlurFilter = new BlurFilter(10,10,1);
		//public var bef:BevelFilter = new BevelFilter(2);
		private var rect:Rectangle = new Rectangle();
		
		public function Silhouette() 
		{
			Console.output('Silhouette adapted by Bruce LANE (http://www.batchass.fr)');
			
			screen = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT,true,0);
			pic = new Bitmap(screen);
			
			//screen.noise(12);        
			addChild(pic);
			addEventListener( MouseEvent.MOUSE_DOWN, startDraw );
			addEventListener( MouseEvent.MOUSE_MOVE, startDraw );
		}//ctor
		private function startDraw(evt:MouseEvent) : void 
		{
			mx = evt.localX; 
			my = evt.localY; 		
		}		
		
		override public function render(info:RenderInfo):void 
		{
			var h:Number = 1 + Math.random() * 140;
			var w:Number = 1 + Math.random() * 140;
			
			screen.lock()
			rect.x = 60*(Math.random() -0.5)+mx - h*0.5;
			rect.y = 60*(Math.random() -0.5)+my - w*0.5;
			rect.width = w;
			rect.height = h;
			screen.fillRect(rect, Math.random() *0xFFffFFff);
			
			screen.applyFilter(screen, screen.rect, point, filt);
			//screen.applyFilter(screen, screen.rect, point, bef);
			screen.unlock();
			
			//screen.setPixel(mx, my, Math.random() *0xFFffFFff);
			info.render( pic );
			
		}//onenter
		
	}//classend
}//package