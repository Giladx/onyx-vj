/**
 * Copyright bbbluevelvet ( http://wonderfl.net/user/bbbluevelvet )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/eMKK
 */

// forked from ProjectNya's WaveParticle
////////////////////////////////////////////////////////////////////////////////
// WaveParticle
//
// [AS3.0] WaveParticleã«æŒ‘æˆ¦ï¼ (3)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=1564
// [AS3.0] FontLoaderã‚¯ãƒ©ã‚¹ã«æŒ‘æˆ¦ï¼ (1)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=1337
//
// http://clockmaker.jp/blog/2011/11/starling-framework-sample/
////////////////////////////////////////////////////////////////////////////////

package {
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	//[SWF(backgroundColor="#0473B2", width="465", height="465", frameRate="30")]
	
	public class WaveParticle extends Patch 
	{
		private var loader:FontLoader;
		private var background:Background;
		private var se:SoundEffect;
		private var container:Sprite;
		private var wave:Wave;
		private var light:Light;
		
		public function WaveParticle() {
			init();
		}
		
		private function init():void {
			Console.output('WaveParticle from bbbluevelvet ( http://wonderfl.net/user/bbbluevelvet )');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			background = new Background();
			addChild(background);
			//
			container = new Sprite();
			addChild(container);
			//
			wave = new Wave(new Rectangle(0, 0, 465, 300));
			container.addChild(wave);
			wave.y = 182;
			//
			light = new Light(new Rectangle(0, 0, 465, 465));
			container.addChild(light);
			light.y = 0;
			//
			resize();
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( container );
		}
		private function resize(evt:Event = null):void 
		{
			var sw:uint = DISPLAY_WIDTH;
			var sh:uint = DISPLAY_HEIGHT;
			var cx:uint = uint(sw/2);
			var cy:uint = uint(sh/2);
			background.width = sw;
			background.height = sh;
			if (wave) {
				wave.scaleX = sw/465;
				wave.y = cy - 50;
				wave.start();
			}
			if (light) {
				light.resize(new Rectangle(0, 0, sw, sh));
				light.start();
			}
		}
		
	}
	
}


//////////////////////////////////////////////////
// Waveã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.ColorTransform;
import flash.filters.BlurFilter;
import flash.display.BlendMode;
import frocessing.math.PerlinNoise;
//import org.libspark.utils.GeomUtil;

class Wave extends Sprite {
	private var rect:Rectangle;
	private var container:Sprite;
	private var bitmapData:BitmapData;
	private var bitmap:Bitmap;
	private var points:Array;
	private static var segments:uint = 5;
	private static var ratio:Number = 1/segments;
	private static var color:uint = 0xFFFFFF;
	private var perlin:PerlinNoise;
	private var t:Number = 0;
	private var c:uint = 0;
	private static var tightness:uint = 40;
	private static var colorTrans:ColorTransform;
	private static var blur:BlurFilter;
	private static var point:Point = new Point();
	
	public function Wave(r:Rectangle) {
		rect = r;
		init();
	}
	
