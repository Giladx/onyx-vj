/**
 * Copyright okoi ( http://wonderfl.net/user/okoi )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/yEha
 */

package plugins.visualizer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.plugin.*;	
	/**
	 * ...
	 * @author okoi
	 */
	public final class PerlinVisualizer extends Visualizer
	{
		private static const SPECTRUM_NUM:int = 512;
		
		private var _back:BitmapData;
		private var _front:Sprite;
		
		private var _leftSpectrumFactorRecordList:Vector.<SpectrumFactorRecord>;
		private var _rightSpectrumFactorRecordList:Vector.<SpectrumFactorRecord>;
		
		private var _time:int;
		
		private static const ONESIDE_WAVELINE_COUNT:int = 8;
		private var _leftWaveList:Array /*WaveLine*/;
		private var _rightWaveList:Array /*WaveLine*/;
		
		private var _radius:Number = 0;
		
		private var _colorMatrixFilter:ColorMatrixFilter;
		private var _blurFilter:BlurFilter;
		private var sprite:Sprite = new Sprite();
		private var _waveBuffer:Array;
		private var _fftBuffer:Array;
		
		private var _spectrumData:SpectrumData;
		private var _bytes:ByteArray = new ByteArray();
		private var position:int = 0;
		
		public function PerlinVisualizer()
		{
			var i:int;
			
			_back = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0);
			sprite.addChild(new Bitmap(_back));
			
			_front = new Sprite();
			sprite.addChild(_front);
			
			_leftSpectrumFactorRecordList = new Vector.<SpectrumFactorRecord>(SPECTRUM_NUM / 2, true);
			_rightSpectrumFactorRecordList = new Vector.<SpectrumFactorRecord>(SPECTRUM_NUM / 2, true);
			for (i = 0; i < SPECTRUM_NUM / 2; i++)
			{
				_leftSpectrumFactorRecordList[i] = new SpectrumFactorRecord();
				_rightSpectrumFactorRecordList[i] = new SpectrumFactorRecord();
			}
			
			_time = 0;
			
			_leftWaveList = [];
			_rightWaveList = [];
			for (i = 0; i < ONESIDE_WAVELINE_COUNT; i++)
			{
				_leftWaveList.push(new WaveLine(120));
				_rightWaveList.push(new WaveLine(120));
			}
			
			_colorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.99, 0]);
			_blurFilter = new BlurFilter(8, 8, 3);
			
		}
		public function GetSpectrumData(FFTMode:Boolean = false):Array
		{
			var i:int;
			var buf:Array = new Array(512);
			
			SoundMixer.computeSpectrum(_bytes, FFTMode, 0);
			_bytes.position = 0;
			for (i = 0; i < 512; i++)
				buf[i] = _bytes.readFloat();
			return buf;
		}

		override public function render(info:RenderInfo):void 
		{
			
			var i:int;
			
			//--------------------------------------
			//    analyze
			//--------------------------------------
			var listSize:int = SPECTRUM_NUM / 2;
			var totalConsecutiveOverAverage:int = 0;
			var totalValue:Number = 0;
			_waveBuffer = GetSpectrumData(false);
			_fftBuffer = GetSpectrumData(true);
			
			_spectrumData = new SpectrumData(_fftBuffer, position);

			for (i = 0; i < SPECTRUM_NUM; i++)
			{
				if (i < listSize)
				{
					_leftSpectrumFactorRecordList[i].addRecord(_spectrumData.soundPosition, _spectrumData.data[i]);
				}
				else
				{
					_rightSpectrumFactorRecordList[i - listSize].addRecord(_spectrumData.soundPosition, _spectrumData.data[i]);
				}
				
				totalValue += _spectrumData.data[i];
			}
			
			_radius *= 0.5;
			_radius += totalValue;
			
			var wavePower:Number = 0;
			var wavePowerList:Array = new Array(ONESIDE_WAVELINE_COUNT);
			var rightWavePointList:Array = new Array(ONESIDE_WAVELINE_COUNT);
			for (i = 0; i < ONESIDE_WAVELINE_COUNT; i++)
			{
				wavePowerList[i] = 0;
				rightWavePointList[i] = 0;
			}
			var waveIndex:int = 0;
			
			listSize = _leftSpectrumFactorRecordList.length;
			for (i = 0; i < listSize; i++)
			{
				waveIndex = int(i / (listSize / ONESIDE_WAVELINE_COUNT));
				wavePowerList[waveIndex] += _leftSpectrumFactorRecordList[i].getLatestValue();
			}
			listSize = _rightSpectrumFactorRecordList.length;
			for (i = 0; i < listSize; i++)
			{
				waveIndex = int(i / (listSize / ONESIDE_WAVELINE_COUNT));
				rightWavePointList[waveIndex] += _rightSpectrumFactorRecordList[i].getLatestValue();
			}
			
			for (i = 0; i < ONESIDE_WAVELINE_COUNT; i++)
			{
				var angle:Number = ((360 / ONESIDE_WAVELINE_COUNT) * i + _time);
				var y:Number = Math.sin(angle * Math.PI / 180) * _radius;
				
				_leftWaveList[i].update(new Point(0, DISPLAY_HEIGHT / 2 + y), new Point(DISPLAY_WIDTH, DISPLAY_HEIGHT / 2 + y), wavePowerList[i], angle);
				_rightWaveList[i].update(new Point(DISPLAY_WIDTH, DISPLAY_HEIGHT / 2 - y), new Point(0, DISPLAY_HEIGHT / 2 - y), rightWavePointList[i], angle);
			}
			
			//--------------------------------------
			//    draw
			//--------------------------------------
			var g:Graphics = _front.graphics;
			
			g.clear();
			
			for (waveIndex = 0; waveIndex < ONESIDE_WAVELINE_COUNT; waveIndex++)
			{
				var wave:WaveLine = _leftWaveList[waveIndex];
				
				var points:Array /*Point*/ = wave.getDividePoints();
				g.lineStyle(0.5, 0xFFFFFF, wave.alpha);
				for (i = 0; i < points.length; i++)
				{
					
					if (i == 0)
						g.moveTo(points[i].x, points[i].y);
					else
						g.lineTo(points[i].x, points[i].y);
				}
				
				wave = _rightWaveList[waveIndex];
				points = wave.getDividePoints();
				g.lineStyle(0.5, 0xFFFFFF, wave.alpha);
				
				for (i = 0; i < points.length; i++)
				{
					
					if (i == 0)
						g.moveTo(points[i].x, points[i].y);
					else
						g.lineTo(points[i].x, points[i].y);
				}
			}
			
			_back.lock();
			_back.applyFilter(_back, _back.rect, new Point(), _colorMatrixFilter);
			
			_back.applyFilter(_back, _back.rect, new Point(), _blurFilter);
			_back.draw(_front, null, new ColorTransform(0, 0, 0, 0, 150, 150, 255, 70), "add");
			_back.unlock();
			
			_time++;
			info.render( sprite );
		}
		
	}
}
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;

