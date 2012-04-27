/**
 * Copyright flashmafia ( http://wonderfl.net/user/flashmafia )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/f4H9
 */

package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filters.GlowFilter;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
		
	public class SpacePirateTransmission extends Patch 
	{
		private var sprite:Sprite;

		public function SpacePirateTransmission() 
		{
			sprite = new Sprite();
			sprite.addChild(new Background());
			
			var emission : Emission = new Emission(0xFFFFAA);
			sprite.addChild(emission);
			emission.filters = [new GlowFilter(0xFF8040)];
			sprite.addChild(new HoloFx(emission));

		}
		override public function render(info:RenderInfo):void 
		{			
			info.render( sprite );		
		}
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import onyx.plugin.DISPLAY_HEIGHT;
import onyx.plugin.DISPLAY_WIDTH;

internal class HoloFx extends Bitmap 
{
	private var _emission : DisplayObject;
	private var _sourceBmd : BitmapData;
	private var _matrix : Matrix;
	private var _sourceRect : Rectangle;
	private var _destPoint : Point;
	private var _zero : Point;
	private var _theta : Number;
	private var _scanLine : int;
	
	public function HoloFx(emission : DisplayObject) {
		_emission = emission;
		
		_sourceRect = new Rectangle(0, 0, 0, 1);
		_destPoint = new Point();
		_zero = new Point();
		_theta = 0.0;
		_scanLine = 0;
		
		_sourceBmd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x0);
		bitmapData = _sourceBmd.clone();
		
		_matrix = new Matrix();
		
		super(bitmapData, PixelSnapping.AUTO, true);
		
		blendMode = BlendMode.ADD;
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	
	private function update(e : Event) : void {
		_sourceBmd.fillRect(_sourceBmd.rect, 0x0);
		_sourceBmd.draw(_emission, _matrix);
		
		bitmapData.lock();
		
		_scanLine = ++_scanLine & 127;
		
		var offset : Number;
		var n : uint = DISPLAY_HEIGHT;
		while (n-- != 0) {
			_theta = (_theta + (Math.PI / (64 + _scanLine))) % (Math.PI * 2);
			offset = Math.tan(_theta * n / DISPLAY_HEIGHT);
			offset = offset < -(DISPLAY_WIDTH  >> 1) ? -(DISPLAY_WIDTH >> 1) : offset > (DISPLAY_WIDTH >> 1) ? DISPLAY_WIDTH >> 1 : offset;
			
			_sourceRect.x = offset;
			_sourceRect.width = DISPLAY_WIDTH - offset;
			_sourceRect.y = n;
			
			_destPoint.y = n;
			
			bitmapData.copyPixels(_sourceBmd, _sourceRect, _destPoint);
		}
		
		bitmapData.unlock();
	}
	
	private function resize(e : Event) : void {
		var sw : Number = stage.stageWidth;
		var sh : Number = stage.stageHeight;
		
		_matrix = new Matrix();
		_matrix.scale(DISPLAY_WIDTH / sw, DISPLAY_HEIGHT / sh);
		
		scaleX = sw / DISPLAY_WIDTH;
		scaleY = sh / DISPLAY_HEIGHT;
	}
}
internal class Emission extends Sprite {
	private var _shape : Shape;
	private var _theta : Number;
	private var _color : uint;
	private var _radius : Number;
	private var _cx : int;
	private var _cy : int;
	
	public function Emission(color : uint) {
		addChild(_shape = new Shape());
		_shape.filters = [new BlurFilter(0.0, 128.0, BitmapFilterQuality.MEDIUM)];
		
		_color = color;
		_theta = 0.0;
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function update(e : Event) : void {
		_cx = DISPLAY_WIDTH >> 1;
		_cy = DISPLAY_HEIGHT >> 1;
		
		_radius = Math.sqrt(((_cx * _cx) + (_cy * _cy)) >> 2);
		
		_theta += Math.PI / 222;
		
		draw(graphics, _radius / 12, _theta);
		draw(_shape.graphics, _radius / 10, _theta);
	}
	
	private function draw(g : Graphics, thickness : Number, theta : Number) : void {
		g.clear();
		g.lineStyle(thickness, _color, 0.28);
		
		/* head */
		g.drawCircle(_cx, _cy, _radius / 2);
		
		/* bones */
		var ampX : Number = _radius * Math.cos(theta);
		var ampY : Number = _radius * Math.sin(theta);
		g.moveTo(_cx + ampX, _cy + ampY);
		g.lineTo(_cx - ampX, _cy - ampY);
		g.moveTo(_cx + ampX, _cy - ampY);
		g.lineTo(_cx - ampX, _cy + ampY);
	}
}
internal final class Background extends Shape {
	private const _colors : Array = [0x999999, 0x000000];
	private const _alphas : Array = [1.0, 1.0];
	private const _ratios : Array = [0, 255];
	private var _matrix : Matrix;
	
	public function Background() {
		_matrix = new Matrix();
	
	}
	
	public function onResize(e : Event) : void {
		var sw : Number = DISPLAY_WIDTH;
		var sh : Number = DISPLAY_HEIGHT;
		
		_matrix.createGradientBox(sw, sh, Math.PI);
		graphics.clear();
		graphics.beginGradientFill(GradientType.RADIAL, _colors, _alphas, _ratios, _matrix);
		graphics.drawRect(0, 0, sw, sh);
		graphics.endFill();
	}
}
