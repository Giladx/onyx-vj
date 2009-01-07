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
package ui.controls.sequence {
	
	import onyx.display.*;
	import onyx.plugin.Filter;
	
	import ui.assets.*;
	import ui.core.*;
	import ui.text.TextField;
	import ui.window.Browser;

	/**
	 * 
	 */
	public final class SequenceTrack extends UIObject implements ILayerDrop, IFilterDrop, ISelectable {
		
		/**
		 * 	@private
		 */
		private var _layer:Layer;
		
		/**
		 * 	@constructor
		 */
		public function SequenceTrack(layer:Layer):void {
			
			_layer = layer;
			
			var text:TextField	= new TextField(50,12);
			text.x				= 4;
			text.y				= 12;
			text.text			= 'TRACK ' + (_layer.index + 1);
			
			// add display
			addChild(new AssetSequenceTrack());
			addChild(text);
			
			// register it as a drop target
			Browser.registerTarget(this, true);
		}
		
		/**
		 * 
		 */
		public function set selected(value:Boolean):void {
			
		}
		
		/**
		 * 
		 */
		public function get layer():ILayer {
			return _layer;
		}
		
		/**
		 * 
		 */
		public function load(path:String, settings:LayerSettings = null):void {
			
		}
		
		/**
		 * 
		 */
		public function addFilter(filter:Filter):void {
			
		}
		
		/**
		 * 	Returns the index of the track
		 */
		public function get index():int {
			return _layer.index;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			// register it as a drop target
			Browser.registerTarget(this, false);
			
			super.dispose();
		}
		
	}
}