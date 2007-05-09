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

	/**
	 * 	Drawing clip
	 * 	Control click on a layer the preview box to send mouse events to this file
	 */
	[SWF(width='320', height='240', frameRate='24')]
	public class DrawingClip extends Sprite implements IRenderObject, IControlObject {
		
		public var color:uint	= 0xFFFFFF;
		
		private var _source:BitmapData		= new BitmapData(BITMAP_WIDTH,BITMAP_HEIGHT,true, 0x00000000);
		private var _controls:Controls;
		
		/**
		 * 	@constructor
		 */
		public function DrawingClip():void {
			_controls = new Controls(this, 
				new ControlColor('color', 'color')
			);
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			_draw(event.localX, event.localY);
		}

		/**
		 * 	@private
		 */
		private function _onMouseMove(event:MouseEvent):void {
			_draw(event.localX, event.localY);
		}
		
		/**
		 * 	@private
		 */
		private function _draw(x:int, y:int):void {
			
			var graphics:Graphics = this.graphics;
			
			graphics.beginFill(color);
			graphics.drawCircle(x, y, 3);
			graphics.endFill();
		}

		/**
		 * 	@private
		 */
		public function render():RenderTransform {
			
			var transform:RenderTransform = RenderTransform.getTransform(this);
			transform.content = _source;

			_source.scroll(2,1);
			_source.draw(this);

			graphics.clear();
			
			return transform;
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {

			_source.dispose();
			_source = null;
			
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			_controls.dispose();
			graphics.clear();

		}
	}
}