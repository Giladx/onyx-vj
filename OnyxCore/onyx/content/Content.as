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
		protected var _matrix:Matrix;
		
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
		protected var _x:int;

		/**
		 * 	@private
		 */
		protected var _y:int;

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
		 * 	@private
		 */
		private var _alphaTransform:ColorTransform;
		
		/**
		 * 	@private
		 */
		private var _transform:Matrix
		
		/**
		 * 	@constructor
		 */		
		public function Content(layer:ILayer, path:String, content:IBitmapDrawable):void {
			
			// remove intensive logic to a method, so it can get JIT.
			// Constructors are not JIT'd
			_init(layer, path, content);
			
		}
		
		/**
		 * 
		 */
		private function _init(layer:ILayer, path:String, content:IBitmapDrawable):void {
						
			var props:LayerProperties	= layer.properties as LayerProperties;
			_properties					= props;
			
			// store layer, controls (for performance)
			_transform		= new Matrix(),
			_alphaTransform	= new ColorTransform(),
			_filters		= new FilterArray(this),
			_blendMode		= 'normal',
			_visible		= true,
			_filter			= new ColorFilter(),
			_path  			= path,
			_source			= BASE_BITMAP(),
			__color			= props.color,
			__alpha 		= props.alpha,
			__scaleX		= props.scaleX,
			__scaleY		= props.scaleY,
			__rotation		= props.rotation,
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
			
			_filters.addEventListener(FilterEvent.FILTER_APPLIED, super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_MOVED, super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_MUTED, super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_REMOVED, super.dispatchEvent);
			
			// change target to this (performance)
			layer.properties.setNewTarget(this);
			
			// check for custom controls
			if (_content is IControlObject) {
				_controls = (_content as IControlObject).controls;
			}
			
			// if it takes events, pass em on
			if (_content is IEventDispatcher) {
				
				var method:Function = (_content as IEventDispatcher).dispatchEvent;
				
				addEventListener(MouseEvent.MOUSE_DOWN,	method);
				addEventListener(MouseEvent.MOUSE_UP,	method);
				addEventListener(MouseEvent.MOUSE_MOVE,	method);
			}
		}
		
		/**
		 * 	Gets alpha
		 */
		public function get alpha():Number {
			return _alphaTransform.alphaMultiplier;
		}

		/**
		 * 	Sets alpha
		 */
		public function set alpha(value:Number):void {
			_alphaTransform.alphaMultiplier = __alpha.dispatch(value);
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
		public function get anchorX():Number {
			return _anchorX / BITMAP_WIDTH;
		}
		
		/**
		 * 
		 */
		public function set anchorX(value:Number):void {
			_anchorX = __anchorX.dispatch(value) * BITMAP_WIDTH,
			_renderMatrix	= null;
		}
		
		/**
		 * 
		 */
		public function get anchorY():Number {
			return _anchorY / BITMAP_HEIGHT;
		}
		
		/**
		 * 
		 */
		public function set anchorY(value:Number):void {
			_anchorY = __anchorY.dispatch(value) * BITMAP_HEIGHT,
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
			
			_filters.addFilter(filter);

		}

		/**
		 * 	Removes a filter
		 */		
		public function removeFilter(filter:Filter):void {
			
			_filters.removeFilter(filter);
			
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
			_filters.moveFilter(filter, index);
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
		final public function getTransform():RenderTransform {
			
			var transform:RenderTransform, rect:Rectangle;
			
			transform = new RenderTransform();

			// if rotation is 0, send a clipRect, otherwise, don't clip
			
			if (_rotation === 0) {
				
				CLIP_RECT.width		= Math.max(BITMAP_WIDTH / _scaleX, BITMAP_WIDTH), 
				CLIP_RECT.height	= Math.max(BITMAP_HEIGHT / _scaleY, BITMAP_HEIGHT);
				rect = CLIP_RECT;
				
			}
			
			// build a matrix
			if (!_renderMatrix) {
				
				_renderMatrix = new Matrix(1, 0, 0, 1, -_anchorX, -_anchorY);
				_renderMatrix.rotate(_rotation);
				_renderMatrix.concat(new Matrix(_scaleX, 0, 0, _scaleY, _anchorX + _x, _anchorY + _y));
				
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
		 * 	Sets matrix
		 */
		public function set matrix(value:Matrix):void {
			_matrix = value;
			_renderMatrix	= null;
		}
		
		/**
		 * 	Sets matrix
		 */
		final public function get matrix():Matrix {
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
		final public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			_filters.muteFilter(filter, toggle);
		}
		
		
		/**
		 * 	Get Properties
		 */
		final public function get properties():Controls {
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
		 * 
		 */
		final public function getColorTransform():ColorTransform {
			return _alphaTransform;
		}
			
		/**
		 * 	Destroys the content
		 */
		public function dispose():void {
						
			// stop all tweens related to this content
			Tween.stopTweens(this);
			
			// if it takes events, pass em on
			if (_content is IEventDispatcher) {
				var method:Function = (_content as IEventDispatcher).dispatchEvent;
				
				removeEventListener(MouseEvent.MOUSE_DOWN,	method);
				removeEventListener(MouseEvent.MOUSE_UP,	method);
				removeEventListener(MouseEvent.MOUSE_MOVE,	method);
			}
			
			// check to see if it's disposable, but only if it's not a movieclip
			// movieclips are handled through CombineContent
			if (_content is IDisposable && !(this is ContentMC)) {
				(_content as IDisposable).dispose();
			}
			
			// kill all filters
			_filters.clear();
			
			_filters.removeEventListener(FilterEvent.FILTER_APPLIED, super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_MOVED, super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_MUTED, super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_REMOVED, super.dispatchEvent);
			
			// remove control references
			__color			= null,
			__alpha 		= null,
			__scaleX		= null,
			__scaleY		= null,
			__rotation		= null,
			__tint			= null,
			__x				= null,
			__y				= null,
			__framerate		= null,
			__loopStart		= null,
			__loopEnd		= null,
			__blendMode		= null,
			__anchorX		= null,
			__anchorY		= null;
			
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