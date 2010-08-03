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
 * plug-in for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * 
 * Copyright jozefchutka ( http://wonderfl.net/user/jozefchutka )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/y0Ta
 */

package library.patches
{
	// read more and download pbk file here:
	// http://blog.yoz.sk/2010/06/anaglyphs-with-pixel-bender-and-depth-map
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ShaderFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;

	[SWF(width="460", height="368", frameRate="25", backgroundColor="#FFFFFF")]
	public class Anaglyphs extends Patch
	{
		[Embed(source="./images/displacementMapAnaglyph.pbj", mimeType="application/octet-stream")]
		private static const ANAGLYPH_CLASS:Class;
		private static const ANAGLYPH_SHADER:Shader = new Shader(new ANAGLYPH_CLASS());
		
		[Embed(source='./images/zbuffer3.jpg' )] private const IMAGE_CLASS: Class;
		private const IMAGE_BMP:Bitmap = Bitmap( new IMAGE_CLASS() );
		private const IMAGE_BD:BitmapData = IMAGE_BMP.bitmapData;
		
		[Embed(source='./images/zbuffer3Map.jpg' )] private const IMAGE_MAP: Class;
		private const IMAGE_MAP_BMP:Bitmap = Bitmap( new IMAGE_MAP() );
		private const IMAGE_MAP_BD:BitmapData = IMAGE_MAP_BMP.bitmapData;
		
		private var filter:ShaderFilter;
		private var imageLegend:Bitmap = new Bitmap();
		private var mapLegend:Bitmap = new Bitmap();
		
		private var imageContainer:Sprite = new Sprite();
		private var shape:Sprite = new Sprite();
		//Mouse
		private var mx:Number = 0;
		private var my:Number = 0;
		
		public function Anaglyphs():void
		{
			imageContainer.x = 200;
			imageContainer.y = 100;
			addChild(imageContainer);
			
			shape.graphics.beginFill(0xFF0000, 0);
			shape.graphics.drawRect(0, 0, 300, 200);
			shape.graphics.endFill();
			addChild(shape);			

			//addChild( IMAGE_MAP_BMP );
			
			ANAGLYPH_SHADER.data.map.input = IMAGE_MAP_BD; //OK
			filter = new ShaderFilter(ANAGLYPH_SHADER);
			imageContainer.addChild( IMAGE_BMP );
			
			IMAGE_BMP.x = -IMAGE_BMP.width / 2;
			IMAGE_BMP.y = -IMAGE_BMP.height / 2;
			
			imageLegend.bitmapData = IMAGE_BD.clone();
			imageLegend.width = 100;
			imageLegend.height = imageLegend.bitmapData.height
				* imageLegend.width / imageLegend.bitmapData.width;
			addChild(imageLegend); 
			
			mapLegend.bitmapData = IMAGE_MAP_BD.clone();
			mapLegend.width = 100;
			mapLegend.height = mapLegend.bitmapData.height 
				* mapLegend.width / mapLegend.bitmapData.width;
			mapLegend.x = 200 - mapLegend.width;
			addChild(mapLegend); 
			
			addEventListener( InteractionEvent.MOUSE_MOVE, mouseMove );

		}
		
		private function mouseMove(event:MouseEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void 
		{
			var source:BitmapData = info.source;
			
			var dx:Number = (300 / 2 - mx);
			var dy:Number = (200 / 2 - my);
			
			IMAGE_BMP.rotationX -= (IMAGE_BMP.rotationX + dy / 15) / 10;
			IMAGE_BMP.rotationY -= (IMAGE_BMP.rotationY - dx / 15) / 10;
			/*imageContainer.rotationX -= (imageContainer.rotationX + dy / 15) / 10;
			imageContainer.rotationY -= (imageContainer.rotationY - dx / 15) / 10;*/
			
			ANAGLYPH_SHADER.data.dx.value = [10];
			ANAGLYPH_SHADER.data.dy.value = [0];
			
			IMAGE_BMP.filters = [filter];
			source.draw(IMAGE_BMP, info.matrix, null, null, null, true);
		}
		/**
		 * 	
		 */
		override public function dispose():void {
			// .dispose();
			
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
	}
}