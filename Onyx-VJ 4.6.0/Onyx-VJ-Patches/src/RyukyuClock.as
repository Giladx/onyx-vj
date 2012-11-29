/**
 * Copyright mrt ( http://wonderfl.net/user/mrt )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/bAiM
 */

package {
	import EmbeddedAssets.AssetForRyukyuClock;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class RyukyuClock extends Patch {
		private const PARTICLE_MAX:int = 10000;
		private const TRANSFORM_COLOR:ColorTransform = new ColorTransform(1, 1, 1, .95, 0, 0, 0, 0);    
		private const FILTER_BLUR:BlurFilter = new BlurFilter(4, 4, BitmapFilterQuality.LOW);
		private const POINT:Point = new Point();    
		private const DEGREE:Number = 1;
		private const RADIAN:Number = DEGREE * Math.PI / 180;
		private const COS_RADIAN:Number = Math.cos(RADIAN);
		private const SIN_RADIAN:Number = Math.sin(RADIAN);
		
		private var _startTime:int ;
		private var _loader:Loader;
		private var _currentNum:int = 0;
		private var _maineParticles:Array = [];
		private var _particlesList:Array = [];
		private var _clock:Clock;
		private var _canvas:BitmapData;
		private static const NU:Number = 0;
		
		private var sprite:Sprite;    
		
		
		//========================================================================
		// ã??ã??ã??ã??ã??ã??ã??
		//========================================================================
		public function RyukyuClock() {
			
			
			var bmd:BitmapData = new AssetForRyukyuClock();
			sprite = new Sprite();
			
			_particlesList.push(createParticle(bmd));
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("_sans", 30, 0xFFFFFF); 
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = "www.batchass.fr";
			
			_canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000);
			sprite.addChild(new Bitmap(_canvas));
			
			createMainParticle();
			
			_clock = new Clock();            
			upDate();
			_clock.addEventListener(Event.CHANGE, upDate);
			
			var bmdt:BitmapData = new BitmapData(tf.width, tf.height, false, 0x000000);
			bmdt.draw(tf);
			_particlesList.push(createParticle(bmdt));    
			
			var timer:Timer = new Timer(1);
			timer.addEventListener(TimerEvent.TIMER, loop);
			timer.start();
			
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			 
		}
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );	
		}		
		//========================================================================
		// ãƒ¡ã‚¤ãƒ³ã§ä½¿ã†ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã‚’ä½œæˆ
		//========================================================================
		private function createMainParticle():void {
			for (var i:int = 0; i < PARTICLE_MAX; i++) {
				var p:Particle = new Particle();
				var rad:Number = Math.random() * ( Math.PI * 2 );
				p.x = DISPLAY_WIDTH / 2 + 150 * Math.cos( rad );
				p.y = DISPLAY_HEIGHT / 2 + 150 * Math.sin( rad );
				p.ex = p.x;
				p.ey = p.y;
				p.tx = p.x;
				p.ty = p.y;
				p.c = 0xFFFFFF;
				_maineParticles.push(p);
			}
		}
		
		//========================================================================
		// å®Ÿè¡Œã•ã‚Œã‚‹åº¦ã«æ™‚è¨ˆã®è¡¨ç¤ºã«å¿…è¦ãªãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã‚’ä½œã‚Šç›´ã™        
		//========================================================================
		private function upDate(e:Event = null):void {
			var o:Sprite = _clock;
			var bmd:BitmapData = new BitmapData(o.width, o.height, false, 0x000000);
			bmd.draw(o);
			
			_particlesList[1] = createParticle(bmd);    
		}        
		
		//========================================================================
		//  å¼•æ•°ã®BitmapDataã®ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã‚’ä½œæˆã—ã¦è¿”ã™
		//========================================================================
		private function createParticle(bmd:BitmapData):Array {
			var particles:Array = [];
			for ( var _x:Number = 0; _x < bmd.width; _x++ ) {
				for ( var _y:Number = 0; _y < bmd.height; _y++ ) {
					var c:uint = bmd.getPixel( _x, _y );
					if ( c != 0x000000 ) {
						var p:Particle = new Particle();
						p.x = _x + DISPLAY_WIDTH / 2 - bmd.width / 2;
						p.y = _y + DISPLAY_HEIGHT / 2 - bmd.height / 2;
						p.c = c;                        
						particles.push( p );
					}
				}
			}
			return particles;
		}
		
		//========================================================================
		// loopãƒ¡ã‚½ãƒƒãƒ‰
		//========================================================================
		private function loop(e:TimerEvent):void {
			var wait:Number;
			var now:int = getTimer();
			
			_canvas.lock();
			_canvas.colorTransform(_canvas.rect, TRANSFORM_COLOR);
			_canvas.applyFilter(_canvas, _canvas.rect, POINT, FILTER_BLUR);    
			for ( var i:int = 0; i < PARTICLE_MAX; i++ ) {
				var p:Particle = _maineParticles[i];
				var _x:Number = p.ex - DISPLAY_WIDTH / 2;
				var _y:Number = p.ey - DISPLAY_HEIGHT / 2;
				var x1:Number = COS_RADIAN * _x - SIN_RADIAN * _y;
				var y1:Number = COS_RADIAN * _y + SIN_RADIAN * _x;
				p.ex = DISPLAY_WIDTH / 2 + x1 + ((Math.random() - .5) * .5);
				p.ey = DISPLAY_HEIGHT / 2 + y1 + ((Math.random() - .5) * .5);            
				if (_particlesList[_currentNum][i]) {
					var cp:Particle = _particlesList[_currentNum][i]; 
					wait = ( 1 - ( cp.x / 350  ) ) * 4000;
					if ( _startTime + wait > now ) continue ;     
					
					if (Math.abs(cp.x - p.x) < .5 && Math.abs(cp.y - p.y) < .5) {
						p.x = cp.x;
						p.y = cp.y;
					}else {
						p.x += (cp.x - p.x) * .08;
						p.y += (cp.y - p.y) * .08;
					}
				}else {
					if (Math.abs(p.ex - p.x) < .5 && Math.abs(p.ey - p.y) < .5) {
						p.x = p.ex;
						p.y = p.ey;
					}else {
						p.x += (p.ex - p.x) * .05;
						p.y += (p.ey - p.y) * .05;
					}
				}
				_canvas.setPixel( p.x, p.y, p.c );
			}    
			_canvas.unlock();
		}
		
		//========================================================================
		// ã‚¯ãƒªãƒƒã‚¯æ™‚ã®å‡¦ç†        
		//========================================================================
		private function onClick(e:MouseEvent = null):void {
			_startTime = getTimer();
			(_currentNum < 2) ? _currentNum++ : _currentNum = 0;            
			
			shuffle(_maineParticles);
		}
		
		//========================================================================
		// å¼•æ•°ã§æ¸¡ã•ã‚ŒãŸé…åˆ—ã®ä¸­èº«ã‚’ã‚·ãƒ£ãƒƒãƒ•ãƒ«ã™ã‚‹
		//========================================================================
		private function shuffle(list:Array):void{
			var i:int = list.length;
			while (--i) {
				var j:Number = Math.floor(Math.random() * (i + 1));
				if (i == j) continue;
				var k:Particle = list[i];
				list[i] = list[j];
				list[j] = k;
			}
		}        
	}
}


