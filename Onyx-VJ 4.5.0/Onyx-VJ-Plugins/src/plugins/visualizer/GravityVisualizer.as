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
 * Copyright su8erlemon ( http://wonderfl.net/user/su8erlemon )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/mUxE 
 *  
 */
package plugins.visualizer 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import frocessing.color.ColorCMY;
	import frocessing.color.ColorHSL;
	import frocessing.color.ColorHSV;
	import frocessing.color.ColorRGB;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	public final class GravityVisualizer extends Visualizer 
	{
	
		private const MAX_NUM:int = 1;
		
		private var st:Sprite = new Sprite();
		private var output:BitmapData;
		public var bf:BlurFilter = new BlurFilter(19,19,1);
		
		private var startTime:Number;
		private var prevBeat:Number;
				
		private var spectBytes:ByteArray = new ByteArray();
		private var spectrum:Vector.<Number> = new Vector.<Number>(512, true);
		private var spectrumAverage:Number = 0.0;
		
		private var line:Shape = new Shape();
		
		private var col:uint=0xff55ff;
		private var rl:Number=0;
		
		public function GravityVisualizer() 
		{
			init();
		}
		
		private function init():void{
			Console.output("GravityVisualizer, credits to su8erlemon" );
			Console.output("http://wonderfl.net/user/su8erlemon" );
			
			startTime = getTimer();
			prevBeat = 0.0;
			
			output = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0 );
			
			startTime = getTimer();
		}
		
		override public function render(info:RenderInfo):void 
		{
			
			var graphics:Graphics = st.graphics;
			graphics.clear();
			computeSpectrum();
			
			rl += 0.001;
			
			var interval:uint = ( 60 * 1000)/130;
			var current:Number = getTimer() - startTime;
			var beat:uint = int(current/interval*2);
			
			if(int(beat * 0.5) != int(prevBeat * 0.5)){
				
				var v0:int = 20+spectrumAverage * 70;
				
				for(var i:int = 0;i<30;i++)     
				{
					if(v0 > 70)v0=70;
					var rect:Node = new Node(v0*i*0.05,col);
					rect.x = DISPLAY_WIDTH/2;
					rect.y = DISPLAY_HEIGHT/2;            

					st.graphics.clear();
					st.addChild(rect);
				}
			}
			
			prevBeat = beat;
			output.draw(st,null,null,BlendMode.ADD);
		
			output.applyFilter(output,output.rect,output.rect.topLeft,bf);
		
			info.render( output );
		}
		
		
		private function computeSpectrum():void{
			var bytes:ByteArray = spectBytes;
			bytes.position = 0;
			
			SoundMixer.computeSpectrum(bytes, false,65);
			
			var total:Number = 0;
			var plus:Number = 0;
			var pc:uint = 0;
			var minus:Number = 0;
			var mc:uint = 0;
			var numbers:Vector.<Number> = spectrum;
			for (var i:uint = 0; i < 512; ++i) {
				var n:Number = bytes.readFloat() * 2.0;
				total += Math.abs(n);
				if (n > 0) {
					plus += n;
					++pc;
				}
				else if (n < 0) {
					minus += n;
					++mc;
				}
				numbers[i] = n;
			}
			spectrumAverage = total / 256.0;
			
		}
	}
	
}

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.display.Shape;
import flash.display.Graphics;

class Node extends Sprite
{
	private var shape1:Shape = new Shape();
	private var shape1gr:Graphics;
	
	private var t:Number=0;
	private var v:Number = 40;
	private var v0:Number = 40;
	private var col:uint=0xff55ff;
	private const G:Number = 9.8;
	
	public function Node(_v0:Number,_col:uint)
	{
		v0 = _v0;
		shape1gr = shape1.graphics;
		addChild(shape1);
		
		col = _col;
		
		addEventListener(Event.ENTER_FRAME,update);
		shape1.rotation = Math.random()*90;
	}
	
	private function update(w:Event):void
	{   
		t += 0.2;
		
		v = 6 + v0 * t  - (0.5 * G *  t * t);
		
		if(v < 6)
		{
			shape1gr.clear();
			this.parent.removeChild(this);
			removeEventListener(Event.ENTER_FRAME,update);                
		}
		else
		{
			shape1gr.clear();
			shape1gr.beginFill(col,1);
			shape1gr.drawCircle(v,0,4);
			shape1gr.drawCircle(-v,0,4);
			shape1gr.drawCircle(0,v,4);
			shape1gr.drawCircle(0,-v,4);
			shape1gr.endFill();
			shape1.rotation += 1 ;
		}
		
	} 
}