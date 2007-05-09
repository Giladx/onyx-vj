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
package ui.states {
	
	import flash.events.MouseEvent;
	
	import onyx.constants.*;
	import onyx.controls.Control;
	import onyx.display.Layer;
	import onyx.states.ApplicationState;
	import onyx.states.StateManager;
	
	import ui.layer.UILayer;

	/**
	 * 	When a layer is clicked and dragged, this state allows the layer to be moved by dragging
	 */
	public final class LayerMoveState extends ApplicationState {

		/**
		 * 	@private
		 */		
		private var _origin:UILayer;
		
		/**
		 * 	@constructor
		 */
		public function LayerMoveState(origin:UILayer):void {
			_origin = origin;
		}
		
		/**
		 * 
		 */
		override public function initialize():void {

			// listen for rollover events for all layers except the one that originated the layer
			for each (var layer:UILayer in UILayer.layers) {
				if (layer !== _origin) {
					layer.addEventListener(MouseEvent.MOUSE_OVER, _onLayerOver);
				}
			}

			// listen for mouse up
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		/**
		 * 	@private
		 * 	When mouse is hovered over another layer
		 */
		private function _onLayerOver(event:MouseEvent):void {
			var layer:UILayer = event.currentTarget as UILayer;
			_origin.moveLayer(layer.index);

			// if control key is down, swap the blendModes			
			if (event.shiftKey) {
				var originBlend:String	= _origin.blendMode;
				var newBlend:String		= layer.blendMode;
				
				var originControl:Control = _origin.layer.properties.blendMode;
				var newControl:Control = layer.layer.properties.blendMode;
				
				originControl.value = newBlend;
				newControl.value = originBlend;
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			StateManager.removeState(this);
		}

		/**
		 * 	Terminates state
		 */
		override public function terminate():void {
			if (_origin) {
				STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			}

			for each (var layer:UILayer in UILayer.layers) {
				layer.removeEventListener(MouseEvent.MOUSE_OVER, _onLayerOver);
			}
			
			_origin = null;
		}
	}
}