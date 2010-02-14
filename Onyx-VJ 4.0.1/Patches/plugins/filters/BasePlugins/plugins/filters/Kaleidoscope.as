/**
 * Copyright (c) 2003-2010 Mario Klingemann
 *
 * http://www.quasimondo.com
 * twitter: @quasimondo
 * contact: mario@quasimondo.com
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 */
package plugins.filters {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class Kaleidoscope extends Filter implements IBitmapFilter {
		
		private var diag:Number;
		private var _alpha:ColorTransform	= new ColorTransform();
		private var _slices:int				= 12;
		
		private var nudge:Number			= 0.09;
		private var sclfact:Number			= 0;
		private var rot:Number				= 0;
		private var r:Number				= 0;
		private var r2:Number				= 0;
		private var sh1:Number				= 0;
		private var sh2:Number				= 0;
		private var scl:Number				= 1;
		private var m:Matrix				= new Matrix();

		public var rotate1:Boolean			= true;
		public var rotate2:Boolean			= true;
		public var rotate3:Boolean			= true;
		public var flip:Boolean				= false;
		public var singleview:Boolean		= true;
		public var rotspeed1:Number			= 0.007;
		public var rotspeed2:Number		= -0.003;
		public var rotspeed3:Number		= -0.005;

		private var angle:Number;
		private var stampImage:BitmapData;
		
		private const mat1:Matrix			= new Matrix(0.5, 0, 0, 0.5);
		private const mat2:Matrix			= new Matrix(-0.5, 0, 0, 0.5, DISPLAY_WIDTH);
		private const mat3:Matrix			= new Matrix(0.5, 0, 0, -0.5, 0, DISPLAY_HEIGHT);
		private const mat4:Matrix			= new Matrix(-0.5, 0, 0, -0.5, DISPLAY_WIDTH, DISPLAY_HEIGHT);
		
		/**
		 * 	@constructor
		 */
		public function Kaleidoscope():void {
			parameters.addParameters(
				new ParameterInteger('slices', 'slices', 1, 40, 15),
				new ParameterInteger('alpha', 'alpha', 0, 100, 100),
				new ParameterBoolean('rotate1', 'rotate1'),
				new ParameterBoolean('rotate2', 'rotate2'),
				new ParameterBoolean('rotate3', 'rotate3'),
				new ParameterBoolean('flip', 'flip'),
				new ParameterBoolean('singleview', 'singleview'),
				new ParameterNumber('rotspeed1', 'rotspd1', -1, 1, 0.007, 1000),
				new ParameterNumber('rotspeed2', 'rotspd2', -1, 1, 0.007, 1000),
				new ParameterNumber('rotspeed3', 'rotspd3', -1, 1, 0.007, 1000)
			);
		}
		
		public function set alpha(value:int):void {
			_alpha.alphaMultiplier = value / 100;
		}
		
		public function get alpha():int {
			return _alpha.alphaMultiplier * 100;
		}
		
		public function set slices(value:int):void {
			_slices = value;
			angle	= Math.PI / value;
		}
		
		public function get slices():int {
			return _slices
		}
		
		override public function initialize():void {
			
			stampImage = createDefaultBitmap();
			diag = Math.sqrt(2 * DISPLAY_HEIGHT * DISPLAY_HEIGHT) * .62;
			
			slices = _slices;

		}
		
		public function applyFilter(source:BitmapData):void {
			
			var slice:Shape = new Shape();
			
			stampImage.fillRect(DISPLAY_RECT, 0x00000000);
			stampImage.draw(source, mat1);
			stampImage.draw(source, mat2);
			stampImage.draw(source, mat3);
			stampImage.draw(source, mat4);
			
			source.fillRect(DISPLAY_RECT, 0x00000000);
			
			if (rotate1) {
				r += rotspeed1;
			}
			if (rotate2) {
				r2 -= rotspeed2;
			}
			if (rotate3) {
				rot += rotspeed3;
			}
			for (var i:int = 0; i<=_slices; i++) {
				m.identity();
				m.b += sh1;
				m.c += sh2;
				m.rotate(r2);
				m.translate(2*10/scl, 2*10/scl+i*sclfact*10);
				m.rotate(r);
				m.scale(scl, scl);
				
				var graphics:Graphics = slice.graphics;
				graphics.lineStyle();
				graphics.moveTo(0, 0);
				graphics.beginBitmapFill(stampImage, m);
				graphics.lineTo(Math.cos((angle+nudge)-Math.PI/2)*diag, Math.sin((angle+nudge)-Math.PI/2)*diag);
				graphics.lineTo(Math.cos(-(angle+nudge)-Math.PI/2)*diag, Math.sin(-(angle+nudge)-Math.PI/2)*diag);
				graphics.lineTo(0, 0);
				graphics.endFill();
				m.identity();
				if (flip && i%2 == 1) {
					m.scale(-1, 1);
				}
				m.rotate(rot+i*angle*2);
				m.translate(DISPLAY_WIDTH*0.5, DISPLAY_HEIGHT*0.5);
				
				source.draw(slice, m);
			}
			
		}
		
	}
}