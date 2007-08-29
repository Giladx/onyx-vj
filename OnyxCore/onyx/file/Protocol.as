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
package onyx.file {
	
	import flash.events.*;
	
	import onyx.core.IDisposable;
	import onyx.content.IContent;
	import onyx.display.ILayer;
	
	/**
	 * 
	 */
	public class Protocol extends Object implements IDisposable {
		
		/**
		 * 	@protected
		 */
		protected var _callback:Function;
		
		/**
		 * 	@protected
		 */
		protected var _path:String;
		
		/**
		 * 
		 */
		protected var _layer:ILayer;
		
		/**
		 * 
		 */
		public function Protocol(path:String, callback:Function, layer:ILayer):void {
			_path		= path,
			_callback	= callback,
			_layer		= layer;
		}
		
		/**
		 * 
		 */
		public function resolve():void {
			
		}
		
		/**
		 * 
		 */
		public function dispatchContent(event:Event, content:IContent = null):void {
			
			// send the content back over to the layer
			_callback(event, content);
			
			// clear references
			dispose();
			
		}
		
		/**
		 * 	Pass the event to the content loader object
		 */
		protected function dispatchEvent(event:Event):void {
			_callback(event);
		}
		
		/**
		 * 
		 */
		final public function dispose():void {
			_callback	= null,
			_layer		= null;
		}
	}
}