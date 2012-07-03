/**
 * Copyright Etienne.Verhote ( http://wonderfl.net/user/Etienne.Verhote )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/ctrk
 */

// forked from ProjectNya's WaterEffect (4)
////////////////////////////////////////////////////////////////////////////////
// WaterEffect (4)
//
// ç½®ãæ›ãˆãƒžãƒƒãƒ—åŠ¹æžœ (3)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=480
// BitmapDataã§ãƒŽã‚¤ã‚ºç”Ÿæˆ (3)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=481
// [AS3.0] PerlinNoiseã‚¯ãƒ©ã‚¹ã«æŒ‘æˆ¦ï¼
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=1114
//
// å‹•ä½œã‚’è»½ãã™ã‚‹ãŸã‚ã®æ–¹æ³• (æ±äº¬ã¦ã‚‰ã“7 @trick7)
// Bitmap.filters ã‚’ä½¿ã‚ãšã€BitmapData.applyFilter() ã‚’ç”¨ã„ã‚‹
////////////////////////////////////////////////////////////////////////////////

package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import EmbeddedAssets.AssetForWaterFx;
		
	public class WaterFx extends Patch {
		private var water:WaterEffect;
		private var faded:Boolean = true;
		private var timer:Timer;
		public function WaterFx() {
			Console.output('WaterFx adapted by Bruce LANE (http://www.batchass.fr)');
			var bd:BitmapData = new AssetForWaterFx();		
			/*graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			graphics.endFill();*/
			//
			var rect:Rectangle = new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			water = new WaterEffect(rect);
			addChild(water);
			water.addEventListener(WaterEffect.COMPLETE, complete, false, 0, true);
			var bitmap:Bitmap = new Bitmap(bd);
			var matrix:Matrix = new Matrix();
			matrix.translate(32, 32);
			water.setup(bitmap, matrix, 400);
			water.wave(0, 0.8);
		}
		private function complete(evt:Event):void {
			timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, exchange, false, 0, true);
			timer.start();
		}
		private function exchange(evt:TimerEvent):void {
			evt.target.removeEventListener(TimerEvent.TIMER_COMPLETE, exchange);
			faded = !faded;
			if (faded) {
				water.wave(0.4, 0.8);
			} else {
				water.wave(0.8, 0.4);
			}
		}
		override public function render(info:RenderInfo):void {
			info.render(water);
		}
		override public function dispose():void {
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, exchange);
			water.removeEventListener(WaterEffect.COMPLETE, complete);
			timer = null;
			water.disposeAll();
			water = null;
		}
	}
	
}


//////////////////////////////////////////////////
// WaterEffectã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.events.Event;
import flash.filters.DisplacementMapFilter;
import flash.display.BitmapDataChannel;
import flash.filters.DisplacementMapFilterMode;
import flash.filters.BlurFilter;
import flash.display.BlendMode;
import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.tweens.ITween;
import org.libspark.betweenas3.events.TweenEvent;
import org.libspark.betweenas3.easing.Linear;
import org.libspark.betweenas3.easing.Quad;
import frocessing.color.ColorHSV;

class WaterEffect extends Sprite {
	private var rect:Rectangle;
	private var noise:PerlinNoise;
	private static var octaves:uint = 1;
	private static var channel:uint = BitmapDataChannel.RED;
	private var speeds:Array;
	private var target:DisplayObject;
	private var container:Bitmap;
	private var bitmapData:BitmapData;
	private var mapfilter:DisplacementMapFilter;
	private var blurfilter:BlurFilter;
	private var matrix:Matrix;
	private static var baseScale:Number;
	private var _scale:Number = 0;
	private var _size:Number = 0;
	private static var time:Number = 2;
	private var colorTrans:ColorTransform;
	private var color:ColorHSV;
	private var hue:Number = 0;
	private var saturation:Number = 0;
	public static const COMPLETE:String = Event.COMPLETE;
	
	public function WaterEffect(r:Rectangle) {
		rect = r;
		init();
	}
	
