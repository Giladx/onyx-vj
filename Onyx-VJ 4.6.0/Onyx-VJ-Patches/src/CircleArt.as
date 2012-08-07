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
 * Based on CircleArt code by Lucas Swick (http://summitprojectsflashblog.wordpress.com/author/lucasswick/)
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * version 4.0.493 last modified Fev 21st 2009
 * 
 */
package 
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class CircleArt extends Patch 
	{
		private var _canvasBD:BitmapData;
		private var _canvasBMP:Bitmap;
		private var _circle:Shape;
		private var _tolerance:uint;
		private var _spacing:uint;
		private var _randomizer:uint;
		private var _spread:uint;
		private var _jumpRate:uint;
		private	var _loopCount:uint;
		private var _currentDecayIndex:uint;
		private var _totalDecay:uint;
		
		private var _canvasBlur:BlurFilter;
		private var _blurFilter:BlurFilter;
		private var _rect:Rectangle;
		private var _point:Point;
		
		private var _drawTimer:Timer;
		private const source:BitmapData	= createDefaultBitmap(); 		
		//[Embed(source='../assets/boulePiquante.png' )] private const ImageB: Class;
		[Embed(source='../assets/tree.jpg' )] private const ImageB: Class;
		private const _sourceBD:BitmapData = Bitmap( new ImageB() ).bitmapData;
		private var mx:int = 0;
		private var my:int = 0;

		/**
		 * 	@constructor
		 */
		public function CircleArt()
		{
			Console.output('CircleArt 4.0.493');
			Console.output('Credits to Lucas SWICK');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				
				new ParameterInteger( 'randomizer', 'random size', 1, 300, 235 )
			);
			randomizer = _randomizer;
			init();
		}
	
		// INITIALIZATION ============================================================================================================
		private function init():void {
			createVars();
			createChildren();
			initButtons();
			initEvents();
		}
		
		private function createVars():void {
			
			_canvasBD = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00FFFFFF)
			_canvasBMP = new Bitmap( _canvasBD, "auto", true );
			//addChild( _canvasBMP );
			
			_circle = new Shape();
			
			_tolerance = 0x22;
			_spacing = 1;
			_randomizer = 10;
			_spread = 35;
			_jumpRate = 1;
			_loopCount = 4;
			_currentDecayIndex = 0;
			_totalDecay = 2;
			
			_canvasBlur = new BlurFilter(2, 2, 1);
			_blurFilter = new BlurFilter(1.04, 1.04, 1);
			_rect = new Rectangle(0, 0, _canvasBD.width, _canvasBD.height);
			_point = new Point(0, 0);
			
			// var canvasShadow:DropShadowFilter = new DropShadowFilter(0);
			// _canvasBMP.filters = [canvasShadow];
			
			_drawTimer = new Timer(1, 0);
			_drawTimer.addEventListener( TimerEvent.TIMER, doDraw );
			_drawTimer.start();
		}
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			//bmp2.bitmapData
			//info.source.copyPixels( _canvasBD, DISPLAY_RECT, ONYX_POINT_IDENTITY );
			info.render( _canvasBMP );		
		} 
		
		override public function dispose():void {
			source.dispose();
		}		
		private function createChildren():void {
		}
		
		private function initButtons():void {
			addEventListener( MouseEvent.MOUSE_DOWN, startDraw );
			//addEventListener( MouseEvent.MOUSE_UP, stopDraw );
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
	
		private function initEvents():void {
		}
	
		public function unload(evt:Event=null):void {
		}
		
		// ACTIONS ===================================================================================================================
	
		/**
		 * drawCircle.
		 * @param			xm:uint, ym:uint
		 * @description	
		**/
		private function drawCircle( xm:uint, ym:uint ) : void {
			var x:Number = Math.min( _sourceBD.width, Math.max(0, xm + Math.random() * _randomizer - Math.random() * _randomizer ) );
			var y:Number = Math.min( _sourceBD.height, Math.max(0, ym + Math.random() * _randomizer - Math.random() * _randomizer ) );
	
			var col:Number = _sourceBD.getPixel(x, y);
	
			var bounds:Rectangle = new Rectangle(x, y, _spacing, _spacing);
								
			var i:uint;
			var col2:uint
			var w:uint = _sourceBD.width;
			var h:uint = _sourceBD.height;
			
			var minX:uint = x - _spread;
			var minY:uint = y - _spread;
			var maxX:uint = x + _spread;
			var maxY:uint = y + _spread;
	
			//left
			for (i = x - _jumpRate; i > minX; i -= _jumpRate) {
				col2 = _sourceBD.getPixel(i, y);
				if ( discreetColors( col, col2, _tolerance ) ) {
					bounds.left = i;
					break;
				}
			}
			
			//right
			for (i = x + _jumpRate; i < maxX; i += _jumpRate) {
				col2 = _sourceBD.getPixel(i, y);
				if ( discreetColors( col, col2, _tolerance ) ) {
					bounds.right = Math.max(_spacing, i);
					break;
				}
			}
			
			//top
			for (i = y - _jumpRate; i > minY; i -= _jumpRate) {
				col2 = _sourceBD.getPixel(x, i);
				if ( discreetColors( col, col2, _tolerance ) ) {
					bounds.top = i;
					break;
				}
			}
			
			//bottom
			for (i = y + _jumpRate; i < maxY; i += _jumpRate) {
				col2 = _sourceBD.getPixel(x, i);
				if ( discreetColors( col, col2, _tolerance ) ) {
					bounds.bottom = Math.max(_spacing, i);
					break;
				}
			}
			
			var width:Number = bounds.width;
			var height:Number = bounds.height;
			var scale:Number = Math.max( _spacing, Math.min( width, height ) );
	
			var halfSize:uint = Math.max(2, scale / 2);
			_circle.graphics.clear();
			_circle.graphics.lineStyle(0, col, .9 );
			_circle.graphics.drawCircle(0, 0, halfSize);
			
			var mtx:Matrix = new Matrix();
			mtx.translate( bounds.left + bounds.width / 2, bounds.top + bounds.height / 2 );
			
			_circle.filters = [];
			
			// take a 'snapshot'
			_canvasBD.draw( _circle, mtx, null, BlendMode.NORMAL );
			
			_blurFilter.blurX = scale; 
			_blurFilter.blurY = scale;
			_circle.filters = [_blurFilter];
			
			// draws on FIRE
			_canvasBD.draw( _circle, mtx, null, BlendMode.ADD );
	
		
		}
		
		/**
		 * discreetColors.
		 * @param			col1:uint
		 * @param			col2:uint
		 * @description	
		**/
		private function discreetColors( col1:uint, col2:uint, tolerance:uint) : Boolean {
			// return Math.abs( col1 - col2) > _tolerance;
	
			var r1:uint = col1 >> 16 & 0xff;
			var g1:uint = col1 >> 8 & 0xff;
			var b1:uint = col1 & 0xff;
			
			var r2:uint = col2 >> 16 & 0xff;
			var g2:uint = col2 >> 8 & 0xff;
			var b2:uint = col2 & 0xff;
			
			return ( Math.abs( r1 - r2 ) > tolerance ||
					Math.abs( g1 - g2 ) > tolerance ||
					Math.abs( b1 - b2 ) > tolerance );
			
		}
		
		// SETTERS AND GETTERS =======================================================================================================
		
		
		
		// EVENTS ====================================================================================================================
		private function mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
		}
	
		/**
		 * startDraw.
		 * @param			evt:MouseEvent
		 * @description	
		**/
		private function startDraw(event:MouseEvent) : void {
			mx = event.localX; 
			my = event.localY; 
			
		}
		
		/**
		 * stopDraw.
		 * @param			evt:MouseEvent
		 * @description	
		**/
		/*private function stopDraw(evt:MouseEvent) : void {
			_drawTimer.stop();
		}*/
		
		/**
		 * doDraw.
		 * @param			evt:TimerEvent
		 * @description	
		**/
		private function doDraw(evt:TimerEvent) : void {
			var i:uint;
			var tmx:Number = Math.random() * _randomizer;
			var tmy:Number = Math.random() * _randomizer;
			/*mx += tmx; 
			 
			if ( mx > DISPLAY_WIDTH ) 
			{
				mx = 0;
				my += tmy;
			}
			if ( my < 1 ) my = DISPLAY_HEIGHT;
			*/
			mx += tmx; 
			my -= tmy; 
			if ( mx > DISPLAY_WIDTH ) mx = 0;
			if ( my < 1 ) my = DISPLAY_HEIGHT;
			
			for (i = 0; i < _loopCount; i++) {
				drawCircle( mx, my );
			}
			
			
			// apply a blur to the background
			// applyFilter(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):void
			/* _currentDecayIndex++;
			if (_currentDecayIndex > _totalDecay) {
				_canvasBD.applyFilter( _canvasBD, _rect, _point, _canvasBlur );
				_currentDecayIndex = 0;
			} */
			
			
		}
		public function get randomizer():uint
		{
			return _randomizer;
		}
		
		public function set randomizer(value:uint):void
		{
			_randomizer = value;
		}
	
	}// Class
}
