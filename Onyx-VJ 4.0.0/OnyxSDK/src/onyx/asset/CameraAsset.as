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
package onyx.asset {
	
	import flash.display.*;
	import flash.media.*;
	import flash.text.*;
	
	[ExcludeSDK]
	
	/**
	 * 
	 */
	internal final class CameraAsset extends OnyxFile {
		
		/**
		 * 	@private
		 */
		private var camera:String

		/**
		 * 	@constructor
		 */
		public function CameraAsset(name:String) {
			this.camera					= name,
			this.thumbnail.bitmapData	= new CameraThumbnail();
			
			var source:BitmapData		= this.thumbnail.bitmapData;
			var label:TextField			= new TextField();
			label.autoSize				= TextFieldAutoSize.LEFT;
			label.wordWrap				= true;
			label.width					= 44;
			label.defaultTextFormat		= new TextFormat('Arial', 9, 0xFFFFFF);
			label.text					= name;
			source.draw(label);
		}
		
		/**
		 * 
		 */
		override public function get name():String {
			return camera;
		}
		
		/**
		 * 
		 */
		override public function get path():String {
			return 'camera://' + name;
		}
		
		/**
		 * 
		 */
		override public function get extension():String {
			return '';
		}
		
		/**
		 * 
		 */
		override public function get isDirectory():Boolean {
			return false;
		}
	}
}