/**
 *
 * @author okoi
 */
class WaveLine
{
	private var _length:Number = 0; //    start,endé??ã??é??ã??
	
	private var _divideCount:int;
	private var _divideVec:Point; //    start-endã??å??å??ã??ã??ã??ã??ã??ã??ã??ã??ã??
	private var _dividePoints:Array /*Point*/; //
	
	private var _powerVec:Point;
	
	private var _noise:BitmapData;
	private var _noiseOffset:Array /*Point*/;
	private var _noiseSeed:int;
	
	private var _alpha:Number = 0;
	
	//-------------------------------------------------
	//    getter / setter
	//-------------------------------------------------
	public function get alpha():Number
	{
		return _alpha;
	}
	
	public function WaveLine(divideCount:int)
	{
		var i:int;
		
		_divideCount = divideCount;
		
		_noise = new BitmapData(512, 10, true, 0);
		_noiseOffset = [new Point(), new Point()];
		_noiseSeed = int(Math.random() * 256);
	}
	
	public function getLength():Number
	{
		return _length;
	}
	
	public function getDividePoints():Array /*Point*/
	{
		return _dividePoints;
	}
	
	private function _updateNoise():void
	{
		_noiseOffset[0].x -= 3; //    æ??å??ã??ã?ªã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??
		_noiseOffset[1].x += 0;
		
		_noise.perlinNoise(30, //    x æ??å??ã??ä??ç??ã??ã??å??æ??æ??(å??)
			0, //    y æ??å??ã??ä??ç??ã??ã??å??æ??æ??(é??ã??)
			1, //    é??ã??ã??å??æ??ã??ã??ã??ã??ã??ã??ã??é??ã??
			_noiseSeed, //    é??å??ã?ªæ??æ??
			true, //    è??æ??ã??ã??ã??ã??ã??ã??ã?ªã??ã??å??è??ã?ªã??ã??ã?ºç??æ??ã??è??ã??ã??(ç??09å??æ??ã??ã??ã??ã??ã??ã??æ??ã??å??æ??ç??)
			false, //    ã??ã??ã??ã??ã??ã??ã??ã?ºã??æ??ç??ã??falseã??å??å??ã??ç??ã??æµ?ã??æ??ã??ã??ã??ã?ªè??è??å??æ??
			8, // (8 | 4 | 2 | 1),    //    ã??ã??ã?ºç??æ??ã??ã??ã??ã??ã??ã??
			false, //    ã??ã??ã??ã??ã??ã??ã??å??
			_noiseOffset //    ç??03å??æ??ã??æ?ºã??ã??å??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??Pointå??ã??é??å??ã??ã??ã??
		);
		
	}
	
