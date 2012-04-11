/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 *  
 * Based on Lines code by André Michelle (http://www.andre-michelle.com)
 * adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * last modified July 28th 2010
 */
package 
{	
	import com.andremichelle.FPS;
	import com.andremichelle.Particle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Lines extends Patch
	{
		private var _lineColor:uint			= 0x5533FF;
		private var _particlesnum:int = 10;
		
		private var bitmap: Bitmap;
		
		private var particles: Array;
		
		private var forceXPhase: Number;
		private var forceYPhase: Number;
		private var red:uint = 0xFF0000;
		private var green:uint = 0x00FF00;
		private var blue:uint = 0x0000FF;	
		
		public function Lines()
		{
			Console.output('Lines');
			Console.output('Credits to Andre Michelle (http://www.andre-michelle.com)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterColor('lineColor', 'Color'),
				new ParameterInteger( 'particlesnum', '# of particles', 1, 1000, _particlesnum )
			) 
			init();
		}
		
		private function init(): void
		{
			var m: Matrix = new Matrix();
			m.createGradientBox( DISPLAY_WIDTH, DISPLAY_HEIGHT, Math.PI/2 );
			
			forceXPhase = Math.random() * Math.PI;
			forceYPhase = Math.random() * Math.PI;
			
			createParticles();
						
			bitmap = new Bitmap( new BitmapData ( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0 ), PixelSnapping.AUTO, false );
			addChild( bitmap );
			
			addChild( new FPS() );
		}
		private function createParticles(): void
		{
			particles = null;
			particles = new Array();
			var particle: Particle;
			
			var a: Number;
			var r: Number;
			
			for( var i: int = 0 ; i < _particlesnum ; i++ )
			{
				a = Math.PI * 2 / _particlesnum * i;
				r = ( 1 + i / _particlesnum * 4 ) * 1;
				
				particle = new Particle( Math.cos( a ) * 32, Math.sin( a ) * 32 );
				particle.vx = Math.sin( -a ) * r;
				particle.vy = -Math.cos( a ) * r;
				particles.push( particle );
			}
			
		}

		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			var bitmapData: BitmapData = bitmap.bitmapData;
			bitmapData.colorTransform( bitmapData.rect, new ColorTransform( 1, 1, 1, 1, 0, 0, 0, -1 ) );
			
			var p0: Particle;
			var p1: Particle;
			
			var dx: Number;
			var dy: Number;
			var dd: Number;
			
			var shape: Shape = new Shape();
			
			shape.graphics.clear();
			shape.graphics.lineStyle( 0, _lineColor, 1 );
			
			forceXPhase += .0025261;
			forceYPhase += .000621;
			
			var forceX: Number = 1000 + Math.sin( forceXPhase ) * 500;
			var forceY: Number = 1000 + Math.sin( forceYPhase ) * 500;
			
			for each( p0 in particles )
			{
				shape.graphics.moveTo( p0.sx, p0.sy );
				
				p0.vx -= p0.sx / forceX;
				p0.vy -= p0.sy / forceY;
				
				p0.sx += p0.vx;
				p0.sy += p0.vy;
				
				shape.graphics.lineTo( p0.sx, p0.sy );
			}
			
			bitmapData.draw( shape, new Matrix( 1, 0, 0, 1, DISPLAY_WIDTH >> 1, DISPLAY_HEIGHT >> 1 ) );
			info.source.copyPixels(bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
		public function set particlesnum(value:int):void {
			_particlesnum = value;
			createParticles();
		} 
		public function get particlesnum():int {
			return _particlesnum;
		} 		
		override public function dispose():void {
			//source.dispose();
		}		

		public function get lineColor():uint
		{
			return _lineColor;
		}

		public function set lineColor(value:uint):void
		{
			_lineColor = value;
		}

	}
}