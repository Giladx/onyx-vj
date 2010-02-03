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
package onyx.asset.vp {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.text.*;
	
	import onyx.asset.*;
	
	/*private var _imageDir:File = File.documentsDirectory.resolvePath("library" );// put onyx lib here
	private var _localFolderId:String; 
	private static var instance:ImageCacheManager;
	private var pendingDictionaryByLoader:Dictionary = new Dictionary();
	private var pendingDictionaryByURL:Dictionary = new Dictionary();*/
	/**
	 * 
	 */
	public final class VPCachedAsset extends AssetFile {
		
		/**
		 * 	@private
		 */
		private var assetUrl:String;
		private var thumbUrl:String;
		private var assetName:String;
		private const label:TextField = new TextField();;
		/**
		 * 
		 */
		public function VPCachedAsset( name:String, url:String, thumb_url:String='' ):void {
			this.assetUrl 					= url; // https://www.videopong.net/api/get_clip/replacethissessiontoken/0cwqpxstzh2/ninja.swf
			this.thumbUrl 					= thumb_url; // https://www.videopong.net/movies/0cwqpxstzh2/thumb1.jpg
			this.assetName 					= name; // Ninja
										
			const format:TextFormat			= new TextFormat(new AssetDefaultFont().fontName, 7, 0xFFFFFF);
			format.leading					= 3;
			label.autoSize					= TextFieldAutoSize.LEFT;
			label.wordWrap					= true;
			label.width						= 44;
			label.embedFonts				= true;
			label.defaultTextFormat			= format;
			
			label.text						= name.toUpperCase();
			if ( thumbUrl.length > 0)
			{
				// create a thumbnail loader
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onImageLoaded );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler ); 
				
				loader.load(new URLRequest(thumbUrl));
			}
			else
			{
				this.thumbnail.bitmapData		= new VideoPongThumbnail();
				
				const source:BitmapData			= this.thumbnail.bitmapData;
				source.draw(label);
			}
			
		}
		/**
		 * 
		 */
		private function onImageLoaded( evt:Event ):void
		{
			if (evt) 
			{
				var bmpThumb:Bitmap = Bitmap( evt.target.content );
				var tmpBD:BitmapData = new BitmapData( 64, 48 );
				tmpBD.draw( bmpThumb.bitmapData );
				this.thumbnail.bitmapData = tmpBD;
				this.thumbnail.bitmapData.draw(label);
			}
		}

/*		public function getAssetThumbnailByURL( thumbnailUrl:String, localFolderId:String ):String
		{
			_localFolderId = localFolderId;
			gb = Singleton.getInstance();
			//var cacheFile:File = new File( _imageDir.nativePath + folder + File.separator + cleanURLString( url ) );
			var localUrl:String = _imageDir.nativePath + File.separator + gb.hostDir + File.separator + gb.folderDictionary[_localFolderId] + File.separator + getFileName( thumbnailUrl ) ;
			var cacheFile:File = new File( localUrl );
			
			gb.log( "ImageCacheManager, getAssetThumbnailByURL localUrl: " + localUrl );
			gb.log( "ImageCacheManager, getAssetThumbnailByURL _localFolderId: " + _localFolderId );
			gb.log( "ImageCacheManager, getAssetThumbnailByURL gb.folderDictionary[_localFolderId]: " + gb.folderDictionary[_localFolderId] );
			if( cacheFile.exists )
			{
				gb.log( "ImageCacheManager, getAssetThumbnailByURL cacheFile exists: " + cacheFile.url );
				return cacheFile.url;
			} 
			else 
			{
				gb.log( "ImageCacheManager, getAssetThumbnailByURL cacheFile does not exist: " + thumbnailUrl );
				addImageToCache( thumbnailUrl );
				return thumbnailUrl;
			}
			
		}
		public function getAssetByURL( assetUrl:String, localFolderId:String ):String
		{
			_localFolderId = localFolderId;
			gb = Singleton.getInstance();
			//var cacheFile:File = new File( _imageDir.nativePath + folder + File.separator + cleanURLString( url ) );
			var localUrl:String = _imageDir.nativePath + File.separator + gb.hostDir + File.separator + gb.folderDictionary[_localFolderId] + File.separator + getFileName( assetUrl ) ;
			var cacheFile:File = new File( localUrl );
			
			gb.log( "ImageCacheManager, getAssetByURL localUrl: " + localUrl );
			gb.log( "ImageCacheManager, getAssetByURL _localFolderId: " + _localFolderId );
			gb.log( "ImageCacheManager, getAssetByURL gb.folderDictionary[_localFolderId]: " + gb.folderDictionary[_localFolderId] );
			if( cacheFile.exists )
			{
				gb.log( "ImageCacheManager, getAssetByURL cacheFile exists: " + cacheFile.url );
				return cacheFile.url;
			} 
			else 
			{
				gb.log( "ImageCacheManager, getAssetByURL cacheFile does not exist: " + assetUrl );
				addImageToCache( assetUrl );
				return assetUrl;
			}
			
		}
		private  function addImageToCache( url:String ):void
		{
			if(!pendingDictionaryByURL[url]){
				var req:URLRequest = new URLRequest(url);
				var loader:URLLoader = new URLLoader();
				loader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
				loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
				loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
				loader.addEventListener( Event.COMPLETE, imageLoadComplete );
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.load(req);
				pendingDictionaryByLoader[loader] = url;
				pendingDictionaryByURL[url] = true;
			} 
		}
		private function imageLoadComplete( event:Event ):void
		{
			var loader:URLLoader = event.target as URLLoader;
			var url:String = pendingDictionaryByLoader[loader];
			//var fileName:String = pendingDictionaryByLoader[loader];
			//var cacheFile:File = new File( _imageDir.nativePath +File.separator+ cleanURLString( url ) );
			
			gb = Singleton.getInstance(); //useless?
			var cacheFile:File = new File( _imageDir.nativePath + File.separator + gb.hostDir + File.separator + gb.folderDictionary[_localFolderId] + File.separator + getFileName( url ) );
			var stream:FileStream = new FileStream();
			
			stream.open(cacheFile,FileMode.WRITE);
			stream.writeBytes(loader.data);
			stream.close();
			delete pendingDictionaryByLoader[loader]
			delete pendingDictionaryByURL[url];
		}
		public function getFileName( url:String ):String
		{
			var lastSlash:uint = url.lastIndexOf( '/' );
			var fileName:String = "assets/closeBtn.png";
			if ( lastSlash > -1 )
			{
				fileName = url.substr( lastSlash + 1 );
			}
			return fileName;
		}*/
		/**
		 * 
		 */
		private function ioErrorHandler( evt:IOErrorEvent ):void 
		{
			trace("thumbnail load error");
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
			return assetUrl;
		}
		
		/**
		 * 
		 */
		public function get url():String {
			return assetUrl;	
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
		public function toString():String {
			return '[VPAsset: ' + path + ']';
		}
	}
}