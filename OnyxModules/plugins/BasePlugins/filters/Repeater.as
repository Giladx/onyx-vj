/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package filters {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.utils.math.*;

	/**
	 * 	Repeater
	 */
	public final class Repeater extends Filter implements IBitmapFilter {
		
		public var amount:int			= 2;
		private var _bmp:BitmapData		= BASE_BITMAP();
		
		public function Repeater():void {
			
			super(
				true,
				new ControlInt('amount', 'amount', 2, 15, 2, { factor: 5 })
			)
		}
		
		/**
		 * 	Applys a filter to the bitmap
		 */
		public function applyFilter(bitmapData:BitmapData):void {
			
			var amount:int = amount;
			var square:int = pow(amount, 2);
			
			var scaleX:Number = ceil(bitmapData.width / amount);
			var scaleY:Number = ceil(bitmapData.height / amount);
			
			var newbmp:BitmapData = new BitmapData(scaleX, scaleY, true, 0x00000000);
			var matrix:Matrix = new Matrix();
			matrix.scale(1 / amount, 1 / amount);
			newbmp.draw(bitmapData, matrix);
	
			for (var count:int = 0; count < square; count++) {
				bitmapData.copyPixels(
					newbmp, 
					newbmp.rect, 
					new Point((count % amount) * scaleX, 
					floor(count / amount) * scaleY)
				);
			}
		}
		
		/**
		 * 	Disposes the filter
		 */
		override public function dispose():void {
			if (_bmp) {
				_bmp.dispose();
			}
			super.dispose();
		}
	}
}