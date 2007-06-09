/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
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
package onyx.core {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.content.ColorFilter;
	import onyx.utils.math.*;
	
	public final class RenderTransform {

		/**
		 *	Gets a transform for a specified displayobject
		 */
		public static function getTransform(ref:DisplayObject):RenderTransform {
			
			var transform:RenderTransform, matrix:Matrix;
			
			transform					= new RenderTransform(),
			matrix						= new Matrix();
			
			matrix.scale(ref.scaleX, ref.scaleY);
			matrix.rotate(ref.rotation);
			matrix.translate(ref.x, ref.y);

			transform.matrix			= matrix,
			transform.rect				= (ref.rotation === 0) ? new Rectangle(0, 0, max(BITMAP_WIDTH / ref.scaleX, BITMAP_WIDTH), max(BITMAP_HEIGHT / ref.scaleY, BITMAP_HEIGHT)) : null,
			transform.content			= ref;

			return transform;
		}
				
		public var content:IBitmapDrawable;
		public var matrix:Matrix;
		public var rect:Rectangle;

		/**
		 * 	Concatenates a transformation
		 */		
		public function concat(transform:RenderTransform):RenderTransform {
			if (matrix && transform && transform.matrix) {
				matrix.concat(transform.matrix);
			}
			return this;
		}
	}
}