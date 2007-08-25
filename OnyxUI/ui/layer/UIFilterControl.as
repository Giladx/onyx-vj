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
package ui.layer {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import onyx.core.*;
	import onyx.events.FilterEvent;
	import onyx.plugin.*;
	
	import ui.controls.filter.*;
	import ui.controls.page.*;
	import ui.core.UIObject;
	import ui.window.*;

	public class UIFilterControl extends UIObject {
		
		/**
		 * 	@private
		 */
		private var _target:IFilterObject;
		
		/**
		 * 
		 */
		protected var selectedPage:int						= -1;

		/**
		 * 
		 */
		protected var filterPane:FilterPane					= new FilterPane();
		
		/**	
		 * 	@private
		 */
		protected var controlPage:ControlPage				= new ControlPage();
		
		/**
		 *  @private
		 */
		protected var controlTabs:ControlPageSelected		= new ControlPageSelected();
		
		/**
		 * 	@private
		 */
		protected var tabContainer:Sprite						= new Sprite();
		
		/**
		 * 
		 */
		protected var pages:Array;
		
		/**
		 * 	@constructor
		 */
		public function UIFilterControl(target:IFilterObject, xOffset:int, yOffset:int, ... pages:Array):void {

			// move to top
			super(true);
			
			this.pages = pages || [];
			
			// listen for events
			_target = target;
			_target.addEventListener(FilterEvent.FILTER_APPLIED, _onFilterApplied);
			_target.addEventListener(FilterEvent.FILTER_REMOVED, _onFilterRemoved);
			_target.addEventListener(FilterEvent.FILTER_MOVED, _onFilterMove);
			_target.addEventListener(FilterEvent.FILTER_MUTED, _onFilterMute);
			
			// set location
			tabContainer.x				= xOffset;
			tabContainer.y				= yOffset;
			tabContainer.mouseChildren	= true;
			tabContainer.mouseEnabled	= false;
			
			// add filter objects
			addChild(filterPane);
			addChild(controlPage);
			tabContainer.addChild(controlTabs);
			
			// create buttons for pages
			_registerPages();
			
			// select page
			selectPage(0);
			
			// register this as a drop target for filters
			Filters.registerTarget(this, true);
		}
		
		/**
		 * 	Returns the currently selected filter
		 */
		public function get selectedFilter():LayerFilter {
			return filterPane.selectedFilter;
		}
		
		/**
		 * 	Selects a page
		 */
		public function selectPage(index:int, controls:Array = null):void {
			
			var page:LayerPage = pages[index];
			
			if (controls) {
				page.controls = controls;
				controlPage.addControls(page.controls);
			}
			
			if (index !== selectedPage) {
				
				controlPage.addControls(page.controls);
				controlTabs.text	= page.name;
				controlTabs.x		= index * 35;
				
				selectedPage = index;
			}
		}
		

		/**
		 * 	Gets a page
		 */
		public function getPage(index:int):LayerPage {
			return pages[index];
		}
		
		/**
		 * 	Adds a page
		 */
		private function _registerPages():void {
			
			var len:int = pages.length;
			for (var count:int = 0; count < len; count++) {
				var page:LayerPage = pages[count];

				var button:ControlPageButton = new ControlPageButton(count);
				button.x		= (count * 35);

				tabContainer.addChild(button);
	
				button.addEventListener(MouseEvent.MOUSE_DOWN, _onPageSelect);
			}
		}

		/**
		 * 	@private
		 */
		private function _onPageSelect(event:MouseEvent):void {
			
			var target:ControlPageButton = event.currentTarget as ControlPageButton;
			
			// if it's the filter page
			if (target.index === 1) {
				
				var filter:LayerFilter = filterPane.getFilter(_target.filters[0]);
				
				if (filter && !filter.filter.muted) {
					filterPane.selectFilter(filter);
				}
				
			} else {
				
				filterPane.selectFilter(null);
				selectPage(target.index);
			}
		}
		
		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			_target.addFilter(filter);
		}
		
		/**
		 * 	Removes a filter
		 */
		public function removeFilter(filter:Filter):void {
			_target.removeFilter(filter);
		}
		
		/**
		 * 	@private
		 * 	Event when filter is added
		 */
		private function _onFilterApplied(event:FilterEvent):void {
			filterPane.register(event.filter);
		}
		
		/**
		 * 	@private
		 * 	Called when a filter is removed
		 */
		private function _onFilterRemoved(event:FilterEvent):void {
			filterPane.unregister(event.filter);
		}

		/**
		 * 	@private
		 * 	When a filter is moved
		 */		
		private function _onFilterMove(event:FilterEvent):void {
			filterPane.reorder();
		}

		/**
		 * 	@private
		 * 	When a filter is moved
		 */		
		private function _onFilterMute(event:FilterEvent):void {
			filterPane.mute(event.filter);
		}
		
		/**
		 * 	Returns the target
		 */
		public function get target():IFilterObject {
			return _target;
		}
		
		/**
		 * 	Disposes content
		 */
		override public function dispose():void {
			
			// tell the filters that we are unregistering
			// Filters.registerTarget(this, false);
			
			// dispose
			super.dispose();
		}
	}
}