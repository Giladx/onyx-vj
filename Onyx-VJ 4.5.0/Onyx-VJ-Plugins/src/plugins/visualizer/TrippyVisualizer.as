/**
 * Copyright yabuchany ( http://wonderfl.net/user/yabuchany )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/589J
 */

// forked from Murai's TrippyAtractor

/*
* Free Music Archive: Digi G'Alessio - ekiti son feat valeska - april deegee rmx 
* http://creativecommons.org/licenses/by-nc-nd/3.0/
*/
package plugins.visualizer {
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	public final class TrippyVisualizer extends Visualizer  {
		
		
		private const N:uint = 50000;
		//private const N:uint = 10000;
		
		private var _a:Number;
		private var _b:Number;
		private var _c:Number;
		private var _d:Number;
		
		//private var _va:Number = 1.0;
		private var _va:Number = 10;
		//private var _vb:Number = 1.0;
		private var _vb:Number = 10;
		//private var _vc:Number = 1.0;
		private var _vc:Number = 10;
		//private var _vd:Number = 1.0;
		private var _vd:Number = 10;
		
		private var _head:Particle;
		
		private var _canvas:BitmapData;
		/*private var _w:uint;
		private var _h:uint;*/
		
		//private var snd:Sound;
		private var FFTswitch:Boolean = true;
		private var count:int;
		private var vol:Number;
		private var bmp:Bitmap;
		//private var hex:uint=0x0;
		private var hex:uint=0xff358b;
		
		//private var _trans:ColorTransform = new ColorTransform(1, 1, 1, 1, 0x4F, 0x4F, 0x4F);
		private var _trans:ColorTransform = new ColorTransform(0, 0, 0, 0, 0, 0, 0);
		private var bytes:ByteArray;
		
		private var myBlur:BlurFilter = new BlurFilter(80, 20);
		private var myGlow:GlowFilter = new GlowFilter(0xffff00,0.8,32, 32);
		
		public function TrippyVisualizer() {

			
			/*_w = 600;
			_h = 600;*/
			
			count = 0;
			
			/////
			
			
			var o:Particle = _head = new Particle();
			
			for (var i:uint = 0; i < N; ++i) {    // Nã¯ãƒ‘ãƒ¼ãƒ†ã‚£ã‚¯ãƒ«ã®æ•°
				o = o.next = new Particle();
			}
			
			//_canvas = new BitmapData(_w, _h, false, 0xffffff);
			_canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000);
			bytes = new ByteArray();
			
			
			bmp = new Bitmap(_canvas);    
			bmp.filters = [myBlur];
			bmp.x = DISPLAY_WIDTH / 2 - bmp.width / 2;
			bmp.y = DISPLAY_HEIGHT / 2 - bmp.height / 2;
			

		}
		
		private function _reset():void {
			
			_a = (Math.random() - 0.5) * 3;
			_b = (Math.random() - 0.5) * 3;
			_c = (Math.random() - 0.5) * 6;
			_d = (Math.random() - 0.5) * 6;
			//if (Math.abs(_a) < 0.8) _a += 0.8 * _a / Math.abs(_a);
			if (Math.abs(_a) < 0.2) _a += 0.2 * _a / Math.abs(_a);
			//if (Math.abs(_b) < 0.8) _b += 0.8 * _b / Math.abs(_b);
			if (Math.abs(_b) < 0.8) _b += 0.8 * _b / Math.abs(_b);
			//if (Math.abs(_c) < 1.0) _c += 1.0 * _c / Math.abs(_c);
			if (Math.abs(_c) < 2.0) _c += 2.0 * _c / Math.abs(_c);
			//if (Math.abs(_d) < 1.0) _d += 1.0 * _d / Math.abs(_d);
			if (Math.abs(_d) < 1.0) _d += 1.0 * _d / Math.abs(_d);
			
			var p:Particle = _head;
			do {
				p.x0 = (Math.random() - 0.5) * 2;
				p.y0 = (Math.random() - 0.5) * 2;
			}
			while (p = p.next);
		}

		
		private function change():void {
			// colorå¤‰æ›´ã®ãƒ‡ãƒ¼ã‚¿
			//hex = [0x000000,0x333333,0xff358b,0x01b0f0,0xaeee00][count++ % 5];//A
			hex = [0x666666,0x999999,0xcccccc][count++ % 5];//A
			_reset();
			
		}

		
		override public function render(info:RenderInfo):void  {
			_canvas.lock();
			
			_canvas.colorTransform(_canvas.rect, _trans);
			//_canvas.colorTransform(_canvas.rect, 0x000000);
			var p:Particle = _head;
			do {
				p.x1 = Math.sin(_a * p.y0) + _c * Math.cos(_a * p.x0) + Math.random() * 0.008;
				//p.y1 = Math.sin(_b * p.x0) + _d * Math.cos(_b * p.y0) + Math.random() * 0.001;
				p.y1 = Math.cos(_b * p.x0) + _d * Math.sin(_b * p.y0) + Math.random() * 0.001;
				
				p.x0 = p.x1;
				p.y0 = p.y1;
				
				_canvas.setPixel(DISPLAY_WIDTH / 2 + p.x1 * 30, DISPLAY_HEIGHT / 2 + p.y1 * 200, hex);
			}
			while (p = p.next);
			
			_canvas.unlock();
			
			if (_a < -3.0) _va = 2.0; else if (_a > 3.0) _va = -2.0;
			//if (_a < -3.0) _va = 5; else if (_a > 3.0) _va = -5;
			if (_b < -3.0) _vb = 1.0; else if (_b > 3.0) _vb = -1.0;
			//if (_b < -3.0) _vb = 5; else if (_b > 3.0) _vb = -5;
			if (_c < -3.0) _vc = 1.0; else if (_c > 3.0) _vc = -1.0;
			//if (_c < -3.0) _vc = 5; else if (_c > 3.0) _vc = -5;
			if (_d < -3.0) _vd = 2.0; else if (_d > 3.0) _vd = -2.0;
			//if (_d < -3.0) _vd = 5; else if (_d > 3.0) _vd = -5;
			//_a += _va * 0.002;
			_a += _va * 0.010;
			//_b += _vb * 0.004;
			_b += _vb * 0.004;
			//_c += _vc * 0.008;
			_c += _vc * 0.008;
			//_d += _vd * 0.010;
			_d += _vd * 0.002;
			bytes.clear();
			SoundMixer.computeSpectrum(bytes, FFTswitch, 0);
			vol = bytes.readFloat();
			if(vol > 1)change();//A
			
			for (var i:int = 0; i < 1; i++) {
				vol = bytes.readFloat();
			}
			info.render( _canvas );
		}
	}
}

internal class Particle {
	public var x1:Number;
	public var y1:Number;
	public var x0:Number;
	public var y0:Number;
	public var next:Particle;
}
