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
package plugins.filters {
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import onyx.parameter.*;

	import onyx.tween.*;

	public final class RayOfLight extends Filter implements IBitmapFilter {
		
		private var _alpha:ColorTransform	= new ColorTransform(1,1,1,.4);	
		private var matrix:Matrix			= new Matrix(1.02, 0,0, 1.02);
		public var blend:String				= 'lighten';
		
		/**
		 * 	@constructor
		 */
		public function RayOfLight():void {
			
			parameters.addParameters(
				new ParameterProxy('scale', 'scale', 
					new ParameterNumber('scaleX', 'scaleX', 0, 3, 1.02),
					new ParameterNumber('scaleY', 'scaleY', 0, 3, 1.02)
				),
				new ParameterNumber('alpha', 'alpha', 0, 1, .4),
				new ParameterBlendMode('blend', 'blend')
			);
		}
		
		public function get alpha():Number {
			return _alpha.alphaMultiplier;
		}
		
		public function set alpha(value:Number):void {
			_alpha.alphaMultiplier = value;
		}
		
		public function get scaleX():Number {
			return matrix.a;
		}
		
		public function get scaleY():Number {
			return matrix.d;
		}
		
		public function set scaleX(value:Number):void {
			matrix.a = value;
		}

		public function set scaleY(value:Number):void {
			matrix.d = value;
		}
		
		override public function initialize():void {
		}
		
		public function applyFilter(source:BitmapData):void {
			source.draw(source, matrix, _alpha, blend);
		}
	}
}