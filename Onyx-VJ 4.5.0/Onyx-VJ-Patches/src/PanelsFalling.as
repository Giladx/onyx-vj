/**
 * Copyright Saqoosha ( http://wonderfl.net/user/Saqoosha )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/cXkO
 */

package {
	import frocessing.color.ColorHSV;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class PanelsFalling extends Patch {
				
		private var _canvas:Canvas;
		
		private var _color:ColorHSV;
		private var _px:int;
		private var _py:int;
		
		
		public function PanelsFalling() {
			var pp:PerspectiveProjection = root.transform.perspectiveProjection;
			pp.focalLength = 2000;
			root.transform.perspectiveProjection = pp;
			
			_canvas = addChild(new Canvas()) as Canvas;
			_color = new ColorHSV();
			_px = _py = -1;
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		
		private function _onMouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_draw();
		}
		
		
		private function _onMouseMove(event:MouseEvent):void {
			_draw();
		}
		
		
		private function _onMouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_px = _py = -1;
		}
		
		
		private function _draw():void {
			_color.h = getTimer() / 50 + Math.random() * 30;
			var cx:int = mouseX / 5;
			var cy:int = mouseY / 5;
			if (_px >= 0) _canvas.drawLine(_px, _py, cx, cy, _color.value);
			_px = cx;
			_py = cy;
		}
		override public function render(info:RenderInfo):void 
		{
			
			info.render( _canvas );		
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;

import onyx.plugin.DISPLAY_HEIGHT;
import onyx.plugin.DISPLAY_WIDTH;

import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.easing.Circ;
import org.libspark.betweenas3.tweens.ITween;


class Canvas extends Sprite {
	
	
	private var _image:Bitmap;
	private var _grid:Bitmap;
	
	private var _px:int;
	private var _py:int;
	
	
	public function Canvas() {
		mouseChildren = false;
		
		var b:BitmapData = new BitmapData(95 + 1, 95, false, 0x0);
		_image = addChild(new Bitmap(b, PixelSnapping.ALWAYS, false)) as Bitmap;
		_image.scaleX = _image.scaleY = 5;
		
		var s:Shape = new Shape();
		s.graphics.beginFill(0x101010);
		s.graphics.drawRect(4, 0, 1, 5);
		s.graphics.drawRect(0, 4, 4, 1);
		s.graphics.endFill();
		var p:BitmapData = new BitmapData(5, 5, true, 0x0);
		p.draw(s);
		s.graphics.clear();
		s.graphics.beginBitmapFill(p);
		s.graphics.drawRect(0, 0, DISPLAY_WIDTH + 5, DISPLAY_HEIGHT);
		s.graphics.endFill();
		
		b = new BitmapData(DISPLAY_WIDTH + 5, DISPLAY_HEIGHT, true, 0x0);
		b.draw(s);
		_grid = addChild(new Bitmap(b, PixelSnapping.ALWAYS, false)) as Bitmap;
		
		_px = _py = -1;
	}
	
	
	public function drawLine(x0:int, y0:int, x1:int, y1:int, color:int):void {
		var steep:Boolean = Math.abs(y1 - y0) > Math.abs(x1 - x0);
		var tmp:int;
		if (steep) {
			tmp = x0;
			x0 = y0;
			y0 = tmp;
			tmp = x1;
			x1 = y1;
			y1 = tmp;
		}
		if (x0 > x1) {
			tmp = x0;
			x0 = x1;
			x1 = tmp;
			tmp = y0;
			y0 = y1;
			y1 = tmp;
		}
		var deltax:int = x1 - x0;
		var deltay:int = Math.abs(y1 - y0);
		var error:int = deltax / 2;
		var ystep:int;
		var y:int = y0;
		if (y0 < y1) {
			ystep = 1;
		} else {
			ystep = -1;
		}
		for (var x:int = x0; x <= x1; x++) {
			if (steep) {
				setPixel(y, x, color);
			} else {
				setPixel(x, y, color);
			}
			error = error - deltay;
			if (error < 0) {
				y = y + ystep;
				error = error + deltax;
			}
		}
	}
	
	
	public function setPixel(x:int, y:int, color:uint):void {
		if (x == _px && y == _py) return;
		_px = x;
		_py = y;
		
		_image.bitmapData.setPixel32(x, y, 0x333333);
		var s:Shape = new Shape();
		s.graphics.beginFill(color);
		s.graphics.drawRect(-2, -2, 3, 3);
		s.graphics.endFill();
		s.x = x * 5 + 2 + Math.random() * 200 - 100;
		s.y = y * 5 + 2 + Math.random() * 200 - 100;
		s.z = -2000;
		s.rotationX = Math.random() * 360 - 180;
		s.rotationY = Math.random() * 360 - 180;
		s.rotationZ = Math.random() * 360 - 180;
		s.scaleX = s.scaleY = 10;
		s.alpha = 0;
		addChild(s);
		var t:ITween = BetweenAS3.to(s, {
			x: x * 5 + 2,
			y: y * 5 + 2,
			z: 0,
			rotationX: 0,
			rotationY: 0,
			rotationZ: 0,
			scaleX: 1,
			scaleY: 1,
			alpha: 1.0
		}, 1.0, Circ.easeOut);
		t.onComplete = function ():void {
			s.parent.removeChild(s);
			_image.bitmapData.setPixel32(x, y, color);
		};
		t.play();
	}
}
