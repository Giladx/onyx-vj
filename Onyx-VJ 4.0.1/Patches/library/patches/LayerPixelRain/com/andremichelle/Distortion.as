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
package com.andremichelle {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.constants.*;
	
	
	public final class Distortion {
		
		private static const BUFFER:BitmapData		= new BitmapData(BITMAP_WIDTH,BITMAP_HEIGHT,true,0);
		private static const SHAPE:Shape			= new Shape();
		private static const DISTORT:DistortImage	= new DistortImage(BITMAP_WIDTH,BITMAP_HEIGHT,0,0);
		
		public static function render(source:BitmapData, distortion:Distortion, matrix:Matrix = null, transform:ColorTransform = null, blendMode:String = null):void {
			BUFFER.copyPixels(source, source.rect, POINT);
			DISTORT.setTransform(SHAPE.graphics, BUFFER, distortion.topLeft, distortion.topRight, distortion.bottomRight, distortion.bottomLeft)
			source.fillRect(BITMAP_RECT, 0);
			source.draw(SHAPE, matrix, transform, blendMode);
		}
		
		public var topLeft:Point;
		public var topRight:Point;
		public var bottomLeft:Point;
		public var bottomRight:Point;
		
		public function Distortion(topLeft:Point = null, topRight:Point = null, bottomLeft:Point = null, bottomRight:Point = null):void {
			this.topLeft		= topLeft || new Point(0,0);
			this.topRight		= topRight || new Point(BITMAP_WIDTH, 0);
			this.bottomLeft		= bottomLeft || new Point(0, BITMAP_HEIGHT);
			this.bottomRight 	= bottomRight || new Point(BITMAP_WIDTH, BITMAP_HEIGHT);
		}
		
		public function isIdentity():Boolean {
			return (topLeft.y != 0 && topRight.y != 0 && topLeft.x != 0 && bottomLeft.x != 0 && bottomRight.x != BITMAP_WIDTH && topRight.x != BITMAP_WIDTH && bottomLeft.y != BITMAP_HEIGHT && bottomRight.y != BITMAP_HEIGHT);
		}
		
		public function toString():String {
			return topLeft.toString() + ':' + topRight.toString() + ':' + bottomLeft.toString() + ':' + bottomRight.toString(); 
		}
	}
}