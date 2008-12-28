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
	import onyx.utils.bitmap.Distortion;

	/**
	 * 
	 */
	public final class Distort extends Filter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var distortion:Distortion = new Distortion();
		public var lock:Boolean				= false;
		
		private const _tlX:ParameterInteger = new ParameterInteger('topLeftX', 'topX', -DISPLAY_WIDTH * 2, DISPLAY_WIDTH *  3, 0);
		private const _tlY:ParameterInteger = new ParameterInteger('topLeftX', 'topX', -DISPLAY_WIDTH * 2, DISPLAY_WIDTH *  3, 0);

		private const _trX:ParameterInteger = new ParameterInteger('topRightX', 'topX', -DISPLAY_WIDTH * 2, DISPLAY_WIDTH *  3, DISPLAY_WIDTH);
		private const _trY:ParameterInteger = new ParameterInteger('topRightY', 'topY', -DISPLAY_HEIGHT * 2, DISPLAY_HEIGHT * 3, 0);
		private const _blX:ParameterInteger = new ParameterInteger('bottomLeftX', 'bottomX', -DISPLAY_WIDTH * 2, DISPLAY_WIDTH *  3, 0);
		private const _blY:ParameterInteger = new ParameterInteger('bottomLeftY', 'bottomY', -DISPLAY_HEIGHT * 2, DISPLAY_HEIGHT * 3, DISPLAY_HEIGHT);
		private const _brX:ParameterInteger = new ParameterInteger('bottomRightX', 'bottomX', -DISPLAY_WIDTH * 2, DISPLAY_WIDTH *  3, DISPLAY_WIDTH);
		private const _brY:ParameterInteger = new ParameterInteger('bottomRightY', 'bottomY', -DISPLAY_HEIGHT * 2, DISPLAY_HEIGHT * 3, DISPLAY_HEIGHT);
		
		public function Distort():void {
			
			parameters.addParameters(
				new ParameterProxy('topLeft', 'topLeft',
					_tlX,
					_tlY,
					true
				),
				new ParameterProxy('topRight', 'topRight',
					_trX,
					_trY,
					true
				),
				new ParameterProxy('bottomLeft', 'bottomLeft',
					_blX,
					_blY,
					true
				),
				new ParameterProxy('bottomRight', 'bottomRight',
					_brX,
					_brY,
					true
				),
				new ParameterBoolean('lock', 'lock')
			);
		}
		
		public function set topLeftX(value:Number):void {
			distortion.topLeft.x = _tlX.dispatch(value);
		}
		
		public function set topRightX(value:Number):void {
			distortion.topRight.x = _trX.dispatch(value);
		}
		
		public function set bottomLeftX(value:Number):void {
			distortion.bottomLeft.x = _blX.dispatch(value);
		}
		
		public function set bottomRightX(value:Number):void {
			distortion.bottomRight.x = _brX.dispatch(value);;
		}
		
		public function set topLeftY(value:Number):void {
			distortion.topLeft.y = _tlY.dispatch(value);;
		}
		
		public function set topRightY(value:Number):void {
			distortion.topRight.y = _trY.dispatch(value);;
		}
		
		public function set bottomLeftY(value:Number):void {
			distortion.bottomLeft.y = _blY.dispatch(value);;;
		}
		
		public function set bottomRightY(value:Number):void {
			distortion.bottomRight.y = _brY.dispatch(value);;;
		}
		
		public function get topLeftX():Number {
			return distortion.topLeft.x;
		}
		
		public function get topRightX():Number {
			return distortion.topRight.x;
		}
		
		public function get bottomLeftX():Number {
			return distortion.bottomLeft.x;
		}
		
		public function get bottomRightX():Number {
			return distortion.bottomRight.x;
		}
		
		public function get topLeftY():Number {
			return distortion.topLeft.y;
		}
		
		public function get topRightY():Number {
			return distortion.topRight.y;
		}
		
		public function get bottomLeftY():Number {
			return distortion.bottomLeft.y;
		}
		
		public function get bottomRightY():Number {
			return distortion.bottomRight.y;
		}
		
		public function applyFilter(source:BitmapData):void {
			if (!lock) {
				Distortion.render(source, distortion);
			}
		}
		
	}
}