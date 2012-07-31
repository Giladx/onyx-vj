/**
 * Copyright Aquioux ( http://wonderfl.net/user/Aquioux )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/wPwm
 */

package plugins.filters {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class KugatFilter extends Filter implements IBitmapFilter {
	/**
	 * Pixelate by BitmapData#fillRect
	 * Practice of strategy pattern
	 * @author Aquioux(Yoshida, Akio)
	 * @see http://aquioux.net/blog/?p=2617
	 * Picture ã??å??ç??ç??æ??ã??è??æ??ã??ã??http://www.ashinari.com/
	 */

		private const DEGREE:int = 5;        // æ??è??ã??æ?µé??æ??
		
		private const INTERVAL:int = 9;                // ã??ã??ã??ã??é??é??
		private const COLOR_SHIFT:Number = 0.075;    // è??ç?ºè??ã??å??å??å??

		private const FILL_COLOR:uint = 0x00000000;
		
		private var canvas_:BitmapData;
		private var sourceBmd:BitmapData = new BitmapData(52, 70);
		
		private var drawer_:Drawer;
		private var _type:String	= 'Horizontal';
		
		private var data_:Vector.<uint>;
		
		// BitmapData.rect
		private var sourceRect_:Rectangle;
		

		public function KugatFilter() {
			
			parameters.addParameters(
				new ParameterArray('type', 'type', ['Horizontal', 'Vertical', 'Alter 1', 'Alter 2', 'Square'], _type)
			);
			_type		= 'Horizontal';
			canvas_ =new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, FILL_COLOR);
			
			Pixelation.degree = DEGREE;

			drawer_ = new Drawer();
			drawer_.interval   = INTERVAL;
			drawer_.colorShift = COLOR_SHIFT;
			
			select(_type);
		}
		private function select(name:String):void {
			switch (name)
			{
				case "Horizontal":
					drawer_.behavior = new BehaviorHorizontal();
				break;
				case "Vertical":
					drawer_.behavior = new BehaviorVertical();
				break;
				case "Alter 1":
					drawer_.behavior = new BehaviorAlter1();
				break;
				case "Alter 2":
					drawer_.behavior = new BehaviorAlter2();
				break;
				case "Square":
					drawer_.behavior = new BehaviorSquare();
				break;
			}
			
		}
		public function applyFilter(source:BitmapData):void {
			
			sourceRect_ = sourceBmd.rect;
			sourceBmd.draw(source, new Matrix(52/DISPLAY_WIDTH, 0, 0, 70/DISPLAY_HEIGHT));
			data_ = Pixelation.pixelate(sourceBmd.clone());
			drawer_.draw(data_, canvas_, sourceRect_);
			source.draw(canvas_);
		}
		override public function dispose():void {
			
		}		
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
			select(_type);
		}
	}
}

import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;
/**
 * @author YOSHIDA, Akio (Aquioux)
 */
class Pixelation {
	/**
	 * æ??è??ã??æ?µé??æ??
	 */
	static public function set degree(value:int):void { _degree = value; }
	static private var _degree:int = 5;
	
	/**
	 * ã??ã??ã??ã??ã??å??è??
	 */
	static public function set invert(value:Boolean):void { _invert = value; }
	static private var _invert:Boolean = false;
	
	
	/**
	 * æ?µé??å??å??å??
	 * @param    bmd    å??å?? BitmapData
	 * @return    ã??ã??ã??ã??å?? pixel ã??æ?µé??å??ã??æ??ç??ã??ã??é??å??
	 */
	static public function pixelate(bmd:BitmapData):Vector.<uint> {
		// ã??ã??ã??ã??æ??ä??ã??ã??ã??ã??ã??ç??æ??ã??å??å?? BitmapData ã??ã??é??ç??
		// å??æ??å??
		var smooth:Smooth = new Smooth();
		smooth.strength = 1;
		smooth.quality = BitmapFilterQuality.HIGH;
		smooth.applyEffect(bmd);
		// ã??ã??ã??ã??ã??ã??ã??
		new GrayScale().applyEffect(bmd);
		// æ??è??
		var posterize:Posterize = new Posterize();
		posterize.degree = _degree + 1;
		posterize.applyEffect(bmd);
		
		// bmd.getVector
		var pixelVector:Vector.<uint> = bmd.getVector(bmd.rect);
		pixelVector.fixed = true;
		
		// æ??è??ã??æ?µé??å??ã??è??ç??
		var val:Number = 0xFF / _degree;
		var len:uint   = pixelVector.length;
		var data:Vector.<uint>  = new Vector.<uint>();
		for (var i:int = 0; i < len; i++) {
			var result:Number = (pixelVector[i] & 0xFF) / val;
			if (result != int(result)) int(result + 1);
			data.push(_invert ? result : _degree - result);
		}
		data.fixed = true;
		return data;
	}
}


