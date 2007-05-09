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
	
	import cursor.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.content.IContent;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;

	/**
	 * 
	 */
	[SWF(width='320', height='240', frameRate='24')]
	public class ScreenShare extends Sprite implements IControlObject, IRenderObject {

		/**
		 * 	@private
		 */
		private var _mouseX:int;

		/**
		 * 	@private
		 */
		private var _mouseY:int;

		/**
		 * 	@private
		 */
		private var _scale:Number			= 1;

		/**
		 * 	@private
		 */
		private var _backgroundColor:uint 	= 0x000000;

		/**
		 * 	@private
		 */
		private var _controls:Controls;
		
		/**
		 * 	@constructor
		 */
		public function ScreenShare():void {
			_controls = new Controls(this,
				new ControlInt('scale', 'scale', 1, 200, 100),
				new ControlColor('backgroundColor', 'Background Color')
			);
			

			_mouseX = STAGE.mouseX;
			_mouseY = STAGE.mouseY;
			
			STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			_mouseX = STAGE.mouseX;
			_mouseY = STAGE.mouseY;
			
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseMove(event:MouseEvent):void {
			_mouseX = STAGE.mouseX;
			_mouseY = STAGE.mouseY;
		}
			
		/**
		 * 	@private
		 */
		public function render():RenderTransform {
			
			var transform:RenderTransform = new RenderTransform();
			transform.content	= STAGE;
			transform.rect		= new Rectangle(0,0,BITMAP_WIDTH,BITMAP_HEIGHT);

			var offsetX:int		= STAGE.mouseX - (BITMAP_WIDTH / 2);
			var offsetY:int		= STAGE.mouseY - (BITMAP_HEIGHT / 2);
			
			var matrix:Matrix	= new Matrix();
			matrix.scale(_scale, _scale);
			matrix.translate(-offsetX, -offsetY);
			transform.matrix	= matrix;

			return transform;
		}
		
		/**
		 * 
		 */
		public function set backgroundColor(value:uint):void {
			_backgroundColor = controls.getControl('backgroundColor').setValue(value);
		}
		
		/**
		 * 
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}

		/**
		 * 	Returns scale
		 */
		public function set scale(value:int):void {
			_scale = value / 100;
		}
		
		/**
		 * 
		 */
		public function get scale():int {
			return _scale * 100;
		}
		
		/**
		 * 	Returns custom controls
		 */
		public function get controls():Controls {
			return _controls;
		}

		/**
		 * 	dispose
		 */
		public function dispose():void {
			_controls.dispose();
			_controls = null;
			
			STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);

		}
	}
}