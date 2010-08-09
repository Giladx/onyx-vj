/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 *  
 * plug-in for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * version 4.0.504 last modified March 6th 2009
 */
package library.patches {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	[SWF(width='320', height='240', frameRate='24', backgroundColor='#FFFFFF')]
	public class BatchassPerlin extends Patch 
	{
		private var _baseX:int = 200;
		private var _baseY:int = 25;
		private var _octaves:int = 2;
		private var _seed:int = Math.floor(Math.random()*10);
		private var _stitch:Boolean = false;
		private var _fractal:Boolean = true;
		private var _grayScale:Boolean = false;
		private var _channels:int = 7;
		private var _xSpeed:int = 2;
		private var _ySpeed:int = 5;
		private var point1:Point = new Point(0, 0);
		private var point2:Point = new Point(0, 0);
		private var offset:Array = [point1, point2];		
		private const source:BitmapData	= createDefaultBitmap(); 		
		/**
		 * 	@constructor
		 */
		public function BatchassPerlin():void {
			Console.output('Batchass Perlin Noise 4.0.504');
			Console.output('Credits to Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterInteger( 'octaves', 'octaves', 1, 10, _octaves ),
				new ParameterInteger( 'channels', 'channels', 1, 100, _channels ),
				new ParameterInteger( 'baseX', 'baseX', 0, DISPLAY_WIDTH, _baseX ),
				new ParameterInteger( 'baseY', 'baseY', 0, DISPLAY_HEIGHT, _baseY ),
				new ParameterInteger( 'xSpeed', 'xSpeed', 0, 40, _xSpeed ),
				new ParameterInteger( 'ySpeed', 'ySpeed', 0, 40, _ySpeed ),
				new ParameterBoolean( 'stitch', 'stitch' ),
				new ParameterBoolean( 'grayScale', 'grayScale' ),
				new ParameterBoolean( 'fractal', 'fractal' )
			) 
		}
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void {
			offset[0].x += _xSpeed;
			offset[1].y += _ySpeed;
			source.perlinNoise(_baseX, _baseY, _octaves, _seed, _stitch, _fractal, _channels, _grayScale, offset);

			info.source.copyPixels(source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		} 
		public function set stitch(value:Boolean):void {
			_stitch = value;
		} 
		public function get stitch():Boolean {
			return _stitch;
		} 		
		public function set grayScale(value:Boolean):void {
			_grayScale = value;
		} 
		public function get grayScale():Boolean {
			return _grayScale;
		} 		
		public function set fractal(value:Boolean):void {
			_fractal = value;
		} 
		public function get fractal():Boolean {
			return _fractal;
		} 		
		public function set channels(value:int):void {
			_channels = value;
		} 
		public function get channels():int {
			return _channels;
		} 		
		public function set octaves(value:int):void {
			_octaves = value;
		} 
		public function get octaves():int {
			return _octaves;
		} 		
		public function set baseX(value:int):void {
			_baseX = value;
		} 
		public function get baseX():int {
			return _baseX;
		} 		
		public function set baseY(value:int):void {
			_baseY = value;
		} 
		public function get baseY():int {
			return _baseY;
		} 		
		public function set xSpeed(value:int):void {
			_xSpeed = value;
		} 
		public function get xSpeed():int {
			return _xSpeed;
		} 		
		public function set ySpeed(value:int):void {
			_ySpeed = value;
		} 
		public function get ySpeed():int {
			return _ySpeed;
		} 		
		override public function dispose():void {
			source.dispose();
		}
	}
}
