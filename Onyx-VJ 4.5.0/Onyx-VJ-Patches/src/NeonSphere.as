/**
 * Copyright Aquioux ( http://wonderfl.net/user/Aquioux )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/hGTP
 */

package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * Neon Sphere
	 * @author YOSHIDA, Akio(Aquioux)
	 */
	public class NeonSphere extends Patch {
		private var viewer_:Viewer;        // ã??ã??ã??ã??
		
		public function NeonSphere() {
			
			var longitude:int = 36;
			var latitude:int  = longitude * 2;
			
			// åº?æ??ã??ã??ã??ç??æ??ã??ã??ã??å??æ??å??
			CreateData.setup(longitude, latitude, 150);
			
			// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??å??æ??å??
			Projection.offsetX = DISPLAY_WIDTH / 2;
			Projection.offsetY = DISPLAY_HEIGHT / 2;
			Projection.offsetZ = 500;
			Projection.longitude = longitude;
			Projection.latitude  = latitude;
			Projection.setup(CreateData.data);
			
			// ã??ã??ã??æ??å??ã??ã??ã??å??æ??å??
			MouseBehavior.setup(this);
			
			// ã??ã??ã??ã??ã??ä??æ??
			viewer_ = new Viewer(DISPLAY_WIDTH, DISPLAY_HEIGHT);
			viewer_.buttonMode = true;
			addChild(viewer_);
			
		}
		
		// ã??ã??ã??ã??ã??ã??
		override public function render(info:RenderInfo):void  {
			MouseBehavior.update();
			viewer_.update(Projection.update(MouseBehavior.moveX, MouseBehavior.moveY));
			info.render(viewer_);
		}
	}
}

//package {
/**
 * åº?æ??ã??ã??ã??ç??æ??ã??ã??ã??
 * @author YOSHIDA, Akio(Aquioux)
 */
/*public*/ class CreateData {
	/**
	 * åº?æ??ã??ã??ã?? Vector
	 */ 
	static public function get data():Vector.<Number> { return _data; }
	static private var _data:Vector.<Number>;
	
	/**
	 * ã??ã??ã??ã??ã??ã??
	 */
	static public function setup(longitude:int, latitude:int, scale:int):void {
		_data = new Vector.<Number>();
		var xRadian:Number = Math.PI * 2 / longitude;
		latitude++;    // æ?µç??ã??ç??ã??ã??ã??
		var yRadian:Number = Math.PI     / latitude;
		for (var y:int = 1; y < latitude; y++) {
			for (var x:int = 0; x < longitude; x++) {
				var px:Number = scale * Math.sin(yRadian * y) * Math.cos(xRadian * x);
				var py:Number = scale * Math.cos(yRadian * y);
				var pz:Number = scale * Math.sin(yRadian * y) * Math.sin(xRadian * x);
				_data.push(px, py, pz);
			}
		}
		_data.fixed = true;
	}
}
//}

//package {
//import aquioux.display.colorUtil.CycleRGB;
import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import flash.geom.Utils3D;
import flash.geom.Vector3D;
/**
 * ä??æ??å??åº?æ??ã??äº?æ??å??åº?æ??ã??æ??å??ã??ã??
 * @author YOSHIDA, Akio(Aquioux)
 */
