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
package onyx.utils {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.*;
	
	import onyx.constants.STAGE;
	import onyx.core.IDisposable;
	import onyx.utils.math.*;
	
	/**
	 * 	Displays a graph over time
	 */
	public final class GraphPlotter extends Sprite implements IDisposable {
		
		/**
		 * 	@private
		 */
		public var maxY:Number;

		/**
		 * 	@private
		 */
		public var minY:Number;

		/**
		 * 	@private
		 */
		private var maxX:Number	= 0;

		/**
		 * 	@private
		 */
		private var minX:Number	= 0;
		
		/**
		 * 	@private
		 */
		private var _width:int;

		/**
		 * 	@private
		 */
		private var _height:int;
		
		/**
		 * 	@private
		 */
		private var _graph:Shape		= new Shape();
		
		/**
		 * 	@private
		 */
		private var _minText:TextField	= new TextField();

		/**
		 * 	@private
		 */
		private var _maxText:TextField	= new TextField();
		
		/**
		 * 	@private
		 */
		private var _init:Boolean		= false;
		
		/**
		 * 	@private
		 */
		private var _firstVal:int		= getTimer();
		
		/**
		 * 	@constructor
		 */
		public function GraphPlotter(initValue:Number = 0, color:uint = 0xFFFF00, labelOffsetX:int = 0, width:int = 200, height:int = 188):void {

			_width	= width;
			_height = height;
			
			maxY = minY = initValue;

			_minText.width 		= width;
			_maxText.width 		= width;
			_minText.height		= _maxText.height = 20;
			_minText.y			= height - 20;
			_minText.selectable = _maxText.selectable = false;
			_minText.textColor	= _maxText.textColor = color;
			_minText.x			= _maxText.x = labelOffsetX;

			var x:Number = 0;
			var y:Number = initValue;
			
			_calc(x, y);
			
			_graph.graphics.clear();
			_graph.graphics.lineStyle(0, color);
			_graph.graphics.moveTo(x, y);
			
			addChild(_graph);
			addChild(_minText);
			addChild(_maxText);
		}
		
		/**
		 * 	@private
		 * 	Calculates minimum and maximum values
		 */
		private function _calc(x:Number, y:Number):void {
			maxY = max(y, maxY);
			minY = min(y, minY);
			maxX = max(x, maxX);
			minX = min(x, minX);
			
			_minText.text = minY.toFixed(2);
			_maxText.text = maxY.toFixed(2);
		}
		
		/**
		 * 	Registers a value to plot
		 */
		public function register(value:Number):void {
			
			var x:Number = (getTimer() - _firstVal) / STAGE.frameRate;
			var y:Number = value;
			
			// calculate the x / y
			_calc(x, y);

			// draw
			_graph.graphics.lineTo(x, y);
			
			// get ratio
			var ratioY:Number			= _height / (maxY - minY);
			_graph.y					= (maxY * ratioY);

			_graph.scaleY				= -ratioY;
			_graph.scaleX				= _width / maxX;
			
		}
		
		/**
		 * 	Dispose
		 */
		public function dispose():void {
			_graph.graphics.clear();
			_minText = null;
			_maxText = null;
		}
	}
}