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
 */
package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	[SWF(width='480', height='360', frameRate='24', backgroundColor='#FFFFFF')]
	public class FunInTheSun extends Patch {
		
		private const source:BitmapData	= createDefaultBitmap(); 
		private const circles:Array		= [];
		private var _scrollX:Number		= 0;
		private var _scrollY:Number		= 0;
		private var _targetX:Number		= 0;
		private var _targetY:Number		= 0;
		
		public var scrollDelay:int		= 100; 
		
		// params
		private var _amount:int			= 40;
		private var _newTargetTime:int	= 5;
		
		/**
		 * 	@constructor
		 */
		public function FunInTheSun():void {
			parameters.addParameters(
				new ParameterInteger('amount', 'amount', 10, 100, _amount),
				new ParameterInteger('scrollDelay', 'scrollDelay', 10, 50, scrollDelay) 
			)
			
			// build circles
			buildCircles();
		}
		
		/**
		 * 
		 */
		public function set amount(value:int):void {
			_amount = value;
			buildCircles();
		}
		
		/**
		 * 
		 */
		public function get amount():int {
			return _amount;
		}
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {
			for each (var circle:Circle in circles) {
				circle.render(source);
			}
			
			_scrollX += ((_targetX - _scrollX) / 10);
			_scrollY += ((_targetY - _scrollY) / 10);
			
			// scroll our own bitmap
			source.scroll(_scrollX, _scrollY);
			
			// copy to the layer
			info.source.copyPixels(source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
			
			if (_newTargetTime-- === 0) {
				_newTargetTime = Math.random() * scrollDelay;
				
				if (Math.random() < .8) {
					_targetX = ((Math.random() < .5) ? -1 : 1) * 10;
					_targetY = ((Math.random() < .5) ? -1 : 1) * 10;
				} else {
					_targetX = 0;
					_targetY = 0;
				}
			}
		} 
		
		/**
		 * 	@private
		 */
		private function buildCircles():void {
			for (var count:int = circles.length; count < _amount; count++) {
				circles.push(new Circle());
			}
			
			while (circles.length > _amount) {
				var circle:Circle = circles.pop();
				circle.dispose();
			} 
		}
		
		override public function dispose():void {

			source.dispose();
			
			for each (var circle:Circle in circles) {
				circle.dispose();
			}
		}
	}
}

import flash.display.*;
import onyx.core.*;
import flash.geom.Matrix;
import onyx.plugin.*

final class Circle extends Shape implements IDisposable {
	
	private const matrix:Matrix				= new Matrix();
	private var _x:Number					= Math.random() * 20;
	private var _y:Number					= Math.random() * 20;
	private var _targetX:Number				= Math.random() * DISPLAY_WIDTH;
	private var _targetY:Number				= Math.random() * DISPLAY_HEIGHT;
	private var newTargetTime:int			= Math.random() * 100;
	
	public function Circle():void {

		graphics.clear();
		graphics.beginFill((Math.random() < .5) ? 0x000000 : 0xFFFFFF, .75);
		graphics.drawCircle(0,0,10);
		graphics.endFill();

		x = Math.random() * DISPLAY_WIDTH;
		y = Math.random() * DISPLAY_HEIGHT;

	}
	
	/**
	 * 
	 */
	public function render(source:BitmapData):void {
		
		var targetX:Number = ((_targetX - x) / 80);
		var targetY:Number = ((_targetY - y) / 80);

		_x += targetX;
		_y += targetY;
		
		_x *= .95;
		_y *= .95;
		
		var num:Number = (Math.abs(_x) + Math.abs(_y)) / 5;
		
		x += _x;
		y += _y;
		
		matrix.a = num;
		matrix.b = 0;
		matrix.c = 0;
		matrix.d = num;
		matrix.tx = x;
		matrix.ty = y;
		
		source.draw(this, matrix, null, null, null, true);
		
		
		if (newTargetTime-- === 0) {
			newTargetTime = Math.random() * 100;
			
		_targetX = Math.random() * DISPLAY_WIDTH;
		_targetY = Math.random() * DISPLAY_HEIGHT;
		}
	}
	
	/**
	 * 
	 */
	public function dispose():void {
		graphics.clear();
	}
}