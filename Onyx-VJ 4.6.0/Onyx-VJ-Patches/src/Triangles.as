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
	
	//[SWF(width='460', height='368', frameRate='24', backgroundColor='#FFFFFF')]
	public class Triangles extends Patch
	{
		private var _lineColor:uint			= 0x6f8787;
		private var _fillColor:uint			= 0x5533FF;
		private var _deg:uint				= 0;
		private var _trianglesnum:int 		= 10;
		private var _xt:int 				= 10;
		private var _yt:int 				= 0;
		private var _size:int 				= DISPLAY_HEIGHT/4;
		
		private var bitmap: Bitmap;
		
		private var particles: Array;
		
		private var nextx:int;
		private var nexty:int;
		private var prevx:int;
		private var prevy:int;
		private var angle:Number;
		private var i:int;
		private var container:Sprite = new Sprite;    
		
		
		public function Triangles()
		{
			Console.output('Triangles by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterColor('lineColor', 'Line Color'),
				new ParameterColor('fillColor', 'Fill Color'),
				new ParameterInteger('deg', 'Degrees', 0, 360, _deg),
				new ParameterExecuteFunction('createTriangles', 'Create'),
				new ParameterInteger( 'size', 'size', 10, 1000, _size ),
				new ParameterInteger( 'xt', 'x translation', -100, 100, _xt ),
				new ParameterInteger( 'yt', 'y translation', -100, 100, _yt ),
				new ParameterInteger( 'trianglesnum', '# of triangles', 1, 1000, _trianglesnum )
			) 
			init();
		}
		
		private function init(): void
		{
			container = new Sprite();

		}
		public function createTriangles():void
		{
			for ( var i:int=0; i< trianglesnum; i++ )
				createTriangle(i);
		}
		public function createTriangle( triNum:int ):void
		{


			var tri:Sprite = new Sprite();
			tri.graphics.clear();
			//if ( yt > 0 ) deg = 0;
			//if ( xt > 0 ) deg = 30;
			if ( xt != 0 ) tri.x = ( size * triNum * 1.4 ) -2500;
			if ( yt != 0 ) tri.y = size * triNum else tri.y = 200;
			tri.graphics.beginFill( fillColor, 1 );

			angle = deg * Math.PI / 180;
			nextx = Math.cos(angle) * size;
			nexty = Math.sin(angle) * size;
			tri.graphics.moveTo( nextx, nexty );
			
			for( var degree:int = deg+120; degree < 360; degree += 120)
			{
				angle = degree * Math.PI / 180;
				nextx = Math.cos(angle) * size;
				nexty = Math.sin(angle) * size;
				tri.graphics.lineTo(nextx, nexty);
				//trace("degree:"+degree+" nextx:"+nextx+" nexty:"+nexty);
			}
			tri.graphics.endFill();
			container.addChildAt( tri, 0 );
		}
		
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			var source:BitmapData = info.source;
			info.matrix.translate( xt, yt );
			source.draw( container, info.matrix, null, null, null, true );
			info.source.copyPixels(source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
		override public function dispose():void 
		{
			//source.dispose();
		}		
		public function set trianglesnum(value:int):void 
		{
			_trianglesnum = value;
		} 
		public function get trianglesnum():int 
		{
			return _trianglesnum;
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