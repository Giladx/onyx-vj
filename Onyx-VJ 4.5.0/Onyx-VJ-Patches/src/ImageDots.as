/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/vr0s
 */

// forked from bongiovi015's flash on 2011-9-8
package
{
	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import EmbeddedAssets.AssetForImageDots;
	
	public class ImageDots extends Patch {
		public const CIRCLE_SIZE : int = 4;
		public const MAX_DISPLACE : int = 800;
		public var W:int;
		public var H:int;
		private var bmpdText:BitmapData;
		private var bmpdPerlin:BitmapData;
		private var spMask:Sprite = new Sprite;
		private var particles:Array = [];
		private var isOpen:Boolean = true;
		private var bmp:Bitmap;
		
		public var seed:int = Math.floor(Math.random() * 0xFFFF);
		public var offset:Array = [new Point, new Point];
		public var perlinOffset : Number = MAX_DISPLACE;
		private var bmpd:BitmapData;
		private var sprite:Sprite;
		private var _text:String = "batchass";
		
		public function ImageDots()
		{
			Console.output('ImageDots v 0.0.1');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterString('text', 'text')
			);
			sprite = new Sprite();
			addChild(sprite);
			
			var mtx:Matrix = new Matrix;
			mtx.createGradientBox(DISPLAY_WIDTH, DISPLAY_HEIGHT);
			graphics.beginGradientFill(GradientType.RADIAL, [0x333333, 0x111111], [1, 1], [0, 255], mtx);
			graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			graphics.endFill();

			bmpd = new AssetForImageDots();
			
			bmp = new Bitmap(bmpd);
			sprite.addChild(bmp);
			_createText();
			W = bmpdText.width;
			H = bmpdText.height;
			spMask.x = (DISPLAY_WIDTH - W) * .5;
			spMask.y = (DISPLAY_HEIGHT - H) * .5;
			bmpdPerlin = new BitmapData(W/2, H/2, false);
			_createParticles();
			
			sprite.addChild(spMask);
			bmp.mask = spMask;
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onClick);
			_onClick();
		}
		
		override public function render(info:RenderInfo):void 
		{			
			bmpdPerlin.perlinNoise(W/2, H/2, 4, seed, false, true, 7, false, offset);
			spMask.graphics.clear();
			
			for each(var p:Particle in particles) {
				spMask.graphics.beginFill(0xFFFFFF, 1);
				var tx:Number = p.x;
				var ty:Number = p.y;
				var color:uint = bmpdPerlin.getPixel(tx/2, ty/2);
				var r:Number = ((color >> 16 & 0xFF) / 0xFF - .5) * perlinOffset;
				var g:Number = ((color >> 8 & 0xFF) / 0xFF - .5) * perlinOffset;
				var b:Number = Math.floor((color & 0xFF) / 0xFF * 100) / 100;
				b = Math.pow(b, 2);
				tx += r*2;
				ty += g*3;
				spMask.graphics.drawCircle(tx, ty, CIRCLE_SIZE * b * (1 - perlinOffset / MAX_DISPLACE) * 2);                    
				spMask.graphics.endFill();
			}
			
			
			const SPEED:int = 2;
			offset[0].x += SPEED;
			offset[1].y += SPEED;
			info.render( sprite );		
		}
		
		
		private function _onClick(e:MouseEvent=null) : void {
			const duration : Number = 3;
			if(isOpen) Tweener.addTween(this, {time:duration, transition:"easeOutCubic", perlinOffset:1});
			else Tweener.addTween(this, {time:duration/2, transition:"easeInCubic", perlinOffset:MAX_DISPLACE});
			
			isOpen = !isOpen;
		}
		
		
		private function _createParticles():void 
		{
			var i:int;
			var j:int;
			particles = [];
			/*var k:int;
			
			for(k=0;k<H; k+=CIRCLE_SIZE/2) 
			{*/
			for(j=0;j<H; j+=CIRCLE_SIZE/2) 
			{
				for(i=0;i<W; i+=CIRCLE_SIZE/2) 
				{
					var color:uint = bmpdText.getPixel32(i, j);
					if( (color >> 24 & 0xFF) > 0x1F) {
						var p:Particle = new Particle;
						p.x = i;
						p.y = j;
						//p.z = k;
						particles.push(p);
					} 
					
				}                
			}
			/*}*/
		}
		
		private function _createText():void {
			var tf:TextField = new TextField;
			var format:TextFormat = new TextFormat("Arial Black", 60, 0xFFFFFF);
			tf.defaultTextFormat = format;
			tf.text = _text;
			tf.autoSize = "left";
			bmpdText = new BitmapData(tf.width+70, tf.height+70, true, 0);
			bmpdText.draw(tf);
		}
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = value;
			_createText();
			_createParticles();
		}
		override public function dispose():void {
			bmpd.dispose();
			bmpdPerlin.dispose();
			bmpdText.dispose();
		}
	}
}


class Particle 
{
	public var x : Number = 0;
	public var y : Number = 0;
	public var z : Number = 0;
	
	public function Particle():void 
	{ 
		
	}
}

