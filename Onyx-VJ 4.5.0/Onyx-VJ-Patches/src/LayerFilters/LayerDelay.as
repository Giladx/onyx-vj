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
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	public final class LayerDelay extends Patch {

		/**
		 * 	@private
		 */
		private var _content:Content;
		
		/**
		 * 	The delay between layers
		 */
		public var delay:int			= 8;
		
		/**
		 * 
		 */
		private var frames:Array		= [];
		
		/**
		 * 	@private
		 */
		public var layers:int			= 4;
		
		/**
		 * 	@public
		 */
		public var blend:String			= 'lighten';
		
		/**
		 * 	@private
		 */
		private var _transform:ColorTransform	= new ColorTransform();
		
		/**
		 * 	@constructor
		 */
		public function LayerDelay():void {

			parameters.addParameters(
			 	new ParameterLayer('source', 'source'),
			 	new ParameterInteger('delay', 'frame delay', 1, 24, 6),
			 	new ParameterInteger('layers', 'layers', 4, 12, layers),
			 	new ParameterBlendMode('blend', 'blend'),
			 	new ParameterNumber('amount', 'amount', 0, 1, 1)
			 );
			 
		}
		
		/**
		 * 
		 */
		public function set amount(value:Number):void {
			_transform.alphaMultiplier = value;
		}
		
		/**
		 * 
		 */
		public function get amount():Number {
			return _transform.alphaMultiplier;
		}
		
		/**
		 * 	The layer to render
		 */
		public function get source():Content {
			return _content;
		}
		
		/**
		 * 	The layer to render
		 */
		public function set source(value:Content):void {
			this._content = value;
		}
		
		/**
		 * 	Render, called from Onyx
		 */
		override public function render(info:RenderInfo):void {
			
			// check the source	
			if (_content && _content.source) {
				
				var source:BitmapData	= info.source;

				var frame:BitmapData	= _content.source.clone(); 
				frames.push(frame);
				
				var totalFrames:int		= delay * layers;
				
				if (frames.length >= totalFrames) {
					while (frames.length >= totalFrames) {
						var data:BitmapData = frames.shift() as BitmapData;
						data.dispose();
					}
				}
				
				var first:Boolean	= true;
				
				// now we need to draw
				for (var count:int = totalFrames; count >= delay; count -= delay) {
					frame = frames[count];
					if (frame) {
						if (first) {
							info.source.draw(frame, info.matrix, _transform, 'normal', null, true);
						} else {
							info.source.draw(frame, info.matrix, _transform, blend, null, true);
						}
					}
					first = false;
				}
			}
		}
		
		/**
		 * 	Dispose, called from onyx
		 */
		override public function dispose():void {

		}
	}
}