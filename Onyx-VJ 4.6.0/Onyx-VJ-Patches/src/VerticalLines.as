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
 * Triangles by Bruce LANE (http://www.batchass.fr)
 * 
 */
package 
{	
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
	
	public class VerticalLines extends Patch
	{
		private var _lineColor:uint			= 0x6f8787;
		private var _fillColor:uint			= 0x5533FF;
		private var _deg:uint				= 0;
		private var _linesnum:int 			= 100;
		private var _xt:int 				= -10;
		private var _yt:int 				= 0;
		private var _size:int 				= 15;
		
		private var bitmap: Bitmap;
		
		private var particles: Array;
		
		private var nextx:int;
		private var nexty:int;
		private var prevx:int;
		private var prevy:int;
		private var angle:Number;
		private var i:int;
		private var container:Sprite = new Sprite;    
		
		
		public function VerticalLines()
		{
			Console.output('VerticalLines by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterColor('lineColor', 'Line Color'),
				new ParameterColor('fillColor', 'Fill Color'),
				new ParameterInteger('deg', 'Degrees', 0, 360, _deg),
				new ParameterExecuteFunction('createVerticalLines', 'Create'),
				new ParameterInteger( 'size', 'size', 10, 1000, _size ),
				new ParameterInteger( 'xt', 'x translation', -100, 100, _xt ),
				new ParameterInteger( 'yt', 'y translation', -100, 100, _yt ),
				new ParameterInteger( 'linesnum', '# of lines', 1, 1000, _linesnum )
			) 
			init();
		}
		
		private function init(): void
		{
			container = new Sprite();
			
		}
		public function createVerticalLines():void
		{
			for ( var i:int=0; i< _linesnum; i++ )
				createLine(i);
		}
		public function createLine( lineNum:int ):void
		{
			var line:Sprite = new Sprite();

			nextx = lineNum * size * 2;
			
			//Console.output(nextx + "-"+nexty);
			line.graphics.beginFill( fillColor );
			line.graphics.drawRect( nextx, nexty, size, DISPLAY_HEIGHT );
			
			line.graphics.endFill();
			container.addChild( line );
			
		}
		
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			var source:BitmapData = info.source;
			info.matrix.translate( xt/1000, yt );
			source.draw( container, info.matrix, null, null, null, true );
			info.source.copyPixels(source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
		override public function dispose():void 
		{
			//source.dispose();
		}		
		public function set linesnum(value:int):void 
		{
			_linesnum = value;
		} 
		public function get linesnum():int 
		{
			return _linesnum;
		} 		
				
		
		public function get fillColor():uint
		{
			return _fillColor;
		}
		
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		public function get lineColor():uint
		{
			return _lineColor;
		}
		
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
		}
		public function get deg():uint
		{
			return _deg;
		}
		
		public function set deg(value:uint):void
		{
			_deg = value;
		}
		public function get size():int
		{
			return _size;
		}
		
		public function set size(value:int):void
		{
			_size = value;
		}
		public function get xt():int
		{
			return _xt;
		}
		
		public function set xt(value:int):void
		{
			_xt = value;
		}
		public function get yt():int
		{
			return _yt;
		}
		
		public function set yt(value:int):void
		{
			_yt = value;
		}
		
	}
}