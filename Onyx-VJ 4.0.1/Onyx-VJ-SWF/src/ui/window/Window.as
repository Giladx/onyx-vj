/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.IParameterObject;
	
	import ui.assets.AssetWindow;
	import ui.core.UIObject;
	import ui.text.*;
	
	/**
	 * 	Window (SC: was internal)
	 */
	public class Window extends UIObject {
		
		/**
		 * 	@private
		 */
		protected var registration:WindowRegistration;
		
		/**
		 * 	@constructor
		 */
		public function Window(reg:WindowRegistration, background:Boolean, width:int, height:int):void {
			
			this.registration	= reg;
			
			// check for title
			if (background) {
				
				// add the background
				var asset:AssetWindow = new AssetWindow(width, height);
				asset.draw((reg && reg.name) ? reg.name : null);
				addChild(asset);
				
			}
			
			// moves to top yes
			setMovesToTop(true);
			
			// check to see if we have to register control
			if (reg && this is IParameterObject) {
				
				(this as IParameterObject).getParameters().registerGlobal('/ONYX/WINDOW/' + reg.name);

			}
		}
		
		/**
		 *  SC
		 */ 
		public function toXML():XML {
			
			// TODO: make this call selective, 
			// example if the caller is MIDIsave
			// save to XML only midihash, if other caller do other task			
			var xml:XML = <window/>;
			xml.@title 	= registration.name;
						
			return xml;
		}
		
		/**
		 *  SC
		 */ 
		public function loadXML(xml:XML):void {
			
			// for each LOOP control copy hash to this.controls
			
		}
		
		/**
		 * 
		 */
		public function get id():String {
			return '/ONYX/WINDOW/' + registration.name;
		}
		
	}
}