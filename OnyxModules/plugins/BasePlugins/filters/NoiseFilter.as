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
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;

	/**
	 * 	Noise filter
	 */
	public final class NoiseFilter extends Filter implements IBitmapFilter {
		
		private var _amount:Number		= .25;
		private var _greyscale:Boolean	= true;
		private var _noise:BitmapData;
		public var mode:String			= 'overlay';
		
		public function NoiseFilter():void {
			
			super(
				false,
				new ControlInt('amount','Amount', 0, 100, 4),
				new ControlBoolean('greyscale', 'GreyScale', 0),
				new ControlBlend('mode', 'mode')
			);
		}
		
		public function applyFilter(bmp:BitmapData):void {
			
			_noise.noise(Math.random() * 100, 0, _amount * 255, 7, _greyscale);
			
			bmp.draw(_noise, null, null, 'overlay');
			
		}
		
		public function set amount(a:int):void {
			_amount = a / 100;
		}

		public function get amount():int{
			return _amount * 100;
		}

		public function get greyscale():Boolean {
			return _greyscale;
		}

		public function set greyscale(b:Boolean):void {
			_greyscale = b;
		}
		
		override public function dispose():void {
			if (_noise) {
				_noise.dispose();
				_noise = null;
			}
		}
		
		override public function initialize():void {
			_noise	= BASE_BITMAP();
		}

	}
}