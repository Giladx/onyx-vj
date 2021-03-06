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

	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.TransitionEvent;
	import onyx.tween.easing.Linear;
	
	use namespace onyx_ns;
	
	/**
	 * 	Transition is a plug-in that is executed when a layer is loaded over another layer.
	 */
	public class Transition extends PluginBase implements IControlObject {
		
		
		/*
			Automatically register the default transition
		*/		
		registerPlugin(new Plugin('DISSOLVE', Transition, 'DISSOLVES THE LOADED LAYER'));

		/**
		 * 	@private
		 * 	Stores definitions
		 */
		private static const _definition:Object		= {};
		
		/**
		 * 	@private
		 */
		onyx_ns static const _transitions:Array		= [];
		
		/**
		 * 	Registers a plugin
		 */
		onyx_ns static function registerPlugin(plugin:Plugin):void {
			_definition[plugin.name] = plugin;
			plugin._parent = _transitions;
			_transitions.push(plugin);
			
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
		public static function get transitions():Array {
			return _transitions;
		}
		
		/**
		 * 	@private
		 * 	Stores duration of the transition
		 */
		onyx_ns var _duration:int;
		
		/**
		 * 	@constructor
		 */
		public function Transition():void {
			super(
				new ControlInt('duration', 'duration', 0, 5000, 2000)
			)
		}
		
		/**
		 * 	Renders content onto the source bitmap
		 */
		public function render(source:BitmapData, channelA:BitmapData, channelB:BitmapData, ratio:Number):void {
			
			var transform:ColorTransform = new ColorTransform(1,1,1, 1 - ratio);
			source.draw(channelA, null, transform);
			transform.alphaMultiplier = ratio;
			source.draw(channelB, null, transform)

		}
		
		/**
		 * 	Sets duration
		 */		
		final public function set duration(value:int):void {
			_duration = value;
		}
		
		/**
		 * 	Gets duration
		 */
		final public function get duration():int {
			return _duration;
		}
		
		/**
		 * 
		 */
		final override public function toString():String {
			return 'onyx-transition://' + _plugin.name;
		}
	}
}