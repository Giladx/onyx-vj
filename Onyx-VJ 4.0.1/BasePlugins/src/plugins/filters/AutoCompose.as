/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package plugins.filters {
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.events.*;
	import onyx.parameter.*;


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
				new ParameterExectueFunction'clear', 'clear'),
				new ParameterNumber('preblur',	'preblur', 0, 30, 0, 10),
				new ParameterNumber('drawDelay',	'drawDelay', 0, 30, 1, 10),
				new ParameterNumber('alpha',	'alpha', 0, 1, .3),
				new ParameterBlendMode('mode', 'mode', mode)
			);

		}
		
		public function clear():void {
			_buffer.fillRect(DISPLAY_RECT, 0);
		}
		
		override public function initialize():void {
			_buffer = createDefaultBitmap();
			super.initialize();
		}
		
		public function applyFilter(source:BitmapData):void {
			
			_currentBlur	+= preblur;
			_currentDelay	+= drawDelay;
			
			if (_currentBlur >= 2) {
				var factor:int = _currentBlur - 2;
				
				_currentBlur -= factor;
				_buffer.applyFilter(_buffer, DISPLAY_RECT, ONYX_POINT_IDENTITY, new BlurFilter(factor,factor));
			}
			
			if (_currentDelay >= 1) {
				_currentDelay--;

				// auto-scroll
				_buffer.draw(source, null, _alpha,mode);
			}
			
			source.copyPixels(_buffer, DISPLAY_RECT, POINT);
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
	

	import onyx.parameter.*;
	import onyx.display.*;

	[SWF(width='320', height='240', frameRate='24')]
	public class LayerDraw extends Sprite implements IParameterObject {
		
		private var _controls:Parameters;
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
			bitmap	= new Bitmap(createDefaultBitmap());
			
			_controls = new Parameters(this,
				new ParameterLayer('layer', 'layer'),
				new ParameterBoolean('followMouse', 'followMouse'),
				new ParameterInteger('preblur', 'preblur', 0, 30, 0),
				new ParameterInteger('size', 'size', 0, 100, 50),
				new ParameterInteger('alph', 'alpha', 0, 100, 100),
				new ParameterBlendModes('mode', 'blend'),
				new ParameterExectueFunction'clear', 'clear')
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
			bitmap.bitmapData.fillRect(DISPLAY_RECT, 0x00000000);
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
				graphics.beginBitmapFill(layer.source, matrix);
				graphics.drawCircle(event.localX, event.localY, size);
				graphics.endFill();
			}
		}
		
		private function enterFrame(event:Event):void {
			var source:BitmapData	= this.bitmap.bitmapData;
			
			if (_blur) {
				source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _blur);
			}
			
			source.draw(shape, null, color, mode);
		}
		
		private function mouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			shape.graphics.clear();
		}
		
		public function get controls():Parameters {
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