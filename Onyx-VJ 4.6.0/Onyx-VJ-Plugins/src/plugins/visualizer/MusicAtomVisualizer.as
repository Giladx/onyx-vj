/**
 * Copyright (c) 2003-2011 "Onyx-VJ Team" which is comprised of:
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
 * Based on code by Edik Ruzga
 * 
 */
package plugins.visualizer {
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import org.si.utils.FFT;
	
	public final class MusicAtomVisualizer extends Visualizer 
	{
		private const shape:Shape	= new Shape();
		private var output:BitmapData;

		private var wave:ByteArray;
		private var xx:Number;
		private var yy:Number;
		private var direction:Number = 0;
		private var color:Number = 0;
		

		public var c:uint=0;
		public var steps:uint = 8;
		public var dots:Vector.<Dot>;
		public var bf:BlurFilter = new BlurFilter(2.5,2.5,1);
		
		/**
		 * 	@constructor
		 */
		public function MusicAtomVisualizer():void 
		{
			Console.output("MusicAtomVisualizer, credits to Edik Ruzga" );

			wave = new ByteArray();

			xx = DISPLAY_WIDTH/2;
			yy = DISPLAY_HEIGHT/2;
			dots = new Vector.<Dot>();
			for(var i:uint=0;i<steps;i++)
			{
				dots.push(new Dot(0,0,Math.random()*Math.PI*2));
			}
			output = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0 );
		}	
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void 
		{		
			var graphics:Graphics = shape.graphics;
			graphics.clear();
			
			SoundMixer.computeSpectrum(wave,false);
			
			var spVal:Number;
			var i:uint;
			var inRe:Vector.<Number> = new Vector.<Number>();
			c++;
			if(c%20==0){
				var ct:ColorTransform = new ColorTransform(1,1,1,0.999);
				output.colorTransform(output.rect,ct);
			}
			var halfPos:uint = wave.length/2;
			for(i=0;i<256;i++)
			{
				wave.position = i*4;
				var sp1:Number = wave.readFloat();
				wave.position = i*4+halfPos;
				var sp2:Number=wave.readFloat();
				inRe.push((sp1+sp2)/2);
			}
			var fft:FFT = new FFT(256);
			fft.setData(inRe);
			var spec:FFT = fft.calcRealFFT();
			var res:Vector.<Number> = spec.getData();
			
			var part:uint = 256/steps;
			var shift:uint = 600/(steps+1);
			var pow:Number = -1.8;
			
			for(var j:uint=0;j<steps;j++){
				var sec1:Vector.<Number> = res.splice(0,part);
				var fft2:FFT = new FFT(part);
				fft2.setData(sec1);
				fft2.calcRealIFFT();
				var wave1:Vector.<Number> = fft2.getData();
				var m:Number = (Math.pow(j+1,pow)+0.004)*10;
				var dot:Dot = dots[j];
				dot.alpha*=0.5;
				var d:Number = Math.sin(dot.y*0.05);
				var xx:Number = output.width/2+Math.sin(dot.x*0.05)*200*d;
				var yy:Number = output.height/2+Math.cos(dot.x*0.05)*200*d;
				//graphics.clear();
				graphics.moveTo(xx,yy);
				
				for(i=1;i<part;i++)
				{
					spVal = wave1[i]/m;
					dot.alpha = dot.alpha*0.9 + Math.min(1,Math.abs(spVal*0.5))*0.1;
					dot.direction+=spVal*0.1;
					dot.x+=Math.sin(dot.direction);//*0.5;
					dot.y+=Math.cos(dot.direction);//*0.5;
					graphics.lineStyle(dot.alpha*0.5,HSLtoRGB(1,dot.direction*4,1,0.0001+dot.alpha*0.5));
					d = Math.sin(dot.y*0.05);
					xx = output.width/2+Math.sin(dot.x*0.05)*200*d;
					yy = output.height/2+Math.cos(dot.x*0.05)*200*d;
					graphics.lineTo(xx,yy);				
				}
				output.draw(shape,null,null,BlendMode.ADD);
			}
			output.applyFilter(output,output.rect,output.rect.topLeft,bf);

			info.render( output );
			
		}
		
		
		public function clean():void
		{
			output.fillRect(output.rect,0);
			dots = new Vector.<Dot>();
			for(var i:uint=0;i<steps;i++)
			{
				dots.push(new Dot(0,0,Math.random()*Math.PI*2));
			}
		}
		
		private function HSLtoRGB(a:Number=1,hue:Number=0,saturation:Number=1,lightness:Number=0.5):uint
		{
			a = Math.max(0,Math.min(1,a));
			saturation = Math.max(0,Math.min(1,saturation));
			lightness = Math.max(0,Math.min(1,lightness));
			hue = hue%360;
			if(hue<0)hue+=360;
			hue/=60;
			var C:Number = (1-Math.abs(2*lightness-1))*saturation;
			var X:Number = C*(1-Math.abs((hue%2)-1));
			var m:Number = lightness-0.5*C;
			C=(C+m)*255;
			X=(X+m)*255;
			m*=255;
			if(hue<1) return (C<<16) + (X<<8) + m;
			if(hue<2) return (X<<16) + (C<<8) + m;
			if(hue<3) return (m<<16) + (C<<8) + X;
			if(hue<4) return (m<<16) + (X<<8) + C;
			if(hue<5) return (X<<16) + (m<<8) + C;
			return (C<<16) + (m<<8) + X;
		}
	}
}

//Dot class
import org.si.utils.FFT;
class Dot {
	
	public var x:Number;
	public var y:Number;
	public var dx:Number = 0;
	public var dy:Number = 0;
	public var direction:Number;
	public var color:uint = 0;
	public var alpha:Number = 0;
	
	public function Dot(x:Number,y:Number,direction:Number) {
		this.x = x;
		this.y = y;
		this.direction = direction;
	}
	
}
