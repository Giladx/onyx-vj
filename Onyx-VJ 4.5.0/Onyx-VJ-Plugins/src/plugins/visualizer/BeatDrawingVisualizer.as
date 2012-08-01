
/**
 * Copyright rettuce ( http://wonderfl.net/user/rettuce )
 * GNU General Public License, v3 ( http://www.gnu.org/licenses/quick-guide-gplv3.html )
 * Downloaded from: http://wonderfl.net/c/y68y
 */

package plugins.visualizer
{
	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.plugin.*;

	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public final class BeatDrawingVisualizer extends Visualizer
	{
		private var _bArr:ByteArray = new ByteArray();
		private var _pArr:Array = [];
		private var _stg:Sprite;
		private var _bg:Bitmap;
		private var midX:int = DISPLAY_WIDTH/2;
		private var midY:int = DISPLAY_HEIGHT/2;
		
		public function BeatDrawingVisualizer()
		{       		
			_stg = new Sprite();
			
			for(var i:int=0; i<512; i++){
				_pArr[i] = new Point(midX, midY);
			}
		}
		
		override public function render(info:RenderInfo):void 
		{
			SoundMixer.computeSpectrum(_bArr, false, 0);    //ã€€byteArr(length=512), FFT, rate 0->44.1 KHz, 1->22.05KHz...
			_bArr.position = 0;
			
			var byteTotal:Number = 0;    // ä¸¡éŸ³
			var totalR:Number    = 0;    // å³ãƒ‘ãƒ³
			var totalL:Number    = 0;    // å·¦ãƒ‘ãƒ³
			var byte:Number      = 0;
			
			for(var i:int = 0; i < 512; i++)
			{
				byte = Math.abs(_bArr.readFloat());
				byteTotal += byte;
				
				if(i<256) totalR += byte;
				else totalL += byte;
				
				if(byte>0.1)
				{
					Tweener.addTween( _pArr[i], { 
						x:Math.cos((i*360/512-90)*Math.PI/180)*400*(byte-0.05)+midX,
						y:Math.sin((i*360/512-90)*Math.PI/180)*400*(byte-0.05)+midY,
						time:0.2, transition:'easeOutQuad'
					});
				};
			};            
			
			_stg.graphics.clear();
			_stg.graphics.lineStyle(0.5,0x000000 );
			_stg.graphics.beginFill(0xFFFFFF*Math.random());
			_stg.graphics.moveTo(_pArr[0].x,_pArr[0].y);
			for(var m:int=0; m<_pArr.length-1; m++){
				var px:Number = (_pArr[m].x + _pArr[m+1].x)/2;
				var py:Number = (_pArr[m].y + _pArr[m+1].y)/2;                
				_stg.graphics.curveTo(_pArr[m].x, _pArr[m].y, px, py);
			}
			_stg.graphics.lineTo(_pArr[_pArr.length-1].x, _pArr[_pArr.length-1].y );
			_stg.graphics.lineTo(_pArr[0].x,_pArr[0].y);            
			_stg.graphics.endFill();
			
			// éŸ³ã®å¹³å‡å€¤
			byteTotal /= 512;
			
			// å·¦å³ãƒ‘ãƒ³å¹³å‡å€¤
			totalR /= 256; 
			totalL /= 256;             
			 
			info.render(_stg);
		}
		
	}
}