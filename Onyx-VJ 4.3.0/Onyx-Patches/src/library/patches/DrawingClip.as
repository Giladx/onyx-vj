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
package library.patches {
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 	Drawing clip
	 * 	Control click on a layer the preview box to send mouse events to this file
	 */
	public class DrawingClip extends Patch {
		
		private const source:BitmapData		= createDefaultBitmap();
		private const filter:BlurFilter		=  new BlurFilter(0, 0);
		private var last:Point				= new Point(0, 0);

		private var _currentBlur:Number		= 0;
		private var _blur:BlurFilter;
		private var _begin:Boolean			= false;

		public var lineColor:uint			= 0xFFFFFF;
		public var fillColor:uint			= 0xFFFFFF;
		public var preblur:Number			= 0;
		public var size:int					= 3;
		public var type:String				= 'circle';
		public var fill:Boolean				= true;
		public var line:Boolean				= true;
		public var alph:Number				= 1;
	
		/**
		 * 	@constructor
		 */
		public function DrawingClip():void {

			parameters.addParameters( 
				new ParameterArray('type', 'type', ['circle', 'square', 'line'], type),
				new ParameterInteger('size', 'size', 2, 30, size),
				new ParameterNumber('alph', 'alpha', 0, 1, alph),
				new ParameterColor('lineColor', 'lineColor'),
				new ParameterColor('fillColor', 'fillColor'),
				new ParameterBoolean('fill', 'draw fill'),
				new ParameterBoolean('line', 'draw line'),
				new ParameterNumber('preblur',	'preblur', 0, 30, 0, 10)
			);
			
			addEventListener(InteractionEvent.MOUSE_DOWN, mouseDown);
		}
		
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			
			addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
			last.x = event.localX;
			last.y = event.localY;
			
			_mouseMove(event);
		}

		/**
		 * 	@private
		 */
		private function _mouseMove(event:MouseEvent):void {
			
			switch (type) {
				case 'circle':
					graphics.drawCircle(event.localX, event.localY, size);
					break;
				case 'square':
					graphics.drawRect(event.localX - size / 2, event.localY - size / 2, size, size);
					break;
				case 'line':
					graphics.moveTo(last.x, last.y);
					graphics.lineTo(event.localX, event.localY);
					break;
			}

			last.x = event.localX;
			last.y = event.localY;
		}

		/**
		 * 	@private
		 */
		override public function render(info:RenderInfo):void {
			
			_currentBlur	+= preblur;
			
			if (_currentBlur >= 2) {
				var factor:int = _currentBlur - 2;
				
				_currentBlur = 0;
				
				filter.blurX = factor + 2;
				filter.blurY = factor + 2;
				
				source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, filter);
			}

			source.draw(this);

			// clear
			graphics.clear();
			if (line) {
				graphics.lineStyle(size, lineColor, alph);
			}
			if (fill) {
				graphics.beginFill(fillColor, alph);
			}
			
			// blit to the layer
			info.copyPixels(source);
		}
		
		/**
		 * 	@private
		 */
		private function _mouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		}
		
		/**
		 * 	Called when the item is destroyed
		 */
		override public function dispose():void {

			source.dispose();
			
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);

		}
	}
}