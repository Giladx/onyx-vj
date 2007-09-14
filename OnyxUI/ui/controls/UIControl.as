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
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	
	import onyx.controls.Control;
	import onyx.core.IDisposable;
	import onyx.events.ControlEvent;
	
	import ui.core.UIObject;
	import ui.text.TextField;

	/**
	 * 	Base UIControl class: This class is an UIObject that contains a parameterized control.
	 * 
	 * 	@see onyx.controls.Control
	 */
	public class UIControl extends UIObject implements IDisposable {

		/**
		 * 	@private
		 */
		protected static const CONTAINER:UnClippedContainer	= new UnClippedContainer();
		
		/**
		 * 	Stores all available UIControls
		 */
		public static const controls:Dictionary	= new Dictionary(true);

		/**
		 * 	Stores the related core control
		 */
		protected var _control:Control;

		/**
		 * 	@constructor
		 */
		public function UIControl(options:UIOptions, control:Control, movesToTop:Boolean = false, label:String = null):void {
			
			// store the UIControl so we can toggle affectable controls
			controls[this] = null;

			// store the control
			_control = control;
			
			if (options) {
			
				if (options.background) {
					displayBackground(options.width, options.height);
				}
				
				if (options.label && label) {
					addLabel(label, options.width, options.height, -8, 0, options.labelAlign);
				}
			}
			
			super(movesToTop);
		}
		
		/**
		 * 
		 */
		public function get control():Control {
			return _control;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			super.dispose();
			_control = null;
			delete controls[this];
		}
	}
}
