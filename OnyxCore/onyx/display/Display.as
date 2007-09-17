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
package onyx.display {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.Mouse;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.jobs.*;
	import onyx.plugin.*;
	import onyx.states.*;
	import onyx.utils.array.*;
	
	use namespace onyx_ns;
	
	[Event(name='render', type='onyx.events.RenderEvent')]
	
	/**
	 * 	Base Display class
	 */
	public class Display extends Bitmap implements IDisplay {

		/**
		 * 	@private
		 * 	Stores the saturation, tint, etc, as well as colortransform
		 */
		private var _filter:ColorFilter;
		
		/**
		 * 	@private
		 * 	Stores the filters for this content
		 */
		private var _filters:FilterArray;
		
		/**
		 * 	@private
		 */
		private var __x:Control;
		
		/**
		 * 	@private
		 */
		private var __y:Control;
		
		/**
		 * 	@private
		 */
		private var __visible:Control;
		
		/**
		 * 	@private
		 */
		private var __alpha:Control;

		/**
		 * 	@private
		 */
		private var	_size:DisplaySize;
		
		/**
		 * 	@private
		 */
		private var _controls:Controls;
		
		/**
		 * 	@private
		 */
		onyx_ns var _layers:Array					= [];
		
		/**
		 * 
		 */
		onyx_ns var _valid:Array					= [];
		
		/**
		 * 	@private
		 */
		private var __renderer:ControlPlugin;
		
		/**
		 * 	@private
		 */
		private var _backgroundColor:uint;
		
		/**
		 * 	@constructor
		 */
		public function Display():void {
			
			var plugin:Plugin = Renderer.renderers[0]; 
			
			__x 		= new ControlInt('displayX', 'x', 0, 2000, STAGE.stageWidth - 320),
			__y 		= new ControlInt('displayY', 'y', 0, 2000, 0),
			__visible	= new ControlBoolean('visible', 'visible'),
			__alpha		= new ControlNumber('alpha','alpha', 0, 1, 1),
			__renderer	= new ControlPlugin('renderer',	'renderer',	ControlPlugin.RENDERERS, false, true, plugin);
			_size		= DISPLAY_SIZES[2],
			_filter		= new ColorFilter();
			
			_filters	= new FilterArray(this),
			_controls	= new Controls(this,
				new ControlNumber(
					'brightness',			'BRIGHT',		-1,		1,		0
				),
				new ControlNumber(
					'contrast',				'CONTRAST',		-1,		2,		0
				),
				new ControlNumber(
					'saturation',			'SATURATION',	0,		2,		1
				),
				new ControlInt(
					'threshold',			'THRESHOLD',	0,		100,	0
				),
				new ControlProxy(
					'position',				'POSITION',
					__x,
					__y,
					{ invert:true }
				),
				new ControlColor(
					'backgroundColor',		'BACKGROUND'
				),
				new ControlRange(
					'size', 'size', DISPLAY_SIZES, DISPLAY_SIZES[0]
				),
				new ControlBoolean(
					'smoothing',			'SMOOTHING',	0
				),
				__alpha,
				__visible,
				__renderer
			);
			
			// init the bitmap
			super(
				new BitmapData(BITMAP_WIDTH, BITMAP_HEIGHT, false, _backgroundColor), PixelSnapping.ALWAYS, true);
			
			// add it to the displays index
			AVAILABLE_DISPLAYS.push(this);
			
			// hide/show mouse when over the display
			addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver, true);
			addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut, true);

			// load the rendering state
			StateManager.loadState(new DisplayRenderState(this));
		}
		
		/**
		 * 	@private
		 * 	Make sure the mouse is gone when we roll over it
		 */
		private function _onMouseOver(event:MouseEvent):void {
			Mouse.hide();
		}
		
		/**
		 * 	@private
		 * 	Make sure the mouse comes back when we roll over it
		 */
		private function _onMouseOut(event:MouseEvent):void {
			Mouse.show();
		}
		
		/**
		 * 	Returns the number of layers
		 */
		public function get numLayers():int {
			return _layers.length;
		}
		
		/**
		 * 	Creates a specified number of layers
		 */
		public function createLayers(numLayers:int):void {
			
			while (numLayers-- ) {
				
				// create a new layer and set it's index
				var layer:Layer = new Layer();
				layer._display = this;
				
				// add to the index
				_layers.push(layer);
				
				// listen for load and unload (to push to the valid array);
				layer.addEventListener(LayerEvent.LAYER_LOADED,		_onLayerLoad);
				layer.addEventListener(LayerEvent.LAYER_UNLOADED,	_onLayerUnLoad);
				
				// dispatch
				dispatchEvent(
					new DisplayEvent(DisplayEvent.LAYER_CREATED, layer)
				);
			}
		}
		
		/**
		 * 	Call this function to apply a transition to the layer before it is rendered to the display
		 */
		public function setLayerTransition(layer:ILayer, transform:TransitionTransform):void {
			DISPLAY_TRANSITIONS[layer] = transform;
		}
		
		/**
		 * 	Returns layer by index number
		 */
		public function getLayer(index:int):ILayer {
			return _layers[index];
		}
		
		/**
		 * 	@private
		 * 	Called when a layer is loaded
		 */
		private function _onLayerLoad(event:LayerEvent):void {
			
			var currentLayer:ILayer	= event.currentTarget as ILayer;
			var currentIndex:int	= currentLayer.index;
			
			var len:int = _valid.length;

			for (var index:int = 0; index < len; index++) {
				var layer:Layer = _valid[index];
				if (currentLayer.index < layer.index) {
					break;
				}
			}
			
			_valid.splice(index, 0, currentLayer);

		}
		
		/**
		 * 	@private
		 * 	Called when a layer is unloaded
		 */
		private function _onLayerUnLoad(event:LayerEvent):void {
			var layer:Layer = event.currentTarget as Layer;
			var index:int = _valid.indexOf(layer);
			
			_valid.splice(index, 1);
		}

		/**
		 * 	Returns the layers
		 */
		public function get layers():Array {
			return _layers.concat();
		}

		/**
		 * 	Moves a layer to a specified index
		 */
		public function moveLayer(... args:Array):void {
			
			var layer:Layer		= args[0];
			var index:int		= args[1];
			
			var fromIndex:int	= layer.index;
			var toLayer:Layer	= _layers[index];
			
			if (toLayer) {
				
				var numLayers:int = _layers.length;
				
				var fromChildIndex:int = _layers.indexOf(layer);
				
				swap(_layers, layer, index);

				// dispatch events to the layers				
				layer.dispatch(new LayerEvent(LayerEvent.LAYER_MOVE));
				toLayer.dispatch(new LayerEvent(LayerEvent.LAYER_MOVE));
				
				// now we need to check if they're both valid layers, and move them
				var toLayerValid:int = _valid.indexOf(toLayer);
				
				// swap
				if (toLayerValid >= 0) {
					swap(_valid, layer, toLayerValid);
				}
				
			}
		}
		
		/**
		 * 	Gets the display index
		 */
		public function get index():int {
			return AVAILABLE_DISPLAYS.indexOf(this);
		}
		
		/**
		 * 	Gets the controls related to the display
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	Copies a layer
		 */
		public function copyLayer(layer:ILayer, index:int):void {
			
			var layerindex:int	= layer.index;
			var copylayer:Layer	= _layers[index];
			
			if (copylayer) {
				
				var settings:LayerSettings = new LayerSettings();
				settings.load(layer);
				
				copylayer.load(layer.path, settings);
				
			}
		}
		
		/**
		 * 
		 */
		public function indexOf(layer:ILayer):int {
			return _layers.indexOf(layer);
		}
		
		/**
		 * 	Loads a mix file into the layers
		 * 	@param	request:URLRequest
		 * 	@param	origin:ILayer
		 * 	@param	transition:Transition
		 */
		public function load(path:String, origin:ILayer, transition:Transition):void {
			
			var job:LoadONXJob = new LoadONXJob(origin, transition);
			JobManager.register(this, job, path);
		}
		
		/**
		 * 	Sets background color
		 */
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
		}
		
		/**
		 * 	Sets the background color
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		/**
		 * 	Sets the size of the display
		 */
		public function set size(value:DisplaySize):void {
			_size	= value,
			width	= value.width,
			height	= value.height;
		}
		
		/**
		 * 
		 */
		public function get size():DisplaySize {
			return _size;
		}

		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			_filters.addFilter(filter);
		}

		/**
		 * 	Removes a filter
		 */		
		public function removeFilter(filter:Filter):void {
			_filters.removeFilter(filter);
		}
		
		/**
		 * 	Tint
		 */
		public function set tint(value:Number):void {	
			_filter.tint = value;
		}
		
		/**
		 * 	Sets color
		 */
		public function set color(value:uint):void {
			_filter.color = value;
		}

		
		/**
		 * 	Gets color
		 */
		public function get color():uint {
			return _filter._color;
		}

		/**
		 * 	Gets tint
		 */
		public function get tint():Number {
			return _filter._tint;
		}

		/**
		 * 	Gets saturation
		 */
		public function get saturation():Number {
			return _filter._saturation;
		}
		
		/**
		 * 	Sets saturation
		 */
		public function set saturation(value:Number):void {
			_filter.saturation = value;
		}

		/**
		 * 	Gets contrast
		 */
		public function get contrast():Number {
			return _filter._contrast;
		}

		/**
		 * 	Sets contrast
		 */
		public function set contrast(value:Number):void {
			_filter.contrast = value;
		}

		/**
		 * 	Gets brightness
		 */
		public function get brightness():Number {
			return _filter._brightness;
		}
		
		/**
		 * 	Sets brightness
		 */
		public function set brightness(value:Number):void {
			_filter.brightness = value;
		}

		/**
		 * 	Gets threshold
		 */
		public function get threshold():int {
			return _filter._threshold;
		}
		
		/**
		 * 	Sets threshold
		 */
		public function set threshold(value:int):void {
			_filter.threshold = value;
		}
		
		/**
		 * 	Gets a filter's index
		 */
		public function getFilterIndex(filter:Filter):int {
			return _filters.indexOf(filter);
		}
		
		/**
		 * 
		 */
		public function set framerate(value:Number):void {
			for each (var layer:Layer in _valid) {
				layer.framerate = value;
			}
		}
		
		/**
		 * 	Sets the default matrix for all layers
		 */
		public function set matrix(value:Matrix):void {
			for each (var layer:Layer in _valid) {
				layer.matrix = value;
			}
		}
		
		/**
		 * 
		 */
		public function get matrix():Matrix {
			return null;
		}

		/**
		 * 
		 */
		public function get loopStart():Number {
			return 0;
		}
		
		/**
		 * 
		 */
		public function set loopStart(value:Number):void {
			for each (var layer:Layer in _valid) {
				layer.loopStart = value;
			}
		}

		/**
		 * 
		 */
		public function pause(value:Boolean = true):void {
			
			if (value) {
				StateManager.pauseStates(DisplayRenderState);
			} else {
				StateManager.resumeStates(DisplayRenderState);
			}
		}
				
		/**
		 * 
		 */
		public function set time(value:Number):void {
			for each (var layer:Layer in _valid) {
				layer.time = value;
			}
		}
		
		/**
		 * 
		 */
		public function set loopEnd(value:Number):void {
			for each (var layer:Layer in _valid) {
				layer.loopEnd = value;
			}
		}
		
		/**
		 * 
		 */
		public function get loopEnd():Number {
			return 1;
		}
		
		/**
		 * 
		 */
		public function get framerate():Number {
			return 1;
		}
		
		/**
		 * 	Returns the display bitmap before rendering filters
		 */
		public function get source():BitmapData {
			return super.bitmapData;
		}

		/**
		 * 	Returns the display bitmap
		 */
		public function get rendered():BitmapData {
			return super.bitmapData;
		}
		
		/**
		 * 
		 */
		public function get totalTime():int {
			return 1;
		}
		
		/**
		 * 	Moves a filter to an index
		 */
		public function moveFilter(filter:Filter, index:int):void {
			
			if (swap(_filters, filter, index)) {
				super.dispatchEvent(new FilterEvent(FilterEvent.FILTER_MOVED, filter));
			}
		}
		
		/**
		 * 
		 */
		public function get time():Number {
			return 0;
		}
		
		/**
		 * 	Renders the display
		 */
		public function render():RenderTransform {
			
			var data:BitmapData = super.bitmapData;
			
			// lock the bitmaps so nothing updates
			data.lock();
		
			// fill the display
			data.fillRect(BITMAP_RECT, _backgroundColor);
			
			// loop and render
			// TBD: raise the framerate of the root movie, and do 
			// calculation to render different content on different frames
			var length:int = _valid.length - 1;
			
			if (length >= 0) {
				
				// render the display using the renderer
				(__renderer.item as Renderer).render(data, _valid);
				
				// render filters onto the bitmap
				_filters.render(data);
			}
			
			// apply threshold, etc
			data.applyFilter(data, BITMAP_RECT, POINT, _filter.filter);
			
			// unlock
			data.unlock();
			
			// dispatch a render event
			// dispatchEvent(new RenderEvent());
			
			return null;
		}

		/**
		 * 	Sets the display location
		 */
		public function set displayX(value:int):void {
			super.x = __x.dispatch(value);
		}
		
		/**
		 * 	Sets the display location
		 */
		public function get displayX():int {
			return super.x;
		}
		
		/**
		 * 	Sets the display location
		 */
		public function set displayY(value:int):void {
			super.y = __y.dispatch(value);
		}
		
		/**
		 * 	Sets the display location
		 */
		public function get displayY():int {
			return super.y;
		}


		/**
		 * 	@private
		 */
		override public function set x(value:Number):void {
			// do nothing, use displayX
		}
		
		/**
		 * 	@private
		 */
		override public function set y(value:Number):void {
			// do nothing, use displayY
		}
		
		/**
		 * 	@private
		 */
		override public function get x():Number {
			return 0;
		}
		
		/**
		 * 	@private
		 */
		override public function get y():Number {
			return 0;
		}
		/**
		 * 	Returns the anchor
		 */
		public function get anchorX():int {
			return 0;
		}
		
		/**
		 * 	Sets the anchor
		 */
		public function set anchorX(value:int):void {
			// do nothing, use no anchor
		}
		
		/**
		 * 	Returns the anchor
		 */
		public function get anchorY():int {
			return 0;
		}
		
		/**
		 * 
		 */
		public function set anchorY(value:int):void {
			// do nothing, use no anchor
		}
		
		/**
		 * 	Mutes a filter
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			_filters.muteFilter(filter, toggle);
		}
		
		/**
		 * 	Sets visibility
		 */
		override public function set visible(value:Boolean):void {
			__visible.dispatch(value);
			
			if (value && !parent) {
				
				x = STAGE.stageWidth - width;
				y = 0;
				
				STAGE.addChildAt(this, 0);
			} else if (!value && parent) {
				STAGE.removeChild(this);
			}
		}
		
		/**
		 * 	Visibility
		 */
		override public function get visible():Boolean {
			return parent !== null;
		}
		 		
		/**
		 * 	Returns the display as xml
		 */
		public function toXML():XML {
			
			var xml:XML = <mix/>;

			// add version metadata
			var meta:XML = <metadata />
			meta.appendChild(<version>{VERSION}</version>);
			meta.appendChild(<format>{XML_FORMAT_VERSION}</format>);
			
			xml.appendChild(meta);
		
			// add display xml
			var display:XML = <display />;
			
			// add display controls
			display.appendChild(_controls.toXML('position', 'size', 'visible','renderer'));
			
			// add filters
			display.appendChild(_filters.toXML());
			
			// add display settings			
			xml.appendChild(display);

			// add layers
			var layers:XML = <layers />
			display.appendChild(layers);
			
			// create xml for all the layers
			for each (var layer:Layer in _layers) {
				if (layer.path) {
					layers.appendChild(layer.toXML());
				}
			}
			
			return xml;
		}
		
		/**
		 * 	Loads settings from xml
		 */
		public function loadXML(xml:XMLList):void {
			
			// load display settings
			controls.loadXML(xml.controls);

			// remove filters
			_filters.clear();
			
			// load xml
			_filters.loadXML(xml.filters);
			
		}
		
		/**
		 * 
		 */
		override public function set alpha(value:Number):void {
			_filter.alphaMultiplier = __alpha.dispatch(value);
		}
		
		/**
		 * 
		 */
		override public function get alpha():Number {
			return _filter.alphaMultiplier;
		}

		/**
		 * 	Disposes the display
		 */
		public function dispose():void {
		}

		/**
		 * 
		 */
		public function get path():String {
			return null;
		}
		
		/**
		 * 	Applies a filter to the rendered output
		 */
		public function applyFilter(filter:IBitmapFilter):void {
			filter.applyFilter(super.bitmapData);
		}
	}
}