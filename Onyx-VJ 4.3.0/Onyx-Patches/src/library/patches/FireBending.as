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
 * Based on FireBending code by Edik RUZGA
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * version 4.0.503 last modified March 6th 2009
 */
package library.patches {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	
	[SWF(width='320', height='240', frameRate='24', backgroundColor='#FFFFFF')]
	public class FireBending extends Patch 
	{
		protected var bd : BitmapData;
		protected var ba : ByteArray;
		protected var position : uint;
		protected var rect : Rectangle;
		protected var _shifter : int;
		protected var blur : BlurFilter;
		private var mx:Number = 0;
		private var my:Number = 0;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private var ang:Number;
		private var dl:Number;
		private var lastX:Number = 0;
		private var lastY:Number = 0;
		private var map:BitmapData;
		private var dm:DisplacementMapFilter;
		private var _color:uint;
		private var p:Sprite;
		private var bmp2:Bitmap;
		private var pallete:Bitmap;
		private var shifts:Array;
		private var shifts2:Array;
		
		private const source:BitmapData	= createDefaultBitmap(); 		
		/**
		 * 	@constructor
		 */
		public function FireBending():void {
			Console.output('FireBending 4.0.503');
			Console.output('Credits to Edik RUZGA');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			_color = 0xFF4400;
			parameters.addParameters(
				new ParameterColor('color', 'color')
			)

			map = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,false,0x888888);
			dm = new DisplacementMapFilter(new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,false,0),
				new Point(),BitmapDataChannel.BLUE,BitmapDataChannel.GREEN,50,50);
			p = new Sprite();	
			shifts = [new Point(),new Point()];
			shifts2 = [new Point(1,1),new Point(1,-1)];
			bmp2 = new Bitmap( map );
			addChild(bmp2);
			/* bmp2.scaleX = 2;
			bmp2.scaleY = 2; */ 
			
			for (var xx:int=0; xx<bmp2.bitmapData.width; xx++) 
			{
				for (var yy:int=0; yy<bmp2.bitmapData.height; yy++) 
				{
					dx = (bmp2.bitmapData.width/2-xx);
					dy = (bmp2.bitmapData.height/2-yy);
					ang = Math.atan2(dx,dy);
					dl = 1 - Math.round( Math.sqrt( dx*dx + dy*dy ) )/ ( bmp2.bitmapData.width*0.45 ) * Math.sin( ang ) * 127 ;
					map.setPixel( xx, yy, int( 127 + dl + int( ( 127 + dl * Math.cos( ang ) * 127 ) << 8 ) ) );
						
				}
			}
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			addEventListener( MouseEvent.MOUSE_UP, mouseUp );
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
		public function set color(value:uint):void {
			_color = value;
		}
		public function get color():uint {
			return _color;
		}
		private function mouseDown(event:MouseEvent):void 
		 {
			buttonMode=true;
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);		 
		} 
		private function mouseUp(event:MouseEvent):void 
		 {
			buttonMode=false;
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		} 
		private function mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
		}
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			for (var i:int=0; i<shifts.length; i++) 
			{
				shifts[i]=shifts[i].add(shifts2[i]);
			}
			dm.mapBitmap.perlinNoise(6,6,2,0,false,true,BitmapDataChannel.BLUE|BitmapDataChannel.GREEN,false,shifts);
			dm.mapBitmap.draw( map, null, new ColorTransform( 1, 1, 1, 0.7 ) );
			if (buttonMode) 
			{	
				p.graphics.drawGraphicsData(
					Vector.<IGraphicsData>(
						[new GraphicsStroke(3, false,"normal","none","round",3.0, 
							new GraphicsSolidFill(_color)),
							new GraphicsPath(Vector.<int>([1,2]),
							Vector.<Number>( [lastX, lastY, mx, my] ) )]));
			}
			dm.scaleX = ( mx - ( DISPLAY_WIDTH/2 ) ) / 5; 
			dm.scaleY = ( my - ( DISPLAY_HEIGHT/2 ) ) / 5; 
			lastX = mx;
			lastY = my;
			bmp2.bitmapData.draw(p);
			bmp2.bitmapData.applyFilter( bmp2.bitmapData, bmp2.bitmapData.rect, bmp2.bitmapData.rect.topLeft, dm );

			info.source.copyPixels( bmp2.bitmapData, DISPLAY_RECT, ONYX_POINT_IDENTITY );
		} 
		
		override public function dispose():void {
			source.dispose();
		}
	}
}
