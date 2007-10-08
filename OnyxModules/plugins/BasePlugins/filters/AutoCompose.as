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
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.plugin.*;
	import onyx.events.ControlEvent;

	public final class AutoCompose extends TempoFilter implements IBitmapFilter {
		
		private var _buffer:BitmapData;
		private var _alpha:ColorTransform	= new ColorTransform(1,1,1,.3);
		private var _currentBlur:Number		= 0;
		private var _currentDelay:Number	= 0;

		public var preblur:Number			= 0;
		public var drawDelay:Number			= 1;
		public var mode:String				= 'lighten'
		
		public function AutoCompose():void {
			
			super(true,
				null,
				new ControlExecute('clear', 'clear'),
				new ControlNumber('preblur',	'preblur', 0, 30, 0, 10),
				new ControlNumber('drawDelay',	'drawDelay', 0, 30, 1, 10),
				new ControlNumber('alpha',	'alpha', 0, 1, .3),
				new ControlBlend('mode', 'mode', mode)
			);

		}
		
		public function clear():void {
			_buffer.fillRect(BITMAP_RECT, 0);
		}
		
		override public function initialize():void {
			_buffer = BASE_BITMAP();
			super.initialize();
		}
		
		public function applyFilter(source:BitmapData):void {
			
			_currentBlur	+= preblur;
			_currentDelay	+= drawDelay;
			
			if (_currentBlur >= 2) {
				var factor:int = _currentBlur - 2;
				
				_currentBlur -= factor;
				_buffer.applyFilter(_buffer, BITMAP_RECT, POINT, new BlurFilter(factor,factor));
			}
			
			if (_currentDelay >= 1) {
				_currentDelay--;

				// auto-scroll
				_buffer.draw(source, null, _alpha,mode);
			}
			
			source.copyPixels(_buffer, BITMAP_RECT, POINT);
		}
		
		public function set alpha(value:Number):void {
			_alpha.alphaMultiplier = value;
		}
		
		public function get alpha():Number {
			return _alpha.alphaMultiplier;
		}
		
		override public function dispose():void {
			_buffer.dispose();
			_buffer = null;
		}
	}
}

/**

package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.display.*;

	[SWF(width='320', height='240', frameRate='24')]
	public class LayerDraw extends Sprite implements IControlObject {
		
		private var _controls:Controls;
		private var bitmap:Bitmap;
		private var shape:Shape;
		private var color:ColorTransform;
		
		public var mode:String			= 'lighten';
		public var layer:ILayer;
		public var size:int				= 50;
		public var followMouse:Boolean;
		
		private var _blur:BlurFilter;
		
		public function LayerDraw():void {
			color	= new ColorTransform();
			shape	= new Shape();
			bitmap	= new Bitmap(BASE_BITMAP());
			
			_controls = new Controls(this,
				new ControlLayer('layer', 'layer'),
				new ControlBoolean('followMouse', 'followMouse'),
				new ControlInt('preblur', 'preblur', 0, 30, 0),
				new ControlInt('size', 'size', 0, 100, 50),
				new ControlInt('alph', 'alpha', 0, 100, 100),
				new ControlBlend('mode', 'blend'),
				new ControlExecute('clear', 'clear')
			)
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			addChild(bitmap);
		}
		
		public function set preblur(value:int):void {
			if (value > 0) {
				_blur = new BlurFilter(value, value);
			} else {
				_blur = null;
			}
		}
		
		public function get preblur():int {
			return _blur ? _blur.blurX : 0; 
		}
		
		public function clear():void {
			bitmap.bitmapData.fillRect(BITMAP_RECT, 0x00000000);
		}
		
		public function set alph(value:int):void {
			color.alphaMultiplier = value / 100;
		}
		
		public function get alph():int {
			return color.alphaMultiplier * 100;
		}
		
		private function mouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		private function mouseMove(event:MouseEvent):void {
			if (layer) {
				var graphics:Graphics	= shape.graphics;
				var bitmap:BitmapData	= this.bitmap.bitmapData;
				var matrix:Matrix		= new Matrix();
				
				var x:Number				= event.localX;
				var y:Number				= event.localY;
				
				if (followMouse) {
					matrix.translate(-event.localX,-event.localY);
				}
				
				graphics.clear();
				graphics.beginBitmapFill(layer.rendered, matrix);
				graphics.drawCircle(event.localX, event.localY, size);
				graphics.endFill();
			}
		}
		
		private function enterFrame(event:Event):void {
			var source:BitmapData	= this.bitmap.bitmapData;
			
			if (_blur) {
				source.applyFilter(source, BITMAP_RECT, POINT, _blur);
			}
			
			source.draw(shape, null, color, mode);
		}
		
		private function mouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			shape.graphics.clear();
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
	}
}


**/