/**
 * Copyright Aquioux ( http://wonderfl.net/user/Aquioux )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/6h3y
 */

package plugins.filters {
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	
	import frocessing.color.ColorRGB;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class SeuratFilter extends Filter implements IBitmapFilter {
		
		static public const MAX_SIZE:uint = 400;
		private var bm_:Bitmap;
		private var bmd_:BitmapData;
		private var filter:BlurFilter = new BlurFilter(2, 2, BitmapFilterQuality.HIGH);
		private var rgb:ColorRGB = new ColorRGB();
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		private var _delay:int    	 	= 100;
		private var previousTime:Number     = 0.0;
		private var _radius:uint = 10;
		private var time:Number;
		private var dt:Number ;
		private var interval:uint = radius * 2;
		private var matrix:Matrix = new Matrix();
		private var dot:Dot;
		
		public function SeuratFilter():void {

			bmd_ = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0xFF000000);
			parameters.addParameters(
				new ParameterInteger('radius', 'radius', 3, 100, _radius),
				new ParameterInteger('delay', 'delay', 3, 1000, _delay, 10)
			);
		}

		public function applyFilter(bitmapData:BitmapData):void {
			
			
			var colors:Vector.<uint> = bitmapData.getVector(bitmapData.rect);
				
			time = getTimer();
			dt = time - previousTime;
			
			if ( dt > delay )
			{
				if (dot) 
				{
					dot.RemoveAll();
					dot = null;
					bmd_.dispose();
					bmd_ = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0xFF000000);
				}
				
				dot = new Dot(radius);
				
				for (var j:int = 0; j < DISPLAY_HEIGHT; j += interval) {
					for (var i:int = 0; i < DISPLAY_WIDTH; i += interval) {
						var idx:uint = DISPLAY_WIDTH * j + i;
						rgb.value32 = colors[idx];
						dot.draw(rgb);
						matrix.tx = i + offsetX;
						matrix.ty = j + offsetY;
						bmd_.draw(dot, matrix);
					}
				}
				bitmapData.applyFilter(bmd_, DISPLAY_RECT, ONYX_POINT_IDENTITY, filter);
				previousTime = time;
			}
			else
			{
				bitmapData.applyFilter(bmd_, DISPLAY_RECT, ONYX_POINT_IDENTITY, filter);	
			}
			
		}

		public function get delay():int
		{
			return _delay;
		}

		public function set delay(value:int):void
		{
			_delay = value;
		}

		public function get radius():uint
		{
			return _radius;
		}

		public function set radius(value:uint):void
		{
			_radius = value;
			interval = _radius * 2;
		}


	}
}
import flash.display.*;

import frocessing.color.ColorRGB;

class Dot extends Sprite {
	
	private var radius_:uint;
	private var circles_:Array;
	
	public function Dot(radius:uint) {
		radius_ = radius;
		
		circles_ = [];
		for (var i:int = 0; i < 3; i++) {
			var circle:Shape = new Shape();
			circle.blendMode = BlendMode.ADD;
			addChild(circle);
			circles_.push(circle);
		}
	}
	
	public function draw(rgb:ColorRGB):void {
		var v:Vector.<uint> = new Vector.<uint>(3, true);
		v[0] = rgb.r;
		v[1] = rgb.g;
		v[2] = rgb.b;
		
		for (var i:int = 0; i < 3; i++) {
			var circle:Shape = circles_[i];
			var g:Graphics = circle.graphics;
			g.clear();
			g.beginFill(0xFF << 8 * (2 - i));
			g.drawCircle(Math.random() - 0.5, Math.random() - 0.5, radius_ * v[i] / 255);
			g.endFill();
		}
	}
	public function RemoveAll():void {
		this.removeChildren();
		circles_ = [];
	}
}