	public function update(startPoint:Point, endPoint:Point, wavePower:Number, waveAngle:Number):void
	{
		var dx:Number = endPoint.x - startPoint.x;
		var dy:Number = endPoint.y - startPoint.y;
		
		//    ã??ã??ã??ã??é??ã??æ??æ??
		_length = Math.sqrt(dx * dx + dy * dy);
		
		//    å??å??ã??ã??æ??ã??ã??ã??ã??ã??æ??æ??
		_divideVec = new Point(dx, dy);
		_divideVec.normalize(_length / _divideCount);
		
		var normal:Point = new Point(dx / _length, dy / _length);
		//x' = x * cosÎ? - y * sinÎ?
		//y' = x * sinÎ? + y * cosÎ?
		_powerVec = new Point(normal.x * 0 - normal.y * 1, normal.x * 1 + normal.y * 0); // 90åº?å??è??
		
		//    ã??ã??ã?ºæ??æ??
		_updateNoise();
		
		_dividePoints = [];
		var waveAngleSin:Number = -Math.sin(waveAngle * Math.PI / 180);
		for (var i:int = 0; i <= _divideCount; i++)
		{
			var sweep:Number = Math.sin(Math.PI * (i / _divideCount)) * waveAngleSin;
			
			var flick:Number = _noise.getPixel32((i * 1) % 512, 1);
			
			var a:Number = (((flick >> 24) & 0xff) - 128);
			var power:Number = a * sweep * wavePower * 0.1;
			
			var px:Number = startPoint.x + _divideVec.x * i + _powerVec.x * power;
			var py:Number = startPoint.y + _divideVec.y * i + _powerVec.y * power;
			
			_dividePoints.push(new Point(px, py));
		}
		
		//    ã‚¢ãƒ«ãƒ•ã‚¡å€¤
		_alpha *= 0.05;
		_alpha += wavePower;
	}
	
}

/**
 * ...
 * @author okoi
 */
class SpectrumValueHistory
{
	private static const SIZE:int = 60; //    è¨˜éŒ²é‡
	private var _data:Vector.<Number>;
	private var _average:Number;
	private var _countConsecutiveOverAverage:int = 0;
	
	//-------------------------------------------
	//    getter / setter
	//-------------------------------------------
	public function get average():Number
	{
		return _average;
	}
	
	public function get countConsecutiveOverAverage():int
	{
		return _countConsecutiveOverAverage;
	}
	
	public function SpectrumValueHistory()
	{
		_data = new Vector.<Number>(SIZE, true);
		for (var i:int = 0; i < SIZE; i++)
			_data[i] = 0;
		
		_average = 0;
	}
	
	/**
	 * è¨˜éŒ²ã‚’è¿½åŠ ã™ã‚‹ã€å¤ã„ãƒ‡ãƒ¼ã‚¿ã¯å‰Šé™¤ã•ã‚Œã‚‹
	 * @param    value
	 */
	public function add(value:Number):void
	{
		var i:int;
		
		for (i = SIZE - 1; i > 0; i--)
		{
			_data[i] = _data[i - 1];
		}
		_data[0] = value;
		
		//    å¹³å‡å€¤è¨ˆç®—
		_average = 0;
		for (i = 0; i < SIZE; i++)
			_average += _data[i];
		_average = _average / SIZE;
		
		if (_data[0] > _average)
		{
			_countConsecutiveOverAverage += 1;
		}
		else
		{
			_countConsecutiveOverAverage = 0;
		}
	}
	
