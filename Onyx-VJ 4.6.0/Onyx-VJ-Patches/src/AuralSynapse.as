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
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class AuralSynapse extends Patch 
	{
		//public  var retang:Shape;
		public  var circs:uint;
		public  var circulos:Array;
		public  var alt:int, larg:int;
		public  var blurFilter:Array;
		private var sprite:Sprite;
		private var _ms:int = 40;
		private var _blur:int = 10;
		private var _ctime:Number = 0;
	
		public function AuralSynapse() 
		{
			parameters.addParameters(
				new ParameterInteger( 'ms', 'ms:', 1, 1000, _ms ),
				new ParameterInteger( 'blur', 'blur:', 1, 100, _blur ),
				new ParameterExecuteFunction('draw', 'draw circle')
			);
			sprite = new Sprite();
			circs = 6;
			circulos = new Array(circs);
			alt = DISPLAY_HEIGHT;
			larg = DISPLAY_WIDTH;
			blurFilter = [new BlurFilter(blur, blur, 3)];
			for(var i:uint = 0; i < circulos.length-1; i++) {
				circulos[i] = new Brilho(Math.random() * larg, Math.random() * alt, blurFilter);
				sprite.addChild(circulos[i]);
			}
			_ctime = getTimer();
		}
		public function draw():void
		{
			blurFilter = null;
			blurFilter = [new BlurFilter(blur, blur, 3)];
			circs++;
			sprite.removeChildren();
			circulos = null;
			circulos = new Array(circs);
			for(var i:uint = 0; i < circulos.length-1; i++) {
				circulos[i] = new Brilho(Math.random() * larg, Math.random() * alt, blurFilter);
				sprite.addChild(circulos[i]);
			}
		}
		
		override public function render(info:RenderInfo):void 
		{
			if ( getTimer() - _ctime > ms ) 
			{
				_ctime = getTimer();
				for(var i:uint = 0; i < circulos.length-1; i++) circulos[i].avancar(larg, alt);
			}
			info.render( sprite );
		}
		override public function dispose():void {
			
		}

		public function get ms():int
		{
			return _ms;
		}

		public function set ms(value:int):void
		{
			_ms = value;
		}

		public function get blur():int
		{
			return _blur;
		}

		public function set blur(value:int):void
		{
			_blur = value;
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
