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
 * Based on code by André Michelle (http://www.andre-michelle.com)
 * 
 */
package plugins.visualizer {
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	public final class IsometricVisualizer extends Visualizer {

		private var spectrum:Array ;
		private var sprite:Sprite = new Sprite();
		private var source:BitmapData = createDefaultBitmap();
		
		private var output:BitmapData;
		private var peaks:BitmapData;
		private var displace:Matrix;
		private var rect:Rectangle;
		private var gradient:Array;
		private var darken:ColorTransform;
		
		/**
		 * 	@constructor
		 */
		public function IsometricVisualizer():void 
		{
		
			spectrum = SpectrumAnalyzer.getSpectrum(false);
			
			output = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0 );
			peaks = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0xFF000000 );
			
			displace = new Matrix();
			displace.tx = 2;
			displace.ty = -1;
			
			darken = new ColorTransform( 1, 1, 1, 1, -2, -2, -2, 0 );
			
			rect = new Rectangle( 0, 0, 1, 0 );
			
			sprite.addChild( new Bitmap( output ) );
			sprite.addChild( new Bitmap( peaks ) );
			
			gradient = createRainbowGradientArray();
		}
		
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void 
		{
			
			var graphics:Graphics			= sprite.graphics;
			
			graphics.clear();
			
			spectrum = SpectrumAnalyzer.getSpectrum(true);
			
			peaks.fillRect( peaks.rect, 0 );
			
			var value: Number;
			var height: Number;
			
			var smooth: Number;
			
			for( var i: int = 0 ; i < 256 ; i++ )
			{
				value = spectrum[i];
				
				if( i == 0 ) smooth = value;
				else smooth += ( value - smooth ) / 8;
				
				height = 2 + smooth * 0xf0;
				
				rect.x = 8 + i;
				rect.y = 320 + ( i >> 2 ) - height;
				rect.height = height;
				
				peaks.setPixel32( rect.x, rect.y, 0xffffffff );
				
				output.fillRect( rect, 0xff000000 | gradient[i] );
			}
		
			output.draw( output, displace, darken, null, null, true );

			source.draw( sprite );
			
			info.render( source );
		}
		
		private function createRainbowGradientArray(): Array
		{
			var gradient: Array = new Array();
			
			var shape: Shape = new Shape();
			var bmp: BitmapData = new BitmapData( 256, 1, false, 0 );
			
			var colors: Array = [ 0, 0xff0000, 0xffff00, 0x00ff00, 0x00ffff ];
			var alphas: Array = [ 100, 100, 100, 100, 100 ];
			var ratios: Array = [ 0, 16, 128, 192, 255 ];
			
			var matrix: Matrix = new Matrix();
			
			matrix.createGradientBox( 256, 1, 0, 0, 0 );
			
			shape.graphics.beginGradientFill( 'linear', colors, alphas, ratios, matrix );
			shape.graphics.drawRect( 0, 0, 256, 1 );
			shape.graphics.endFill();
			
			bmp.draw( shape );
			
			for( var i: int = 0 ; i < 256 ; i++ )
			{
				gradient[i] = bmp.getPixel( i, 0 );
			}
			
			return gradient;
		}
	}
}
