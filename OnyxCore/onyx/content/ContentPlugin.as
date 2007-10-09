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
package onyx.content {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.utils.getTimer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;


	use namespace onyx_ns;
	
	[ExcludeClass]
	public final class ContentPlugin extends Content {
		
		/**
		 * 	@private
		 */
		private var _render:IRenderObject;

		/**
		 * 	@constructor
		 */
		public function ContentPlugin(layer:ILayer, path:String, renderable:IRenderObject):void {
			
			_render = renderable;
			
			// add a control for the visualizer
			_controls = new Controls(this);
			
			super(layer, path, null);
		}
		
		/**
		 * 	Updates the bimap source
		 */
		override public function render():RenderTransform {
	
			var content:IRenderObject			= _render as IRenderObject;
			var transform:RenderTransform		= content.render();
			var drawContent:IBitmapDrawable		= transform.content || _content;
			
			// render content
			renderContent(_source, drawContent, transform, _filter);
			
			// render filters
			_filters.render(_source);
						
			// return transformation
			return transform;
			
		}
		
		/**
		 * 	
		 */
		override public function get time():Number {
			return 0;
		}
		
		/**
		 * 	
		 */
		override public function set time(value:Number):void {
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {

			_render.dispose();
			_render = null;
			
			super.dispose();

		}
	}
}