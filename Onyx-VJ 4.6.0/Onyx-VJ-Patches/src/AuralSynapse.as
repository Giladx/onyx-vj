/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/4raK
 */

// forked from bradsedito's AuralSynapse
// AuralSynapse
// BradSedito 12.11.2011

package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class AuralSynapse extends Patch 
	{
		//public  var retang:Shape;
		public  var circs:uint;
		public  var circulos:Array;
		public  var alt:int, larg:int;
		public  var blur:Array;
		private var sprite:Sprite;
		private var timer:Timer;
		
		public function AuralSynapse() 
		{
			sprite = new Sprite();
			circs = 6;
			circulos = new Array(circs);
			alt = DISPLAY_HEIGHT;
			larg = DISPLAY_WIDTH;
			blur = [new BlurFilter(10, 10, 3)];
			/*retang = new Shape();
			retang.graphics.beginFill(0);
			retang.graphics.drawRect(0, 0, larg, alt);
			sprite.addChild(retang);*/
			for(var i:uint = 0; i < circs; i++) {
				circulos[i] = new Brilho(Math.random() * larg, Math.random() * alt, blur);
				sprite.addChild(circulos[i]);
			}
			timer = new Timer(40);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		private function onTimer(evt:TimerEvent):void 
		{
			for(var i:uint = 0; i < circs; i++) circulos[i].avancar(larg, alt);
			
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );
		}
		override public function dispose():void {
			
		}
	}
}
import flash.display.Shape;
class Brilho extends Shape {
	public var vx:Number;
	public var vy:Number;
	public function Brilho(x:Number, y:Number, filtros:Array) {
		super();
		this.x = x;
		this.y = y;
		vx = Math.random() * 4 - 2;
		vy = Math.random() * 4 - 2;
		graphics.beginFill(Math.floor(Math.random() * 0xFFFFFF));
		graphics.drawCircle(0, 0, Math.random() * 40 + 80);
		blendMode = "add";
		filters = filtros;
	}
	public function avancar(mx:Number, my:Number):void {
		if(x > mx || x < 0) vx *= -1;
		if(y > my || y < 0) vy *= -1;
		x += vx;
		y += vy;
	}
}
