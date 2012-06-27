package {
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Strobo extends Patch {
		private var white:BitmapData;
		private var black:BitmapData;
		private var sprite:Sprite;
		private var ms:int;
		private var toggle:Boolean;
		private var _delay:int = 200;

		public function Strobo() {
			parameters.addParameters(
				new ParameterInteger( 'delay', 'delay', 5, 1000, _delay  )
			);
			sprite = new Sprite();
			white = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0xFFFFFF);
			black = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x00);
			ms = getTimer();			
		}		
		override public function render(info:RenderInfo):void {		
			if( getTimer() - delay > ms ) {
				ms = getTimer();
				toggle = !toggle;
			}
			info.render( toggle ? white : black );			
		}

		public function get delay():int	{
			return _delay;
		}

		public function set delay(value:int):void {
			_delay = value;			
		}
		override public function dispose():void {
			white.dispose();
			black.dispose();
		}
	}
}