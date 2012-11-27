/**
 * Copyright Falsv ( http://wonderfl.net/user/Falsv )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/Cm1M
 */

// forked from bradsedito's 3D Perlin Particle's
package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class PerlinParticle3d extends Patch 
	{
		private const MAX_PARTICLES: int = 500;
		private const colorTransform: ColorTransform = new ColorTransform( 0.92, 0.96, 0.94 );
		private var filter: BitmapFilter;
		private const blurFilter:BlurFilter = new BlurFilter(4, 4, 2);
		private const origin: Point = new Point();
		
		private var screen: BitmapData;
		private var forceCalc: BitmapData;
		private var forceField: BitmapData;
		private var forceMatrix: Matrix;
		private var octaves: Array;
		private var p0: Point;
		private var p1: Point;
		private var particles: Particle;
		private var phase0: Number;
		private var phase1: Number;
		private var freq0: Number;
		private var freq1: Number;
		
		public function PerlinParticle3d()
		{
			var scale: Number = 2;
			
			filter = getFadingFilter(0.9);
			
			screen = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0 );
			forceField = screen.clone();
			forceCalc = new BitmapData( screen.width / scale, screen.height / scale, true, 0 );
			forceMatrix = new Matrix();
			forceMatrix.scale( scale, scale );
			
			addChild( new Bitmap( screen ) );
			
			octaves = [
				p0 = new Point(),
				p1 = new Point()
			];
			
			freq0 = 220 / 2000;
			freq1 = 110 / 2000;
			
			phase0 = 0.0;
			phase1 = 0.0;
			
			createParticles();
		}
		
		private function getFadingFilter(alphaMultiplier:Number = 0.5):ColorMatrixFilter
		{
			return new ColorMatrixFilter([
				1, 0, 0, 0, 0, 
				0, 1, 0, 0, 0, 
				0, 0, 1, 0, 0, 
				0, 0, 0, alphaMultiplier, 0 ] );
		}
		
		private function createParticles(): void
		{
			var p: Particle;
			
			var i: int = 0;
			var n: int = MAX_PARTICLES;
			
			p = particles = new Particle();
			
			for(;i<n;++i)
			{
				p = p.next = new Particle();
				initParticle(p);
			}
		}
		
		private function initParticle(p: Particle): void
		{
			p.x = DISPLAY_WIDTH * 0.5;
			p.y = DISPLAY_HEIGHT * 0.5;
			
			p.vx = (Math.random() - Math.random()) * 4;
			p.vy = (Math.random() - Math.random()) * 4;
			
			p.weight = Math.random()*3+0.2;
		}
		
		override public function render(info:RenderInfo):void 
		{
			const width: int = screen.width;
			const height: int = screen.height;
			
			const speed: Number = 0.5;
			
			var ran: Function = Math.random;
			
			phase0 += freq0;
			if( phase0 > 1 ) --phase0;
			
			phase1 += freq1;
			if( phase1 > 1 ) --phase1;
			
			var a0: Number = phase0 * 2 * Math.PI;
			var a1: Number = phase1 * 2 * Math.PI;
			
			var sin0: Number = Math.sin( a0 );
			var cos0: Number = Math.cos( a0 );
			
			var sin1: Number = Math.sin( a1 );
			var cos1: Number = Math.cos( a1 );
			
			p0.x += speed;
			p0.y -= speed;
			p1.x -= speed;
			p1.y += speed;
			
			forceCalc.perlinNoise( 0x40, 0x40, 2, 0xaabbcc, false, true, BitmapDataChannel.GREEN | BitmapDataChannel.BLUE, false, octaves );
			forceField.draw( forceCalc, forceMatrix );
			
			var c: int;
			var p: Particle = particles.next;
			var r: int;
			var g: int;
			var b: int;
			
			do
			{    
				c = forceField.getPixel( p.x, p.y );
				p.vx += (((c & 0xff) - 0x80)/0x80)*p.weight;
				p.vy += ((((c >> 0x08) & 0xff) - 0x80)/0x80)*p.weight;
				
				p.vx *= 0.94;
				p.vy *= 0.94;
				
				p.x += p.vx;
				p.y += p.vy;
				
				if( p.x > width )
				{
					p.vx *= -(1.0 + ran() + ran() + ran() + ran());
					p.vx -= ran() + ran();
					p.x = width - 1;
					
				}
				else
					if( p.x < 0 )
					{
						p.vx *= -(1.0 + ran() + ran() + ran() + ran());
						p.vx += ran() + ran();
						p.x = 0;
					}
				
				if( p.y > height )
				{
					p.vy *= -(1.0 + ran() + ran() + ran() + ran());
					p.vy -= ran() + ran();
					p.y = height - 1;
				}
				else
					if( p.y < 0 )
					{
						p.vy *= -(1.0 + ran() + ran() + ran() + ran());
						p.vy += ran() + ran();
						p.y = 0;
					}
				
				c = screen.getPixel( p.x, p.y );        
				
				if( 0xffffff != c )
				{
					r = ( c >> 0x10 ) & 0xff;
					g = ( c >> 0x08 ) & 0xff;
					b = c & 0xff;
					
					r += 0x80 + cos1 * 0x60;
					g += 0x80;
					b += 0x10 + sin1 * 0x10;
					
					if( r > 0xff ) r = 0xff;
					if( g > 0xff ) g = 0xff;
					if( b > 0xff ) b = 0xff;
					
					screen.setPixel( p.x, p.y, (r<<0x10)|(g<<0x08)|b );
				}
				
				p = p.next;
				
			} while(p);
			
			screen.applyFilter( screen, screen.rect, origin, blurFilter);
			info.source.copyPixels( screen, DISPLAY_RECT, ONYX_POINT_IDENTITY );
		}
	}
}


dynamic class Particle 
{
	public var next: Particle;       
	public var x: Number;
	public var y: Number;       
	public var vx: Number;
	public var vy: Number;
	public var weight: Number;
	
	//TweenMax.to(root.stage, 1, {x:mouseX, y:mouseY, ease:Quad.easeOut});         
}
