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
	
	import flash.display.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.display.Display;
	
	import ui.assets.AssetDisplay;
	import ui.controls.*;
	import ui.controls.page.*;
	import ui.core.*;
	import ui.settings.*;
	import ui.styles.*;
	import ui.window.*;

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
		 * 	@private
		 */
		private var _localControls:Controls;
		
		/**
		 * 	@private
		 */
		private var _preview:Bitmap;
		
		/**
		 * 	@constructor
		 */
		public function UIDisplay(display:Display):void {
			
			_localControls = new Controls(this,
				new ControlBoolean('preview', 'show prev', 1),
				new ControlProxy('previewLocation', 'preview',
					new ControlInt('previewX', 'previewX', 0, 2440, 0),
					new ControlInt('previewY', 'previewY', 0, 2440, 0),
					{ invert: true }
				),
				new ControlInt('framerate', 'framerate', 12, 60, 30)
			);
			
			var controls:Controls = display.controls;

			// super!			
			super(
				display,
				88,
				0,
				new LayerPage('DISPLAY',
					controls.getControl('backgroundColor'),
					controls.getControl('alpha'),
					controls.getControl('saturation'),
					controls.getControl('threshold'),
					controls.getControl('brightness'),
					controls.getControl('contrast')
				),
				new LayerPage('FILTER'),
				new LayerPage('POSITION',
					controls.getControl('visible'),
					controls.getControl('smoothing'),
					controls.getControl('position'),
					controls.getControl('size'),
					_localControls.getControl('preview'),
					_localControls.getControl('previewLocation'),
					_localControls.getControl('framerate')
				),
				new LayerPage('RENDER',
					controls.getControl('renderer')
				)
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
			
			// set the preview to true
			preview = true;
		}
		
		/**
		 * 
		 */
		public function get previewX():int {
			return _preview ? _preview.x : 0
		}
		
		/**
		 * 
		 */
		public function set previewX(value:int):void {
			if (_preview) {
				_preview.x = value;
			}
		}
		
		/**
		 * 
		 */
		public function get previewY():int {
			return _preview ? _preview.y : 0
		}
		/**
		 * 
		 */
		public function set previewY(value:int):void {
			if (_preview) {
				_preview.y = value;
			}
		}
		
		/**
		 * 	Returns whether the Preview window is being used
		 */
		public function get preview():Boolean {
			return _preview !== null;
		}
		
		/**
		 * 	Sets the preview location
		 */
		public function set preview(value:Boolean):void {
			
			if (value) {
				
				_preview			= new Bitmap(_display.rendered, PixelSnapping.ALWAYS, false);
				_preview.x			= PREVIEW_X;
				_preview.y			= PREVIEW_Y;
				
				STAGE.addChildAt(_preview, 0);
				
			} else if (_preview) {
				STAGE.removeChild(_preview);
				
				_preview.bitmapData = null;
				_preview = null;
			}
			
			// dispatch to the ui
			_localControls.getControl('preview').dispatch(value);
			
		}
		
		/**
		 * 
		 */
		public function get controls():Controls {
			return _localControls;
		}
		
		/**
		 * 
		 */
		public function set framerate(value:int):void {
			STAGE.frameRate = value;
		}
		
		/**
		 * 
		 */
		public function get framerate():int {
			return STAGE.frameRate;
		}
	}
}