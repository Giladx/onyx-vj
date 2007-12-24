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
package onyx.controls {
	
	import onyx.core.*;
	import onyx.constants.*;
	import onyx.display.*;
	import onyx.events.ControlEvent;
	import onyx.content.IContent;
	
	use namespace onyx_ns;
	
	/**
	 * 	This class will display available layers and their path names.  Use this control if you'd like
	 * 	your filter or plug-in to use another layer as its' source.  For example, once you have a layer, you can
	 * 	read the layer.source (bitmapdata) or layer.source (bitmapdata before rendering filters)
	 * 
	 * 	@see onyx.core.IControlObject
	 */
	public final class ControlLayer extends ControlRange {
		
		/**
		 * 	@constructor
		 */
		public function ControlLayer(name:String, displayName:String):void {
			
			var display:IDisplay	= DISPLAY;
			var data:Array			= (display) ? display.layers : [];

			super(name, displayName, data, data[0]);

		}
		
		/**
		 * 
		 */
		override public function toXML():XML {
			var xml:XML			= <{name}/>;
			var layer:ILayer	= this.value;
			
			if (value) {
				xml.appendChild(layer.index);
			}
			
			return xml;
		}
		
		/**
		 * 
		 */
		override public function loadXML(xml:XML):void {
			
		}

		/**
		 * 
		 */
		override public function set value(v:*):void {
			_target[name] = REUSABLE_EVENT.value = v;
			dispatchEvent(REUSABLE_EVENT);
		}
 		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlLayer;
		}
	}
}