import flash.display.BitmapData;
import flash.geom.Rectangle;
/**
 * Pixelation ã??å??ã??ã??ã??ã??ã??ã??ã??æ??ç??
 * @author YOSHIDA, Akio (Aquioux)
 */
class Drawer {
	/**
	 * ã??ã??ã??ã??é??é??
	 */
	public function set interval(value:uint):void { _interval = value; }
	private var _interval:int = 5;
	
	/**
	 * è??ç?ºè??ã??å??å??å??
	 */
	public function set colorShift(value:Number):void { _colorShift = value; }
	private var _colorShift:Number = 0.1;
	
	/**
	 * æ??ç??ã?µã??ã??ã??ã??ã??ã??
	 */
	public function set behavior(value:IBehavior):void { _behavior = value; }
	private var _behavior:IBehavior;
	
	
	/**
	 * ã??ã??ã??ã??ã??ã??ã??
	 */
	public function Drawer() {
		_behavior = new BehaviorSquare();
	}
	
	/**
	 * æ??ç??
	 * @param    data    è??ç?ºã??ã??ã??ã??ã??ã??ã??
	 * @param    canvas    è??ç?ºã??ã??ã??ã??
	 * @param    rect    è??ç?ºé??å??
	 */
	public function draw(data:Vector.<uint>, canvas:BitmapData, rect:Rectangle):void {
		var width:uint   = rect.width;
		var angle:Number = Math.random() * 360;
		var len:uint     = data.length;
		canvas.lock();
		for (var i:int = 0; i < len; i++) {
			var currentDegree:int = data[i] * 2 - 1;
			if (currentDegree < 0) currentDegree = 0;
			var posX:int =  i % width;
			var posY:int = (i / width) >> 0;
			if (currentDegree > 0) canvas.fillRect(_behavior.execute(currentDegree, posX, posY, _interval), CycleRGB.getColor(angle));
			angle += _colorShift;
		}
		canvas.unlock();
	}
}

import flash.geom.Rectangle;
/**
 * æ??ç??ã?µã??ã??ã??ã??ã??ã??ã?? interface
 * @author YOSHIDA, Akio (Aquioux)
 */
interface IBehavior {
	/**
	 * ã?µã??ã??ã??ã??å??è??ï??æ??ç??ã??ã??ã??ã?? Rectangle ã??ç??æ??ï??
	 * @param    degree    æ?µé??
	 * @param    posX    é??å??Xåº?æ??
	 * @param    posY    é??å??Yåº?æ??
	 * @param    interval    ã??ã??ã??ã??é??é??
	 * @return    æ??ç??ã??ã??ã??ã?? Rectangle
	 */
	function execute(degree:int, posX:int, posY:int, interval:int):Rectangle;
}

