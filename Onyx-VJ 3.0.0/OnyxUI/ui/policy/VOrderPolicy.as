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
package ui.policy {
	
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * 	Vertical Ordering Policy
	 */
	public final class VOrderPolicy extends Policy {
		
		/**
		 * 	The padding between objects
		 */
		public var padding:int;
		public var paddingTop:int;
		
		/**
		 * 	@constructor
		 */
		public function VOrderPolicy(padding:int = 1, paddingTop:int = 0):void {
			this.padding 	= padding;
			this.paddingTop = paddingTop;
		}
		
		/**
		 * 	Initialized to a target
		 */
		override public function initialize(target:IEventDispatcher):void {

			target.addEventListener(Event.ADDED, _onAdded,		false, 0, true);
			target.addEventListener(Event.REMOVED, _onRemoved,	false, 0, true);
		}
		
		/**
		 * 	Terminated
		 */
		override public function terminate(target:IEventDispatcher):void {
		}
		
		/**
		 * 	@private
		 */
		private function _onAdded(event:Event):void {

			var parent:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
			var y:int = paddingTop;

			for (var count:int = 0; count < parent.numChildren; count ++) {
				var child:DisplayObject = parent.getChildAt(count);
				child.y	= y;
				
				y += child.height + padding;
			}

		}
		
		
		/**
		 * 	@private
		 */
		private function _onRemoved(event:Event):void {

			var parent:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
			var y:int = paddingTop;

			for (var count:int = 0; count < parent.numChildren; count ++) {
				var child:DisplayObject = parent.getChildAt(count);
				child.y	= y;
				
				y += child.height + padding;
			}

		}
	}
}