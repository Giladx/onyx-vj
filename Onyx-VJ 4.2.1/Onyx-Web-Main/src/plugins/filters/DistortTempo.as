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
	import flash.events.Event;
	import flash.geom.*;
	
	import onyx.parameter.*;

	import onyx.tween.*;
	import onyx.utils.bitmap.Distortion;

	public final class DistortTempo extends TempoFilter implements IBitmapFilter {
		
		private var distortion:Distortion = new Distortion();
		private var tween:Tween;
		
		public function DistortTempo():void {
			
			super(true);

		}
		
		override protected function onTrigger(beat:int, event:Event):void {
			
			var points:Array = [distortion.topLeft, distortion.topRight, distortion.bottomRight, distortion.bottomLeft];
			points = points.sort(_sort);
			
			tween = new Tween(
				this, 
				nextDelay,
				new TweenProperty('topLeftX', topLeftX, getRndX(points.indexOf(distortion.topLeft))),
				new TweenProperty('topLeftY', topLeftY, getRndY(points.indexOf(distortion.topLeft))),
				new TweenProperty('topRightX', topRightX, getRndX(points.indexOf(distortion.topRight))),
				new TweenProperty('topRightY', topRightY, getRndY(points.indexOf(distortion.topRight))),
				new TweenProperty('bottomLeftX', bottomLeftX, getRndX(points.indexOf(distortion.bottomLeft))),
				new TweenProperty('bottomLeftY', bottomLeftY, getRndY(points.indexOf(distortion.bottomLeft))),
				new TweenProperty('bottomRightX', bottomRightX, getRndX(points.indexOf(distortion.bottomRight))),
				new TweenProperty('bottomRightY', bottomRightY, getRndY(points.indexOf(distortion.bottomRight)))
			);
		}
		
		/**
		 * 
		 */
		private function _sort(a:Point,b:Point):int {
			var num : int = Math.round(Math.random()*2)-1;
			return num;
		}
		
		/**
		 * 	@private
		 */
		private function getRndX(index:int):int {
			
			if (index % 2 === 0) {
				return 0 - (Math.random() * DISPLAY_WIDTH / 4);
			} else {
				return DISPLAY_WIDTH + (Math.random() * DISPLAY_WIDTH / 4);
			}
			
		}
		
		/**
		 * 
		 */
		private function getRndY(index:int):int {
			if (Math.floor(index / 2) === 1) {
				return DISPLAY_HEIGHT + (Math.random() * DISPLAY_HEIGHT / 4);
			} else {
				return 0 - (Math.random() * DISPLAY_HEIGHT / 4);
			}
		}
		
		public function set topLeftX(value:Number):void {
			distortion.topLeft.x = value;
		}
		
		public function set topRightX(value:Number):void {
			distortion.topRight.x = value;
		}
		
		public function set bottomLeftX(value:Number):void {
			distortion.bottomLeft.x = value;
		}
		
		public function set bottomRightX(value:Number):void {
			distortion.bottomRight.x = value;
		}
		
		public function set topLeftY(value:Number):void {
			distortion.topLeft.y = value;
		}
		
		public function set topRightY(value:Number):void {
			distortion.topRight.y = value;
		}
		
		public function set bottomLeftY(value:Number):void {
			distortion.bottomLeft.y = value;
		}
		
		public function set bottomRightY(value:Number):void {
			distortion.bottomRight.y = value;
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
			Distortion.render(source, distortion, null, null, 'overlay');
		}
		
		override public function dispose():void {
			if (tween) {
				tween.dispose();
			}
		}
		
	}
}