/**
 * Copyright Indyaner2 ( http://wonderfl.net/user/Indyaner2 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/9mK8
 */

// forked from celsyum's forked from: Ripple01
// forked from chutaicho's Ripple01
//-----------------------------------------------------
// title : Ripple
// æ³¢ç´‹åŠ¹æžœã®ç·´ç¿’
//-----------------------------------------------------
package plugins.filters
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import org.flintparticles.common.utils.Maths;
	
	public final class RippleFilter extends Filter implements IBitmapFilter {
		
		private const BUFFER_SCALE:Number = 0.2; //ãƒãƒƒãƒ•ã‚¡ç”¨ãƒ“ãƒƒãƒˆãƒžãƒƒãƒ—ã®ã‚µã‚¤ã‚º
		
		private var _buffer1:BitmapData;
		private var _buffer2:BitmapData;
		private var _defData:BitmapData;
		private var _scale:Number;
		private var _matrix:Matrix; 
		private var _fullRect:Rectangle;
		private var _drawRect:Rectangle;
		private var _origin:Point;
		private var _filter:DisplacementMapFilter;
		private var _convoFilter:ConvolutionFilter;
		private var _colorTransform:ColorTransform;
		private var resizeData:BitmapData;
		private var _size:int = 20; 
		private var _mx:int = DISPLAY_WIDTH/2; 
		private var _my:int = DISPLAY_HEIGHT/2; 
		
		public function RippleFilter()
		{
			parameters.addParameters(
				new ParameterInteger('size', 'size', 3, 100, _size),
				new ParameterInteger('mx', 'mx', 0, DISPLAY_WIDTH, _mx),
				new ParameterInteger('my', 'my', 0, DISPLAY_WIDTH, _my)
			);
			resizeData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT);
			
			_buffer1 = new BitmapData(DISPLAY_WIDTH*BUFFER_SCALE, DISPLAY_HEIGHT*BUFFER_SCALE, false, 0x000000);
			_buffer2 = new BitmapData(_buffer1.width, _buffer1.height, false, 0x000000);
			_defData = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x7f7f7f);
			
			
			_fullRect = new Rectangle(0, 0, _buffer1.width, _buffer1.height);
			_drawRect = new Rectangle();
			
			_filter = new DisplacementMapFilter(_buffer1, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE, 50, 50, DisplacementMapFilterMode.WRAP);
			
			_convoFilter = new ConvolutionFilter(3, 3, [0.5, 1, 0.5, 1, 0, 1, 0.5, 1, 0.5], 3);
			_colorTransform = new ColorTransform(1, 1, 1, 1, 0, 128, 128);       
			_matrix = new Matrix(_defData.width/_buffer1.width, 0, 0, _defData.height/_buffer1.height);
			
			
		}
		
		private function switchBuffers():void
		{
			var temp : BitmapData;
			temp = _buffer1;
			_buffer1 = _buffer2;
			_buffer2 = temp;
		}
		public function applyFilter(bitmapData:BitmapData):void {
			resizeData.draw( bitmapData );

			var rad:int = _size/2 * -1;
			_drawRect.x = ( rad + mx ) * BUFFER_SCALE;    
			_drawRect.y = ( rad + my ) * BUFFER_SCALE;
			_drawRect.width = _drawRect.height = _size * BUFFER_SCALE;
			_buffer1.fillRect(_drawRect, 0xFF);
			
			var temp:BitmapData = _buffer2.clone();
			_buffer2.applyFilter(_buffer1, _fullRect, new Point(), _convoFilter);
			_buffer2.draw(temp, null, null, BlendMode.SUBTRACT, null, false);
			_defData.draw(_buffer2, _matrix, _colorTransform, null, null, true);
			_filter.mapBitmap = _defData;

			temp.dispose();
			switchBuffers();
			
			bitmapData.applyFilter(bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY, _filter);	
		}		

		public function get my():int
		{
			return _my;
		}

		public function set my(value:int):void
		{
			_my = value;
		}

		public function get mx():int
		{
			return _mx;
		}

		public function set mx(value:int):void
		{
			_mx = value;
		}

		public function get size():int
		{
			return _size;
		}

		public function set size(value:int):void
		{
			_size = value;
		}


	}
}