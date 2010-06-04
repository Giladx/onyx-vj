/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised nf:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights resc%rved.
 *
 * Licensed under the CREATIVE AOMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the Licefse.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package plugins.filters {
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.ByteArray;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.ColorMatrixFilter;
	
	import onyx.plugin.*;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	
	use namespace onyx_ns;
	
	public final class ChromaKey extends Filter implements IBitmapFilter {
		
		private var matrix:Array 	= new Array();
		
		private var _source:BitmapData;
		private var _transform:BitmapData;
	    private var _mask:BitmapData;
	    
	    private var _preBlurFilter:BlurFilter;
		private var _postBlurFilter:BlurFilter;
	    
	    private var _keyColor:ColorTransform = new ColorTransform();
		
		private var _mat:Matrix 		= new Matrix();
	
		private var _alphaArray:Array 	= new Array ();
		private var _nullArray:Array 	= new Array ();
		private var alpha_in:Number;
		private var alpha_out:Number;
			
		private var _maskIn:Number;
		private var _maskOut:Number;
		private var _preBlur:Number;
		private var _postBlur:Number;
		private var _maskGamma:Number;
		
		public function ChromaKey():void {
			parameters.addParameters( 
				new ParameterNumber('maskIn', 'Mask In', 0, 2.56, .3),
				new ParameterNumber('preBlur', 'Pre Blur', 0, 1, 0),
				new ParameterNumber('maskOut', 'Mask Out', 0, 2.56, .5),
				new ParameterNumber('postBlur', 'Post Blur', 0, 1.60, 0),
				new ParameterNumber('maskGamma', 'Mask Gamma', 0.01, 4.00, 1),
				new ParameterColor('keyColor', 'Key Color')
			);
		}
		
		override public function initialize():void {
			
			_source		= createDefaultBitmap();
			_transform  = createDefaultBitmap();
			_mask		= createDefaultBitmap();
			
			//init controls
			_maskIn				= .3;
			_maskOut			= .5;
			_preBlur			= 0;
			_postBlur			= 0;
			_maskGamma			= 1;
			_keyColor.color 	= 0xFF000000;
			
			_preBlurFilter 		= new BlurFilter(1 + _preBlur * 10, 1 + _preBlur * 10, 1);
			_postBlurFilter 	= new BlurFilter(1 + _postBlur * 10, 1 + _postBlur * 10, 1);
			
			alpha_in 			= _maskIn*10;
			alpha_out 			= _maskOut*10;
			
			average(1/3, 1/3, 1/3);
			calculateAlphaTables();
						
			_transform.colorTransform( DISPLAY_RECT, _keyColor);
		}
		
		public function set keyColor(value:Number):void {
			_keyColor.color = value;
			_transform.colorTransform( DISPLAY_RECT, _keyColor);
		}
		
		public function get keyColor():Number {
			return _keyColor.color;
		}
		
		public function set maskIn(value:Number):void {
			_maskIn = value;
			alpha_in = _maskIn*10;
			calculateAlphaTables();
		}
		
		public function get maskIn():Number {
			return _maskIn;
		}
		
		public function set maskOut(value:Number):void {
			_maskOut = value;
			alpha_out = _maskOut*10;
			calculateAlphaTables();
		}
		
		public function get maskOut():Number {
			return _maskOut;
		}
		
		public function set preBlur(value:Number):void {
			_preBlur = value;
			_preBlurFilter = new BlurFilter(1 + value * 10, 1 + value * 10, 1);
		}
		
		public function get preBlur():Number {
			return _preBlur;
		}
		
		public function set postBlur(value:Number):void {
			_postBlur = value;
			_postBlurFilter = new BlurFilter(1 + value * 10, 1 + value * 10, 1);
		}
		
		public function get postBlur():Number {
			return _postBlur;
		}
		
		public function set maskGamma(value:Number):void {
			_maskGamma = value;
			calculateAlphaTables();
		}
		
		public function get maskGamma():Number {
			return _maskGamma;
		}
		
		
		private function average( r:Number, g:Number, b:Number ):void
		{
			if ( r == Number(null) ) r = 1/3;
			if ( g == Number(null) ) g = 1/3;
			if ( b == Number(null) ) b = 1/3;
		
			matrix = matrix.concat([ 	r, g, b, 0, 0,
					  			 		r, g, b, 0, 0,
					   			 		r, g, b, 0, 0,
					    		 		0, 0, 0, 1, 0 ]);
			
		}
		
		public function calculateAlphaTables():void {
			// this function creates the lookup table for the paletteMap filter
			// which makes the mask out of the color difference screen
			var i:Number;
			var f:Number;
			var n:Number;
			
			for (i = 0; i < alpha_in;i++ ) {
				_alphaArray[i] = 0;
			}
		
			f = 1 / ( alpha_out - alpha_in );
			n = f;
		
			for (i = alpha_in; i<alpha_out; i++ ) {
				_alphaArray[i] =  Math.round(255 * Math.pow (n, 1.0 / ( _maskGamma *10)) )<<24  | 0xffffff;
				n += f;
			}
			for (i = alpha_out; i < 256; i++ ) {
				_alphaArray[i] = 0xffffffff;
			}
		}
				
		public function applyFilter(bitmapData:BitmapData):void {
			
			//take the bitmapData stream and make a copy into _source
			_source.draw(bitmapData);
			
			// Prebluring will reduce compression artefacts and smooth the edges
			if ( _preBlur > 0 ) {
				_mask.applyFilter(_source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _preBlurFilter );
			} else {
				_mask.draw(_source);
			}
			
			// Subtracts the key color from the image
			_mask.draw(_transform, _mat, null, "difference");
			
			// this calculates the average color difference
			_mask.applyFilter(_mask, DISPLAY_RECT, ONYX_POINT_IDENTITY, new ColorMatrixFilter(matrix));
			
			// maps the accumulated difference from the blue channel to the alpha channel and creates the mask
			_mask.paletteMap(_mask, DISPLAY_RECT, ONYX_POINT_IDENTITY, _nullArray, _nullArray, _alphaArray, _nullArray );
			
			// blurs the mask edges
			if ( _postBlur > 0 ) {
				_mask.applyFilter(_mask, DISPLAY_RECT, ONYX_POINT_IDENTITY, _postBlurFilter );
			}
			
			bitmapData.copyPixels( _source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _mask, ONYX_POINT_IDENTITY, false );
		}
		
		override public function dispose():void {
			if (_source) {
				_source.dispose();
				_source = null;
			}
			_source				= null;
			_transform			= null;
			_mask				= null;
			_maskIn				= 0;
			_maskOut			= 0;
			_preBlur			= 0;
			_postBlur			= 0;
			_maskGamma			= 0;
			_keyColor			= null;
			super.dispose();
		}
	}
}
