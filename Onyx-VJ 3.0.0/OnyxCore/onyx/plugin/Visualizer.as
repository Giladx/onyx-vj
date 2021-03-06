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
package onyx.plugin {
	
	import flash.display.BitmapData;
	
	import onyx.constants.*;
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.*;
	import onyx.display.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	A Visualizer plug-in is a plugin that will respond to audio events
	 */
	public class Visualizer extends PluginBase implements IRenderObject {

		/**
		 * 	@private
		 * 	Stores definitions
		 */
		private static const _definition:Object		= {};
		
		/**
		 * 	@private
		 */
		onyx_ns static const _visualizers:Array		= [];
		
		/**
		 * 	Registers a plugin
		 */
		onyx_ns static function registerPlugin(plugin:Plugin):void {
			
			_definition[plugin.name] = plugin;
			plugin._parent = _visualizers;
			_visualizers.push(plugin);

		}

		/**
		 * 	Returns a definition
		 */
		public static function getDefinition(name:String):Plugin {
			return _definition[name];
		}
		
		/**
		 * 
		 */
		public static function get visualizers():Array {
			return _visualizers;
		}
				
		/**
		 * 	@constructor
		 */
		public function Visualizer(...controls:Array):void {
			super.controls.addControl.apply(null, controls);
		}
		
		/**
		 * 
		 */
		public function render():RenderTransform {
			return null;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
		}
		
		/**
		 * 
		 */
		final override public function toString():String {
			return 'onyx-visualizer://' + _plugin.name;
		}
	}
}