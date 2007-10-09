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
package onyx.content {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.errors.*;
	import onyx.events.FilterEvent;
	import onyx.plugin.*;
	import onyx.tween.*;
	import onyx.utils.array.*;
	
	[Event(name="filter_applied",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
	[Event(name="filter_muted",		type="onyx.events.FilterEvent")]
		
	use namespace onyx_ns;
	
	public class Content extends EventDispatcher implements IContent {
		
		/**
		 * 	@private
		 */
		private static var CLIP_RECT:Rectangle = new Rectangle();
		
		/**
		 * 	@private
		 */
		private var _blendMode:String;
		
		/**
		 * 	@private
		 */
		private var _visible:Boolean;
		
		/**
		 * 	@private
		 * 	Stores the filters for this content
		 */
		protected var _filters:FilterArray;

		/**
		 * 	@private
		 * 	Stores the Bitmap Colorfilter and ColorTransform 
		 */
		protected var _filter:ColorFilter;
		
		/**
		 * 	@private
		 * 	Stores the matrix for the content
		 */
		onyx_ns var _renderMatrix:Matrix;
		
		/**
		 * 	@private
		 * 	The concatenated matrix
		 */
		private var _matrix:Matrix;
		
		/**
		 * 	@private
		 * 	Stores local rotation
		 */
		private var _rotation:Number;
		
		/**
		 * 
		 */
		protected var _paused:Boolean;

		/**
		 * 	@private
		 */
		protected var _scaleX:Number;

		/**
		 * 	@private
		 */
		protected var _scaleY:Number;

		/**
		 * 	@private
		 */
		private var _x:int;

		/**
		 * 	@private
		 */
		private var _y:int;

		/**
		 * 	@private
		 */
		protected var _anchorX:int;

		/**
		 * 	@private
		 */
		protected var _anchorY:int;

		/**
		 * 	@private
		 * 	The source
		 */
		protected var _source:BitmapData;
		
		/**
		 * 	@private
		 * 	Stores the layer's controls so that the external content can use them
		 */
		protected var _controls:Controls;
		
		/**
		 * 	@private
		 * 	Stores the content that we're gonna draw
		 */
		protected var _content:IBitmapDrawable;
		
		/**
		 * 	@private
		 */
		protected var _path:String;

		/**
		 * 	@private
		 */
		private var __color:Control;

		/**
		 * 	@private
		 */
		private var __alpha:Control;

		/**
		 * 	@private
		 */
		private var __brightness:Control;

		/**
		 * 	@private
		 */
		private var __contrast:Control;

		/**
		 * 	@private
		 */
		protected var __scaleX:Control;

		/**
		 * 	@private
		 */
		protected var __scaleY:Control;

		/**
		 * 	@private
		 */
		private var __rotation:Control;

		/**
		 * 	@private
		 */
		private var __saturation:Control;

		/**
		 * 	@private
		 */
		private var __threshold:Control;

		/**
		 * 	@private
		 */
		private var __tint:Control;

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
		protected var __framerate:Control;

		/**
		 * 	@private
		 */
		private var __blendMode:Control;

		/**
		 * 	@private
		 */
		protected var __loopStart:Control;

		/**
		 * 	@private
		 */
		protected var __loopEnd:Control;
		
		/**
		 * 	@private
		 */
		protected var __visible:Control;
		
		/**
		 * 	@private
		 */
		protected var __anchorX:Control;
		
		
		/**
		 * 	@private
		 */
		protected var __anchorY:Control;

		/**
		 * 	@private
		 */
		protected var _properties:LayerProperties;
		
		/**
		 * 	@constructor
		 */		
		public function Content(layer:ILayer, path:String, content:IBitmapDrawable):void {
			
			var props:LayerProperties	= layer.properties as LayerProperties;
			_properties					= props;
			
			// store layer, controls (for performance)
			_filters		= new FilterArray(this),
			_blendMode		= 'normal',
			_visible		= true,
			_filter			= new ColorFilter(),
			_path  			= path,
			_source			= BASE_BITMAP(),
			__color			= props.color,
			__alpha 		= props.alpha,
			__brightness	= props.brightness,
			__contrast		= props.contrast,
			__scaleX		= props.scaleX,
			__scaleY		= props.scaleY,
			__rotation		= props.rotation,
			__saturation	= props.saturation,
			__threshold		= props.threshold,
			__tint			= props.tint,
			__x				= props.x,
			__y				= props.y,
			__framerate		= props.framerate,
			__loopStart		= props.loopStart,
			__loopEnd		= props.loopEnd,
			__blendMode		= props.blendMode,
			__visible		= props.visible,
			__anchorX		= props.anchorX,
			__anchorY		= props.anchorY,
			_scaleX			= 1,
			_scaleY			= 1,							// scale normally
			_content		= content;						// store content
			
			// change target to this (performance)
			layer.properties.setNewTarget(this);
			
			// check for custom controls
			if (_content is IControlObject) {
				_controls = (_content as IControlObject).controls;
			}
			
			// if it takes events, pass em on
			if (_content is IEventDispatcher) {
				addEventListener(MouseEvent.MOUSE_DOWN,	_forwardEvents);
				addEventListener(MouseEvent.MOUSE_UP,	_forwardEvents);
				addEventListener(MouseEvent.MOUSE_MOVE,	_forwardEvents);
			}
		}
		
		/**
		 * 	Gets alpha
		 */
		public function get alpha():Number {
			return _filter.alphaMultiplier;
		}

		/**
		 * 	Sets alpha
		 */
		public function set alpha(value:Number):void {
			_filter.alphaMultiplier = __alpha.dispatch(value);
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
			return _filter.color;
		}

		/**
		 * 	Gets tint
		 */
		public function get tint():Number {
			return _filter._tint;
		}
		
		/**
		 * 	Sets x
		 */
		public function set x(value:Number):void {
			_x				= __x.dispatch(value),
			_renderMatrix	= null;
		}	

		/**
		 * 	Sets y
		 */
		public function set y(value:Number):void {
			_y				= __y.dispatch(value),
			_renderMatrix	= null;
		}

		/**
		 * 	Sets scaleX
		 */
		public function set scaleX(value:Number):void {
			_scaleX			= __scaleX.dispatch(value),
			_renderMatrix	= null;
		}

		/**
		 * 	Sets scaleY
		 */
		public function set scaleY(value:Number):void {
			_scaleY			= __scaleY.dispatch(value),
			_renderMatrix	= null;
		}
		
		/**
		 * 	Gets scaleX
		 */
		public function get scaleX():Number {
			return _scaleX;
		}

		/**
		 * 	Gets scaleY
		 */
		public function get scaleY():Number {
			return _scaleY;
		}
		
		/**
		 * 
		 */
		public function get anchorX():int {
			return _anchorX;
		}
		
		/**
		 * 
		 */
		public function set anchorX(value:int):void {
			_anchorX = __anchorX.dispatch(value),
			_renderMatrix	= null;
		}
		
		/**
		 * 
		 */
		public function get anchorY():int {
			return _anchorY;
		}
		
		/**
		 * 
		 */
		public function set anchorY(value:int):void {
			_anchorY = __anchorY.dispatch(value),
			_renderMatrix	= null;
		}

		/**
		 * 	Gets x
		 */
		public function get x():Number {
			return _x;
		}

		/**
		 * 	Gets y
		 */
		public function get y():Number {
			return _y;
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
			_filter.saturation = __saturation.dispatch(value);
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
			_filter.contrast = __contrast.dispatch(value);
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
			_filter.brightness = __brightness.dispatch(value);
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
			_filter.threshold = __threshold.dispatch(value);
		}
		
		/**
		 *	Returns rotation
		 */
		public function get rotation():Number {
			return _rotation;
		}

		/**
		 *	@private
		 * 	Sets rotation
		 */
		public function set rotation(value:Number):void {
			_rotation		= value,
			_renderMatrix	= null;
		}

		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			
			if (_filters.addFilter(filter)) {
			
				// dispatch
				var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_APPLIED, filter);
				super.dispatchEvent(event);
				
			}
		}

		/**
		 * 	Removes a filter
		 */		
		public function removeFilter(filter:Filter):void {
			
			if (_filters.removeFilter(filter)) {
				super.dispatchEvent(new FilterEvent(FilterEvent.FILTER_REMOVED, filter));
			}
		}
		
		/**
		 * 	Sets filters
		 */
		public function set filters(value:Array):void {
			throw INVALID_FILTER_OVERRIDE;
		}
		/**
		 * 	Returns filters
		 */
		public function get filters():Array {
			return _filters;
		}
		
		/**
		 * 	Gets a filter's index
		 */
		public function getFilterIndex(filter:Filter):int {
			return _filters.indexOf(filter);
		}
		
		/**
		 * 	Moves a filter to an index
		 */
		public function moveFilter(filter:Filter, index:int):void {
			if (_filters.moveFilter(filter, index)) {
				super.dispatchEvent(new FilterEvent(FilterEvent.FILTER_MOVED, filter));
			};
		}
				
		/**
		 * 	Sets the time
		 */
		public function set time(value:Number):void {
			// do nothing
			// this needs to be overridden
		}
		
		/**
		 * 	Gets the time
		 */
		public function get time():Number {
			return 0;
		}
		
		/**
		 * 	Gets the total time
		 */
		public function get totalTime():int {
			return 1;
		}
		
		/**
		 * 	Pauses content
		 */
		public function pause(value:Boolean = true):void {
			_paused = value;
		}
		
		/**
		 * 	Gets the transform
		 */
		public function getTransform():RenderTransform {
			
			var transform:RenderTransform, rect:Rectangle, anchorX:Number, anchorY:Number;
			
			transform = new RenderTransform();

			// if rotation is 0, send a clipRect, otherwise, don't clip
			
			if (_rotation === 0) {
				
				CLIP_RECT.width		= Math.max(BITMAP_WIDTH / _scaleX, BITMAP_WIDTH), 
				CLIP_RECT.height	= Math.max(BITMAP_HEIGHT / _scaleY, BITMAP_HEIGHT);
				rect = CLIP_RECT;
				
			}
			
			// build a matrix
			if (!_renderMatrix) {
				
				anchorX = _anchorX * Math.abs(_scaleX),
				anchorY = _anchorY * Math.abs(_scaleY);
				
				var H:Number			= Math.sqrt(Math.pow(anchorX,2) + Math.pow(anchorY,2));
				var OFFANG:Number		= Math.atan(anchorY/anchorX);
				var OFFROTX:Number		= ((H * Math.cos((_rotation+OFFANG))) - anchorX);
				var OFFROTY:Number		= ((H * Math.sin((_rotation+OFFANG))) - anchorY);
				var OFFSCALEX:Number	= (_anchorX * (1 - _scaleX));
				var OFFSCALEY:Number	= (_anchorY * (1 - _scaleY));
				
				_renderMatrix = new Matrix();
				_renderMatrix.scale(_scaleX, _scaleY);		
				_renderMatrix.rotate(_rotation);
				
				if (_anchorX === 0 || _anchorY === 0){
					_renderMatrix.translate(_x, _y);
				} else {
					_renderMatrix.translate(_x + OFFSCALEX - OFFROTX, _y + OFFSCALEY - OFFROTY);	
				}
				
				if (_matrix) {
					_renderMatrix.concat(_matrix);
				}

			}
			
			// pass back the render transform
			transform.matrix			= _renderMatrix,
			transform.rect				= rect;

			return transform;
		}
		
		/**
		 * 	Called by the parent layer every frame to render
		 */
		public function render():RenderTransform {
			
			if (_content) {
	
				// get the transformation
				var transform:RenderTransform		= getTransform();

				// render content
				renderContent(_source, _content, transform, _filter);
				
				// render filters
				_filters.render(_source);
				
			}

			// return transformation
			return transform;
		}
						
		/**
		 * 	Gets the framerate
		 */
		public function get framerate():Number {
			return 1;
		}

		/**
		 * 	Sets framerate
		 */
		public function set framerate(value:Number):void {
			__framerate.dispatch(value);
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		public function get loopStart():Number {
			return 0;
		}
		
		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		public function set loopStart(value:Number):void {
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		public function get loopEnd():Number {
			return 1;
		}

		/**
		 * 	Sets the end loop point
		 */
		public function set loopEnd(value:Number):void {
		}

		/**
		 * 	Returns the bitmap source
		 */
		public function get source():BitmapData {
			return _source;
		}
		
		/**
		 * 	Sets blendmode
		 */
		public function set blendMode(value:String):void {
			_blendMode = __blendMode.dispatch(value);
		}
		
		/**
		 * 	Returns content controls
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	@private
		 * 	Forwards events
		 */
		final private function _forwardEvents(event:MouseEvent):void {
			var content:IEventDispatcher = _content as IEventDispatcher;
			content.dispatchEvent(event);
		}
		
		/**
		 * 	Sets matrix
		 */
		public function set matrix(value:Matrix):void {
			_matrix = value;
			_renderMatrix	= null;
		}
		
		/**
		 * 	Sets matrix
		 */
		public function get matrix():Matrix {
			return _matrix;
		}
		
		/**
		 * 
		 */
		final public function get blendMode():String {
			return _blendMode;
		}
		
		/**
		 * 
		 */
		public function get path():String {
			return _path;
		}
		
		/**
		 * 	Mutes a filter
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			_filters.muteFilter(filter, toggle);
		}
		
		
		/**
		 * 	Get Properties
		 */
		public function get properties():Controls {
			return _properties;
		}
		
		/**
		 * 	Sets visible
		 */
		final public function set visible(value:Boolean):void {
			_visible = __visible.dispatch(value);
		}

		/**
		 * 	Return visible
		 */
		final public function get visible():Boolean {
			return _visible;
		}

		/**
		 * 
		 */
		final public function applyFilter(filter:IBitmapFilter):void {
			filter.applyFilter(_source);
		}
			
		/**
		 * 	Destroys the content
		 */
		public function dispose():void {
						
			// stop all tweens related to this content
			Tween.stopTweens(this);
			
			// if it takes events, pass em on
			if (_content is IEventDispatcher) {
				removeEventListener(MouseEvent.MOUSE_DOWN,	_forwardEvents);
				removeEventListener(MouseEvent.MOUSE_UP,	_forwardEvents);
				removeEventListener(MouseEvent.MOUSE_MOVE,	_forwardEvents);
			}
			
			// check to see if it's disposable, but only if it's not a movieclip
			// movieclips are handled through CombineContent
			if (_content is IDisposable && !(this is ContentMC)) {
				(_content as IDisposable).dispose();
			}
			
			// remove control references
			__color			= null,
			__alpha 		= null,
			__brightness	= null,
			__contrast		= null,
			__scaleX		= null,
			__scaleY		= null,
			__rotation		= null,
			__saturation	= null,
			__threshold		= null,
			__tint			= null,
			__x				= null,
			__y				= null,
			__framerate		= null,
			__loopStart		= null,
			__loopEnd		= null,
			__blendMode		= null,
			__anchorX		= null,
			__anchorY		= null;
			
			// kill all filters
			for each (var filter:Filter in _filters) {
				removeFilter(filter);
			}

			// dispose
			_source.dispose();
			
			// clear references
			_source			= null,
			_content		= null,
			_filter			= null,
			_filters		= null,
			_controls		= null;
		}
	}
}