import flash.geom.Rectangle;
/**
 * æ??ç??ã?µã??ã??ã??ã??ã??ã??ï??æ??å??ï??
 * @author YOSHIDA, Akio (Aquioux)
 */
 class BehaviorHorizontal implements IBehavior {
	/**
	 * ã?µã??ã??ã??ã??å??è??ï??æ??ç??ã??ã??ã??ã?? Rectangle ã??ç??æ??ï??
	 * @param    degree    æ?µé??
	 * @param    posX    é??å??Xåº?æ??
	 * @param    posY    é??å??Yåº?æ??
	 * @param    interval    ã??ã??ã??ã??é??é??
	 * @return    æ??ç??ã??ã??ã??ã?? Rectangle
	 */
	public function execute(degree:int, posX:int, posY:int, interval:int):Rectangle {
		var shiftX:int = 0;
		var shiftY:int = (interval - degree) / 2;
		var rect:Rectangle = new Rectangle();
		rect.x = posX * interval + shiftX;
		rect.y = posY * interval + shiftY;
		rect.width  = interval;
		rect.height = degree;
		return rect;
	}
}

import flash.geom.Rectangle;
/**
 * æ??ç??ã?µã??ã??ã??ã??ã??ã??ï??å??ç??ï??
 * @author YOSHIDA, Akio (Aquioux)
 */
class BehaviorVertical implements IBehavior {
	/**
	 * ã?µã??ã??ã??ã??å??è??ï??æ??ç??ã??ã??ã??ã?? Rectangle ã??ç??æ??ï??
	 * @param    degree    æ?µé??
	 * @param    posX    é??å??Xåº?æ??
	 * @param    posY    é??å??Yåº?æ??
	 * @param    interval    ã??ã??ã??ã??é??é??
	 * @return    æ??ç??ã??ã??ã??ã?? Rectangle
	 */
	public function execute(degree:int, posX:int, posY:int, interval:int):Rectangle {
		var shiftX:int = (interval - degree) / 2;
		var shiftY:int = 0;
		var rect:Rectangle = new Rectangle();
		rect.x = posX * interval + shiftX;
		rect.y = posY * interval + shiftY;
		rect.width  = degree;
		rect.height = interval;
		return rect;
	}
}

import flash.geom.Rectangle;
/**
 * æ??ç??ã?µã??ã??ã??ã??ã??ã??ï??æ??å??ã??å??ç??ã??äº?äº?ï??
 * @author YOSHIDA, Akio (Aquioux)
 */
class BehaviorAlter1 implements IBehavior {
	/**
	 * ã?µã??ã??ã??ã??å??è??ï??æ??ç??ã??ã??ã??ã?? Rectangle ã??ç??æ??ï??
	 * @param    degree    æ?µé??
	 * @param    posX    é??å??Xåº?æ??
	 * @param    posY    é??å??Yåº?æ??
	 * @param    interval    ã??ã??ã??ã??é??é??
	 * @return    æ??ç??ã??ã??ã??ã?? Rectangle
	 */
	public function execute(degree:int, posX:int, posY:int, interval:int):Rectangle {
		var shiftX:int;
		var shiftY:int;
		var rect:Rectangle = new Rectangle();
		if (posX % 2) {
			// same BehaviorHorizontal
			shiftX = 0;
			shiftY = (interval - degree) / 2;
			rect.width  = interval;
			rect.height = degree;
		} else {
			// same BehaviorVertical
			shiftX = (interval - degree) / 2;
			shiftY = 0;
			rect.width  = degree;
			rect.height = interval;
		}
		rect.x = posX * interval + shiftX;
		rect.y = posY * interval + shiftY;
		return rect;
	}
}

import flash.geom.Rectangle;
/**
 * æ??ç??ã?µã??ã??ã??ã??ã??ã??ï??æ??å??ã??å??ç??ã??äº?äº?ï??
 * @author YOSHIDA, Akio (Aquioux)
 */
class BehaviorAlter2 implements IBehavior {
	/**
	 * ã?µã??ã??ã??ã??å??è??ï??æ??ç??ã??ã??ã??ã?? Rectangle ã??ç??æ??ï??
	 * @param    degree    æ?µé??
	 * @param    posX    é??å??Xåº?æ??
	 * @param    posY    é??å??Yåº?æ??
	 * @param    interval    ã??ã??ã??ã??é??é??
	 * @return    æ??ç??ã??ã??ã??ã?? Rectangle
	 */
	public function execute(degree:int, posX:int, posY:int, interval:int):Rectangle {
		var shiftX:int;
		var shiftY:int;
		var rect:Rectangle = new Rectangle();
		if ((posX % 2 + posY % 2) % 2) {
			// same BehaviorHorizontal
			shiftX = 0;
			shiftY = (interval - degree) / 2;
			rect.width  = interval;
			rect.height = degree;
		} else {
			// same BehaviorVertical
			shiftX = (interval - degree) / 2;
			shiftY = 0;
			rect.width  = degree;
			rect.height = interval;
		}
		rect.x = posX * interval + shiftX;
		rect.y = posY * interval + shiftY;
		return rect;
	}
}

