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
package onyx.content {
	
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;

	/**
	 * 	Color transformation and saturation matrix
	 */	
	public final class ColorFilter extends ColorTransform {

		/**
		 * 	@private
		 */
		private static const MATRIX_DEFAULT:Array 	= [	1,0,0,0,0,
														0,1,0,0,0,
														0,0,1,0,0,
														0,0,0,1,0];

		/**
		 * 	@private
		 */
		private static const LUMINANCE_R:Number		= 0.212671;

		/**
		 * 	@private
		 */
		private static const LUMINANCE_G:Number		= 0.715160;

		/**
		 * 	@private
		 */
		private static const LUMINANCE_B:Number		= 0.072169;
		
		/**
		 * 	@private
		 */
		onyx_ns var _threshold:int					= 0;

		/**
		 * 	@private
		 */
		onyx_ns var _brightness:Number				= 0;

		/**
		 * 	@private
		 */
		onyx_ns var _contrast:Number				= 0;

		/**
		 * 	@private
		 */
		onyx_ns var _saturation:Number				= 1;
		
		/**
		 * 	@private
		 */
		private var _matrix:Array					= MATRIX_DEFAULT.concat();

		/**
		 * 	Filter
		 */
		public var filter:ColorMatrixFilter			= new ColorMatrixFilter(MATRIX_DEFAULT);
		
		/**
		 * 	@private
		 */
		onyx_ns var _color:uint						= 0;
		
		/**
		 * 	@private
		 */
		onyx_ns var _tint:Number					= 0;
		
		/**
		 * 	Returns threshold
		 */		
		public function get threshold():int {
			return _threshold;
		}

		/**
		 * 	Sets threshold
		 */
		public function set threshold(value:int):void {

			if (value !== _threshold) {
				
				var oldvalue:Number = _threshold;
				var thresh:Number = -256;
				
				_threshold = value;
				applyMatrix();
				
			}
		}

		/**
		 * 	Returns contrast
		 */	
		public function get contrast():Number {
			return _contrast;
		}
		
		/**
		 * 	Sets contrast
		 */
		public function set contrast(c:Number):void {
			
			if (_contrast !== c) {
				
				var old:Number, v:Number;
				
				old = 1 + _contrast,
				v	= 1 + c;
			
				var mat:Array = [v - old,0,0,0, (128*(1-v)) - (128*(1-old)),
								0,v - old,0,0, (128*(1-v)) - (128*(1-old)),
								0,0,v - old,0, (128*(1-v)) - (128*(1-old)),
								0,0,0,0,0];
									
				_contrast = c;
				applyMatrix(mat);
			}
		}

		/**
		 * 	Gets brightness
		 */
		public function get brightness():Number {
			return _brightness;
		}
		
		/**
		 * 	Sets brightness
		 */
		public function set brightness(value:Number):void {
			if (_brightness !== value) {
				
				var old:Number, v:Number;
				
				old			= 255 * _brightness,
				v			= 255 * value,
				_brightness = value;
			
				applyMatrix([	0,0,0,0,v - old,
								0,0,0,0,v - old,
								0,0,0,0,v - old,
								0,0,0,0,0]
				);
			}
		}

		/**
		 * 	Gets saturation
		 */
		public function get saturation():Number {
			return _saturation;
		}

		/**
		 * 	Sets saturation
		 */
		public function set saturation(s:Number):void {
			if (s !== _saturation) {
				_saturation = s;
				applyMatrix();
			}
		}

		/**
		 * 	Tint
		 */
		public function set tint(value:Number):void {		
			
			_tint = value;
			
			var r:int, g:int, b:int;
			
			r = ((_color & 0xFF0000) >> 16) * value,
			g = ((_color & 0x00FF00) >> 8) * value,
			b = (_color & 0x0000FF) * value;

			var amount:Number = 1 - value;
			
			super.blueMultiplier = super.redMultiplier = super.greenMultiplier = amount,
			super.redOffset		= r,
			super.greenOffset	= g,
			super.blueOffset	= b;
			
		}

		/**
		 * 
		 */
		public function get tint():Number {
			return _tint;
		}
		
		/**
		 * 	Sets color
		 */
		override public function set color(value:uint):void {
			
			_color	= value;
			
			var r:int, g:int, b:int;
			
			r = ((value & 0xFF0000) >> 16) * _tint,
			g = ((value & 0x00FF00) >> 8) * _tint,
			b = (value & 0x0000FF) * _tint;

			var amount:Number = 1 - _tint;
			
			super.blueMultiplier = super.redMultiplier = super.greenMultiplier = amount,
			super.redOffset		= r,
			super.greenOffset	= g,
			super.blueOffset	= b;
		}
		
		/**
		 * 	Gets color
		 */
		override public function get color():uint {
			return _color;
		}

		/**
		 * 	@private
		 */
		private function applyMatrix(mat:Array = null):void {
			
			if (mat) {
				_matrix = matrixAdd(mat);
			}
				
			var newmatrix:Array = _matrix.concat();

			// apply saturation
			if (_saturation != 1) {
				
				var s:Number, irlum:Number, iglum:Number, iblum:Number;
				
				s		= _saturation,
				irlum	= (1-s) * LUMINANCE_R,
				iglum	= (1-s) * LUMINANCE_G,
				iblum	= (1-s) * LUMINANCE_B;
			
				newmatrix = matrixBlend(newmatrix, 
					[		irlum + s	, iglum    , iblum    , 0, 0,
			  				irlum  	, iglum + s, iblum    , 0, 0,
			    			irlum	, iglum    , iblum + s, 0, 0,
			    			0		, 0        , 0        , 1, 0 ]
				);
			}
			
			if (_threshold > 0) {
				var thresh:Number = -256 * ((100 - _threshold));
										
				newmatrix = matrixBlend(
					newmatrix, 
					[	64, 64, 64, 0,  thresh, 
						64, 64, 64, 0,  thresh, 
						64, 64, 64, 0,  thresh, 
						0, 0, 0, 1, 0
					]
				);
			}
				
			
			filter.matrix = newmatrix;
		}
		
		/**
		 * 	@private
		 */
		private function matrixAdd(mat:Array):Array {
			
			var newMatrix:Array, matrixlength:int, i:int, orig:Number, newm:Number;
			
			newMatrix		= [],
			matrixlength	= mat.length;
			
			for (i = 0;i < matrixlength;i++) {
				orig = filter.matrix[i];
				newm = mat[i]
				newMatrix.push(orig + newm);
			}

			return newMatrix;
		}
		
		/**
		 * 	@private
		 */
		private function matrixBlend(mat:Array, old:Array):Array {
			
			var temp:Array, i:int, y:int, x:int;
		
			temp	= [];
			
			for (y = 0; y < 4; y++ ) {
				for (x = 0; x < 5; x++ ) {
					
					temp[i + x] =	mat[i    ] * old[x     ] + 
								mat[i+1] * old[x +  5] + 
								mat[i+2] * old[x + 10] + 
								mat[i+3] * old[x + 15] +
								(x === 4 ? mat[i+4] : 0);
				}
				i+=5;
			}
			
			return temp;
		}

	}
}