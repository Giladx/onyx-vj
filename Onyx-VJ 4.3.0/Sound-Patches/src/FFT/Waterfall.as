package FFT {
		
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import symbols.*;
	
	[SWF(width='480', height='360', frameRate='24')]
	final public class Waterfall extends SoundSpriteFFT {
		
		private var output: BitmapData;
		private var peaks: BitmapData;
		private var displace: Matrix;
		private var rect: Rectangle;
		private var gradient: Array;
		private var darken: ColorTransform;
		
		private var bytes: ByteArray;
		
		public function Waterfall() {
			super();
						
			output = new BitmapData( 480, 360, true, 0 );
			peaks = new BitmapData( 480, 360, true, 0 );
			
			displace = new Matrix();
			displace.tx = 2;
			displace.ty = -1;
			
			darken = new ColorTransform( 1, 1, 1, 1, -2, -2, -2, 0 );
			
			rect = new Rectangle( 0, 0, 1, 0 );
			
			addChild( new Bitmap( output ) );
			addChild( new Bitmap( peaks ) );
			
			//addEventListener( Event.ENTER_FRAME, _onEnterFrame );
			
			graphics.beginFill( 0 );
			graphics.drawRect( 0, 0, 480, 360 );
			graphics.endFill();
			
			gradient = createRainbowGradientArray();
			
		}	
		
		// do some peak interaction here
		override public function onPeak(l:Array,r:Array):void {
		
			peaks.fillRect( peaks.rect, 0 );
			
			//bytes = PluginManager.modules[ID].bytes;
			var value: Number;
			var height: Number;
			
			var smooth: Number;
			
			for(var i:int=0; i<256; i++) {
				value = l[i];
				
				if(i==0) smooth=value;
				else smooth+=(value-smooth)/8;
				
				height = 2 + smooth * 0xf0;
				
				rect.x = 8 + i;
				rect.y = 320 + ( i >> 2 ) - height;
				rect.height = height;
				
				peaks.setPixel32( rect.x, rect.y, 0xffffffff );
				
				output.fillRect( rect, 0xff000000 | gradient[i] );
			}
			
			output.draw( output, displace, darken, null, null, true );
		}
		
		private function createRainbowGradientArray(): Array {
			
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
			
			for( var i: int = 0 ; i < 256 ; i++ ) {
				gradient[i] = bmp.getPixel( i, 0 );
			}
			
			return gradient;
		}
	}
}