import flash.geom.Rectangle;
/**
 * æ??ç??ã?µã??ã??ã??ã??ã??ã??ï??æ??æ??å??ï??
 * @author YOSHIDA, Akio (Aquioux)
 */
class BehaviorSquare implements IBehavior {
	/**
	 * ã?µã??ã??ã??ã??å??è??ï??æ??ç??ã??ã??ã??ã?? Rectangle ã??ç??æ??ï??
	 * @param    degree    æ?µé??
	 * @param    posX    é??å??Xåº?æ??
	 * @param    posY    é??å??Yåº?æ??
	 * @param    interval    ã??ã??ã??ã??é??é??
	 * @return    æ??ç??ã??ã??ã??ã?? Rectangle
	 */
	public function execute(degree:int, posX:int, posY:int, interval:int):Rectangle {
		var shiftX:int = (interval - degree) / 2;
		var shiftY:int = (interval - degree) / 2;
		var rect:Rectangle = new Rectangle();
		rect.x = posX * interval + shiftX;
		rect.y = posY * interval + shiftY;
		rect.width  = degree;
		rect.height = degree;
		return rect;
	}
}

import flash.display.BitmapData;
/**
 * BitmapDataEffector ç?? interface
 * @author YOSHIDA, Akio (Aquioux)
 */
interface IEffector {
	function applyEffect(value:BitmapData):BitmapData;
}

import flash.display.BitmapData;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
/**
 * ColorMatrixFilter ã??ã??ã?? BitmapData ã??ã??ã??ã??ã??ã??ã??ã??å??ï??NTSC ç??å??é??å??å??ã??ã??ã??ï??
 * å??è??ï??Foundation ActionScript 3.0 Image Effects(P106)
 *         http://www.amazon.co.jp/gp/product/1430218711?ie=UTF8&tag=laxcomplex-22
 * @author YOSHIDA, Akio (Aquioux)
 */
class GrayScale implements IEffector {
	private const R:Number = EffectorUtils.LUM_R;
	private const G:Number = EffectorUtils.LUM_G;
	private const B:Number = EffectorUtils.LUM_B;
	
	private const MATRIX:Array = [
		R, G, B, 0, 0,
		R, G, B, 0, 0,
		R, G, B, 0, 0,
		0, 0, 0, 1, 0
	];
	private const FILTER:ColorMatrixFilter = new ColorMatrixFilter(MATRIX);
	
	private const ZERO_POINT:Point = EffectorUtils.ZERO_POINT;
	
	public function applyEffect(value:BitmapData):BitmapData {
		value.applyFilter(value, value.rect, ZERO_POINT, FILTER);
		return value;
	}
}

import flash.display.BitmapData;
import flash.geom.Point;
/**
 * paletteMap ã??ã??ã?? BitmapData ã??æ??è??
 * ã??å??è?µç??å??å??ç??å??é??ã?? å??é??é??ã??å??æ??å??ä??ã??ä??ç??å??ã??P16ã??ã??2.5 æ??åº?å??ã??é??å??å??ã??ã??ã??æ??è??å??ç??ã??
 * @author YOSHIDA, Akio (Aquioux)
 */
class Posterize implements IEffector {
	