	private function init():void {
		noise = new PerlinNoise(rect, 32, 32, octaves, false, channel);
		speeds = new Array();
		for (var n:uint = 0; n < octaves; n++) {
			var sx:Number = (Math.random() - 0.5)*3;
			var sy:Number = (Math.random() - 0.5)*3 + 2.5;
			speeds.push(new Point(sx, sy));
		}
		bitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
		container = new Bitmap(bitmapData);
		addChild(container);
		map = 0;
		blur = 0;
		colorTrans = new ColorTransform();
		color = new ColorHSV(0, 0.8);
		colorTrans.color = color.value;
	}
	public function setup(t:DisplayObject, m:Matrix = null, bs:Number = 0):void {
		target = t;
		matrix = m;
		bitmapData.fillRect(rect, 0x00000000);
		bitmapData.draw(target, matrix, colorTrans, BlendMode.ADD, null, true);
		container.bitmapData = bitmapData.clone();
		baseScale = bs;
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
	}
	public function wave(from:Number = 0, to:Number = 1):void {
		tween(from, to);
	}
	private function tween(from:Number = 0, to:Number = 1):void {
		var itween:ITween = BetweenAS3.parallel(
			BetweenAS3.tween(container, {alpha: to}, {alpha: from}, time, Linear.easeNone), 
			BetweenAS3.tween(this, {map: to}, {map: from}, time, Quad.easeOut), 
			BetweenAS3.tween(this, {blur: to}, {blur: from}, time, Linear.easeNone)
		);
		itween.addEventListener(TweenEvent.COMPLETE, complete, false, 0, true);
		itween.play();
	}
	private function update(evt:Event):void {
		noise.update(speeds);
		bitmapData.lock();
		container.bitmapData.lock();
		bitmapData.fillRect(rect, 0x00000000);
		bitmapData.draw(target, matrix, colorTrans, BlendMode.ADD, null, true);
		container.bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), mapfilter);
		container.bitmapData.applyFilter(container.bitmapData, bitmapData.rect, new Point(), blurfilter);
		bitmapData.unlock();
		container.bitmapData.unlock();
		color.h = 195 + Math.sin(hue*Math.PI/180)*15;
		colorTrans.color = color.value;
		hue ++;
	}
	public function disposeAll():void {
		removeEventListener(Event.ENTER_FRAME, update);
		noise.dispose();
		bitmapData.dispose();
		container = null;
	}
	private function complete(evt:TweenEvent):void {
		dispatchEvent(new Event(COMPLETE));
	}
	public function get map():Number {
		return _scale;
	}
	public function set map(param:Number):void {
		_scale = param;
		var scale:Number = baseScale*(1 - _scale);
		mapfilter = new DisplacementMapFilter(noise, new Point(), channel, channel, scale, scale, DisplacementMapFilterMode.COLOR);
	}
	public function get blur():Number {
		return _size;
	}
	public function set blur(param:Number):void {
		_size = param;
		var size:Number = baseScale*(1 - _size)/10;
		blurfilter = new BlurFilter(size, size, 3);
	}
	
}


//////////////////////////////////////////////////
// PerlinNoiseã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.ColorTransform;

class PerlinNoise extends BitmapData {
	private var bx:uint;
	private var by:uint;
	private var octaves:uint;
	private var seed:uint;
	private var stitch:Boolean = true;
	private var fractalNoise:Boolean = true;
	private var channel:uint = 0;
	private var grayScale:Boolean = true;
	private var offsets:Array = new Array();
	
	public function PerlinNoise(rect:Rectangle, x:uint, y:uint, o:uint = 1, g:Boolean = true, c:uint = 0, s:uint = 1, st:Boolean = false, f:Boolean = true) {
		super(rect.width, rect.height, false, 0xFF000000);
		bx = x;
		by = y;
		octaves = o;
		grayScale = g;
		channel = c;
		if (grayScale) channel = 0;
		for (var n:uint = 0; n < octaves; n++) {
			var point:Point = new Point();
			offsets.push(point);
		}
		stitch = st;
		fractalNoise = f;
		create(s, offsets);
	}
	
	private function create(s:uint, o:Array = null):void {
		seed = s;
		offsets = o;
		if (offsets == null) offsets = [new Point()];
		lock();
		perlinNoise(bx, by, octaves, seed, stitch, fractalNoise, channel, grayScale, offsets);
		draw(this);
		unlock();
	}
	public function update(speeds:Array):void {
		for (var n:uint = 0; n < octaves; n++) {
			var offset:Point = offsets[n];
			var speed:Point = speeds[n];
			offset.x += speed.x;
			offset.y += speed.y;
		}
		lock();
		perlinNoise(bx, by, octaves, seed, stitch, fractalNoise, channel, grayScale, offsets);
		draw(this);
		unlock();
	}
	
}