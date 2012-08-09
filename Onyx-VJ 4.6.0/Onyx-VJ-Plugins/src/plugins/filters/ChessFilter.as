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
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;


	public final class ChessFilter extends Filter implements IBitmapFilter {
		
		private var _source:BitmapData;
		private var _mask:BitmapData;
		
		private var _amount:Number	= 15;
		private var _invert:Boolean	= false;

		public function ChessFilter():void {
			
			parameters.addParameters(
				new ParameterInteger('amount', 'amount', 2, 15, _amount, 1, 5),
				new ParameterBoolean('invert', 'invert')
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
            
            var scaleX:Number = Math.ceil(DISPLAY_WIDTH / _amount);
            var scaleY:Number = Math.ceil(DISPLAY_HEIGHT / _amount);
            
            var m:Boolean = _invert;
            
            _mask.fillRect(DISPLAY_RECT, 0x00000000);
             
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
            
            bitmapData.copyPixels( _source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _mask, ONYX_POINT_IDENTITY, false );
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