/*public*/ class Projection {
	/**
	 * Xåº?æ??ã?ªã??ã??ã??ã??å??
	 */
	static public function get offsetX():Number { return _offsetX; }
	static public function set offsetX(value:Number):void { _offsetX = value; }
	static private var _offsetX:Number = 0;
	/**
	 * Yåº?æ??ã?ªã??ã??ã??ã??å??
	 */
	static public function get offsetY():Number { return _offsetY; }
	static public function set offsetY(value:Number):void { _offsetY = value; }
	static private var _offsetY:Number = 0;
	/**
	 * Zåº?æ??ã?ªã??ã??ã??ã??å??
	 */
	static public function get offsetZ():Number { return _offsetZ; }
	static public function set offsetZ(value:Number):void {
		_offsetZ = value;
		zLevel_  = 1 / value;
	}
	static private var _offsetZ:Number = 500;
	
	/**
	 * çµ?åº?æ??å??å??å??æ??
	 */
	static public function get longitude():int { return _longitude; }
	static public function set longitude(value:int):void {
		_longitude = value;
		//colorOffset_ = 360 / (value + 1);
	}
	static private var _longitude:int;
	
	/**
	 * çµ?åº?æ??å??å??å??æ??
	 */
	static public function get latitude():int { return _latitude; }
	static public function set latitude(value:int):void {
		_latitude = value;
		colorOffset_ = 360 / (value + 2);
	}
	static private var _latitude:int;
	
	
	// åº?æ?? Vecotr
	static private var verts_:Vector.<Number>;            // ä??æ??å??åº?æ??
	static private var projectedVerts_:Vector.<Number>;    // äº?æ??å??æ??å??å??
	static private var uvts_:Vector.<Number>;            // uvts
	static private var data_:Vector.<Number>;            // #update ã??è??å??
	// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??
	static private var projection_:PerspectiveProjection;
	static private var projectionMatrix3D_:Matrix3D;
	// å??è??è??ç??ç??ã??ã??ã?ªã??ã??
	static private var matrix_:Matrix3D;
	
	// ç??å??é??ä??æ??
	static private var vx_:Number = 0;
	static private var vy_:Number = 0;
	
	// è??é??é??
	static private var colorOffset_:Number = 360 / (_longitude + 1);
	static private var colorShift_:int = 0;
	
	// zåº?æ??é??é??
	static private var zLevel_:Number = 1 / _offsetZ;
	
	
	/**
	 * ã??ã??ã??ã??ã??ã??
	 * @param    data    ä??æ??å??åº?æ??ã??ã??ã??
	 */
	static public function setup(verts:Vector.<Number>):void {
		// åº?æ?? Vecotr
		verts_ = verts;
		var n:uint = verts_.length;
		projectedVerts_ = new Vector.<Number>(n * 2 / 3, true);
		uvts_ = new Vector.<Number>(n, true);
		data_ = new Vector.<Number>(n, true);
		
		// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??
		projection_ = new PerspectiveProjection();
		projectionMatrix3D_ = projection_.toMatrix3D();
		
		// å??è??è??ç??ç??ã??ã??ã?ªã??ã??
		matrix_ = new Matrix3D();
	}
	
	/**
	 * ã??ã??ã??ã??ã??ã??
	 * @param    moveX    ç??å??é??ï??Xè??æ??å??ï??
	 * @param    moveY    ç??å??é??ï??Yè??æ??å??ï??
	 * @return    ä??æ??å??åº?æ??ã??æ??å??ã??ã??äº?æ??å??åº?æ??ã??ã??ã??
	 */
	static public function update(moveX:Number, moveY:Number):Vector.<Number> {
		// å??é??ã??ã??ã??ç??å??é?? moveXã??moveY ã??å??é??ã??ç??å??é??å??æ?? vx_ã??vy_ ã??å??ç??
		vx_ -= moveX;
		vy_ += moveY;
		
		// ã??ã??ã?ªã??ã??è??ç??
		matrix_.identity();
		matrix_.appendRotation(vy_, Vector3D.X_AXIS);
		matrix_.appendRotation(vx_, Vector3D.Y_AXIS);
		matrix_.appendTranslation(0, 0, _offsetZ);
		matrix_.append(projectionMatrix3D_);
		
		// åº?æ??ã??ã??ã??ã??å??è??ã??é??ç??
		Utils3D.projectVectors(matrix_, verts_, projectedVerts_, uvts_);
		
		// sort
		var array:Array = [];
		var currentLongitude:int = 0;
		var currentLatitude:int  = 0;
		var len:int = projectedVerts_.length / 2;
		for (var i:int = 0; i < len; i++) {
			var vertex:Vertex = new Vertex();
			vertex.x = projectedVerts_[i * 2]     + _offsetX;
			vertex.y = projectedVerts_[i * 2 + 1] + _offsetY;
			vertex.z = uvts_[i * 3 + 2];
			vertex.longitude = currentLongitude;
			vertex.latitude  = currentLatitude;
			array[i] = vertex;
			currentLongitude++;
			currentLongitude %= _longitude;
			if (currentLongitude == 0) currentLatitude++;
		}
		array.sortOn("z", Array.NUMERIC);
		
		// è¿”å€¤ç”Ÿæˆ
		data_.fixed = false;
		data_.length = 0;
		colorShift_ += 5;
		len = i;
		for (i = 0; i < len; i++) {
			vertex = array[i];
			var alpha:uint = vertex.z < zLevel_ ? 0x33 : 0xFF;
			//var c:uint = CycleRGB.getColor(vertex.longitude * colorOffset_ + colorShift_);
			var c:uint = CycleRGB.getColor(vertex.latitude * colorOffset_ +colorShift_);
			var color:uint = alpha << 24 | c;
			data_.push(vertex.x, vertex.y, Number(color));
		}
		data_.fixed = true;
		
		return data_;
	}
}
//}

