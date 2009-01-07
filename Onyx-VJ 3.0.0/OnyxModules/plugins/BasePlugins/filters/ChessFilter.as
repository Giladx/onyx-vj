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
package filters {
	
	import flash.display.*;
    import flash.geom.*;
    
    import onyx.constants.*;
    import onyx.controls.*;
    import onyx.plugin.*;
    import onyx.core.*;

	public final class ChessFilter extends Filter implements IBitmapFilter {
		
		private var _source:BitmapData;
		private var _mask:BitmapData;
		
		private var _amount:Number	= 2;
		private var _invert:Boolean	= false;

		public function ChessFilter():void {
			
			super(false,
				new ControlInt('amount', 'amount', 2, 15, 2, 1, 5),
				new ControlBoolean('invert', 'invert')
			);

		}
		
		override public function initialize():void {
            
            _source     = content.source.clone();
            _mask       = content.source.clone();
            
            calculateAlphaTables();
			
		}
		
        public function set amount(value:Number):void {
            _amount = value;
            calculateAlphaTables();
        }
        
        public function get amount():Number {
            return _amount;
        }
        
        public function set invert(value:Boolean):void {
            _invert = value;
            calculateAlphaTables();
        }
        
        public function get invert():Boolean {
            return _invert;
        }
        
		public function calculateAlphaTables():void {
            
            var square:int = Math.pow(_amount, 2);
            
            var scaleX:Number = Math.ceil(BITMAP_WIDTH / _amount);
            var scaleY:Number = Math.ceil(BITMAP_HEIGHT / _amount);
            
            var m:Boolean = _invert;
            
            _mask.fillRect(BITMAP_RECT, 0x00000000);
             
            for (var count:int = 0; count < square; count++ ) {
            	
            	if(m) {
            		_mask.fillRect( new Rectangle( count%_amount*scaleX, 
                                               int(count/_amount)*scaleY,
                                               scaleX,
                                               scaleY),
                                    0xFFFFFFFF);
            	}
            	                             
                if(square%2==0 && (count+1)%_amount==0) {
                    m = !m;
                }
                m = !m;
            }
        
        }
                
        public function applyFilter(bitmapData:BitmapData):void {
            
            //take the bitmapData stream and make a copy into _source
            _source.draw(bitmapData);
            
            bitmapData.copyPixels( _source, BITMAP_RECT, POINT, _mask, POINT, false );
        }
        
        override public function dispose():void {
            if (_source) {
                _source.dispose();
                _source = null;
            }
            _mask = null;
            
            super.dispose();
        }
		
	}
}
