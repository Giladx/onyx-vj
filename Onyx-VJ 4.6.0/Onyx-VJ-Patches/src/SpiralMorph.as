/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/zJvJ
 */

// forked from keno42's ã®ã‚“ã³ã‚Šçœºã‚ã‚‹ç”¨
// forked from keno42's ã²ã¾ã‚ã‚Šã£ã½ã„ã‚„ã¤
// è§’åº¦ã®é»„é‡‘æ¯”åˆ†å‰²ã¨ã‹ å‡ºå±• - Nature by Number http://www.etereaestudios.com/movies/nbyn_movies/nbyn_mov_youtube.htm
package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class SpiralMorph extends Patch {
		private var MAX_NUM:int = 1618;
		private var num:int = MAX_NUM;
		private var gv:Number = 0;
		private var ga:Number = 0;
		private var angle:Number = 0;
		private var firstP:Particle = new Particle();
		private var lastP:Particle = firstP;
		private var bmpData:BitmapData;
		private var timer:Timer = new Timer(5100);
		private var sprite:Sprite;
		private var midX:int;
		private var midY:int;
	
		public function SpiralMorph() {
			bmpData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT,false,0x0);
			midX = DISPLAY_WIDTH/2;
			midY = DISPLAY_HEIGHT/2;
			sprite = new Sprite();
			sprite.addChild( new Bitmap( bmpData ) );
			shoot(firstP, angle);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			timer.start();
		}
		private function onClick(e:MouseEvent):void{
			randomRefresh();
		}
		private function onTimer(e:TimerEvent):void{
			randomRefresh();
		}
		private function randomRefresh():void{
			if( num != 0 ) return;
			var tempNum:int = MAX_NUM; 
			var p:Particle = firstP;
			var angleDiff:Number = Math.random() * Math.PI * 2;
			var rBase:int = Math.random() * 0xFF;
			var gBase:int = Math.random() * 0xFF;
			var bBase:int = Math.random() * 0xFF;
			var rGoal:int = Math.random() * 0xFF;
			var gGoal:int = Math.random() * 0xFF;
			var bGoal:int = Math.random() * 0xFF;
			
			angle = 0;
			do {
				tempNum--;
				angle += angleDiff;
				p.toX = midX + Math.sqrt(tempNum) * Math.cos(angle) / (MAX_NUM / 9000);
				p.toY = midY + Math.sqrt(tempNum) * Math.sin(angle) / (MAX_NUM / 9000);
				p.color = 
					Math.floor(rBase + ( (rGoal-rBase) * tempNum / MAX_NUM )) << 16 |
					Math.floor(gBase + ( (gGoal-gBase) * tempNum / MAX_NUM )) << 8 |
					Math.floor(bBase + ( (bGoal-bBase) * tempNum / MAX_NUM ));
			} while( p = p.next );
		}
		override public function render(info:RenderInfo):void {
			var p:Particle = firstP;
			bmpData.lock();
			do {
				p.update();
				bmpData.setPixel(p.x, p.y, p.color);
			} while( p = p.next )
			bmpData.applyFilter(bmpData,bmpData.rect,new Point(),new BlurFilter(2,2));
			bmpData.unlock();
			if( num > 0 ){
				for( var i:int = 0; i < gv; i++ ){
					num--;
					var temp:Particle = new Particle();
					angle += Math.PI * 137.5077 / 180;
					shoot(temp, angle);
					lastP.next = temp;
					lastP = temp;
					if( num == 0 ) break;
				}
				gv += ga; 
				ga += 0.02;
			}
			info.render(sprite);
		}
		private function shoot(p:Particle, angle:Number):void{
			p.x = midX;
			p.y = midY;
			p.toX = midX + Math.sqrt(num) * Math.cos(angle) / (MAX_NUM / 9000);
			p.toY = midY + Math.sqrt(num) * Math.sin(angle) / (MAX_NUM / 9000);
			p.color = 
				(0xCC + Math.ceil( 0x33 - 0x33 * num / MAX_NUM )) << 16 |
				(0x88 + Math.ceil( 0x77 - 0x77 * num / MAX_NUM )) << 8 |
				(Math.ceil( 0x44 * num / MAX_NUM ));
		}
	}
}

final class Particle
{
	public var x:Number;
	public var y:Number;
	public var toX:Number;
	public var toY:Number;
	public var color:uint;
	public var next:Particle;
	public function update():void{
		x += 0.1 * (toX-x);
		y += 0.1 * (toY-y);
	}
}