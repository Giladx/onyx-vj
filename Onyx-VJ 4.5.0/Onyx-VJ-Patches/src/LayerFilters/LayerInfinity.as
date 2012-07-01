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
package LayerFilters {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	import onyx.tween.Tween;

	public class LayerInfinity extends Patch implements IRenderObject, IParameterObject {

		private var start:Point;
		private var _controls:Parameters;
		private var _rect:Rectangle;
		private var concatMatrix:Matrix;
		private var targetMatrix:Matrix;
		private var tween:Tween;
		private var lastTime:int;

		public var delay:int	= 0;
		public var blend:String	= 'normal';
		public var time:int		= 1500;
		
		public var layer:Layer;
		
		private var frames:Array	= [];
		private var tr:Point		= new Point(DISPLAY_WIDTH, 0);
		
		/**
		 * 
		 */
		public function LayerInfinity():void {
			
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterInteger('time', 'time', 250, 5000, time),
				new ParameterBlendMode('blend', 'blend'),
				new ParameterProxy(
					'pos', 'pos', 
					new ParameterInteger('xx', 'x', 0, 320, 0),
					new ParameterInteger('xy', 'y', 0, 240, 0),
					true
				),
				new ParameterProxy(
					'size', 'size', 
					new ParameterInteger('xwidth', 'width', 16, 320, 160),
					new ParameterInteger('xheight', 'height', 12, 240, 120),
					true
				),
				new ParameterBoolean('mouseListen', 'mouserect'),
				new ParameterInteger('delay', 'delay', 0, 24, 0)
			);
			_rect		= new Rectangle(100,80,120,80);
			
			updateMatrix();
		}
		
		/**
		 *	@private 
		 */
		private function updateMatrix():void {
			
			concatMatrix	= new Matrix(_rect.width / DISPLAY_WIDTH, 0, 0, _rect.height / DISPLAY_HEIGHT, _rect.x, _rect.y);
			targetMatrix	= concatMatrix.clone();
			targetMatrix.invert();
			
		}
		
		/**
		 * 
		 */
		public function set xx(value:Number):void {
			_rect.x = value;
			
			updateMatrix();
		}
		
		/**
		 * 
		 */
		public function get xx():Number {
			return _rect.x;
		}
		
		/**
		 * 
		 */
		public function set xy(value:Number):void {
			_rect.y = value;
			
			updateMatrix();
		}
		
		/**
		 * 
		 */
		public function get xy():Number {
			return _rect.y;
		}
		
		
		/**
		 * 
		 */
		public function set xwidth(value:Number):void {
			_rect.width = value;
			
			updateMatrix();
		}
		
		/**
		 * 
		 */
		public function get xwidth():Number {
			return _rect.width;
		}
		
		/**
		 * 
		 */
		public function set xheight(value:Number):void {
			_rect.height = value;
			
			updateMatrix();
		}
		
		/**
		 * 
		 */
		public function get xheight():Number {
			return _rect.height;
		}
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {
			
			var timer:int	= getTimer();
			var ms:int		= timer - lastTime;
			if (ms >= time) {
				var ratio:Number = 1;
				lastTime = timer;
			} else {
				ratio = ms / time; 
			}
			
			if (layer && layer.source) {
				
				var source:BitmapData	= info.source;
				
				if (delay > 0) {
					
					frames.push(layer.source.clone());
					if (frames.length > 100) {
						var bmp:BitmapData = frames.shift() as BitmapData;
						bmp.dispose();
					}
				}
				
				var matrix:Matrix = new Matrix(
					((targetMatrix.a - 1) * ratio) + 1,
					0,
					0,
					((targetMatrix.d - 1) * ratio) + 1,
					targetMatrix.tx * ratio,
					targetMatrix.ty * ratio
				);
				
				var count:int = frames.length - 1;
				
				source.draw(layer.source, matrix, null, null, null, true);
				
				while (true) {
					matrix.concat(concatMatrix);
					
					count -= delay;
					
					bmp = (delay > 0) ? frames[count] : layer.source;
					
					if (bmp) {
						
						source.draw(bmp, matrix, null, blend, null, true);
						
						var mtl:Point = matrix.transformPoint(ONYX_POINT_IDENTITY);
						var mtr:Point = matrix.transformPoint(tr);
						
						if (mtr.x - mtl.x < 5) {
							break;
						}
						
					} else {
						break;
					}
				}
			}
			
		}
		
		/**
		 * 
		 */
		public function get controls():Parameters {
			return _controls;
		}
		
		/**
		 * 
		 */
		public function set mouseListen(value:Boolean):void {
			if (value) {
				this.addEventListener(InteractionEvent.MOUSE_DOWN, handler);
				this.addEventListener(InteractionEvent.MOUSE_UP, handler);
				this.addEventListener(InteractionEvent.RIGHT_MOUSE_DOWN, handler);
			} else {
				this.removeEventListener(InteractionEvent.RIGHT_MOUSE_DOWN, handler);
				this.removeEventListener(InteractionEvent.MOUSE_DOWN, handler);
				this.removeEventListener(InteractionEvent.MOUSE_UP, handler);
			}
		}
		
		/**
		 * 
		 */
		public function get mouseListen():Boolean {
			return this.hasEventListener(MouseEvent.MOUSE_DOWN);
		}
		
		/**
		 * 	@private
		 */
		private function handler(event:MouseEvent):void {
			
			switch (event.type) {
				case InteractionEvent.MOUSE_DOWN:
				
					start = new Point(event.localX, event.localY);
				
					break;
				case InteractionEvent.MOUSE_UP:
				
					if (event.localX > start.x && event.localY > start.y) {
						_rect = new Rectangle(start.x, start.y, event.localX - start.x, event.localY - start.y);
						updateMatrix();
					}
				
					break;
				case InteractionEvent.RIGHT_MOUSE_DOWN:
					break;
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			mouseListen = false;
			
			while (frames.length) {
				var data:BitmapData = frames.shift() as BitmapData;
				data.dispose();
			}
		}
		
	}
}