	private function init():void {
		bitmapData = new BitmapData(rect.width, rect.height, true, 0x00FFFFFF);
		bitmap = new Bitmap(bitmapData);
		addChild(bitmap);
		container = new Sprite();
		addChild(container);
		container.alpha = 0.4;
		container.filters = [new BlurFilter(2, 2, 3)];
		perlin = new PerlinNoise();
		colorTrans = new ColorTransform(1, 1, 1, 0.6, 0, 0, 0, 0);
		blur = new BlurFilter(8, 8, 3);
		blendMode = BlendMode.HARDLIGHT;
	}
	public function start():void {
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
	}
	private function update(evt:Event):void {
		container.graphics.clear();
		for (var n:uint = 0; n < 6; n++) {
			var offset:Number = (n < 3) ? n*0.25 : (n + 1)*0.25;
			setup(offset);
			draw();
		}
		bitmapData.lock();
		bitmapData.draw(container, null, colorTrans, BlendMode.LAYER, rect, true);
		bitmapData.applyFilter(bitmapData, rect, point, blur);
		bitmapData.unlock();
	}
	private function setup(offset:Number):void {
		points = new Array();
		points.push(new Point(- rect.width*ratio, rect.height*0.5));
		for (var n:uint = 1; n <= segments + 1; n++) {
			var px:Number = n*rect.width*ratio;
			var py:Number = (perlin.noise(n*0.25, t + offset)*0.8 + 0.1)*rect.height;
			points.push(new Point(px - rect.width*ratio, py));
		}
		t += 0.002;
		points.push(new Point(rect.width*(1 + ratio), rect.height*0.5));
		points.unshift(points[0]);
		points.push(points[points.length - 1]);
	}
	private function draw():void {
		container.graphics.lineStyle(0, color, 0.5);
		container.graphics.moveTo(points[0].x, points[0].y);
		for (var p:uint = 0; p < points.length - 3; p++) {
			var p0:Point = points[p];
			var p1:Point = points[p + 1];
			var p2:Point = points[p + 2];
			var p3:Point = points[p + 3];
			for (var s:uint = 1; s < tightness + 1; s++) {
				//var px:Number = GeomUtil.spline(p0.x, p1.x, p2.x, p3.x, s/tightness);
				//var py:Number = GeomUtil.spline(p0.y, p1.y, p2.y, p3.y, s/tightness);
				var px:Number = spline(p0.x, p1.x, p2.x, p3.x, s/tightness);
				var py:Number = spline(p0.y, p1.y, p2.y, p3.y, s/tightness);
				container.graphics.lineTo(px, py);
			}
		}
	}
	private function spline(p0:Number, p1:Number, p2:Number, p3:Number, t:Number):Number {
		var v0:Number = (p2 - p0) * 0.5;
		var v1:Number = (p3 - p1) * 0.5;
		var t2:Number = t * t;
		var t3:Number = t2 * t;
		return (2 * p1 - 2 * p2 + v0 + v1) * t3 + ( -3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1;
	}
	
}


//////////////////////////////////////////////////
// Lightã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.filters.BlurFilter;
import flash.display.BlendMode;

class Light extends Sprite {
	private var rect:Rectangle;
	private var container:Sprite;
	private var particles:Array;
	private var timer:Timer;
	private static var interval:uint = 50;
	
	public function Light(r:Rectangle) {
		rect = r;
		init();
	}
	
	private function init():void {
		particles = new Array();
		container = new Sprite();
		addChild(container);
		container.filters = [new BlurFilter(4, 4, 3)];
		blendMode = BlendMode.ADD;
	}
	public function start():void {
		create();
		timer = new Timer(interval);
		timer.addEventListener(TimerEvent.TIMER, create, false, 0, true);
		timer.start();
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
	}
	private function create(evt:TimerEvent = null):void {
		var radius:uint = uint(Math.random()*6 + 2);
		var particle:Particle = new Particle(radius);
		particle.x = (Math.random()*0.8 + 0.1)*rect.width;
		particle.y = (Math.random()*0.3 + 0.4)*rect.height;
		particle.initialize(uint(Math.random()*20) + 100);
		particle.vx = (Math.random() - 0.5)*2;
		particle.vy = Math.random()*5 - 1;
		particle.acceleration = Math.random()*0.01 + 0.996;
		container.addChild(particle);
		particles.push(particle);
	}
	private function update(evt:Event):void {
		for (var n:String in particles) {
			var particle:Particle = particles[n];
			if (particle) particle.update();
			if (particle.life < 0 || particle.y < 0 || particle.y > rect.height) {
				if (container.contains(particle)) container.removeChild(particle);
				particle = null;
				delete particles[n];
			}
		}
	}
	public function resize(r:Rectangle):void {
		rect = r;
	}
	
}


//////////////////////////////////////////////////
// Particleã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.geom.Matrix;
import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.InterpolationMethod;

class Particle extends Sprite {
	private var radius:uint;
	private static var colors:Array = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
	private static var alphas:Array = [1, 0.8, 0];
	private static var ratios:Array = [0, 153, 255];
	private var matrix:Matrix;
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var acceleration:Number = 1;
	private var max:uint = 100;
	public var life:int = max;
	private var _scale:Number = 1;
	
	public function Particle(r:uint) {
		radius = r;
		init();
	}
	
