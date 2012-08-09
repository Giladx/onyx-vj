/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
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
 * Copyright nontsu ( http://wonderfl.net/user/nontsu )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/aJRR  
 */
package plugins.visualizer 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.PixelSnapping;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	public final class ClassicVisualizer extends Visualizer 
	{
		private var numRectangleWidth:Number     = 60;//2.734375;
		private var uintRectangleHeight:uint     = 400;//200;
		private var uintMP3ChannelSize:uint        = 12;//256;
		
		private var bdMirrorImage:BitmapData    = new BitmapData(700, uintRectangleHeight, true, 0x00000000);
		private var bmpMirrorImage:Bitmap        = new Bitmap(bdMirrorImage, PixelSnapping.AUTO, true);
		
		private var matBlendMatrix:Matrix         = new Matrix();
		private var arrBlendColors:Array         = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
		private var arrBlendLeftAlphas:Array     = [1, 1, 1, 1, 1, 1, 1];
		private var arrBlendRightAlphas:Array     = [0.5,0.5,0.5,0.5,0.5,0.5,0.5];
		private var arrBlendRatios:Array         = [0, 42, 84, 126, 168, 210, 255];
		
		private var matMirrorMatrix:Matrix         = new Matrix(1, 0, 0, -1, 0, uintRectangleHeight);
		private var MP3ByteArray:ByteArray         = new ByteArray();
				
		private var sprite:Sprite;
		
		public function ClassicVisualizer() 
		{
			Console.output("ClassicVisualizer, credits to Matt Wakeling" );
			Console.output("http://wonderfl.net/user/Matt_Wakeling" );
			
			sprite = new Sprite();
			matBlendMatrix.createGradientBox(numRectangleWidth, uintRectangleHeight, ((-90 * Math.PI) / 180));
			
			bmpMirrorImage.x         = 0;
			bmpMirrorImage.y         = uintRectangleHeight;
			bmpMirrorImage.scaleY     = 0.5;
			bmpMirrorImage.alpha     = 0.5;
			
			sprite.addChild(bmpMirrorImage);

		}
		
		override public function render(info:RenderInfo):void 
		{
			var numFrequency:Number         = 0;
			
			SoundMixer.computeSpectrum(MP3ByteArray);
			
			sprite.graphics.clear();
			
			for (var uintLeftCount:uint = 0; uintLeftCount < uintMP3ChannelSize; uintLeftCount++)
			{
				numFrequency = Math.abs(MP3ByteArray.readFloat());
				
				sprite.graphics.lineStyle();
				sprite.graphics.beginGradientFill(GradientType.LINEAR, arrBlendColors, arrBlendLeftAlphas, arrBlendRatios, matBlendMatrix, SpreadMethod.REPEAT);
				sprite.graphics.drawRect((uintLeftCount * numRectangleWidth), uintRectangleHeight, Math.floor(numRectangleWidth), -(numFrequency * uintRectangleHeight));
				sprite.graphics.endFill();
			}
			
			for (var uintRightCount:uint = 0; uintRightCount < uintMP3ChannelSize; uintRightCount++)
			{
				numFrequency = Math.abs(MP3ByteArray.readFloat());
				
				sprite.graphics.lineStyle();
				sprite.graphics.beginGradientFill(GradientType.LINEAR, arrBlendColors, arrBlendRightAlphas, arrBlendRatios, matBlendMatrix, SpreadMethod.REPEAT);
				sprite.graphics.drawRect((uintRightCount * numRectangleWidth), uintRectangleHeight, Math.floor(numRectangleWidth), -(numFrequency * uintRectangleHeight));
				sprite.graphics.endFill();
			}
			
			
			bdMirrorImage.lock();
			bdMirrorImage.fillRect(bdMirrorImage.rect, 0x00000000);
			bdMirrorImage.draw(sprite, matMirrorMatrix, null, null, null, true);
			bdMirrorImage.unlock();
			
			info.render( sprite );
		}
	}
}