//========================================================================
// Particleã‚¯ãƒ©ã‚¹
//========================================================================
class Particle {
	public var x:Number = 0;
	public var y:Number = 0;
	public var tx:Number = 0;
	public var ty:Number = 0;
	public var ex:Number = 0;
	public var ey:Number = 0;
	public var c:int = 0;
}

//========================================================================
// Clockã‚¯ãƒ©ã‚¹
//========================================================================
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.events.Event;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.utils.Timer;

class Clock extends Sprite {
	// å„ãƒ†ã‚­ã‚¹ãƒˆãƒ•ã‚£ãƒ¼ãƒ«ãƒ‰    
	private var _hoursField:TextField;
	private var _minutesField:TextField;
	private var _secondsField:TextField;
	private var _dotField:TextField;
	private var _txtFormat:TextFormat;
	// æ™‚åˆ»
	private var _hours:String;
	private var _minutes:String;
	private var _seconds:String;
	// TeraClock
	private var _clock:TeraClock;
	
	public function Clock() {
		// ãƒ†ã‚­ã‚¹ãƒˆãƒ•ã‚©ãƒ¼ãƒžãƒƒãƒˆ        
		_txtFormat = new TextFormat();
		_txtFormat.font = "BPdotsUnicaseSquare"
		_txtFormat.size = 39;
		_txtFormat.color = 0xFFFFFF;
		_txtFormat.kerning = true;            
		// æ™‚ã‚’è¡¨ç¤ºã™ã‚‹ãƒ†ã‚­ã‚¹ãƒˆãƒ•ã‚£ãƒ¼ãƒ«ãƒ‰ã‚’ä½œæˆã™ã‚‹            
		_hoursField = new TextField();
		_txtFormat.size = 60;
		_hoursField.defaultTextFormat = _txtFormat;
		_hoursField.autoSize = TextFieldAutoSize.LEFT;
		_hoursField.x = 13;
		_hoursField.y = 10;
		this.addChild(_hoursField);                
		// å??ã??è??ç?ºã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ä??æ??ã??ã??    
		_minutesField = new TextField();
		_minutesField.defaultTextFormat = _txtFormat;
		_minutesField.x = 103;
		_minutesField.y = 10;
		this.addChild(_minutesField);            
		// ç??ã??è??ç?ºã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ä??æ??ã??ã??            
		_secondsField = new TextField();
		_secondsField.defaultTextFormat = _txtFormat;
		_secondsField.x = 190;
		_secondsField.y = 10;
		this.addChild(_secondsField);            
		// ã??ã??ã??ã??è??ç?ºã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ä??æ??ã??ã??    
		_dotField = new TextField();
		_dotField.defaultTextFormat = _txtFormat;
		_dotField.text = ":";
		_dotField.x = 75;
		_dotField.y = 10;
		this.addChild(_dotField);            
		_dotField = new TextField();
		_dotField.defaultTextFormat = _txtFormat;
		_dotField.text = ":";
		_dotField.x = 165;
		_dotField.y = 10;
		this.addChild(_dotField);            
		// TeraClockã??ä??ç??ã??ã??æ??è??ã??è??ç?ºã??æ??æ??ã??ã??
		_clock = new TeraClock();
		_hoursField.text = _clock.hours2;
		_minutesField.text = _clock.minutes2;            
		_secondsField.text = _clock.seconds2;            
		
		_clock.addEventListener(TeraClock.HOURS_CHANGED, _hoursChangeHandler);
		_clock.addEventListener(TeraClock.SECONDS_CHANGED, _secondsChangeHandler);
		_clock.addEventListener(TeraClock.MINUTES_CHANGED, _minutesChangeHandler);
		
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	// 1æ??é??æ??ã??è??ç?ºã??æ??æ??ã??ã??CHANGEã??ã??ã??ã??ã??dispatchã??ã??ã??        
	private function _hoursChangeHandler(e:Event):void {
		_hoursField.text = _clock.hours2;    
		dispatchEvent(new Event(Event.CHANGE));        
	}        
	// 1å??æ??ã??è??ç?ºã??æ??æ??ã??ã??CHANGEã??ã??ã??ã??ã??dispatchã??ã??ã??    
	private function _minutesChangeHandler(e:Event):void {
		_minutesField.text = _clock.minutes2;    
		dispatchEvent(new Event(Event.CHANGE));            
	}        
	// 1ç??æ??ã??è??ç?ºã??æ??æ??ã??ã??CHANGEã??ã??ã??ã??ã??dispatchã??ã??ã??        
	private function _secondsChangeHandler(e:Event):void {
		_secondsField.text = _clock.seconds2;            
		dispatchEvent(new Event(Event.CHANGE));
	}
}


/**
 * trick7ã??ã??ã??TeraClockã??ã??ã??ã??ã?ª
 * @author tera 
 * ã??ã??ã??ã??
 * http://www.trick7.com/blog/2008/09/02-074335.php
 */

import flash.display.*;
import flash.events.Event;
import flash.events.EventDispatcher;    

class TeraClock extends Sprite {
	public static const HOURS_CHANGED:String = "hoursChanged";
	public static const MINUTES_CHANGED:String = "minutesChanged";
	public static const SECONDS_CHANGED:String = "secondsChanged";
	private var _hours:int;
	private var _minutes:int;
	private var _seconds:int;
	private var _preSeconds:int;
	private var _gmt:int;
	public function TeraClock(GMT:int = 1) {
		_gmt = GMT%24;
		this.enterFrameListener(null);
		addEventListener(Event.ENTER_FRAME, enterFrameListener);
	}
	