	public function init():void {
		draw();
	}
	public function initialize(m:uint):void {
		max = m;
		life = max;
	}
	public function update():void {
		life --;
		x += vx;
		y -= vy;
		vy *= acceleration;
		scale = life/max;
	}
	public function get scale():Number {
		return _scale;
	}
	public function set scale(value:Number):void {
		_scale = value;
		scaleX = scaleY = _scale;
		alpha = _scale;
	}
	private function draw():void {
		matrix = new Matrix();
		matrix.createGradientBox(radius*2, radius*2, 0, - radius, - radius);
		graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();
	}
	
}


//////////////////////////////////////////////////
// SoundEffectã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.events.IOErrorEvent;

class SoundEffect extends EventDispatcher {
	public var id:String;
	private var sound:Sound;
	private var channel:SoundChannel;
	private var level:Number;
	private var _volume:Number = 1;
	private var looping:Boolean = false;
	public var initialized:Boolean = false;
	public var playing:Boolean = false;
	
	public function SoundEffect() {
	}
	
	public function init(Snd:Class, lv:Number = 1):void {
		sound = new Snd();
		level = lv;
	}
	public function load(filePath:String, lv:Number = 1):void {
		sound = new Sound();
		sound.addEventListener(IOErrorEvent.IO_ERROR, ioerror, false, 0, true);
		sound.addEventListener(ProgressEvent.PROGRESS, progress, false, 0, true);
		sound.addEventListener(Event.COMPLETE, initialize, false, 0, true);
		try {
			sound.load(new URLRequest(filePath));
		} catch (err:Error) {
			trace(err.message);
		}
		level = lv;
	}
	private function ioerror(evt:IOErrorEvent):void {
		trace(evt.text);
	}
	private function progress(evt:ProgressEvent):void {
		dispatchEvent(evt);
	}
	private function initialize(evt:Event):void {
		initialized = true;
		channel = sound.play();
		channel.stop();
		dispatchEvent(evt);
	}
	public function play(loop:Boolean = false):void {
		playing = true;
		if (channel) channel.stop();
		looping = loop;
		channel = sound.play();
		var transform:SoundTransform = channel.soundTransform;
		transform.volume = level*volume;
		channel.soundTransform = transform;
		if (looping) {
			channel.addEventListener(Event.SOUND_COMPLETE, complete, false, 0, true);
		}
	}
	public function stop():void {
		playing = false;
		if (channel) {
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, complete);
		}
	}
	public function get volume():Number {
		return _volume;
	}
	public function set volume(value:Number):void {
		_volume = value;
		if (channel) {
			var transform:SoundTransform = channel.soundTransform;
			transform.volume = level*_volume;
			channel.soundTransform = transform;
		}
	}
	private function complete(evt:Event):void {
		channel.removeEventListener(Event.SOUND_COMPLETE, complete);
		if (looping) {
			channel = sound.play(0);
			channel.addEventListener(Event.SOUND_COMPLETE, complete, false, 0, true);
			var transform:SoundTransform = channel.soundTransform;
			transform.volume = level*volume;
			channel.soundTransform = transform;
		} else {
			playing = false;
		}
	}
	
}


//////////////////////////////////////////////////
// FontLoaderã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.events.EventDispatcher;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.net.URLRequest;
import flash.text.Font;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.events.HTTPStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.system.ApplicationDomain;
import flash.system.SecurityDomain;
import flash.system.LoaderContext;
import flash.utils.getDefinitionByName;

class FontLoader extends EventDispatcher {
	public var id:uint;
	private var loader:Loader;
	private var info:LoaderInfo;
	private var _className:String;
	private var _font:Font;
	private var _fontName:String;
	private var embeded:Boolean = false;
	public static const IO_ERROR:String = IOErrorEvent.IO_ERROR;
	public static const HTTP_STATUS:String = HTTPStatusEvent.HTTP_STATUS;
	public static const SECURITY_ERROR:String = SecurityErrorEvent.SECURITY_ERROR;
	public static const INIT:String = Event.INIT;
	public static const COMPLETE:String = Event.COMPLETE;
	
	public function FontLoader() {
		loader = new Loader();
		info = loader.contentLoaderInfo;
	}
	
