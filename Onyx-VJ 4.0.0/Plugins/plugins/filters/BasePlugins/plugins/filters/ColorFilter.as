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
package plugins.filters {
	
	import flash.display.BitmapData;
	import flash.filters.*;
	
	import onyx.parameter.*;


	public final class ColorFilter extends Filter implements IBitmapFilter {
		

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
		 * 
		 */
		public function ColorFilter():void {
			parameters.addParameters(
				new ParameterNumber('brightness',	'bright', -1, 1, 0),
				new ParameterNumber('contrast',	'contrast', -1, 2, 0),
				new ParameterNumber('saturation',	'saturation', 0, 2, 1),
				new ParameterInteger('threshold',	'threshold', 0, 100, 0)
			)
		}

		/**
		 * 	@private
		 */
		private var _threshold:int					= 0;

		/**
		 * 	@private
		 */
		private var _brightness:Number				= 0;

		/**
		 * 	@private
		 */
		private var _contrast:Number				= 0;

		/**
		 * 	@private
		 */
		private var _saturation:Number				= 1;
		
		/**
		 * 	@private
		 */
		private var _matrix:Array					= MATRIX_DEFAULT.concat();

		/**
		 * 	Filter
		 */
		private var _filter:ColorMatrixFilter			= new ColorMatrixFilter(MATRIX_DEFAULT);
		
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
				
			
			_filter.matrix = newmatrix;
		}
		
		/**
		 * 	@private
		 */
		private function matrixAdd(mat:Array):Array {
			
			var newMatrix:Array, matrixlength:int, i:int, orig:Number, newm:Number;
			
			newMatrix		= [],
			matrixlength	= mat.length;
			
			for (i = 0;i < matrixlength;i++) {
				orig = _filter.matrix[i];
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
		
		/**
		 * 
		 */
		public function applyFilter(source:BitmapData):void {
			source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _filter);
		}
	}
}