/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
	
	import flash.geom.ColorTransform;
	
	import onyx.controls.*;
	import onyx.display.Display;
	import onyx.events.FilterEvent;
	import onyx.filter.Filter;
	
	import ui.assets.AssetDisplay;
	import ui.controls.*;
	import ui.controls.page.*;
	import ui.core.*;
	import ui.styles.*;
	import ui.window.*;
	import flash.display.Bitmap;

	/**
	 * 	Display Control
	 */
	public final class UIDisplay extends UIFilterControl implements IFilterDrop, IControlObject {
		
		/**
		 * 	@private
		 */
		private var _display:Display;
		
		/**
		 * 	@private
		 */
		private var _background:AssetDisplay			= new AssetDisplay();
		
		/**
		 * 
		 */
		private var _localControls:Controls;
		
		/**
		 * 
		 */
		private var _preview:Bitmap;
		
		/**
		 * 	@constructor
		 */
		public function UIDisplay(display:Display):void {
			
			_localControls = new Controls(this,
				new ControlBoolean('preview', 'show prev')
			);
			
			var controls:Controls = display.controls;

			// super!			
			super(
				display,
				88,
				0,
				new LayerPage('DISPLAY',
					controls.getControl('position'),
					controls.getControl('size'),
					controls.getControl('backgroundColor'),
					controls.getControl('visible'),
					controls.getControl('threshold'),
					controls.getControl('brightness'),
					controls.getControl('contrast'),
					controls.getControl('saturation'),
					_localControls.getControl('preview')
				),
				new LayerPage('FILTER'),
				new LayerPage('CUSTOM')
			);

			// save display
			_display = display;
			
			// order
			controlPage.x = 91;
			controlPage.y = 25;
			filterPane.x = 4;
			filterPane.y = 4;

			// change tab color
			controlTabs.transform.colorTransform = LAYER_HIGHLIGHT;
			
			// add background
			addChildAt(_background, 0);
			
			// tbd: clean up tabs
			addChild(tabContainer);
		}
		
		/**
		 * 
		 */
		public function set preview(value:Boolean):void {
			if (value) {
				
				_preview = new Bitmap();
				_preview.x = 200;
				_preview.y = -60;
				
				_preview.bitmapData = _display.rendered;
				
				addChild(_preview);
				
			} else if (_preview) {
				removeChild(_preview);
				_preview = null;
			}
		}
		
		/**
		 * 	Returns whether the Preview window is being used
		 */
		public function get preview():Boolean {
			return _preview !== null
		}
		
		/**
		 * 
		 */
		public function get controls():Controls {
			return _localControls;
		}
	}
}