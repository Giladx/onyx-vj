/**
 * Copyright Saqoosha ( http://wonderfl.net/user/Saqoosha )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/c6fs
 */

// write as3 code here..
package {
	
	import EmbeddedAssets.AssetForBallSphere;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import frocessing.color.ColorHSV;
	import frocessing.color.ColorRGB;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Rainbow extends Patch {
		
		private static const ZERO_POINT:Point = new Point(0, 0);
		
		private static const NUM_OBJECTS:int = 16;
		private static const FORCE:Number = 500.0;
		private static const COLOR_SPEED:Number = 0.05;
		
		private var _center:Sprite;
		private var _images:Array;
		private var _tmp:BitmapData;
		
		private var _mousePressed:Boolean = false;
		private var _prevTime:int = 0;
		private var _colorOffset:Number = 0;
		private var _mousePt:Point = new Point();
		private var mx:int = 320;
		private var my:int = 240;
		
		public function Rainbow() {
			
			var original:BitmapData = new AssetForBallSphere;
			
			_center = new Sprite();
			_center.x = DISPLAY_WIDTH / 2;
			_center.y = DISPLAY_HEIGHT / 2;
			
			var rs:Number = 0, gs:Number = 0, bs:Number = 0;
			var i:int;
			var c:ColorRGB;
			for (i = 0; i < NUM_OBJECTS; i++) {
				c = new ColorHSV(i / NUM_OBJECTS * 360, 1, 1).toRGB();
				rs += c.r;
				gs += c.g;
				bs += c.b;
			}
			
			_images = [];
			for (i = 0; i < NUM_OBJECTS; i++) {
				var a:Number = Math.PI * 2 * i / NUM_OBJECTS;
				c = new ColorHSV(i / NUM_OBJECTS * 360, 1, 1).toRGB();
				var img:ColoredImage = _center.addChild(new ColoredImage(original, c.r / rs, c.g / gs, c.b / bs)) as ColoredImage;
				var px:Number = Math.cos(a) * 30;
				var py:Number = Math.sin(a) * 30;  
				img.init(px, py);
				_images.push(img);
			}
	
			addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
			addEventListener( MouseEvent.MOUSE_MOVE, startDraw );
		}
		private function startDraw(evt:MouseEvent) : void 
		{
			mx = evt.localX; 
			my = evt.localY; 		
		}	
		
		private function _onMouseDown(evt:MouseEvent):void {
			mx = evt.localX; 
			my = evt.localY; 		
			_mousePressed = true;
		}
		
		private function _onMouseUp(e:MouseEvent):void {
			_mousePressed = false;
		}
		
		override public function render(info:RenderInfo):void  {
			_mousePt.x = mx;
			_mousePt.y = my;
			var img:ColoredImage;
			for each (img in _images) {
				var dist:Number = Math.max(Point.distance(_mousePt, img.initPos), 3);
				var lc:Point = img.initPos.subtract(_mousePt);
				var a:Number = Math.atan2(lc.y, lc.x);
				var f:Number = 1 / dist * FORCE * (_mousePressed ? 3 : 1);
				img.addForce(Math.cos(a) * f, Math.sin(a) * f);
				img.update();
			}
			info.render(_center);
		}
	}
}



import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;

import frocessing.color.ColorRGB;

class ColoredImage extends Sprite {
	
	public static var ACC_PARAM:Number = 0.2;
	public static var VELOCITY_PARAM:Number = 0.8;
	
	private var _ix:Number;
	private var _iy:Number;
	private var _vx:Number = 0;
	private var _vy:Number = 0;
	private var _ax:Number = 0;
	private var _ay:Number = 0;
	
	private var _img:Bitmap;
	
	public function ColoredImage(image:BitmapData, r:Number, g:Number, b:Number) {
		_img = addChild(new Bitmap(image)) as Bitmap;
		_img.x = -_img.width / 2;
		_img.y = -_img.height / 2;
		_img.filters = [
			new ColorMatrixFilter([
				r, 0, 0, 0, 0,
				0, g, 0, 0, 0,
				0, 0, b, 0, 0,
				0, 0, 0, 1, 0
			])
		];
		_img.blendMode = BlendMode.ADD;
	}
	
	public function init(ix:Number, iy:Number):void {
		x = _ix = ix;
		y = _iy = iy;
		_img.x -= ix;
		_img.y -= iy;
	}
	
	public function addForce(ax:Number, ay:Number):void {
		_ax += ax;
		_ay += ay;
	}
	
	public function update():void {
		_ax += (_ix - x) * ACC_PARAM;
		_ay += (_iy - y) * ACC_PARAM;
		_vx = (_vx + _ax) * VELOCITY_PARAM;
		_vy = (_vy + _ay) * VELOCITY_PARAM;
		x += _vx;
		y += _vy;
		_ax = _ay = 0;
	}
	
	public function get ix():Number {
		return _ix;
	}
	
	public function get iy():Number {
		return _iy;
	}
	
	public function get initPos():Point {
		return new Point(_ix, _iy);
	}
}