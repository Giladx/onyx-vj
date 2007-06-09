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
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.Onyx;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;
	import onyx.states.StateManager;
	import onyx.utils.math.*;
	import onyx.utils.string.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.controls.filter.*;
	import ui.controls.layer.*;
	import ui.controls.page.*;
	import ui.core.*;
	import ui.states.*;
	import ui.styles.*;
	import ui.text.*;
	import ui.window.*;

	/**
	 * 	Controls layers
	 */	
	public class UILayer extends UIFilterControl implements IFilterDrop {
		
		/**
		 * 	@private
		 */
		private static const LAYER_X:int				= 6;

		/**
		 * 	@private
		 */
		private static const LAYER_Y:int				= 6;

		/**
		 * 	@private
		 */
		private static const SCRUB_LEFT:int				= 8;

		/**
		 * 	@private
		 */
		private static const SCRUB_RIGHT:int			= 183;

		/**
		 * 	@private
		 */
		private static const LAYER_WIDTH:int			= SCRUB_RIGHT - SCRUB_LEFT;

		/**
		 * 	@private
		 */
		public static const layers:Array				= [];
		
		/**
		 * 	@private
		 * 	The text drop shadow
		 */
		private static const TEXT_DROP:Array			= [new DropShadowFilter(1, 45,0x000000, 1, 0, 0, 1)];


		/**
		 * 	Selects a layer
		 */
		public static function selectLayer(uilayer:UILayer):void {
			
			if (selectedLayer) {
				selectedLayer.transform.colorTransform = DEFAULT;
			}
			
			// highlight
			uilayer.transform.colorTransform = LAYER_HIGHLIGHT;
			
			// select layer
			selectedLayer = uilayer;
		}
		
		/**
		 *	The currently selected layer 
		 */
		public static var selectedLayer:UILayer;

		/********************************************************
		 * 
		 * 					CLASS MEMBERS
		 * 
		 **********************************************************/

		/** @private **/
		private var _layer:ILayer;

		/** @private **/
		private var _monitor:Boolean						= false;

		/** @private **/
		private var _btnCopy:ButtonClear					= new ButtonClear(10, 10);

		/** @private **/
		private var _btnDelete:ButtonClear					= new ButtonClear(10, 10);
		
		/** @private **/
		private var _btnVisible:LayerVisible;
		
		/** @private **/
		private var _loopStart:LoopStart;

		/** @private **/
		private var _loopEnd:LoopEnd;
		
		/** @private **/
		private var _assetLayer:AssetLayer					= new AssetLayer();

		/** @private **/
		private var _assetScrub:ScrubArrow 					= new ScrubArrow();

		/** @private **/
		private var _btnScrub:ButtonClear					= new ButtonClear(192, 12, false);

		/** @private **/
		private var _preview:Bitmap							= new Bitmap();

		/** @private **/
		private var _filename:TextField						= new TextField(162,16);
		
		/** @private **/
		private var _regPoint:LayerRegPoint;
		
		/** @private **/
		private var _crossFaderToggle:CrossFaderToggle;

		/**
		 * 	@private
		 */
		private const _mask:Shape				= new Shape();
				
		/**
		 * 	@constructor
		 **/
		public function UILayer(layer:ILayer):void {
			
			// this is the mask for the registration point
			var graphics:Graphics = _mask.graphics;
			graphics.beginFill(0x000000);
			graphics.drawRect(1,1,192,144);
			graphics.endFill();
			addChild(_mask);
			
			var props:LayerProperties = layer.properties as LayerProperties;
			
			// register for filter drops
			super(
				layer,
				0,
				169,
				new LayerPage('BASIC',	props.position,
										props.alpha,
										props.scale,
										props.brightness,
										props.anchor,
										props.contrast,
										props.rotation,
										props.saturation,
										props.tint,
										props.threshold,
										props.color,
										props.framerate
				),
				new LayerPage('FILTER'),
				new LayerPage('CUSTOM')
			);
			
			// store layer
			_layer = layer;

			// push
			layers.push(this);

			// draw
			_draw();
			
			// add handlers			
			_assignHandlers(true);

			// if there is no selected layer, select current layer
			if (!selectedLayer) {
				selectLayer(this);
			}
			
			// if there's already a file in there, set it to update
			if (_layer.path) {
				_onLayerLoad();
			}
			
		}

		/**
		 * 	Overrides the layer colortransform
		 */
		override public function get transform():Transform {
			var mtransform:MultiTransform = new MultiTransform(this, _assetLayer, controlTabs);
			return mtransform;
		}
		
		/**
		 * 	@private
		 * 	assign handlers
		 */
		private function _assignHandlers(value:Boolean):void {
			
			if (value) {
				
				// add layer event handlers
				_layer.addEventListener(LayerEvent.LAYER_LOADED,	_onLayerLoad);
				_layer.addEventListener(LayerEvent.LAYER_UNLOADED,	_onLayerUnLoad);
				
				// listen for progress events
				_layer.addEventListener(ProgressEvent.PROGRESS, _onLayerProgress);
				
				// when the scrub button is pressed
				_btnScrub.addEventListener(MouseEvent.MOUSE_DOWN, _onScrubPress);
				
				// this listens for selecting the layer
				addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
	
				// buttons
				_btnCopy.addEventListener(MouseEvent.MOUSE_DOWN, _onButtonPress);
				_btnDelete.addEventListener(MouseEvent.MOUSE_DOWN, _onButtonPress);
	
				// when the layer is moved
				_layer.addEventListener(LayerEvent.LAYER_MOVE, reOrderLayer);
				
			} else {
				
				// add layer event handlers
				_layer.removeEventListener(LayerEvent.LAYER_LOADED,		_onLayerLoad);
				_layer.removeEventListener(LayerEvent.LAYER_UNLOADED,	_onLayerUnLoad);
				
				// listen for progress events
				_layer.removeEventListener(ProgressEvent.PROGRESS,		_onLayerProgress);
				
				// when the scrub button is pressed
				_btnScrub.removeEventListener(MouseEvent.MOUSE_DOWN,	_onScrubPress);
				
				// this listens for selecting the layer
				removeEventListener(MouseEvent.MOUSE_DOWN,				_mouseDown);
	
				// buttons
				_btnCopy.removeEventListener(MouseEvent.MOUSE_DOWN,		_onButtonPress);
				_btnDelete.removeEventListener(MouseEvent.MOUSE_DOWN,	_onButtonPress);
	
				// when the layer is moved
				_layer.removeEventListener(LayerEvent.LAYER_MOVE, reOrderLayer);
				
				// remove update
				removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
				
			}
		}
		
		/**
		 * 	@private
		 * 	Handler while a file loads
		 */
		private function _onLayerProgress(event:ProgressEvent):void {
			_filename.text = 'LOADING ' + floor(event.bytesLoaded / event.bytesTotal * 100) + '% (' + floor(event.bytesTotal / 1024) + ' kb)';
		}
		
		/**
		 * 	@private
		 */
		private function _onButtonPress(event:MouseEvent):void {
			
			switch (event.currentTarget) {
				case _btnCopy:
					_layer.copyLayer();
					break;
				case _btnDelete:
				
					if (event.ctrlKey) {
						_layer.display.dispose();
					} else {
						_layer.dispose();
					}
					break;
					
			}
		}
		
		/**
		 * 	Moves a layer to a specified index
		 */
		public function moveLayer(index:int):void {
			_layer.moveLayer(index);
		}
		
		/**
		 * 	@private
		 * 	Positions all the objects
		 */
		private function _draw():void {
			
			// resize preview
			_preview.scaleX			= .6 * (320 / BITMAP_WIDTH),
			_preview.scaleY			= .6 * (240 / BITMAP_HEIGHT),
			_preview.smoothing		= false,
			_preview.pixelSnapping	= PixelSnapping.ALWAYS;
			
			// make the filename text have a drop shadow
			_filename.filters			= TEXT_DROP,
			_filename.mouseEnabled		= false,
			_filename.mouseWheelEnabled	= false,
			_filename.cacheAsBitmap 	= true;
			
			var props:LayerProperties = _layer.properties as LayerProperties;
			
			_loopStart			= new LoopStart(props.getControl('loopStart')),
			_loopEnd			= new LoopEnd(props.getControl('loopEnd')),
			_regPoint			= new LayerRegPoint(props.getControl('anchor') as ControlProxy, _mask);
			_btnVisible			= new LayerVisible(props.getControl('visible')),
			_crossFaderToggle	= new CrossFaderToggle(_layer);
			
			var options:UIOptions		= new UIOptions();
			var dropOptions:UIOptions	= new UIOptions(false, false, null, 140, 11);
						
			addChildren(
			
				_assetLayer,														0,			0,
				_preview,															1,			1,
				_regPoint,															-4,			-4,
				_filename,															3,			3,
				controlPage,														3,			184,

				new DropDown(dropOptions, props.blendMode),							4,			153,
				filterPane,															111,		186,

				_btnVisible,														157,		154,
				_btnCopy,															169,		154,
				_btnDelete,															181,		154,
				
				_crossFaderToggle,													159,		298,
				tabContainer,														0,			169				
			);

			// set default locations for the ui objects that get moved / removed
			_assetScrub.x	= SCRUB_LEFT,
			_assetScrub.y	= 138,
			_btnScrub.x		= 1,
			_btnScrub.y		= 139,
			_loopStart.x	= 10,
			_loopStart.y	= 138,
			_loopEnd.x		= 184,
			_loopEnd.y		= 138;
			
			addChild(_assetScrub);
			addChild(_btnScrub);
			
		}
		
		/**
		 * 	Loads a layer
		 */
		public function load(path:String, settings:LayerSettings = null):void {
			
			// see if we're passing a transition
			if (UIManager.transition) {
				var transition:Transition = UIManager.transition.clone();
			}
			
			_layer.load(path, settings, transition);
			
		}
		
		/**
		 * 	@private
		 * 	Handler that is evoked when a layer has finished loading a file
		 */
		private function _onLayerLoad(event:Event = null):void {
			
			// parse out the extension
			var path:String = _layer.path;

			// check for custom controls
			if (_layer.controls) {
				var page:LayerPage = pages[2];
				page.controls = _layer.controls;
				selectPage(2);
			}
			
			// set name
			_filename.text = removeExtension(path).toUpperCase();
			
			// frame listener
			addEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			// if it has time, add the ui controls for time
			if (_layer.totalTime > 1) {
				
				// add time controls
				super.addChild(_loopStart);
				super.addChild(_loopEnd);
				
			} else {
				
				// check to see if added already
				if (_loopStart.parent) {
					super.removeChild(_loopStart);
					super.removeChild(_loopEnd);
				}
			}
		}
		
		/**
		 * 	@private
		 *	Handler that is evoked when a layer is unloaded
		 */
		private function _onLayerUnLoad(event:LayerEvent):void {
			
			var page:LayerPage = pages[2];
			if (page.controls) {
				page.controls = null;
			}
			selectPage(0);
			
			_filename.text = '';
			_assetScrub.x = SCRUB_LEFT;
			
			// remove scrub listener
			removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			// remove time controls if they're added
			if (_loopStart.parent) {
				super.removeChild(_loopStart);
				super.removeChild(_loopEnd);
			}
		}
		
		/**
		 * 	@private
		 * 	Handler that is evoked to update the playhead location
		 */
		private function _updatePlayheadHandler(event:Event):void {

			// updates the playhead marker
			_assetScrub.x = _layer.time * LAYER_WIDTH + SCRUB_LEFT;
			_preview.bitmapData = _layer.rendered;

		}

		/**
		 * 	@private
		 * 	Mouse handler that is evoked when the playhead button is pressed
		 */		
		private function _onScrubPress(event:MouseEvent):void {
			
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onScrubMove);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onScrubUp);
			
			removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			_layer.pause(true);

			_onScrubMove(event);
		}

		/**
		 * 	@private
		 * 	When the scrubber is moved, change the frame
		 */
		private function _onScrubMove(event:MouseEvent):void {
			
			var value:int = min(max(_btnScrub.mouseX, SCRUB_LEFT), SCRUB_RIGHT);
			_assetScrub.x = value;
			_layer.time = (value - SCRUB_LEFT) / LAYER_WIDTH;
			
		}

		/**
		 * 	@private
		 * 	When the scrub bar is moused up
		 */
		private function _onScrubUp(event:MouseEvent):void {

			// add our events back			
			addEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onScrubMove);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onScrubUp);
			
			_layer.pause(false);

		}

		/**
		 * 	@private
		 * 	Handler for the mousedown select
		 */
		private function _mouseDown(event:MouseEvent):void {
			selectLayer(this);
			
			// check to see if we clicked on the top portion, if so, we're going to allow
			// dragging to move a layer
			if (mouseY < 136) {
				
				if (event.ctrlKey) {
					
					_forwardMouse(event);
					addEventListener(MouseEvent.MOUSE_MOVE, _forwardMouse);
					addEventListener(MouseEvent.MOUSE_UP, _stopForwardMouse);
				
				} else {
					
					StateManager.loadState(new LayerMoveState(this));
					
				}
				
			}
		}
		
		/**
		 * 	@private
		 * 	Forwards mouse events to the layer based on clicking the preview
		 */
		private function _forwardMouse(event:MouseEvent):void {
			event.localX = _preview.mouseX;
			event.localY = _preview.mouseY;
			
			_layer.dispatchEvent(event);
		}
		
		/**
		 * 	@private
		 * 	Forwards mouse events to the layer based on clicking the preview
		 */
		private function _stopForwardMouse(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _forwardMouse);
			removeEventListener(MouseEvent.MOUSE_UP, _stopForwardMouse);
			
			_forwardMouse(event);
		}

		/**
		 * 	Moves layer
		 */
		public function reOrderLayer(event:LayerEvent = null):void {
			x = _layer.index * 203 + LAYER_X;
			y = LAYER_Y;
		}
		
		/**
		 * 	Returns the index of the current layer
		 */
		public function get index():int {
			return _layer.index;
		}

		/**
		 * 	Returns layer associated to this control
		 */
		public function get layer():ILayer {
			return _layer;
		}
		
		/**
		 * 	Selects a filter above or below currently selected filter
		 */
		public function selectFilterUp(up:Boolean):void {
			
			if (filterPane.selectedFilter) {
				var index:int = filterPane.selectedFilter.filter.index + (up ? -1 : 1);
				filterPane.selectFilter(filterPane.getFilter(_layer.filters[index]));
			} else {
				filterPane.selectFilter(filterPane.getFilter(_layer.filters[int((up) ? _layer.filters.length - 1 : 0)]));
			}

		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			// remove listeners
			_assignHandlers(false);

			// remove children
			super.dispose();
			
			// remove layer
			layers.splice(layers.indexOf(this), 1);
			
			// remove references
			_layer = null;
			
			if (selectedLayer === this) {
				selectLayer(null);
			}
		}
	}
}
