/** 
 * Copyright (c) 2003-2012, www.onyx-vj.com
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
package plugins.filters {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.URLRequest;
	
	import onyx.asset.AssetFile;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 	Mask Filter
	 */
	public final class MaskFilter extends Filter implements IBitmapFilter {
		
		private var _source:BitmapData;
		
		public var feedBlend:String				= 'normal';
	
		private var myMask:BitmapData;

		
		public function MaskFilter():void {

			Console.output( 'MaskFilter v 0.0.3: needs library/mask.png' );
			
			parameters.addParameters(
				new ParameterBlendMode('feedBlend', 'Mask Blend')
			);
			var imgFile:File = new File( AssetFile.resolvePath( 'library/mask.png' ) );
			if ( imgFile.exists )
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler);
				
				loader.load(new URLRequest(imgFile.url));
			}
		}
		
		
		override public function initialize():void {
			_source		= createDefaultBitmap();
			myMask		= createDefaultBitmap();
		}
		
		
		public function applyFilter(bitmapData:BitmapData):void {
			
			_source.draw(bitmapData, null,  null, feedBlend);

			// copy the pixels back to the original bitmap
			bitmapData.copyPixels(_source, DISPLAY_RECT, ONYX_POINT_IDENTITY, myMask, ONYX_POINT_IDENTITY);
		}
		private function loadHandler(event:Event):void 
		{
			if ( !(event is IOErrorEvent) ) 
			{
				try 
				{
					myMask = Bitmap(LoaderInfo(event.target).content).bitmapData;
					Console.output( 'library/mask.png loaded' );
				} 
				catch (e:Error) 
				{
					Console.output( 'loadHandler: ' + ( e.message ) );
				}
			}
			else
			{
				Console.output( 'loadHandler, IO Error loading: ' + (event as IOErrorEvent).text );
			}
		}	
		override public function dispose():void {
			if (_source) {
				_source.dispose();
				_source = null;
			}
			
			super.dispose();
		}
	}
}