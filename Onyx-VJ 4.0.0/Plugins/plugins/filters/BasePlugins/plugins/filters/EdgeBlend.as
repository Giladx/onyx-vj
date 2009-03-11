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
package plugins.filters {
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
//	import onyx.plugin.*;

	public final class EdgeBlend extends Filter implements IBitmapFilter {
		
		private var buffer:BitmapData;
		
		public var matrix:Array				= [0, -2, 0, -2, 8, -2, 0, -2, 0];
		public var transform:ColorTransform = new ColorTransform();
		public var filter:ConvolutionFilter	= new ConvolutionFilter(3, 3, matrix, 1);
		public var sharpen:Boolean			= false;
		public var mode:String				= 'darken';
		public var blend:String				= 'lighten';
		
		public function EdgeBlend():void {
			parameters.addParameters(
				new ParameterBlendMode('mode', 'mixback mode'),
				new ParameterBlendMode('blend', 'blend'),
				new ParameterNumber('alpha', 'alpha', 0, 1, 1),
				new ParameterInteger('width', 'width', 1, 100, 2),
				new ParameterBoolean('includeSource', 'include source')
			);
		}
		
		public function get includeSource():Boolean {
			return sharpen;
		}
		
		public function set includeSource(value:Boolean):void {
			this.sharpen = value;
			this.width = width;
		}
		
		public function get width():int {
			return matrix[1] * -1;
		}
		
		public function set width(value:int):void {
			matrix[1] = matrix[3] = matrix[5] = matrix[7] = value * -1;
			matrix[4] = value * 4;
			
			if (sharpen) {
				matrix[7] = matrix[7] / 2;
			}
			
			filter.matrix = matrix;
		}
		
		public function set alpha(value:Number):void {
			transform.alphaMultiplier = value;
		}
		
		public function get alpha():Number {
			return transform.alphaMultiplier;
		}
		
		override public function initialize():void {
			buffer	= createDefaultBitmap();		
		}
		
		override public function set muted(value:Boolean):void {
			super.muted = value;
			
			if (value && buffer) {
				buffer.fillRect(DISPLAY_RECT, 0);
			}
		}
		
		public function applyFilter(source:BitmapData):void {
			
			source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, filter);
			buffer.draw(source, null, transform, blend);
			source.draw(buffer, null, null, mode);
		}
		
		override public function dispose():void {
			if (buffer) {
				buffer.dispose();
			}
		}
	}
}