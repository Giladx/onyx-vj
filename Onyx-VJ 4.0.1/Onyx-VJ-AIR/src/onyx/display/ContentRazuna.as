/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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
package onyx.display {
	
	import flash.display.Loader;
	import flash.media.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class ContentRazuna extends ContentBase {
		
		/**
		 * 	@private
		 * 	Stores the loader object where the content was loaded into
		 */
		private var loader:Loader;
		private static var _login:String;
		private static var _pwd:String;

		public static function loadXML(xml:XML):void {
			for each (var node:XML in xml.razuna) {
				_login	= node.login;
				_pwd	= node.pwd;
			}
		}
		/**
		 * 
		 */
		public static function toXML():XML {
			const xml:XML	= 
				<razuna>
					<login>{_login}</login>
					<pwd>{_pwd}</pwd>
				</razuna>;
			
			return xml;
		}		

		/**
		 * 	@constructor
		 */
		public function ContentRazuna(layer:LayerImplementor, path:String, loader:Loader):void {
			
			this.loader = loader;
			
			// pass parameters
			super(layer, path, loader.content, loader.contentLoaderInfo.width, loader.contentLoaderInfo.height);
			
		}
		

		/**
		 * 	Disposes
		 */
		override public function dispose():void {
			
			super.dispose();
			
			// destroy content
			loader.unload();
			loader	= null;
		}
		
	}
}