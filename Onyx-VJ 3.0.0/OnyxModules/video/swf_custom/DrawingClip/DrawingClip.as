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
package {
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.display.*;
	import onyx.utils.bitmap.Distortion;

	/**
	 * 	Drawing clip
	 * 	Control click on a layer the preview box to send mouse events to this file
	 */
	[SWF(width='320', height='240', frameRate='24')]
	public class DrawingClip extends Sprite implements IRenderObject, IControlObject {
		
		public var color:uint				= 0xFFFFFF;
		private var _source:BitmapData		= new BitmapData(BITMAP_WIDTH,BITMAP_HEIGHT,true, 0x00000000);
		private var _controls:Controls;

		public var preblur:Number			= 0;
		private var _currentBlur:Number		= 0;
		
		private var _blur:BlurFilter;
		private var _begin:Boolean			= false;
		
		private var lastX:int;
		private var lastY:int;
		
		/**
		 * 	@constructor
		 */
		public function DrawingClip():void {
			
			_controls = new Controls(this, 
				new ControlNumber('preblur',	'preblur', 0, 30, 0, 10),
				new ControlColor('color', 'color')
			);
			addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
		}
		
		/**
		 * 	@private
		 */
		private function _mouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
			lastX = event.localX;
			lastY = event.localY;
			
			_mouseMove(event);
		}

		/**
		 * 	@private
		 */
		private function _mouseMove(event:MouseEvent):void {
			
			graphics.moveTo(lastX,lastY);
			graphics.lineTo(event.localX,event.localY);
			lastX = event.localX;
			lastY = event.localY;
		}

		/**
		 * 	@private
		 */
		public function render():RenderTransform {
			
			_currentBlur	+= preblur;
			
			if (_currentBlur >= 2) {
				var factor:int = _currentBlur - 2;
				
				_currentBlur = 0;
				_source.applyFilter(_source, BITMAP_RECT, POINT, new BlurFilter(factor + 2,factor + 2));
			}

			_source.draw(this);

			// clear
			graphics.clear();
			graphics.lineStyle(0, color);
			
			var transform:RenderTransform = RenderTransform.getTransform(this);
			transform.content = _source;
			return transform;
		}
		
		/**
		 * 	@private
		 */
		private function _mouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {

			_source.dispose();
			_source = null;
			
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);

			_controls = null;
			graphics.clear();

		}
	}
}