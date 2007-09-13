/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package visualizer {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;

	public final class SpectrumVisualizer extends Visualizer {
		
		public var height:int		= 200;
		private var _shape:Shape	= new Shape();
		
		/**
		 * 	@constructor
		 */
		public function SpectrumVisualizer():void {
			super(
				new ControlInt('height', 'height', 100, 300, height)
			)
		}
		
		/**
		 * 
		 */
		override public function render():RenderTransform {
			var transform:RenderTransform	= RenderTransform.getTransform(_shape);
			var step:Number					= BITMAP_WIDTH / 127;
			var graphics:Graphics			= _shape.graphics;
			
			graphics.clear();
			
			var analysis:Array = SpectrumAnalyzer.getSpectrum(true);
			
			for (var count:int = 0; count < analysis.length; count++) {
				var value:Number	= analysis[count];
				var color:uint		= 0xFFFFFF * value;
				graphics.beginFill(color);
				graphics.drawCircle(count * 2.5, 120, value * 100);
				graphics.endFill();
			}

			return transform;
		}
		
		/*
			SoundMixer.computeSpectrum(ba,true);
			var i:int;
			var j:int;
			var tempValue : Number;
			for (i=0; i<512; i++) {
				levels[i] = ba.readFloat();
			}
			mc.graphics.clear();
			//
			for (i=0; i < 256; i++) {
				colors[i] = RGB2Hex(255-i,i,time);
			}
			angle += Math.PI/600;
			//
			var showed:uint = 0;
			for (i=0; i < 256; i++) {
				var tempLevel_ : Number = (levels[i] + levels[i+256])/2;
				var level_ : Number = tempLevel_*70+60;
				var rad_ : Number = 2*Math.PI*i/256+angle;
				mc.graphics.lineStyle(5,colors[i],tempLevel_*1.3);
				// moving to first point so we don't have live from 0,0 point
				if (showed==0) {
					showed = 1;
					mc.graphics.moveTo(Math.cos(rad_)*level_+275,Math.sin(rad_)*level_+200);
				}
				// drawing line and moving it to last connected point
				mc.graphics.lineTo(Math.cos(rad_)*level_+275,Math.sin(rad_)*level_+200);
				mc.graphics.moveTo(Math.cos(rad_)*level_+275,Math.sin(rad_)*level_+200);
		
			}
			time++;
			if (time == 256) {
				time = 0;
			}
			//Draw original Image on BMP
			bmp.draw(mc, null, null, "add");
			buffer.draw(bmp, null, colTrans);//Save image to buffer
			var firstRect:Rectangle = new Rectangle(0,0,550,400);
			buffer.applyFilter(buffer, firstRect, new Point(0, 0), colorFilter);//Apply fadeout
			bmp.draw(buffer, trans_m);//Transform buffer and draw on BMP
	*/
	}
}

/*

import fl.motion.*;
import flash.filters.*;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;


stage.scaleMode = StageScaleMode.NO_SCALE;


//
var url:String="song.mp3";
var request:URLRequest=new URLRequest(url);
var s:Sound=new Sound;
s.load(request);
var song:SoundChannel=s.play();
song.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);


var ba:ByteArray=new ByteArray;
var mc:MovieClip=new MovieClip;
mc.y = 200;

var levels : Array = new Array();
var i:uint = 0;
var colors : Array = new Array();
var toY:Number = 0;
var colTrans:ColorTransform = new ColorTransform(1,1,1,1);
var time:uint = 0;
var angle:Number = 0;



addEventListener(Event.ENTER_FRAME, processSound);

mc.visible = false;//No need to be visible


var bmp:BitmapData = new BitmapData(550, 400, false, 0x000000);//Visible BMP Data Object
var buffer:BitmapData = new BitmapData(550, 400, false, 0x000000);//Used to save old image for transformation

var efxStageBmp:Bitmap =new Bitmap(bmp);
efxStageBmp.x = 0;
efxStageBmp.y = 0;
addChild(efxStageBmp);

//Add Blur effect to the original MC
mc.filters = [new BlurFilter(2,2,2)];


//Fadeout Effect
var f:Number = -2;
var colorFilter: ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,f, //Adds f to each color channel
 0,1,0,0,f,
 0,0,1,0,f,
 0,0,0,1,1]);

//addChild(mc);



function RGB2Hex(r, g, b ):uint {
	var hex : uint = r << 16 ^ g << 8 ^ b;
	return hex;
}

function soundCompleteHandler(event:Event):void {
	song.stop();
	song=s.play();
	song.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
}
function processSound(event:Event):void {
	SoundMixer.computeSpectrum(ba,true);
	var i:int;
	var j:int;
	var tempValue : Number;
	for (i=0; i<512; i++) {
		levels[i] = ba.readFloat();
	}
	mc.graphics.clear();
	//
	for (i=0; i < 256; i++) {
		colors[i] = RGB2Hex(255-i,i,time);
	}
	angle += Math.PI/600;
	//
	var showed:uint = 0;
	for (i=0; i < 256; i++) {
		var tempLevel_ : Number = (levels[i] + levels[i+256])/2;
		var level_ : Number = tempLevel_*70+60;
		var rad_ : Number = 2*Math.PI*i/256+angle;
		mc.graphics.lineStyle(5,colors[i],tempLevel_*1.3);
		// moving to first point so we don't have live from 0,0 point
		if (showed==0) {
			showed = 1;
			mc.graphics.moveTo(Math.cos(rad_)*level_+275,Math.sin(rad_)*level_+200);
		}
		// drawing line and moving it to last connected point
		mc.graphics.lineTo(Math.cos(rad_)*level_+275,Math.sin(rad_)*level_+200);
		mc.graphics.moveTo(Math.cos(rad_)*level_+275,Math.sin(rad_)*level_+200);

	}
	time++;
	if (time == 256) {
		time = 0;
	}
	//Draw original Image on BMP
	bmp.draw(mc, null, null, "add");
	buffer.draw(bmp, null, colTrans);//Save image to buffer
	var firstRect:Rectangle = new Rectangle(0,0,550,400);
	buffer.applyFilter(buffer, firstRect, new Point(0, 0), colorFilter);//Apply fadeout
	bmp.draw(buffer, trans_m);//Transform buffer and draw on BMP
}

*/