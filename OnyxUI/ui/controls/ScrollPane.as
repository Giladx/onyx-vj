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
package ui.controls {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.IDisposable;
	import onyx.utils.math.*;
	
	import ui.core.UIObject;
	import ui.styles.*;

	/**
	 * 	ScrollPane class
	 */
	public class ScrollPane extends UIObject {

		/**
		 * 	@private
		 */		
		private var _holder:Sprite;

		/**
		 * 	@private
		 */		
		private var _clickY:int;

		/**
		 * 	@private
		 */		
		private var _width:int;

		/**
		 * 	@private
		 */		
		private var _height:int;

		/**
		 * 	@private
		 */		
		private var _scrollY:ScrollBar;
		
		/**
		 * 	@constructor
		 */
		public function ScrollPane(width:int, height:int, label:String = null, background:Boolean = false):void {
			
			// create holder
			_holder = new Sprite();
			
			// add holder
			super.addChild(_holder);
			
			// set width / height
			_width = width;
			_height = height;
			
			// listen for mouse over
			addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			
			// set the scroll 
			super.scrollRect = new Rectangle(0, 0, width, height);
			
			// check for label
			if (label) {
				super.addLabel(label, width, 10, -10);
			}
			
			// check for background
			if (background) {
				super.displayBackground(width, height);
			}
		}
		
		/**
		 * 	@see DisplayObject.addChild
		 */
		override public function addChild(child:DisplayObject):DisplayObject {
			var child:DisplayObject = _holder.addChild(child);
			_calculateAdd();
			
			return child;
		}
		
		/**
		 * 	@see DisplayObjectContainer.addChildAt
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			var child:DisplayObject = _holder.addChildAt(child, index);
			_calculateAdd();
			return child;
		}
		
		/**
		 * 	Gets the child at index
		 */
		override public function getChildAt(index:int):DisplayObject {
			return _holder.getChildAt(index);		
		}
		
		/**
		 * 	@see DisplayObjectContainer.addChildAt
		 */
		override public function getChildIndex(child:DisplayObject):int {
			return _holder.getChildIndex(child);;
		}
		
		/**
		 * 	@see DisplayObjectContainer.removeChild
		 */
		override public function removeChild(child:DisplayObject):DisplayObject {
			
			var child:DisplayObject = _holder.removeChild(child);
			_calculateRemove();
			
			return child;
		}
		
		/**
		 * 	@see DisplayObjectContainer.removeChildAt
		 */
		override public function removeChildAt(index:int):DisplayObject {
			var child:DisplayObject = _holder.removeChildAt(index);
			_calculateRemove();
			return child;
		}

		/**
		 * 	@see DisplayObjectContainer.removeChildAt
		 */
		override public function contains(child:DisplayObject):Boolean {
			return _holder.contains(child);
		}
		
		/**
		 * 	@see DisplayObjectContainer.numChildren
		 */
		override public function get numChildren():int {
			return _holder.numChildren;
		}
		
		/**
		 * 	@private
		 * 	Calculates the rectangle when an item is added
		 */
		private function _calculateAdd():void {
			
			if (_holder.height > _height) {
				_displayScrollBar();
			}
		}
		
		/**
		 * 	@private
		 * 	Calculates the rectangle when an item is removed
		 */
		private function _calculateRemove():void {

			if (_scrollY) {
				if (_holder.height < _height) {
					_destroyScrollBar();
				}
			}

		}
		
		/**
		 * 	@private
		 * 	Listens for the mouse wheel
		 */
		private function _onMouseOver(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		}
		
		/**
		 * 	@private
		 * 	Listens for mouse out
		 */
		private function _onMouseOut(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		}
		
		/**
		 * 	Handles mousewheel events
		 */
		private function _onMouseWheel(event:MouseEvent):void {
			if (_scrollY) {
				_scroll(_scrollY.y - (event.delta * 3));
				event.updateAfterEvent();
			}
		}
		
		/**
		 * 	Displays scroll bar
		 */
		private function _displayScrollBar():void {
			
			if (!_scrollY) {
				
				_scrollY = new ScrollBar();
				_scrollY.x = _width - 6;
				_scrollY.addEventListener(MouseEvent.MOUSE_DOWN, _onScrollPress);
				
				super.addChild(_scrollY);
			}
			
			_scrollY.height = (_height / _holder.height) * _height;
		}
		
		/**
		 * 	@private
		 */
		private function _destroyScrollBar():void {
			
			// remove listener
			_scrollY.removeEventListener(MouseEvent.MOUSE_DOWN, _onScrollPress);
			
			// remove the scroll bar
			super.removeChild(_scrollY);
			
			// remove reference
			_scrollY = null;
			
			// set the holder to default
			_holder.y = 0;
			
		}
		
		/**
		 * 	@private
		 * 	Handler when a scroll bar is pressed
		 */
		private function _onScrollPress(event:MouseEvent):void {
			var scrollbar:ScrollBar = event.currentTarget as ScrollBar;
			
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onScrollMove);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onScrollUp);
			
			_clickY = mouseY - _scrollY.y;
			
			_onScrollMove(event);
		}
		
		/**
		 * 	@private
		 * 	Handler when a scroll bar is moved
		 */
		private function _onScrollMove(event:MouseEvent):void {
			_scroll(mouseY - _clickY);
			event.updateAfterEvent();
		}

		
		/**
		 * 	Scrolls
		 */
		private function _scroll(y:int):void {

			_scrollY.y = min(max(y, 0), _height - _scrollY.height);
			
			var ratio:Number = (_scrollY.y / (_height - _scrollY.height));
			_holder.y = -ratio * (_holder.height - _height);
			
		}
		
		/**
		 * 	@private
		 * 	Handler when a scroll bar is moved
		 */
		private function _onScrollUp(event:MouseEvent):void {
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onScrollMove);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onScrollUp);
		}
		
		/**
		 * 	Resets
		 */
		public function reset():void {
			_holder.y = 0;
		}
		
		/**
		 * 	Disposes
		 */
		override public function dispose():void {
			
			if (_scrollY) {
				_scrollY.removeEventListener(MouseEvent.MOUSE_DOWN, _onScrollPress);
			}

			removeEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);

			super.dispose();
		}		
	}
}