	private function enterFrameListener(e:Event):void {
		var date:Date = new Date();
		if(_gmt>=0){
			_hours = (date.getUTCHours() + _gmt) % 24;
		}else {
			_hours = (24+(date.getUTCHours() + _gmt)) % 24;
		}
		_minutes = date.getUTCMinutes();
		_seconds = date.getUTCSeconds();
		if (_seconds != _preSeconds) {
			dispatchEvent(new Event(SECONDS_CHANGED));
			if (_seconds == 0) {
				dispatchEvent(new Event(MINUTES_CHANGED));
				if (_minutes == 0) {
					dispatchEvent(new Event(HOURS_CHANGED));
				}
			}
		}
		_preSeconds = _seconds;
	}
	public function get hours():int { return _hours; }
	public function get minutes():int { return _minutes; }
	public function get seconds():int { return _seconds; }
	public function get milliseconds():int { return (new Date()).getUTCMilliseconds(); }
	
	public function get hoursUpper():int { return _hours / 10; }
	public function get minutesUpper():int { return _minutes / 10; }
	public function get secondsUpper():int { return _seconds / 10; }
	
	public function get hoursLower():int { return _hours % 10; }
	public function get minutesLower():int  { return _minutes % 10; }
	public function get secondsLower():int { return _seconds % 10; }
	
