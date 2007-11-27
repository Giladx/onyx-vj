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
 */
package filters {
    
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.ByteArray;
    import flash.filters.BlurFilter;
    import flash.filters.GlowFilter;
    import flash.filters.DisplacementMapFilter;
    import flash.filters.ColorMatrixFilter;
    
    import onyx.constants.*;
    import onyx.controls.*;
    import onyx.plugin.*;
    import onyx.core.*;
    
    
    public final class KeyingFilter extends Filter implements IBitmapFilter {
        
        private var matrix:Array    = new Array();
        
        private var _source:BitmapData;
        private var _transform:BitmapData;
        private var _mask:BitmapData;
        
        private var _preBlurFilter:BlurFilter;
        private var _postBlurFilter:BlurFilter;
        
        private var _keyColor:ColorTransform = new ColorTransform();
        
        private var _mat:Matrix         = new Matrix();
    
        private var _alphaArray:Array   = new Array ();
        private var _nullArray:Array    = new Array ();
        private var alpha_in:Number;
        private var alpha_out:Number;
            
        private var _maskIn:Number;
        private var _maskOut:Number;
        private var _preBlur:Number;
        private var _postBlur:Number;
        private var _maskGamma:Number;
        
        public function KeyingFilter():void {
            super(
                false,
                new ControlNumber('maskIn', 'Mask In', 0, 2.56, .3),
                new ControlNumber('preBlur', 'Pre Blur', 0, 1, 0),
                new ControlNumber('maskOut', 'Mask Out', 0, 2.56, .5),
                new ControlNumber('postBlur', 'Post Blur', 0, 1.60, 0),
                new ControlNumber('maskGamma', 'Mask Gamma', 0.01, 4.00, 1),
                new ControlColor('keyColor', 'Key Color')
            );
        }
        
        override public function initialize():void {
            
            _source     = content.source.clone();
            _transform  = content.source.clone();
            _mask       = content.source.clone();
            
            //init controls
            _maskIn             = .3;
            _maskOut            = .5;
            _preBlur            = 0;
            _postBlur           = 0;
            _maskGamma          = 1;
            _keyColor.color     = 0xFF000000;
            
            _preBlurFilter      = new BlurFilter(1 + _preBlur * 10, 1 + _preBlur * 10, 1);
            _postBlurFilter     = new BlurFilter(1 + _postBlur * 10, 1 + _postBlur * 10, 1);
            
            alpha_in            = _maskIn*10;
            alpha_out           = _maskOut*10;
            
            average(1/3, 1/3, 1/3);
            calculateAlphaTables();
                        
            _transform.colorTransform( BITMAP_RECT, _keyColor);
        }
        
        public function set keyColor(value:Number):void {
            _keyColor.color = value;
            _transform.colorTransform( BITMAP_RECT, _keyColor);
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
        
            matrix = matrix.concat([    r, g, b, 0, 0,
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
                _mask.applyFilter(_source, BITMAP_RECT, POINT, _preBlurFilter );
            } else {
                _mask.draw(_source);
            }
            
            // Subtracts the key color from the image
            _mask.draw(_transform, _mat, null, "difference");
            
            // this calculates the average color difference
            _mask.applyFilter(_mask, BITMAP_RECT, POINT, new ColorMatrixFilter(matrix));
            
            // maps the accumulated difference from the blue channel to the alpha channel and creates the mask
            _mask.paletteMap(_mask, BITMAP_RECT, POINT, _nullArray, _nullArray, _alphaArray, _nullArray );
            
            // blurs the mask edges
            if ( _postBlur > 0 ) {
                _mask.applyFilter(_mask, BITMAP_RECT, POINT, _postBlurFilter );
            }
            
            bitmapData.copyPixels( _source, BITMAP_RECT, POINT, _mask, POINT, false );
        }
        
        override public function dispose():void {
            if (_source) {
                _source.dispose();
                _source = null;
            }
            _transform          = null;
            _mask               = null;
            _maskIn             = 0;
            _maskOut            = 0;
            _preBlur            = 0;
            _postBlur           = 0;
            _maskGamma          = 0;
            _keyColor           = null;
            super.dispose();
        }
    }
}