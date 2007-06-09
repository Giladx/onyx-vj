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
package {
	
	import flash.display.Sprite;
	
	import onyx.controls.*;
	import onyx.display.ILayer;
	import onyx.display.*;
	import onyx.content.IContent;

	public class LayerCopy extends Sprite implements IRenderObject, IControlObject {
		
		/**
		 * 	@private
		 */
		private var _controls:Controls;

		/**
		 * 	@private
		 */
		private var _layer:IContent;
		
		/**
		 * 	@constructor
		 */
		public function LayerCopy():void {
			 _controls = new Controls(this,
			 	new ControlLayer('layer', 'layer'),
			 	new ControlDisplay('layer', 'display')
			 );
		}
		
		/**
		 * 	The layer to render
		 */
		public function get layer():IContent {
			return _layer;
		}
		
		/**
		 * 	The layer to render
		 */
		public function set layer(value:IContent):void {
			this._layer = value;
		}
		
		/**
		 * 	Return controls
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	Render, called from Onyx
		 */
		public function render():RenderTransform {
			
			var transform:RenderTransform = new RenderTransform();
			transform.content = _layer ? _layer.rendered : null;
			
			return transform;
		}
		
		/**
		 * 	Dispose, called from onyx
		 */
		public function dispose():void {
			_controls.dispose();
			_controls	= null;
			_layer		= null;
		}
	}
}
