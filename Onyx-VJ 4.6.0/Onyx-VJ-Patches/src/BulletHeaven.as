/**
 * Copyright onedayitwillmake ( http://wonderfl.net/user/onedayitwillmake )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/7qEG
 */

// forked from coppieeee's Ã?Â?Â?Ã?Â?â?? - Ã?Æ?â??Ã?Æ?Â?Ã?Æ?â??Ã?â?šÂ?Ã?â?šÂ?Ã?Æ?Â?Ã?Â?Â?Ã?Â?Å?Ã?â??Â?Ã?Â?Â?Ã?Â?Â?Ã?Â?â??

package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class BulletHeaven extends Patch 
	{
		private var _bulletImg:Bitmap;
		private var _canvas:BitmapData;
		private var _particles:Vector.<Particle>;
		private var _bulletBitmapData:Vector.<Particle>;
		private var mx:int = 320;
		private var my:int = 240;
		private var _enemy:Particle;
		
		public var bulletBD:BitmapData;
		public var drawMode:String = "copyPixels";
		
		public static var staticBD:BitmapData;
		public static var halfPI	:Number = Math.PI / 2;
		public static var TWO_PI	:Number = Math.PI * 2;
		public function BulletHeaven()
		{
			colorHSV = new ColorHSV(360, 1, 1);
			_canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x00);
			var cb:Bitmap = new Bitmap(_canvas);
			addChild(cb);
			
			_particles = new Vector.<Particle>();

			var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
			g.beginFill(0xfffff, 0.5);
			g.drawCircle(16, 16, 16);
			g.beginFill(0xffffff);
			g.drawCircle(16, 16, 8);
			g.endFill();
			var data:BitmapData = new BitmapData(shape.width, shape.height, true, 0xFFFFFF);
			data.draw(shape);
			staticBD = bulletBD = data;
			_enemy = new Particle(0,0,0,0)//bulletBD.width, bulletBD.height);
			
			_bulletImg = new Bitmap(data);
			_bulletImg.x = _bulletImg.width / 2;
			_bulletImg.y = _bulletImg.height / 2;
			
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			addEventListener( MouseEvent.MOUSE_DOWN, onClick);
		}
		private var _radius:Number = 0;
		private var colorHSV:ColorHSV;
		private function onClick(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
		}		
		private function mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
		}		
		override public function render(info:RenderInfo):void 
		{
			_canvas.lock();
			var cr:Rectangle = new Rectangle(0, 0, _canvas.width, _canvas.height);
			var ct:ColorTransform = new ColorTransform (0.8, 0.8, 0.9);
			_canvas.colorTransform(cr, ct);
			
			//_enemy.ax 
			_enemy.vx = (mx - _enemy.x) * 0.1;
			_enemy.vy = (my - _enemy.y) * 0.1;
			_enemy.x += _enemy.vx;
			_enemy.y += _enemy.vy;
			
			for (var i:int = 0; i < 10; i++ )
			{
				colorHSV.h -= 0.1
				_radius += (TWO_PI / 180) * 11.1;
				var sign :int = 5;
				
				if ((i & 1) == 0) // is even
					sign = ~sign + 1; // turn 3, into -3
				
				var vx:Number = Math.cos(_radius) * sign;
				var vy:Number = Math.sin(_radius) * sign;
				var newP:Particle = new Particle(_enemy.x, _enemy.y, vx, vy, colorHSV.value);
				_particles.push(newP);
			}
			
			var removedParticles:Vector.<Particle> = new Vector.<Particle>();
			
			for each(var p:Particle in _particles)
			{
				p.x += p.vx;
				p.y += p.vy;
				p.vx += p.ax;
				p.vy += p.ay;
				p.time ++;
				
				if (p.x < 0 || p.x > DISPLAY_WIDTH || p.y < 0 || p.y > DISPLAY_HEIGHT)
				{
					removedParticles.push(p);
					continue;
				}
				else if (p.time > 0)
				{
					p.time = 0;
					var radius:Number = Math.atan2(p.vy, p.vx);
					var speed:Number = Math.sqrt(p.vx * p.vx + p.vy * p.vy );
					p.ax = Math.cos(radius + halfPI) * 0.1;
					p.ay = Math.sin(radius + halfPI) * 0.1;
				}
				
				var matrix:Matrix = new Matrix();
				matrix.tx = p.x - _bulletImg.width * 0.5;
				matrix.ty = p.y - _bulletImg.height * 0.5;
				if(drawMode=="draw"){
					_canvas.draw(_bulletImg,matrix);
				}else{
					_canvas.copyPixels(p.image, bulletBD.rect, new Point(p.x-16, p.y-16));
				}
			}
			
			for each(var removedP:Particle in removedParticles)
			{
				var index:int = _particles.indexOf(removedP);
				if (index != -1)
					_particles.splice(index, 1);
			}
			_canvas.unlock();
			info.source.copyPixels( _canvas, DISPLAY_RECT, ONYX_POINT_IDENTITY );
		}
		override public function dispose():void 
		{
			
			_canvas.dispose();
			bulletBD.dispose();
			_particles = null;
		}	
	}
}
import flash.display.BitmapData
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
class Particle
{
	public var x:Number;
	public var y:Number;
	public var vx:Number;
	public var vy:Number;
	public var ax:Number = 0;
	public var ay:Number = 0;
	public var time:Number = 0;
	public var image:BitmapData;
	