	public function load(file:String, name:String, e:Boolean = false):void {
		_className = name;
		embeded = e;
		info.addEventListener(ProgressEvent.PROGRESS, progress, false, 0, true);
		info.addEventListener(IOErrorEvent.IO_ERROR, ioerror, false, 0, true);
		info.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatus, false, 0, true);
		info.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityerror, false, 0, true);
		info.addEventListener(Event.INIT, initialize, false, 0, true);
		info.addEventListener(Event.COMPLETE, complete, false, 0, true);
		try {
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			context.securityDomain = SecurityDomain.currentDomain;
			loader.load(new URLRequest(file), context);
		} catch (err:Error) {
			trace(err.message);
		}
	}
	public function unload():void {
		loader.unload();
	}
	private function progress(evt:ProgressEvent):void {
		dispatchEvent(evt);
	}
	private function ioerror(evt:IOErrorEvent):void {
		loader.unload();
		dispatchEvent(new Event(FontLoader.IO_ERROR));
	}
	private function httpstatus(evt:HTTPStatusEvent):void {
		dispatchEvent(new Event(FontLoader.HTTP_STATUS));
	}
	private function securityerror(evt:SecurityErrorEvent):void {
		dispatchEvent(new Event(FontLoader.SECURITY_ERROR));
	}
	private function initialize(evt:Event):void {
		dispatchEvent(new Event(FontLoader.INIT));
	}
	private function complete(evt:Event):void {
		info.removeEventListener(IOErrorEvent.IO_ERROR, ioerror);
		info.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatus);
		info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityerror);
		info.removeEventListener(Event.INIT, initialize);
		info.removeEventListener(Event.COMPLETE, complete);
		var FontClass:Class = Class(ApplicationDomain.currentDomain.getDefinition(className));
		if (!embeded) {
			Font.registerFont(FontClass);
			_font = Font(new FontClass());
		} else {
			var document:Object = new FontClass();
			_font = document.font;
		}
		_fontName = _font.fontName;
		dispatchEvent(new Event(FontLoader.COMPLETE));
	}
	public function get className():String {
		return _className;
	}
	public function get font():Font {
		return _font;
	}
	public function get fontName():String {
		return _fontName;
	}
	
}
//////////////////////////////////////////////////
// Labelã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.AntiAliasType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class Label extends Sprite {
	private var txt:TextField;
	private static var fontType:String = "Myriad Pro Semibold";
	private var _width:uint = 20;
	private var _height:uint = 20;
	private var size:uint = 12;
	public static const LEFT:String = TextFormatAlign.LEFT;
	public static const CENTER:String = TextFormatAlign.CENTER;
	public static const RIGHT:String = TextFormatAlign.RIGHT;
	
	public function Label(w:uint, h:uint, s:uint = 12, align:String = LEFT) {
		_width = w;
		_height = h;
		size = s;
		draw(align);
	}
	
	private function draw(align:String):void {
		txt = new TextField();
		addChild(txt);
		txt.width = _width;
		txt.height = _height;
		txt.autoSize = align;
		txt.type = TextFieldType.DYNAMIC;
		txt.selectable = false;
		txt.embedFonts = true;
		txt.antiAliasType = AntiAliasType.ADVANCED;
		var tf:TextFormat = new TextFormat();
		tf.font = fontType;
		tf.size = size;
		tf.align = align;
		txt.defaultTextFormat = tf;
		textColor = 0x000000;
	}
	public function set text(param:String):void {
		txt.text = param;
	}
	public function set textColor(param:uint):void {
		txt.textColor = param;
	}
	
}


//////////////////////////////////////////////////
// Backgroundã‚¯ãƒ©ã‚¹
//////////////////////////////////////////////////

import flash.display.Shape;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.InterpolationMethod;

class Background extends Shape {
	private static var colors:Array = [0xE0F5FA, 0x067AC2, 0x0D1944];
	private static var alphas:Array = [1, 1, 1];
	private static var ratios:Array = [0, 153, 255];
	
	public function Background() {
		draw();
	}
	
	private function draw():void {
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(1600, 1600, 0, - 560, - 800);
		graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
		graphics.drawRect(0, 0, 800, 600);
		graphics.endFill();
	}
	
}