	public function set degree(value:uint):void {
		// value ã??æ??å??ç??å??ã?? 2 ï?? 256
		if (value <   2) value =   2;
		if (value > 256) value = 256;
		
		if (_gradation) {
			_gradation.fixed = false;
			_gradation.length = 0;
		} else {
			_gradation = new Vector.<uint>();
		}
		
		var prevVal:uint = 0xFF;
		for (var i:int = 0; i < 256; i++) {
			var val:uint = uint(i / (256 / value)) * 255 / (value - 1);
			rArray_[i] = val << 16;
			gArray_[i] = val <<  8;
			bArray_[i] = val;
			
			if (prevVal != val) {
				_gradation.push(val);
				prevVal = val;
			}
		}
		_gradation.fixed = true;
	}

	public function get gradation():Vector.<uint> { return _gradation; }
	private var _gradation:Vector.<uint>;
	

	private var rArray_:Array = [];
	private var gArray_:Array = [];
	private var bArray_:Array = [];
	
	private const ZERO_POINT:Point = EffectorUtils.ZERO_POINT;

	public function Posterize() {
		degree = 8;    // degree ã??ã??ã??ã??ã??ã??
	}

	public function applyEffect(value:BitmapData):BitmapData {
		value.paletteMap(value, value.rect, ZERO_POINT, rArray_, gArray_, bArray_);
		return value;
	}
}

import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.geom.Point;
/**
 * BlurFilter ã??ã??ã??å??æ??å??
 * @author YOSHIDA, Akio (Aquioux)
 */
class Smooth implements IEffector {

	public function set strength(value:Number):void {
		filter_.blurX = filter_.blurY = value;
	}

	public function set quality(value:int):void {
		filter_.quality = value;
	}
	

	private var filter_:BlurFilter;
	
	private const ZERO_POINT:Point = EffectorUtils.ZERO_POINT;

	public function Smooth() {
		filter_ = new BlurFilter(2, 2, BitmapFilterQuality.MEDIUM);
	}

	public function applyEffect(value:BitmapData):BitmapData {
		value.applyFilter(value, value.rect, ZERO_POINT, filter_);
		return value;
	}
}


import flash.geom.Point;
/**
 * bitmapDataEffector ã??ã??ã??ã??ã??å??ã??ã??ã??ã??ã??å??é??ã??ä??ã??å??æ??ã?ªã??
 * @author YOSHIDA, Akio (Aquioux)
 */
class EffectorUtils {
	static public const ZERO_POINT:Point = new Point(0, 0);

	static public const LUM_R:Number = 0.298912;
	static public const LUM_G:Number = 0.586611;
	static public const LUM_B:Number = 0.114478;
}




/**
 * @author Aquioux(YOSHIDA, Akio)
 */
class CycleRGB {
	/**
	 * 32bit ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??å??ï??0ï??255ï??
	 */
	static public function get alpha():uint { return _alpha; }
	static public function set alpha(value:uint):void {
		_alpha = (value > 0xFF) ? 0xFF : value;
	}
	private static var _alpha:uint = 0xFF;
	
	private static const PI:Number = Math.PI;        // å??å??ç??
	private static const DEGREE120:Number  = PI * 2 / 3;    // 120åº?ï??å??åº?æ??å??å??ï??
	
	/**
	 * è??åº?ã??å??ã??ã?? RGB ã??å??ã??
	 * @param    angle    HSV ã??ã??ã??ã??è??åº?ï??åº?æ??æ??ï??ã??æ??å??
	 * @return    è??ï??0xNNNNNNï??
	 */
	public static function getColor(angle:Number):uint {
		var radian:Number = angle * PI / 180;
		var r:uint = (Math.cos(radian)             + 1) * 0xFF >> 1;
		var g:uint = (Math.cos(radian + DEGREE120) + 1) * 0xFF >> 1;
		var b:uint = (Math.cos(radian - DEGREE120) + 1) * 0xFF >> 1;
		return r << 16 | g << 8 | b;
	}
	
	/**
	 * è??åº?ã??å??ã??ã?? RGB ã??å??ã??ï??32bit ã??ã??ã??ï??
	 * @param    angle    HSV ã??ã??ã??ã??è??åº?ï??åº?æ??æ??ï??ã??æ??å??
	 * @return    è??ï??0xNNNNNNNNï??
	 */
	public static function getColor32(angle:Number):uint {
		return _alpha << 24 | getColor(angle);
	}
}

