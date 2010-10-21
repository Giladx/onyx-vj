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
 * plug-in for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * based on LooseGlowLine by mousepancyo (http://wonderfl.net/user/mousepancyo)
 */
 /**
 * Copyright mousepancyo ( http://wonderfl.net/user/mousepancyo )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/5nJE
 */

// forked from undo's forked from: Math Graphics Example
// forked from mousepancyo's Math Graphics Example
package library.patches 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	[SWF(width='320', height='240', frameRate='24', backgroundColor='#FFFFFF')]
	public class LooseGlowLine extends Patch
	{
		
		private var rotObj:Sprite = new RotObj();
		private var _r:Number;
		private var _rad:Number;
		private var _radius:Number;
		private var _centerX:Number = DISPLAY_WIDTH / 2;
		private var _centerY:Number = DISPLAY_HEIGHT / 2;
		private var _p:Point = new Point(_centerX, _centerY);
		private var _isMouseDown:Boolean;
		
		private var _circleBmd:BitmapData;
		private var _canvas:BitmapData;
		private var _glowBmd:BitmapData;
		private var _bm:Bitmap;
		private var _glowBm:Bitmap;
		private var _blure:BlurFilter = new BlurFilter(16, 16, 3);
		
		private var _ct:ColorTransform;
		private var _hsv:ColorHSV;
		
		private var mx:int;
		private var my:int;
		
		/**
		 * 	@constructor
		 */
		public function LooseGlowLine():void 
		{
			Console.output('LooseGlowLine');
			Console.output('mousepancyo ( http://wonderfl.net/user/mousepancyo )');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			var sp:Shape = new Shape();
			sp.graphics.beginFill(0xFFFFFF);
			sp.graphics.drawCircle(30, 30, 10);
			sp.graphics.endFill()
			//
			_circleBmd = new BitmapData(50, 50, true, 0)
			_circleBmd.draw(sp);
			//
			_canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0)
			_bm= new Bitmap( _canvas );
			_bm.x = _bm.y = -25;
			_bm.filters = [_blure];
			addChild(_bm);
			//
			_glowBmd = _canvas.clone();
			_glowBm = new Bitmap(_glowBmd);
			_glowBm.filters = [_blure];
			_glowBm.blendMode = "add";
			_glowBm.x = _glowBm.y = -25;
			addChild(_glowBm);
			//
			_ct= new ColorTransform();
			_hsv = new ColorHSV(0, .9, .99);
			//
			addChild(rotObj);
			rotObj.x = _centerX;
			rotObj.y = _centerY;
			addEventListener( InteractionEvent.MOUSE_DOWN, onDown );
			addEventListener( InteractionEvent.MOUSE_MOVE, mouseMove );
			addEventListener( InteractionEvent.MOUSE_UP, onUp);
			graphics.lineStyle(1, 0);
		}
		
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
		//private function update(e:Event):void{

			var mPoint:Point = new Point(mx, my);
			var cPoint:Point = new Point(_centerX, _centerY);
			rotObj.rotation += (mPoint.y - cPoint.y) * 0.05;
			_r = rotObj.rotation;
			_rad = _r * Math.PI / 180;
			
			if(_isMouseDown){
				_p.x = _centerX + Math.cos(_rad) * (mPoint.x - cPoint.x);
				_p.y = _centerY + Math.sin(_rad) * (mPoint.x - cPoint.x);
				_canvas.copyPixels(_circleBmd, _circleBmd.rect, _p);
				_canvas.colorTransform(_canvas.rect, _ct);
				_glowBmd.copyPixels(_canvas, _canvas.rect, new Point());
				//
				_ct.redMultiplier = (_hsv.value >> 16 & 0xff) / 255;
				_ct.greenMultiplier = (_hsv.value >> 8 & 0xff) / 255;
				_ct.blueMultiplier = (_hsv.value & 0xff) / 255;
				_hsv.h += 1;
			}
			info.source.copyPixels( _canvas, DISPLAY_RECT, ONYX_POINT_IDENTITY );

		}
		
		private function onDown(event:InteractionEvent):void{
			_isMouseDown = true;
			var rad:Number = Math.atan2(my - _centerY, mx - _centerX);
			_p.x = _centerX + Math.cos(rad) * (mx - _centerX);
			_p.y = _centerY + Math.sin(rad) * (mx - _centerX);
			rotObj.rotation = rad * 180 / Math.PI;
			//
			graphics.moveTo(_p.x, _p.y);
		}
		private function onUp(event:InteractionEvent):void{
			_isMouseDown = false;
			graphics.clear();
			graphics.lineStyle(1, 0);
			graphics.moveTo(_p.x, _p.y);
			rotObj.rotation = 0;
		}
		private function mouseMove(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}
	}
}

import flash.display.Sprite;
class RotObj extends Sprite{
	public function RotObj() {
		this.graphics.lineStyle(1, 0x990000);
		graphics.moveTo(0, 0);
		graphics.lineTo(-10, 0);
		graphics.moveTo(0, 0);
		graphics.lineTo(0, -10);
		graphics.moveTo(0, 0);
		graphics.lineTo(10, 0);
		graphics.moveTo(0, 0);
		graphics.lineTo(0, 10);
	}
}