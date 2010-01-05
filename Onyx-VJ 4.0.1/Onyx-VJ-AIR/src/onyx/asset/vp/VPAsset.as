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
package onyx.asset.vp {
	
	import onyx.asset.*;
	import flash.display.*;
	import flash.media.*;
	import flash.text.*;
	
	/**
	 * 
	 */
	public final class VPAsset extends AssetFile {
		
		/**
		 * 	@private
		 */
		private var url:String;
		private var thumbUrl:String;
		private var assetName:String;
		
		/**
		 * 
		 */
		public function VPAsset( name:String, url:String, thumb_url:String ):void {
			this.url = url;
			this.thumbUrl = thumb_url;
			this.assetName = name;
			this.thumbnail.bitmapData		= new VideoPongThumbnail();// TODO: put url of asset 
			
			const source:BitmapData			= this.thumbnail.bitmapData;
			const label:TextField			= new TextField();
			const format:TextFormat			= new TextFormat('Pixel', 7, 0xFFFFFF);
			//const format:TextFormat			= new TextFormat(new AssetDefaultFont().fontName, 7, 0xFFFFFF);
			format.leading					= 3;
			label.autoSize					= TextFieldAutoSize.LEFT;
			label.wordWrap					= true;
			label.width						= 44;
			//label.embedFonts				= true;
			label.defaultTextFormat			= format;
			
			label.text						= name.toUpperCase();
			
			source.draw(label);
		}
		
		/**
		 * 
		 */
		override public function get name():String {
			return assetName;
		}
		
		/**
		 * 
		 */
		override public function get path():String {
			return url;	
		}
		
		/**
		 * 
		 */
		override public function get isDirectory():Boolean {
			return false;
		}
		
		/**
		 * 
		 */
		override public function get extension():String {
			trace(url.substr( url.lastIndexOf( '.' ) ));
			return 'swf';//url.substr( url.lastIndexOf( '.' ) );
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return '[VPAsset: ' + path + ']';
		}
	}
}