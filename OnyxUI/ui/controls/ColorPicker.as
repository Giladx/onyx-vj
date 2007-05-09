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
package ui.controls {
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.utils.math.*;
	
	import ui.assets.AssetColorPicker;
	import ui.core.UIObject;

	public final class ColorPicker extends UIControl {
		
		/**
		 * 	@private
		 */
		private static const STAGE_COLOR:BitmapData = new BitmapData(1,1, false);
		
		/**
		 * 
		 */
		private static const RECT:Rectangle			= new Rectangle(0, 0, 1, 1);
		
		/**
		 * 	@private
		 */
		private static var _picker:Picker;

		/**
		 * 	@private
		 */
		private var _preview:Shape		= new Shape();

		/**
		 * 	@private
		 */
		private var _lastX:int			= 0;

		/**
		 * 	@private
		 */
		private var _lastY:int			= 0;

		/**
		 * 	@constructor
		 */		
		public function ColorPicker(options:UIOptions, control:Control):void {
			
			super(options, control, true, control.display);
			
			_draw(options.width, options.height);
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
			useHandCursor	= true;
			buttonMode		= true;
			mouseChildren	= false;

		}
		
		/**
		 * 	Begin initial fill
		 */
		private function _draw(width:int, height:int):void {
			
			var graphics:Graphics = _preview.graphics;
			graphics.beginFill(0x000000);
			graphics.drawRect(1, 1, width - 1, height - 1);
			graphics.endFill();

			addChild(_preview);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			
			_picker		= new Picker();
			_picker.x	= -_lastX + mouseX;
			_picker.y	= -_lastY + mouseY;
			
			// add to the root outside container so it doesn't clip
			CONTAINER.display(this, _picker);
			
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			_onMouseMove(event);

			// prevent event propagation
			event.stopPropagation();
		}

		/**
		 * 	@private
		 */
		private function _onMouseMove(event:MouseEvent):void {
			
			var transform:ColorTransform = new ColorTransform();
			var picker:Picker	= _picker;
			
			// first, check to see if we're hitting the picker, if so, grab the pixel directly
			if (_picker.mouseX > 0 && _picker.mouseX < 100 && _picker.mouseY > 0 && _picker.mouseY < 100) {
				picker.alpha			= 1;
				picker.cursor.visible	= true;
				var color:uint			= picker.asset.bitmapData.getPixel(_lastX, _lastY);
				
				_lastX = min(max(picker.mouseX,0),99);
				_lastY = min(max(picker.mouseY,0),99);

				picker.cursor.x = _lastX;
				picker.cursor.y = _lastY;
				
			} else {
				
				picker.alpha			= .3;
				picker.cursor.visible	= false;

				var matrix:Matrix		= new Matrix();
				matrix.translate(-STAGE.mouseX, -STAGE.mouseY);

				STAGE_COLOR.draw(STAGE, matrix, null, null, RECT);
				color = STAGE_COLOR.getPixel(0,0);

			}
						
			transform.color = color;
			_control.value = transform.color;
			_preview.transform.colorTransform = transform;
			
		}

		/**
		 * 	@private
		 */
		public function _onMouseUp(event:MouseEvent):void {

			CONTAINER.remove();
			
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
		}
		
		/**
		 * 	Changes color
		 */
		public function set color(c:int):void {
			var transform:ColorTransform = new ColorTransform();
			transform.color = c;
			_preview.transform.colorTransform = transform;
		}
		
		override public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
			super.dispose();			
		}
	}
}

import flash.display.Sprite;
import ui.assets.AssetColorPicker;
import flash.display.Shape;
import flash.geom.ColorTransform;	

/**
 *
 */
final class Picker extends Sprite {
	
	public var cursor:Shape				= new Shape();
	public var asset:AssetColorPicker	= new AssetColorPicker();
	
	/**
	 * 	@constructor
	 */
	public function Picker():void {

		addChild(asset);
		addChild(cursor);

		cursor.graphics.lineStyle(0, 0x000000);
		cursor.graphics.drawRect(0,0,2,2);
		
		mouseEnabled	= false;
		tabEnabled		= false;
	}
}