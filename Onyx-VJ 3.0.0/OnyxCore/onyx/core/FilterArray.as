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
package onyx.core {

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.content.IContent;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	import onyx.utils.array.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Filter array
	 */
	dynamic public final class FilterArray extends Array implements IEventDispatcher {
		
		/**
		 * 	@private
		 */
		private static const REUSABLE_APPLY:FilterEvent		= new FilterEvent(FilterEvent.FILTER_APPLIED, null);
		private static const REUSABLE_MOVE:FilterEvent		= new FilterEvent(FilterEvent.FILTER_MOVED, null);
		private static const REUSABLE_MUTED:FilterEvent		= new FilterEvent(FilterEvent.FILTER_MUTED, null);
		private static const REUSABLE_REMOVE:FilterEvent	= new FilterEvent(FilterEvent.FILTER_REMOVED, null);
		
		/**
		 * 	@private
		 */
		private var _parent:IContent;
		
		/**
		 * 	@private
		 */
		private var dispatcher:EventDispatcher;
		
		/**
		 * 	@constructor
		 */
		public function FilterArray(parent:IContent):void {
			_parent		= parent;
			dispatcher	= new EventDispatcher();
		}
		
		/**
		 * 	Add listener
		 */
		public function addEventListener(type:String, method:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, method, useCapture, priority, useWeakReference);
		}
		
		/**
		 * 
		 */
		public function removeEventListener(type:String, method:Function, useCapture:Boolean = false):void {
			dispatcher.removeEventListener(type, method, useCapture);
		}
		
		/**
		 * 
		 */
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
		
		/**
		 * 
		 */
		public function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		
		/**
		 * 
		 */
		public function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * 	Removes a filter
		 */
		public function addFilter(filter:Filter):void {

			// check for unique filters
			if (filter._unique) {
				
				var plugin:Plugin = Filter.getDefinition(filter.name);
				
				for each (var otherFilter:Filter in this) {
					if (otherFilter is plugin._definition) {
						return;
					}
				}
			}
			
			// it's alive!
			filter.setContent(_parent);
			
			// push the layer into the array
			super.push(filter);
			
			// tell the filter it has started
			filter.initialize();

			// dispatch event
			REUSABLE_APPLY.filter = filter;
			dispatcher.dispatchEvent(REUSABLE_APPLY);
		}
		
		/**
		 * 	Moves a filter
		 */
		public function moveFilter(filter:Filter, index:int):void {
			if (swap(super, filter, index)) {
				REUSABLE_MOVE.filter = filter;
				dispatcher.dispatchEvent(REUSABLE_MOVE);
			}
		}
		
		/**
		 * 	Removes a filter
		 * 	@returns	true if the removed filter existed in the array
		 */
		public function removeFilter(filter:Filter):void {

			// now remove it
			var index:int = super.indexOf(filter);
			
			if (index >= 0) {
				
				// remove all tweens related to the filter
				// Tween.stopTweens(filter);

				// remove the filter
				splice(index, 1);

				// dispose the filter
				filter.dispose();
				
				// clean up our references
				filter.clean();
				
				// dispatch event
				REUSABLE_REMOVE.filter = filter;
				dispatcher.dispatchEvent(REUSABLE_REMOVE);
			}
		}
		
		/**
		 * 	Mutes a filter
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			filter._muted = toggle;

			// dispatch
			REUSABLE_MUTED.filter = filter;
			dispatcher.dispatchEvent(REUSABLE_MUTED);
		}
		
		/**
		 * 	Renders all filters to the source bitmap
		 */
		public function render(source:BitmapData):void {
			
			for each (var filter:Filter in this) {
				var bmp:IBitmapFilter = filter as IBitmapFilter;
				
				if (bmp && !filter._muted) {
					bmp.applyFilter(source);
				}
			}
		}
		
		/**
		 * 	Loads xml
		 */
		public function loadXML(xml:XMLList):void {
			
			for each (var filterXML:XML in xml.*) {
				
				var name:String			= filterXML.@id;
				var plugin:Plugin		= Filter.getDefinition(name);
				
				if (plugin) {
					
					var filter:Filter = plugin.getDefinition() as Filter;
					filter.controls.loadXML(filterXML.controls);

					// add the filter					
					addFilter(filter);
				}
			}
		}
		
		/**
		 * 
		 */
		public function clear():void {
			while (super.length) {
				removeFilter(this[0] as Filter);
			}
		}
		
		/**
		 * 	Returns the filters in an xml format
		 */
		public function toXML():XML {
			var xml:XML = <filters />;
			
			for each (var filter:Filter in this) {
				xml.appendChild(filter.toXML());
			}
			
			return xml;
		}
	}
}