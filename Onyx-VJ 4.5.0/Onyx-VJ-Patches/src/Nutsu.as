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
 * Downloaded from http://wonderfl.net/c/gdJx
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 
 *
 * Copyright nutsu ( http://wonderfl.net/user/nutsu )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/gdJx
 */

package
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Nutsu extends Patch
	{
		
		private var bmpdata:BitmapData;
		private var sprite:Sprite;
		private var matrix:Matrix;
		private var colortrans:ColorTransform;
		private var filter:DisplacementMapFilter;
		private var mx:int=320;
		private var my:int=240;
		
		public function Nutsu() 
		{
			Console.output('Nutsu');
			Console.output('Nutsu (http://wonderfl.net/user/nutsu)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			//BitmapDataを作成して表示リストに追加
			bmpdata = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0 );
			addChild( new Bitmap(bmpdata) );
			//グラフィックの生成
			sprite = newFig( 0, 0, 40, 0xFFFFFF );
			//Matrix,ColorTransformの初期化
			matrix = new Matrix();
			colortrans = new ColorTransform();
			//エフェクトの初期化
			var mapBitmap:BitmapData = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0 );
			var mapPoint:Point       = mapBitmap.rect.topLeft;
			var componentX:uint      = BitmapDataChannel.RED;
			var componentY:uint      = BitmapDataChannel.GREEN;
			var scaleX:Number        = 8;
			var scaleY:Number        = 8;
			mapBitmap.perlinNoise( 240, 240, 2, 0, false, false );
			filter = new DisplacementMapFilter( mapBitmap, mapPoint, componentX, componentY, scaleX, scaleY );
			//イベント
			//addEventListener( Event.ENTER_FRAME, enterframe );
			//stage.addEventListener( MouseEvent.CLICK, reset );
			//addEventListener( InteractionEvent.MOUSE_DOWN, move );
			addEventListener( InteractionEvent.MOUSE_MOVE, mouseMove );
		}
		
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			//エフェクトの適用
			bmpdata.applyFilter( bmpdata, bmpdata.rect, bmpdata.rect.topLeft, filter );
			//変形
			matrix.identity();
			var s:Number = Math.random()*2;
			matrix.scale( s, s );
			matrix.rotate( Math.PI * Math.random() );
			matrix.translate( mx, my );
			//色変換
			colortrans.greenMultiplier = mx / 465;
			colortrans.blueMultiplier  = my / 465;
			colortrans.alphaMultiplier = Math.random();
			//BitmapDataへ描画
			bmpdata.draw( sprite, matrix, colortrans, BlendMode.ADD );
			info.source.copyPixels(bmpdata, DISPLAY_RECT, ONYX_POINT_IDENTITY);	
		}
		private function mouseMove(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}
		
		/*private function reset(e:MouseEvent):void {
			bmpdata.fillRect( bmpdata.rect, 0xFF000000 );
		}*/
		
		private function newFig( cx:Number, cy:Number, size:Number, col:uint ):Sprite {
			//中心(cx,cy), 幅高さsize, 色col　のグラフィックを生成
			var shape:Sprite = new Sprite();
			shape.graphics.lineStyle( 0, 0x000000, 0.3 );
			shape.graphics.beginFill( col );
			shape.graphics.drawCircle( cx, cy, size*0.5 );
			shape.graphics.drawCircle( cx, cy, size*0.4 );
			var w:Number = size * 0.6;
			var h:Number = size * 0.15;
			shape.graphics.drawRect( cx - w/2, cy - h/2, w, h );
			shape.graphics.endFill();
			return shape;
		}
	}
}