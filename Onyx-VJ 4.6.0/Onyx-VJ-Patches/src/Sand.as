/**
 * Copyright taketaketake ( http://wonderfl.net/user/taketaketake )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/kOJA
 */

// forked from yun's ã??ã??ã??ã??ã??ã??ã??æ??ç??
package {
	
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.BitmapDataChannel;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Sand extends Patch {
		
		private var bmpdata:BitmapData;
		private var colortrans:ColorTransform;
		private var filter:BlurFilter;
		private var vectormap:BitmapData;
		private var particles:Array;
		private var particle_number:uint = 65000;
		private var size:Number = 2000;
		
		public function Sand() {
			// BitmapDataã??ä??æ??ã??ã??è??ç?ºã?ªã??ã??ã??è??å??
			bmpdata = new BitmapData(size, size, false, 0);
			//addChild(new Bitmap(bmpdata));
			// ã??ã??ã??ã??ã??ã??å??æ??å??
			colortrans = new ColorTransform(0.95, 0.99, 0.95);
			filter = new BlurFilter(2, 2, 1);
			// ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??å??æ??å??
			vectormap = new BitmapData(size, size, false, 0);
			reset();

		}
		override public function render(info:RenderInfo):void 
		{
			bmpdata.applyFilter(bmpdata, bmpdata.rect, bmpdata.rect.topLeft, filter);
			bmpdata.colorTransform(bmpdata.rect, colortrans);
			// ã??ã??ã??ã??ã??ã??ã??æ??ç??
			bmpdata.lock();
			for (var i:int = 0; i < particle_number; i++) {
				var p:Particle = particles[i];
				// ã??ã??ã??ã??ã??ã??ã??ã??Pixelå??ã??ã??å??é??åº?ã??ç??å?º
				var col:uint = vectormap.getPixel(p.x, p.y);
				p.ax += ((col >> 16 & 0xff) - 128) * 0.0001;
				p.ay += ((col >> 8 & 0xff) - 128) * 0.0004;
				// å??é??åº?ã??ã??é??åº?ã??ä??ç??ã??ç??å?º
				p.x += p.vx += p.ax;
				p.y += p.vy += p.ay;
				if (p.x > size) { p.x -= size; }
				else if (p.x < 0) { p.x += size; }
				if (p.y > size) { p.y -= size; }
				else if (p.y < 0) { p.y += size; }
				// Pixelã??æ??ç??
				bmpdata.setPixel(p.x, p.y, 0xffffff);
				// å??é??åº?ã??é??åº?ã??æ??è??
				p.ax *= 0.98;    p.ay *= 0.97;
				p.vx *= 0.96;    p.vy *= 0.95;                
			}
			bmpdata.unlock();
			info.render( bmpdata );
		}
		override public function dispose():void {
			
		}
		private function reset(e:MouseEvent = null):void {
			// ã??ã??ã??ã??ã??ã??ã??ã??å??æ??å??
			var randomSeed:int = Math.random() * 0xFFFFFFFF;
			var colors:uint = BitmapDataChannel.RED | BitmapDataChannel.GREEN;
			vectormap.perlinNoise(size/2, size/2, 4, randomSeed, false, true, colors);
			// ã??ã??ã??ã??ã??ã??ã??å??æ??å??
			particles = new Array(particle_number);
			for (var i:int = 0; i < particle_number; i++) {
				particles[i] = new Particle(Math.random() * size, Math.random() * size);
			}                
		}

	}
}

// ã??ã??ã??ã??ã??ã??ã??ã??ã??
class Particle {
	// ä??ç??
	public var x:Number;
	public var y:Number;
	// å??é??åº?
	public var ax:Number = 1;
	public var ay:Number = 1;
	// é??åº?
	public var vx:Number = 1;
	public var vy:Number =0;
	function Particle(px:Number, py:Number) {
		x = px;
		y = py;
	}
}