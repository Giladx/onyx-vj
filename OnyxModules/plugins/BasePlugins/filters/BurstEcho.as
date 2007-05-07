/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
	import flash.events.Event;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	import onyx.filter.TempoFilter;
	import onyx.tween.*;

	public final class BurstEcho extends TempoFilter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var _source:BitmapData;
		
		/**
		 * 
		 */
		private var _transform:ColorTransform	= new ColorTransform(1,1,1,.09);
		
		/**
		 * 
		 */
		private var _matrix:Matrix				= new Matrix();
		
		/**
		 * 	@constructor
		 */
		public function BurstEcho():void {
			
			super(
				false,
				new ControlNumber('alpha', 'Echo Alpha', 0, 1, .09)
			);
		}
		
		/**
		 * 
		 */
		public function set alpha(value:Number):void {
			_transform.alphaMultiplier = value;
		}
		
		/**
		 * 
		 */
		public function get alpha():Number {
			return _transform.alphaMultiplier;
		}
		/**
		 * 
		 */
		override public function initialize():void {
			_source = BASE_BITMAP();
			super.initialize();
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			
			// stop tweens
			Tween.stopTweens(_transform);
			
			var tween:Tween = new Tween(_transform, Tempo.tempo,
				new TweenProperty('alphaMultiplier', _transform.alphaMultiplier, ((beat % 2) == 0) ? .95 : .1)
			);
		}
		
		/**
		 * 	Render
		 */
		public function applyFilter(bitmapData:BitmapData):void {
			
			// draw
			_source.draw(bitmapData, _matrix, _transform);
			
			// copy the pixels back to the original bitmap
			bitmapData.copyPixels(_source, BITMAP_RECT, POINT);
			
		}
		
		/**
		 * 
		 */
		override public function dispose():void {

			// stop tweens
			Tween.stopTweens(_transform);
			
			super.dispose();

			if (_source) {
				_source.dispose();
				_source = null;
			}
		}
	}
}