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
package onyx.display{
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.file.*;
	import onyx.system.*;
	import onyx.net.*;
	import onyx.plugin.*;
	import onyx.utils.string.*;

	[Event(name='complete',			type='flash.events.Event')]
	[Event(name='security_error',	type='flash.events.SecurityErrorEvent')]
	[Event(name='io_error',			type='flash.events.IOErrorEvent')]
	[Event(name='progress',			type='flash.events.ProgressEvent')]

	/**
	 * 	Loads different content based on the file url
	 */
	final internal class ContentLoader extends EventDispatcher {
		
		/**
		 * 	@private
		 */
		public var settings:LayerSettings;
		
		/**
		 * 	@private
		 * 	Transition to load with
		 */
		public var transition:Transition;
		
		/**
		 * 	The stored content to use
		 */
		public var content:IContent;
		
		/**
		 * 	Loads a file
		 */
		public function load(path:String, settings:LayerSettings, transition:Transition, layer:ILayer):void {
			
			this.settings	= settings || new LayerSettings(),
			this.transition = (transition && transition.duration > 0) ? transition : null,

			Onyx.resolve(path, handler, layer);
		}
		
		/**
		 * 	@private
		 */
		private function handler(event:Event, content:IContent = null):void {
			
			this.content = content;
			super.dispatchEvent(event);

		}
		
		/**
		 * 	Dispose
		 */
		public function dispose():void {

			// dispose
			this.settings	= null,
			this.transition = null,
			this.content	= null;

		}
	}
}