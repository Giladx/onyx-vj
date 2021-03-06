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
package ui.core {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextFieldAutoSize;
	import flash.utils.*;
	
	import onyx.core.IDisposable;
	
	import ui.assets.AssetBitmap;
	import ui.styles.*;
	import ui.text.*;

	/**
	 * 	Base UIObject Class
	 */
	public class UIObject extends Sprite {
		
		/**
		 * 	@private
		 */
		private static const REUSE:MouseEvent = new MouseEvent(MouseEvent.DOUBLE_CLICK);
		
		/**
		 * 	The overall selection for the app
		 */
		public static var selection:UIObject;
		
		/**
		 * 	@private
		 * 	When mouse is clicked
		 */
		private static function _mouseDown(event:MouseEvent):void {
			
			var dispatcher:IEventDispatcher = event.currentTarget as IEventDispatcher;
			
			if (_doubleObject === dispatcher) {
				if (getTimer() - _doubleTime < 300) {
					event.stopPropagation();
					
					REUSE.ctrlKey	= event.ctrlKey,
					REUSE.altKey	= event.altKey,
					REUSE.shiftKey	= event.shiftKey;
					
					dispatcher.dispatchEvent(REUSE);
				}
			}
			
			_doubleObject = dispatcher;
			_doubleTime = getTimer();
		}
		
		/**
		 * 
		 */
		public static function select(layer:UIObject):void {
			
			if (selection) {
				selection.transform.colorTransform = DEFAULT;
			}
			
			if (layer) {
				// highlight
				layer.transform.colorTransform = LAYER_HIGHLIGHT;
			}
			
			// select layer
			selection = layer;
		}
		
		/**
		 * 	@private
		 */
		private static var _doubleObject:IEventDispatcher;
		
		/**
		 * 	@private
		 */
		private static var _doubleTime:int;

		/**
		 * 	@constructor
		 */
		final public function UIObject(movesToTop:Boolean = false):void {

			if (movesToTop) {
				addEventListener(MouseEvent.MOUSE_DOWN, moveToTop, false, 0, true);
			}
			
			tabEnabled = false;
		}
		
		/**
		 * 	Sets doubleClickEnabled
		 */
		final public override function set doubleClickEnabled(s:Boolean):void {
			if (s) {
				addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown, true, 0, true);
			} else {
				removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown, true);
			}
		}
		
		/**
		 * 	Removes all children
		 */
		final public function clearChildren():void {
			
			var numChildren:int = numChildren;
			for (var count:int = 0; count < numChildren; count++) {
				var child:DisplayObject = getChildAt(0);
				removeChild(child);
				
				if (child is IDisposable) {
					(child as IDisposable).dispose();
				}
			}
		}
		
		/**
		 * 	Moves to the top
		 */
		final public function moveToTop(event:MouseEvent = null):void {
			
			parent.setChildIndex(this, parent.numChildren - 1);
			
		}	
		
		/**
		 * 	Creates a background
		 */
		final protected function displayBackground(width:int, height:int):void {
			addChildAt(new AssetBitmap(width, height), 0);
		}
		
		/**
		 * 
		 */
		final public function getBackground():DisplayObject {
			return getChildAt(0) is AssetBitmap ? getChildAt(0) : null;
		}
		
		/**
		 * 	Adds Children
		 */
		final public function addChildren(... args:Array):void {
			
			var len:int = args.length;
			for (var count:int = 0; count < len; count+=3) {
				
				args[count].x = args[count+1],
				args[count].y = args[count+2];

				addChild(args[count]);
			}
		}

		/**
		 * 	Disposes the UIObject
		 */
		public function dispose():void {
			
			if (parent) {
				parent.removeChild(this);
			}
			
			clearChildren();
			
			// removes listener
			removeEventListener(MouseEvent.MOUSE_DOWN, moveToTop, true);
		}

		
		/**
		 * 	Adds a label to the control
		 */
		final protected function addLabel(name:String, width:int, height:int, offsetY:int = -8, offsetX:int = 0, align:String = null):void {
			
			switch (align) {
				case 'left':
					var left:TextField			= new TextField(width, 12);
					left.textColor				= TEXT_LABEL,
					left.text					= name.toUpperCase(),
					left.mouseEnabled			= false,
					left.y						= offsetY,
					left.x						= offsetX;
					
					super.addChild(left);
					break;
				default:
					var label:TextFieldCenter	= new TextFieldCenter(width + 3, height, offsetX, offsetY);
					label.textColor				= TEXT_LABEL,
					label.text					= name.toUpperCase(),
					label.mouseEnabled			= false;
		
					super.addChild(label);
					break;
			}
		}
	}
}