	/**
	 * æœ€æ–°ã®å€¤ã‚’å–å¾—ã™ã‚‹
	 */
	public function get latestValue():Number
	{
		return _data[0];
	}
	
	/**
	 * å±¥æ­´ã®å¹³å‡å€¤ã‚’å–å¾—ã™ã‚‹
	 */
	public function get averageValue():Number
	{
		var ret:Number = 0;
		for (var i:int = 0; i < SIZE; i++)
			ret += _data[i];
		return ret / SIZE;
	}
	
	/**
	 * å±¥æ­´ã®å‰åŠã¨å¾ŒåŠã‚’æ¯”ã¹ã¦ã€æ€¥æ¿€ã«å€¤ãŒå¢—åŠ ã—ã¦ã„ãŸã‚‰trueã‚’è¿”ã™
	 * @return
	 */
	public function isSteepUp():Boolean
	{
		var i:int;
		var first:Number = 0;
		var last:Number = 0;
		
		for (i = 0; i < SIZE / 2; i++)
		{
			first += _data[SIZE / 2 + i];
			last += _data[i];
		}
		first /= (SIZE / 2);
		last /= (SIZE / 2);
		
		return ((last / first) > 100);
	}
	
	/**
	 * æœ€æ–°ã®å€¤ãŒå¹³å‡å€¤ä»¥ä¸Šã‹ã©ã†ã‹ã‚’å–å¾—ã§ãã‚‹
	 * @return
	 */
	public function isLatestValueUpperAverage():Boolean
	{
		return (latestValue > averageValue);
	}
	
}

/**
 * ...
 * @author ...
 */
class SpectrumData
{
	private var _data:Array;
	private var _soundPosition:int;
	
	//------------------------------------------
	//    getter / setter
	//------------------------------------------
	public function get data():Array
	{
		return _data;
	}
	
	public function get soundPosition():int
	{
		return _soundPosition;
	}
	
	public function SpectrumData(data:Array, soundPosition:int)
	{
		_data = data;
		_soundPosition = soundPosition;
	}
	
}

/**
 * ...
 * @author ...
 */
class SpectrumFactorRecord
{
	private static const SIZE:int = 60;
	private var _record:Vector.<Number>;
	private var _average:Number;
	private var _latestSoundPosition:int;
	private var _countConsecutiveOverAverage:int = 0;
	
	//--------------------------------------------
	//    getter / setter
	//--------------------------------------------
	public function get average():Number
	{
		return _average;
	}
	
	public function get nowSoundPosition():int
	{
		return _latestSoundPosition;
	}
	
	public function get countConsecutiveOverAverage():int
	{
		return _countConsecutiveOverAverage;
	}
	
	//--------------------------------------------
	//--------------------------------------------
	
	public function SpectrumFactorRecord()
	{
		_record = new Vector.<Number>(SIZE, true);
		for (var i:int = 0; i < SIZE; i++)
			_record[i] = 0;
		
		_latestSoundPosition = 0;
	}
	
	/**
	 * è¨˜éŒ²ã‚’è¿½åŠ ã™ã‚‹ã€å¤ã„ãƒ‡ãƒ¼ã‚¿ã¯å‰Šé™¤ã•ã‚Œã‚‹
	 * @param    value
	 */
	public function addRecord(soundPosition:int, value:Number):void
	{
		var i:int;
		
		for (i = SIZE - 1; i > 0; i--)
		{
			_record[i] = _record[i - 1];
		}
		_record[0] = value;
		
		_latestSoundPosition = soundPosition;
		
		//    å¹³å‡å€¤è¨ˆç®—
		_average = 0;
		for (i = 0; i < SIZE; i++)
			_average += _record[i];
		_average = _average / SIZE;
		
		if (_record[0] > _average)
		{
			_countConsecutiveOverAverage += 1;
		}
		else
		{
			_countConsecutiveOverAverage = 0;
		}
		
	}
	
	/**
	 * æœ€æ–°ã®è¨˜éŒ²ã‚’å–å¾—
	 * @return {Number}
	 */
	public function getLatestValue():Number
	{
		return _record[0];
	}
	
	/**
	 * æœ€æ–°ã®å€¤ãŒå¹³å‡å€¤ä»¥ä¸Šã‹ã©ã†ã‹ã‚’å–å¾—ã§ãã‚‹
	 * @return
	 */
	public function isLatestValueUpperAverage():Boolean
	{
		return (getLatestValue() > _average);
	}
	
}

