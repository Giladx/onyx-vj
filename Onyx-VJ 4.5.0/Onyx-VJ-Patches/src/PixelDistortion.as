/**
 * Copyright tripu ( http://wonderfl.net/user/tripu )
 * GNU General Public License, v3 ( http://www.gnu.org/licenses/quick-guide-gplv3.html )
 * Downloaded from: http://wonderfl.net/c/h0dI
 */

package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import EmbeddedAssets.AssetForPixelDistortion;
	
	public class PixelDistortion extends Patch {
		
		protected var _bitmap:BitmapData;
		protected var _distortion:int = 0;
		protected var _maxDistortion:int = 10;
		protected var _decreasing:Boolean = true;
		
		public function PixelDistortion()
		{
			Console.output('PixelDistortion (from http://wonderfl.net/user/tripu)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterInteger( 'distortion', 'distortion', 1, 300, 35 ),
				new ParameterInteger( 'maxDistortion', 'maxDistortion', 1, 300, 300 )
			);
			_bitmap = new AssetForPixelDistortion();
			addChild(new Bitmap(_bitmap, 'auto', true));
		}
		
		
		override public function render(info:RenderInfo):void 
		{
			if (_bitmap) 
			{
				var bd:BitmapData = new AssetForPixelDistortion();
				for (var i:uint = 0; i < _bitmap.width; i ++) 
				{
					for (var j:uint = 0; j < _bitmap.height; j ++) 
					{
						_bitmap.setPixel(i, j, bd.getPixel(Math.random() * _distortion + i - _distortion * 0.5, Math.random() * _distortion + j - _distortion * 0.5));
					}
				}
				
				if (_decreasing) {
					_distortion --;
					if (_distortion < 0) {
						_decreasing = false;
					}
				} else {
					_distortion ++;
					if (_distortion > maxDistortion) {
						_decreasing = true;
					}
				}
				info.render( _bitmap );
			}
		}
		public function get maxDistortion():int
		{
			return _maxDistortion;
		}
		
		public function set maxDistortion(value:int):void
		{
			_maxDistortion = value;
		}
		
		public function get distortion():int
		{
			return _distortion;
		}
		
		public function set distortion(value:int):void
		{
			_distortion = value;
		}

	}
}