	public function Particle(x:Number,y:Number,vx:Number,vy:Number, rgb:int = 0xFFFFFF)
	{
		this.x = x ;
		this.y = y;
		this.vx = vx;
		this.vy = vy;
		image = BulletHeaven.staticBD.clone();
		image.applyFilter(image, image.rect, new Point(), new ColorMatrixFilter(ColorHelper.colorize(rgb)))
		
	}
}


/**
 * Modify the color of an asset without destroying color contrast / shading in the asset.
 * Uses hue/saturation/brightness/contrast to modify a color keeping contrast between colors in the asset intact
 * @version 1.3
 */
internal class ColorHelper
{
	/**
	 * Colorize an asset based on an RGB value
	 * @param	rgb		Hex color value
	 * @param	amount	How much of the original color to keep. [0.0-1.0], 1.0 means none. Range can exceed 1.0 for experimental results
	 */
	public static function colorize(rgb:Number, amount:Number=1):Array
	{
		var r:Number;
		var g:Number;
		var b:Number;
		var inv_amount:Number;
		
		// Found after some googling - @ http://www.faqs.org/faqs/graphics/colorspace-faq/ (ctrl+f luminance)
		var LUMA_R:Number = 0.4086;
		var LUMA_G:Number = 0.7094;
		var LUMA_B:Number = 0.0920;
		
		r = (((rgb >> 16) & 0xFF) / 0xFF);
		g = (((rgb >> 8) & 0xFF) / 0xFF);
		b = ((rgb & 0xFF) / 0xFF);
		
		inv_amount = (1 - amount);
		
		return concat([(inv_amount + ((amount * r) * LUMA_R)), ((amount * r) * LUMA_G), ((amount * r) * LUMA_B), 0, 0,
			((amount * g) * LUMA_R), (inv_amount + ((amount * g) * LUMA_G)), ((amount * g) * LUMA_B), 0, 0, 
			((amount * b) * LUMA_R), ((amount * b) * LUMA_G), (inv_amount + ((amount * b) * LUMA_B)), 0, 0, 
			0, 0, 0, 1, 0]);
	}
	
	/**
	 * Concat two matrices
	 * Could be used to mix colors, but for now it only concacts with an identy matrix
	 * @param	mat	Matrix we want to concact
	 */
	public static function concat( mat:Array ):Array
	{
		// Identity matrix
		var matrix:Array = [1, 0, 0, 0, 0, // RED
			0, 1, 0, 0, 0, // GREEN
			0, 0, 1, 0, 0, // BLUE
			0, 0, 0, 1, 0]; // ALPHA
		
		var temp:Array = new Array();
		
		var i:int = 0;
		var x:int, y:int;
		
		
		// Loop through the matrice
		for (y = 0; y < 4; y++ )
		{
			
			for (x = 0; x < 5; x++ )
			{
				temp[ int( i + x) ] =  Number(mat[i])      * Number(matrix[x]) + 
					Number(mat[int(i + 1)]) * Number(matrix[int(x +  5)]) + 
					Number(mat[int(i + 2)]) * Number(matrix[int(x + 10)]) + 
					Number(mat[int(i + 3)]) * Number(matrix[int(x + 15)]) +
					(x == 4 ? Number(mat[int(i + 4)]) : 0);
			}
			i+=5;
		}
		
		return temp;
	}
}