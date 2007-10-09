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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.controls.Controls;
	import onyx.core.*;
	import onyx.display.*;
	
	[ExcludeClass]
	public class ContentCustom extends Content {
		
		/**
		 * 	@private
		 * 	Stores the loader object where the content was loaded into
		 */
		private var _loader:Loader;
				
		/**
		 * 	@private
		 * 	The ratio to store the content
		 */
		private var _ratioX:Number							= 1;
		
		/**
		 * 	@private
		 * 	The ratio to store the content
		 */
		private var _ratioY:Number							= 1;

		/**
		 * 	@constructor
		 */		
		public function ContentCustom(layer:ILayer, path:String, loader:Loader):void {
			
			_loader		= loader;

			// store ratio
			_ratioX = BITMAP_WIDTH / loader.contentLoaderInfo.width;
			_ratioY = BITMAP_HEIGHT / loader.contentLoaderInfo.height;
			
			// pass controls
			super(layer, path, loader.content);
			
		}
		
		/**
		 * 	Render
		 */
		override public function render():RenderTransform {
			
			var content:IRenderObject			= _content as IRenderObject;
			var transform:RenderTransform		= content.render() || new RenderTransform();
			var drawContent:IBitmapDrawable		= transform.content || _content;
			
			// render content
			renderContent(_source, drawContent, transform, _filter);
			
			// render filters
			_filters.render(_source);
						
			// return transformation
			return transform;
		}
		
		/**
		 * 	Destroys the content
		 */
		override public function dispose():void {
			super.dispose();

			// destroy content
			_loader.unload();
			_loader	= null;
		}

		/**
		 * 
		 */		
		override public function get scaleX():Number {
			return super.scaleX / _ratioX;
		}
		
		/**
		 * 
		 */		
		override public function set scaleX(value:Number):void {
			super.scaleX = value * _ratioX;
		}
		
		/**
		 * 
		 */		
		override public function get scaleY():Number {
			return super.scaleY / _ratioY;
		}
		
		/**
		 * 
		 */		
		override public function set scaleY(value:Number):void {
			super.scaleY = value * _ratioY;
		}
	}
}