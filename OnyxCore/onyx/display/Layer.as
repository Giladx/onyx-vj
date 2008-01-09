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
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.file.File;
	import onyx.plugin.*;
	import onyx.utils.string.*;
	
	use namespace onyx_ns;
	
	[Event(name="filter_applied",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
	[Event(name="layer_loaded",		type="onyx.events.LayerEvent")]
	[Event(name="layer_moved",		type="onyx.events.LayerEvent")]
	[Event(name="progress",			type="flash.events.Event")]
	
	[ExcludeClass]

	/**
	 * 	Layer is the base media for all video objects
	 */
	final public class Layer extends EventDispatcher implements ILayer {
		
		/**
		 * 	@private
		 * 	Holder for null content
		 * 	(this is here so that there is not a layer of checking between changing properties)
		 */
		private static const NULL_LAYER:ContentNull			= new ContentNull();
		
		/**
		 * 	@private
		 * 	The display the layer belongs to
		 */
		onyx_ns var			_display:IDisplay;
		
		/**
		 * 	@private
		 * 	Stores the content
		 */
		onyx_ns var			_content:IContent				= NULL_LAYER;

		/**
		 * 	@private
		 * 	Controls
		 */
		private var			_properties:Controls;
		
		/**
		 * 	@private
		 */
		private var			_channel:Boolean;
		
		/**
		 * 	@constructor
		 */
		public function Layer():void {

			_properties = new LayerProperties(this);
			
		}
		
		/**
		 * 	Loads a file type into a layer
		 * 	The path of the file to load into the layer
		 **/
		public function load(path:String, settings:LayerSettings = null, transition:Transition = null):void {
	
			// get extension (onyx.utils)
			var extension:String = getExtension(path);
			
			// if it's an onx file, pass it over to the display to load
			if (extension === 'mix' || extension === 'xml') {
				
				_display.load(path, this, transition);
			
			// individual content, load it here
			} else {
				
				// registers content
				var loader:ContentLoader = new ContentLoader();
				
				// add listeners
				loader.addEventListener(Event.COMPLETE,						_onContentStatus);
				loader.addEventListener(IOErrorEvent.IO_ERROR,				_onContentStatus);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onContentStatus);
				loader.addEventListener(ProgressEvent.PROGRESS,				super.dispatchEvent);
				
				// load
				loader.load(path, settings, transition, this);
			}
		}
		
		/**
		 * 	@private
		 * 	Content Status Handler
		 */
		private function _onContentStatus(event:Event):void {
			
			var error:ErrorEvent, loader:ContentLoader;
			
			loader			= event.currentTarget as ContentLoader,
			error			= event as ErrorEvent;
			
			// remove references
			loader.removeEventListener(Event.COMPLETE,						_onContentStatus);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,				_onContentStatus);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onContentStatus);
			loader.removeEventListener(ProgressEvent.PROGRESS,				super.dispatchEvent);
			
			// check for error
			if (error) {
				
				Console.output('Error loading layer: ', index, error.text);
			
			} else {

				// create the new content object based on the type				
				var loadedContent:IContent = loader.content;
				
				// if a transition was loaded, load the transition with the layer
				if (loader.transition && !(_content === NULL_LAYER)) {
					
					// if current content is already a transition, destroy it, then load
					if (_content is ContentTransition) {
						(_content as ContentTransition).endTransition();
					}
						
					// create a new transition
					loadedContent = new ContentTransition(this, loader.transition, _content, loadedContent);

					// here we need to dispatch that our old filters went away
					for each (var filter:Filter in _content.filters) {
						super.dispatchEvent(new FilterEvent(FilterEvent.FILTER_REMOVED, filter));
					}

				}

				// pass the content on
				_createContent(loadedContent, loader.settings);

			}
			
			// clear the contentloader
			loader.dispose();
		}
		
		/**
		 * 	@private
		 * 	Initializes Content
		 */
		private function _createContent(content:IContent, settings:LayerSettings):void {

			// get rid of earlier content
			if (!(content is ContentTransition)) {
				_destroyContent();
			}

			// store content
			_content = content;
			
			// listen for events to forward			
			_content.addEventListener(FilterEvent.FILTER_APPLIED,		super.dispatchEvent);
			_content.addEventListener(FilterEvent.FILTER_MUTED,			super.dispatchEvent);
			_content.addEventListener(FilterEvent.FILTER_MOVED,			super.dispatchEvent);
			_content.addEventListener(FilterEvent.FILTER_REMOVED,		super.dispatchEvent);
			_content.addEventListener(TransitionEvent.TRANSITION_END,	_endTransition);

			// apply settings
			if (settings) {
				settings.apply(content);
			}
			
			// apply midi
			settings.applyMidi(_properties);
                        
			// render first frame
			content.render();
			
			// dispatch a "i'm loaded" event if it's not a transition
			if (!(content is ContentTransition)) {
			
				// dispatch a load event
				var dispatch:LayerEvent = new LayerEvent(LayerEvent.LAYER_LOADED);
				super.dispatchEvent(dispatch);
				
			}
		}
		
		
		/**
		 * 	@private
		 * 	Destroys the current content state
		 */
		private function _destroyContent():void {
			
			if (_content !== NULL_LAYER) {
				
				// destroys the earlier content
				_content.removeEventListener(TransitionEvent.TRANSITION_END, _endTransition);

				// dispatch an unload event
				super.dispatchEvent(new LayerEvent(LayerEvent.LAYER_UNLOADED));

				// blow it up
				_content.dispose();
	
				// removes listener forwarding
				_content.removeEventListener(FilterEvent.FILTER_APPLIED,	super.dispatchEvent);
				_content.removeEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
				_content.removeEventListener(FilterEvent.FILTER_REMOVED,	super.dispatchEvent);
				_content.removeEventListener(FilterEvent.FILTER_MUTED,		super.dispatchEvent);
				
			}
		}
		
		/**
		 * 	@private
		 *	Handler for when a transition ends (swap the content
		 */
		private function _endTransition(event:TransitionEvent):void {
			
			var transition:ContentTransition = event.currentTarget as ContentTransition;
			
			// create the content
			_createContent(event.content, null);

		}
		
		/**
		 * 	Sets time
		 */
		public function set time(value:Number):void {
			_content.time = value;
		}
		
		/**
		 * 	Gets time
		 */
		public function get time():Number {
			return _content.time;
		}
		
		/**
		 * 	Gets totalTime
		 */
		public function get totalTime():int {
			return _content.totalTime;
		}
		
		/**
		 * 	Returns the path of the file loaded
		 */
		public function get path():String {
			return _content.path;
		}
		
		/**
		 * 	Returns the control array of the layer
		 */
		public function get controls():Controls {
			return _content.controls;
		}

		/**
		 * 	Gets the framerate of the movie adjusted to it's own time rate
		 */
		public function get framerate():Number {
			return _content.framerate;
		}

		/**
		 * 	Sets the framerate
		 */
		public function set framerate(value:Number):void {
			_content.framerate = value;
		}

		/**
		 * 	Gets the start loop point
		 */
		public function get loopStart():Number {
			return _content.loopStart;
		}

		/**
		 * 	Sets the start loop point
		 */
		public function set loopStart(value:Number):void {
			_content.loopStart = value;
		}

		/**
		 * 	Gets the start marker
		 */
		public function get loopEnd():Number {
			return _content.loopEnd;
		}

		/**
		 * 	Sets the right loop point for the video
		 * 	@param		Percentage for the end loop point
		 */
		public function set loopEnd(value:Number):void {
			_content.loopEnd = value;
		}

		/**
		 * 	Pauses the layer
		 *	@param		True to pause, false to unpause
		 */
		public function pause(b:Boolean = true):void {
			_content.pause(b);
		}
		
		/**
		 * 	Moves the layer
		 */
		public function moveLayer(index:int):void {
			_display.moveLayer(this, index);
		}
		
		/**
		 * 	Copys the layer down
		 */
		public function copyLayer():void {
			_display.copyLayer(this, index + 1);
		}

		/**
		 * 	Returns tint
		 */
		public function get tint():Number {
			return _content.tint;
		}
		
		/**
		 * 	Sets tint
		 */
		public function set tint(value:Number):void {
			_content.tint = value;
		}

		/**
		 * 	Sets color
		 */
		public function set color(value:uint):void {
			_content.color = value;
		}

		/**
		 * 	Gets color of current content
		 */
		public function get color():uint {
			return _content.color;
		}
		
		/**
		 * 	Sets alpha of current content
		 */
		public function set alpha(value:Number):void {
			_content.alpha = value;
		}

		/**
		 * 	Gets alpha of current content
		 */
		public function get alpha():Number {
			return _content.alpha;
		}
		
		/**
		 * 	Sets alpha of current content
		 */
		public function set blendMode(value:String):void {
			_content.blendMode = value;
		}

		/**
		 * 	Sets the x of current content
		 */
		public function set x(value:Number):void {
			_content.x = value;
		}

		/**
		 * 	Sets the y of current content
		 */
		public function set y(value:Number):void {
			_content.y = value;
		}

		/**
		 * 	Sets scaleX for current content
		 */
		public function set scaleX(value:Number):void {
			_content.scaleX = value;
		}

		/**
		 * 	Sets scaleY for current content
		 */
		public function set scaleY(value:Number):void {
			_content.scaleY = value;
		}
		
		/**
		 * 	Gets scaleX for current content
		 */
		public function get scaleX():Number {
			return _content.scaleX;
		}

		/**
		 * 	Gets scaleY for current content
		 */
		public function get scaleY():Number {
			return _content.scaleY;
		}

		/**
		 * 	Gets x for current content
		 */
		public function get x():Number {
			return _content.x;
		}
		
		/**
		 * 
		 */
		public function get anchorX():Number {
			return _content.anchorX;
		}
		
		/**
		 * 
		 */
		public function set anchorX(value:Number):void {
			_content.anchorX = value;
		}
		
		/**
		 * 
		 */
		public function get anchorY():Number {
			return _content.anchorY;
		}
		
		/**
		 * 
		 */
		public function set anchorY(value:Number):void {
			_content.anchorY = value;
		}

		/**
		 * 	Gets y for current content
		 */
		public function get y():Number {
			return _content.y;
		}
		
		/**
		 * 	Gets content rotation
		 */
		public function get rotation():Number {
			return _content.rotation / (Math.PI / 180);
		}

		/**
		 * 	Sets content rotation
		 */
		public function set rotation(value:Number):void {
			_content.rotation = value * (Math.PI / 180);
		}
		
		/**
		 * 	Adds an onyx-based filter
		 * 	The onyx filter to add to the Layer
		 */
		public function addFilter(filter:Filter):void {
			_content.addFilter(filter);
		}
		
		/**
		 * 	Removes an onyx filter from the layer
		 * 	@param		The filter to remove
		 **/
		public function removeFilter(filter:Filter):void {
			_content.removeFilter(filter);
		}
		
		/**
		 * 	Mutes a filter
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			_content.muteFilter(filter, toggle);
		}
		
		/**
		 * 	Returns the filters
		 */
		public function get filters():Array {
			return _content.filters;
		}
		
		/**
		 * 	Returns the index of the layer within the display
		 **/
		public function get index():int {
			return _display.getLayerIndex(this);
		}
		
		/**
		 * 	Returns properties related to the layer
		 */
		public function get properties():Controls {
			return _properties;
		}
		
		/**
		 * 	@private
		 * 	Use this method to dispatch methods to the layer itself (not content)
		 */
		onyx_ns function dispatch(event:Event):void {
			super.dispatchEvent(event);
		}
		
		/**
		 * 	Forwards event to the content
		 * 	(usually mouse events)
		 */
		override public function dispatchEvent(event:Event):Boolean {
			return _content.dispatchEvent(event);
		}
		
		/**
		 * 	Returns filter index
		 */
		public function getFilterIndex(filter:Filter):int {
			return _content.getFilterIndex(filter);
		}
		
		/**
		 * 	Move Filter
		 */
		public function moveFilter(filter:Filter, index:int):void {
			_content.moveFilter(filter, index);
		}
		
		/**
		 * 	Gets Blendmode
		 */
		public function get blendMode():String {
			return _content.blendMode;
		}
		
		/**
		 * 	Renders
		 */
		public function render():RenderTransform {
			return _content.render();
		}
		
		/**
		 *	Gets the source before filters are rendered
		 */
		public function get source():BitmapData {
			return _content.source;
		}
		
		/**
		 * 	Returns the layer's matrix
		 */
		public function get matrix():Matrix {
			return _content.matrix;
		}
		
		/**
		 * 	Sets the layer's matrix
		 */
		public function set matrix(value:Matrix):void {
			_content.matrix = value;
		}
		
		/**
		 * 	Returns the associated display
		 */
		public function get display():IDisplay {
			return _display;
		}
		
		/**
		 * 	Returns visibility
		 */
		public function get visible():Boolean {
			return _content.visible;
		}

		/**
		 * 	Sets the visibility
		 */
		public function set visible(value:Boolean):void {
			_content.visible = value;
		}
		
		/**
		 * 	Returns xml representation of the layer
		 */
		public function toXML():XML {
			
			var xml:XML;
			 
			if(path){
			     xml = <layer path={path}>
                       </layer>;
			} else {
				xml = <layer path="null">
				      </layer>;
			}

			// create properties
			xml.appendChild(_properties.toXML());
            
			// add filters xml
			if(path) {
			     xml.appendChild(_content.filters.toXML());
			}
			
			// add controls xml
			if ( _content.controls ) {
				xml.appendChild(_content.controls.toXML());
			}

			return xml;
		}
		
		/**
		 * 	String representation of the layer
		 */
		override public function toString():String {
			return (_content.path) ? File.getFileName(_content.path) : '';
		}

		/**
		 * 	Disposes the layer
		 */
		public function dispose():void {
			
			// disposes content
			if (_content) {

				// change target (performance)
				_properties.setNewTarget(this);

				// destroy the content
				_destroyContent();

				// set content to nothing					
				_content			= NULL_LAYER;

			}
		}
		
		/**
		 * 	Sets whether the channel is A or B
		 */
		public function set channel(value:Boolean):void {
			_channel = value;
		}
		
		/**
		 * 	Returns whether the channel is on channel A or B 
		 */
		public function get channel():Boolean {
			return _channel;
		}
		
		/**
		 * 	Returns related content
		 */
		public function get content():IContent {
			return _content;
		}
		
		/**
		 * 	Applies a filter to the rendered output
		 */
		public function applyFilter(filter:IBitmapFilter):void {
			_content.applyFilter(filter);
		}
		
		/**
		 * 
		 */
		public function getColorTransform():ColorTransform {
			return _content.getColorTransform();
		}
	}
}