//package {
import flash.display.DisplayObject;
import flash.events.MouseEvent;
/**
 * ãƒ“ãƒ¥ãƒ¼ã‚¢
 * @author YOSHIDA, Akio(Aquioux)
 */
/*public*/ class MouseBehavior {
	// MOUSW_MOVE ã«ã‚ˆã‚‹ç§»å‹•é‡
	static public function get moveX():Number { return _moveX; }
	static private var _moveX:Number = 0;
	
	static public function get moveY():Number { return _moveY; }
	static private var _moveY:Number = 0;
	
	
	// å‰å›žã® MOUSW_MOVE æ™‚ã®ãƒžã‚¦ã‚¹åº§æ¨™
	static private var prevMouseX_:Number = 0;
	static private var prevMouseY_:Number = 0;
	
	// ãƒžã‚¦ã‚¹ã‚’ãƒ€ã‚¦ãƒ³ã—ã¦ã„ã‚‹ã‹å¦ã‹
	static private var isMouseDown_:Boolean = false;
	
	// æ‘©æ“¦ä¿‚æ•°
	static private var friction_:Number = 0.98;
	
	// ãƒžã‚¦ã‚¹ã‚¤ãƒ™ãƒ³ãƒˆã‚’ addEvent ã™ã‚‹å¯¾è±¡
	static private var target_:DisplayObject;
	
	
	/**
	 * ã‚»ãƒƒãƒˆã‚¢ãƒƒãƒ—
	 */
	static public function setup(target:DisplayObject):void {
		target_ = target;
		target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		target.addEventListener(MouseEvent.MOUSE_UP,   mouseUpHandler);
		target.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	// ãƒžã‚¦ã‚¹ãƒãƒ³ãƒ‰ãƒ©
	static private function mouseDownHandler(e:MouseEvent):void {
		isMouseDown_ = true;
	}
	static private function mouseUpHandler(e:MouseEvent):void {
		isMouseDown_ = false;
	}
	static private function mouseMoveHandler(e:MouseEvent):void {
		if (!isMouseDown_) {
			prevMouseX_ = target_.mouseX;
			prevMouseY_ = target_.mouseY;
		}
	}
	
	/**
	 * ã‚¢ãƒƒãƒ—ãƒ‡ãƒ¼ãƒˆ
	 */
	static public function update():void {
		if (isMouseDown_) {
			_moveX = target_.mouseX - prevMouseX_;
			_moveY = target_.mouseY - prevMouseY_;
			prevMouseX_ = target_.mouseX;
			prevMouseY_ = target_.mouseY;
		} else {
			_moveX *= friction_;
			_moveY *= friction_;
		}
	}
}
//}

//package {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
/**
 * ãƒ“ãƒ¥ãƒ¼ã‚¢
 * @author YOSHIDA, Akio(Aquioux)
 */
/*public*/ class Viewer extends Sprite {
	//ãƒ•ã‚§ãƒ¼ãƒ‰ã‚¢ã‚¦ãƒˆã®ãŸã‚ã®å®šç¾©
	private const FADE:ColorTransform = new ColorTransform(0.999, 0.999, 0.999);
	private const BLUR:BlurFilter     = new BlurFilter(4, 4, BitmapFilterQuality.HIGH);
	
	// BitmapData é–¢é€£
	private var bmd_:BitmapData;            // è¡¨ç¤º BitmapData
	private var bufferBmd_:BitmapData;        // ãƒãƒƒãƒ•ã‚¡
	private var rect_:Rectangle;            // ColorTransform, Blur å??ç??
	private const ZERO_POINT:Point = new Point(0, 0);
	
	private var start_:int = 0;
	
	
	/**
	 * ã??ã??ã??ã??ã??ã??ã??
	 * @param    sw    ã??ã??ã??ã??å??
	 * @param    sh    ã??ã??ã??ã??é??
	 */
	public function Viewer(sw:int, sh:int) {
		// BitmapData é??é??
		bufferBmd_ = new BitmapData(sw, sh, true, 0xFF000000);
		bmd_  = bufferBmd_.clone();
		rect_ = bmd_.rect;
		addChild(new Bitmap(bmd_));
	}
	
	/**
	 * ã??ã??ã??ã??ã??ã??
	 * @param    data    æ??ç??åº?æ??ã??ã??ã??
	 */
	public function update(data:Vector.<Number>):void {
		// bufferBmd_ ã??æ??æ??
		bufferBmd_.lock();
		bufferBmd_.fillRect(bufferBmd_.rect, 0x00000000);
		
		var len:uint = data.length;
		for (var i:int = 0; i < len; i += 3) {
			var px:int    = data[i]     >> 0;
			var py:int    = data[i + 1] >> 0;
			var color:int = data[i + 2] >> 0;
			bufferBmd_.setPixel32(px, py, color);
		}
		bufferBmd_.unlock();
		
		// bmd_ ã??æ??æ??
		bmd_.lock();
		bmd_.colorTransform(rect_, FADE);
		bmd_.applyFilter(bmd_, rect_, ZERO_POINT, BLUR);
		bmd_.draw(bufferBmd_);
		bmd_.unlock();
	}
}
//}

//package {
/**
 * åº?æ??
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/ class Vertex {
	// Xåº?æ??å??
	public function get x():Number { return _x; }
	public function set x(value:Number):void { _x = value; }
	private var _x:Number;
	// Yåº?æ??å??
	public function get y():Number { return _y; }
	public function set y(value:Number):void { _y = value; }
	private var _y:Number;
	// Zåº?æ??å??
	public function get z():Number { return _z; }
	public function set z(value:Number):void { _z = value; }
	private var _z:Number;
	// çµ?åº?ä??ã??ä??ç??
	public function get longitude():int { return _longitude; }
	public function set longitude(value:int):void { _longitude = value; }
	private var _longitude:int;
	// ç??åº?ä??ã??ä??ç??
	public function get latitude():int { return _latitude; }
	public function set latitude(value:int):void { _latitude = value; }
	private var _latitude:int;
	
	public function Vertex() { }
}
//}

//package aquioux.display.colorUtil {
/**
 * ã??ã?µã??ã??ã??ã??ã??ã??è??ç??ç??ç??ã?ª RGB ã??è??ç??
 * @author Aquioux(YOSHIDA, Akio)
 */
/*public*/ class CycleRGB {
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
//}