	public function get hours2():String { return niketa(_hours); }
	public function get minutes2():String { return niketa(_minutes); }
	public function get seconds2():String { return niketa(_seconds); }
	
	public function get milliseconds2():String { return niketa((new Date()).getUTCMilliseconds() / 10); }
	
	public function get milliseconds3():String { return keta((new Date()).getUTCMilliseconds(), 3); }
	
	private function niketa(num:int):String {
		if (num < 10) {
			return String("0"+num);
		}else {
			return String(num);
		}
	}
	
	private function keta(num:int, keta:int):String {
		var str:String = String(num);
		while(str.length < keta) str = "0" + str;
		return str;
	}
	
	public function get hoursDegree():Number {
		return ((_hours % 12) * 30) + (_minutes / 2) + (_seconds/120);
	}
	public function get minutesDegree():Number {
		return (_minutes * 6) + (_seconds / 10);
	}
	public function get secondsDegree():Number {
		return _seconds * 6;
	}
	
	public function getDifferenceTime(s:int, m:int, h:int):Object {
		var time:Array = [_seconds, _minutes, _hours, 0];
		var dt:Array   = [s, m, h];
		var cap:Array  = [60, 60, 24];
		for(var i:int = 0; i < 3; ++i) {
			time[i] += dt[i];
			if(time[i] < 0) {
				time[i + 1] += Math.floor(time[i] / cap[i]);
				time[i] = time[i] % cap[i] + cap[i];
				continue;
			}
			if(time[i] >= cap[i]) {
				time[i + 1] += Math.floor(time[i] / cap[i]);
				time[i] = time[i] % cap[i];
				continue;
			}
		}
		return { seconds:time[0], minutes:time[1], hours:time[2], date:time[3] };
	}
}




