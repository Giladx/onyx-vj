/**
 * Copyright tjoen ( http://wonderfl.net/user/tjoen )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/npcy
 */

package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Grunge extends Patch {
		private var bd:BitmapData;
		private var bd2:BitmapData;
		private var isProcessing:Boolean=true;
		private var sprite:Sprite;
		private var _ms:int = 100;
		private var _ctime:Number = 0;
		
		public function Grunge() 
		{
			parameters.addParameters(
				new ParameterInteger( 'ms', 'ms:', 1, 1000, _ms )
			);
			sprite = new Sprite();
			bd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x808080);
			bd2 = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x808080);
			
			var bmp:Bitmap = new Bitmap(bd);
			sprite.addChild(bmp);
			
			bd.perlinNoise(150, 150, 3, 50, true, true, 7, true);
			addEventListener(MouseEvent.MOUSE_DOWN, toggleProcessing);
			_ctime = getTimer();
		}
		private function addLayer():void {
			var seed:uint=Math.random()*1000;
			var sizex:uint=Math.random()*250+2;
			var sizey:uint=Math.random()*250+2;
			bd2.perlinNoise(sizex, sizey, 3, seed, false, true, 7, true);
			bd.draw(bd2, null, null, BlendMode.DIFFERENCE);
		}
		//function toggleProcessing(event:MouseEvent):void {
		private function toggleProcessing(e:MouseEvent):void {
			//isProcessing ? removeEventListener(Event.ENTER_FRAME, addLayer) : addEventListener(Event.ENTER_FRAME, addLayer);
			isProcessing=!isProcessing;
		} 
		override public function render(info:RenderInfo):void {
			if ( getTimer() - _ctime > ms ) 
			{
				_ctime = getTimer();
				if (isProcessing)
				{
					addLayer();
				}
				
			}
			info.render(sprite);
		}
		public function get ms():int
		{
			return _ms;
		}
		
		public function set ms(value:int):void
		{
			_ms = value;
		}
	}
}