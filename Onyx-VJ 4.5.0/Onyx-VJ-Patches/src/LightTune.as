/**
 * Copyright hinomura_mamoru ( http://wonderfl.net/user/hinomura_mamoru )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/iO5k
 */

// forked from hinomura_mamoru's forked from: LightTune (3)
// forked from ProjectNya's LightTune (3)
////////////////////////////////////////////////////////////////////////////////
// [AS3.0] LightTuneã‚¯ãƒ©ã‚¹ã ï¼ (4)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=1158
//
// èƒŒæ™¯ã‚’æš—ãã™ã‚‹ã®ã« ColorTransform ã‚’ç”¨ã„ãŸ
////////////////////////////////////////////////////////////////////////////////

package {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class LightTune extends Patch {
		private var light:LT;
		private var playing:Boolean = true;
		
		public function LightTune() {
			Console.output('LightTune v 0.0.1');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');

			/*graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 465, 465);
			graphics.endFill();*/
			var rect:Rectangle = new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			light = new LT(rect);
			//addChild(light);
			light.start();
			addEventListener(MouseEvent.MOUSE_DOWN, click, false, 0, true);
		}
		private function click(evt:MouseEvent):void {
			playing = !playing;
			if (playing) {
				light.start();
			} else {
				light.stop();
			}
		}
		override public function render(info:RenderInfo):void 
		{			
			info.render( light );		
		}
		
	}
	
}


import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.filters.BlurFilter;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;
//ColorTransform
import flash.geom.ColorTransform;

class LT extends Sprite {
	private var rect:Rectangle;
	private var canvas:BitmapData;
	private var bitmapData:BitmapData;
	private static var scale:Number = 1.25;
	private var matrix:Matrix;
	private var blur:BlurFilter;
	private static var point:Point = new Point();
	private var light:EmitLight;
	//ColorTransform
	private var colorTrans:ColorTransform;
	
	public function LT(r:Rectangle) {
		rect = r;
		init();
	}
	
	private function init():void {
		canvas = new BitmapData(rect.width, rect.height, true, 0xFF000000);
		addChild(new Bitmap(canvas));
		bitmapData = new BitmapData(rect.width, rect.height, false, 0xFF000000);
		matrix = new Matrix();
		matrix.scale(scale, scale);
		var w:int = (rect.width - rect.width*scale)*0.5;
		var h:int = (rect.height - rect.height*scale)*0.5;
		matrix.translate(w, h);
		blur = new BlurFilter(1, 1, 3);
		light = new EmitLight();
		addChild(light);
		light.initialize(40);
		light.x = rect.width*0.5;
		light.y = rect.height*0.5;
		//ColorTransform
		colorTrans = new ColorTransform(0.96, 0.96, 0.96, 1, 0, 0, 0, 0);
	}
	public function start():void {
		addEventListener(Event.ENTER_FRAME, draw, false, 0, true);
	}
	public function stop():void {
		removeEventListener(Event.ENTER_FRAME, draw);
	}
	private function draw(evt:Event):void {
		light.create();
		bitmapData.lock();
		bitmapData.draw(this);
		bitmapData.applyFilter(bitmapData, rect, point, blur);
		bitmapData.unlock();
		canvas.lock();
		//ColorTransform
		canvas.draw(bitmapData, matrix, colorTrans, null, rect, true);
		canvas.unlock();
		light.emit();
	}
	
}


import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.display.BlendMode;
import frocessing.color.ColorHSV;

class EmitLight extends Sprite {
	private var radius:uint;
	private var circles:Array;
	private static var deceleration:Number = 0.9;
	private var id:uint;
	private var color:ColorHSV;
	
	public function EmitLight() {
		init();
	}
	
	private function init():void {
		circles = new Array();
		color = new ColorHSV(0, 0.6, 1);
	}
	public function initialize(r:uint):void {
		radius = r;
	}
	public function create():void {
		id ++;
		var angle:uint = id%360;
		color.h = angle;
		var circle:Circle = new Circle(color.value);
		addChild(circle);
		circle.x = Math.cos(-angle*Math.PI/180)*radius;
		circle.y = Math.sin(-angle*Math.PI/180)*radius;
		circle.vx = (Math.random()*2 - 1)*20;
		circle.vy = (Math.random()*2 - 1)*20;
		circle.scale = Math.random()*0.75 + 0.25;
		circle.blendMode = BlendMode.HARDLIGHT;
		circles.push(circle);
	}
	public function emit():void {
		for (var n:uint = 0; n < circles.length; n++) {
			var circle:Circle = circles[n];
			circle.vx *= deceleration;
			circle.vy *= deceleration;
			circle.x += circle.vx;
			circle.y += circle.vy;
			circle.scale *= deceleration;
			if (circle.scale < 0.1) {
				circles.splice(n, 1);
				removeChild(circle);
				circle = null;
			}
		}
	}
	
}


import flash.display.Shape;

class Circle extends Shape {
	private static var radius:uint = 10;
	private var rgb:uint = 0xFFFFFF;
	private var _scale:Number = 1;
	public var vx:Number = 0;
	public var vy:Number = 0;
	
	public function Circle(c:uint = 0xFFFFFF) {
		rgb = c;
		draw();
	}
	
	private function draw():void {
		graphics.clear();
		graphics.beginFill(rgb);
		graphics.drawCircle(0, 0, radius);
		graphics.drawCircle(0, 0, radius*0.6);
		graphics.endFill();
	}
	public function get scale():Number {
		return _scale;
	}
	public function set scale(param:Number):void {
		_scale = param;
		scaleX = scaleY = _scale;
	}
	
}
