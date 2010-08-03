/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
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
 * Based on Branches code by Pierluigi PESENTI (http://blog.oaxoa.com/)
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * 
 */
package library.patches {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;

	
	[SWF(width='320', height='240', frameRate='24', backgroundColor='#00FFFF')]
	final public class DrawBranches extends Patch 
	{
		private const source:BitmapData	= createDefaultBitmap(); 
		private const branches:Array = [];
		public var  amount:int = 10;
		private var last:Point = new Point(0, 0);
		public var lineColor:uint			= 0x5533FF;
		private var _currentBlur:Number		= 0;
		private const filter:BlurFilter		=  new BlurFilter(0, 0);
		public var preblur:Number			= .4;
		
		/**
		 * 	@constructor
		 */
		public function DrawBranches()
		{
			Console.output('DrawBranches 4.0.510');
			Console.output('Credits to Pierluigi PESENTI');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters( 
				new ParameterColor('lineColor', 'lineColor'),
				new ParameterNumber('preblur', 'preblur', 0, 30, 0, 10),
				new ParameterNumber('amount', 'max branches', 0, 99, 0, 1)
			);
			//buildBranches();
			addEventListener(InteractionEvent.MOUSE_DOWN, mouseDown);
		}



		private function mouseDown(event:MouseEvent):void {
			
			addEventListener(InteractionEvent.MOUSE_MOVE, _mouseMove);
			
			last.x = event.localX;
			last.y = event.localY;
			lineColor+=30;
			buildBranches();
			_mouseMove(event);
		}
		private function _mouseMove(event:MouseEvent):void {
			last.x = event.localX;
			last.y = event.localY;
			buildBranches();
		}
		override public function render(info:RenderInfo):void {
			_currentBlur	+= preblur;
			var factor:int = _currentBlur - 2;
			if (_currentBlur >= 2) _currentBlur = 0;
			filter.blurX = factor + 2;
			filter.blurY = factor + 2;
			source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, filter);
			for each (var branch:Branch in branches) {
				if ( !branch.ended ) branch.render(source);
				
			}
			// copy to the layer
			info.source.copyPixels(source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}  
		
		private function buildBranches():void {
			var newBranch:Branch = new Branch();
			newBranch.xSrc = last.x;
			newBranch.ySrc = last.y;
			newBranch.lineColor = lineColor;
			branches.push(newBranch);
			
			while (branches.length > amount) {
				var branch:Branch = branches.shift();
				branch.dispose();
			}  
		}
		
		override public function dispose():void {

			source.dispose();
			
			for each (var branch:Branch in branches) {
				branch.dispose();
			}
			removeEventListener(InteractionEvent.MOUSE_MOVE, _mouseMove);
			removeEventListener(InteractionEvent.MOUSE_DOWN, mouseDown);
		}		
	}// Class
} //Package

//Branch class
import flash.events.Event;
import flash.geom.Point;

import flash.filters.BevelFilter;
import flash.display.*;
import onyx.core.*;
import onyx.plugin.*;
import flash.geom.Matrix;
import flash.media.Microphone;
final class Branch extends Sprite implements IDisposable {
	
	private var power:Number;
	private var decay:Number;
	private var seed:uint=Math.random()*999;
	private var bd:BitmapData;
	private var bmp:Bitmap;
	private var offsets:Array;
	
	private var line:Sprite;
	private var tx:Number;
	private var ty:Number;
	
	private var angle:Number;
	private var angleRadians:Number;
	
	private var maxRotSpeed:Number=50;
	
	private var colorValue:uint;
	private var rotSpeed:Number;
	
	private var r:Number;
	private var lum:uint;
	private var grey:uint;
	
	private var bevel:BevelFilter;
	private var perlinSize:Number;
	public var lineColor:uint = 0xFF0000;
	public var xSrc:int = 160;
	public var ySrc:int = 120;
	public var ended:Boolean = false;
		
	private const matrix:Matrix	= new Matrix();

	public function Branch(pperlinSize:Number=20) {
		perlinSize=pperlinSize;
		bd=new BitmapData(1, 1, false);
		bmp=new Bitmap(bd);
		
		offsets=[new Point(0,0), new Point(0,0)];
		
		lum=Math.random()*255;
		grey=lum<<16 | lum<<8 |lum;
		tx=ty=0;
		angle=Math.random()*360;
		power=Math.random()*8;
		decay=(90+Math.random()*9)/100;
		lum=Math.random()*255;
		
		line=new Sprite();
		line.graphics.moveTo(0,0);
		addChild(line);
	}
	

	public function render(source:BitmapData):void {
		matrix.a = 1;//Scale
		matrix.b = 0;
		matrix.c = 0;
		matrix.d = 1;//Scale
		matrix.tx = xSrc;
		matrix.ty = ySrc;
		for(var i:uint=0; i<3; i++) grow();
		source.draw(line, matrix, null, null, null, true);
	}
	public function grow():void {
		power*=decay;
		r=power;

		if(r<.3) stopThis();
		offsets[0].x+=1;
		offsets[0].y-=.4;
		
		offsets[1].x-=.3;
		offsets[1].y=.1;
		
		bd.perlinNoise(perlinSize, perlinSize, 2, seed, false, true, 7, true, offsets);
		colorValue=bd.getPixel(0,0)>>16;
		rotSpeed=(-128+colorValue)/255*maxRotSpeed;

		angle+=rotSpeed;
		angleRadians=angle/180*Math.PI;

		tx+=Math.cos(angleRadians)*power;
		ty+=Math.sin(angleRadians)*power;
		
		line.graphics.lineStyle(r*1.5, lineColor);
		line.graphics.lineTo(tx,ty);
	}
	
	public function stopThis():void {
		ended = true;
		dispatchEvent(new Event(Event.COMPLETE));
	}
	public function dispose():void {
		line = null;
		graphics.clear();
	}
}

