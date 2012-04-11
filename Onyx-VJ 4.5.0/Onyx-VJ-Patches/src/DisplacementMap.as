/**
 * Copyright (c) 2003-2011 "Onyx-VJ Team" which is comprised of:
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
 * 
 */
package 
{
	import flash.events.*;
	import flash.display.*;
	import flash.utils.getTimer;
	import flash.filters.DisplacementMapFilter;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * @author nicoptere
	 */
	public class DisplacementMap extends Patch
	{
		private var c : BitmapData, a : BitmapData, b : BitmapData = new BitmapData ( DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x00);
		
		private var f : DisplacementMapFilter = new DisplacementMapFilter (b, b.rect.topLeft, 4, 4, 0, 0, 'wrap');

		private var _sourceBD:BitmapData = createDefaultBitmap();
		private var mx:Number = 0;
		private var my:Number = 0;
		private var _canvasBD:BitmapData;
		private var _canvasBMP:Bitmap;
		
		public function DisplacementMap()
		{
			Console.output('DisplacementMap');
			Console.output('Credits to christian (http://wonderfl.net/user/christian)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			
			_canvasBD = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00FF00FF);
			_canvasBMP = new Bitmap( _canvasBD, "auto", true );
			addChild( _canvasBMP );
			addChild (new Bitmap (c = b.clone ()));
			
			a = b.clone ();
			
			b.fillRect (b.rect, 0x00);
			
			for (var i : uint = 0; i < 10; i++)
			{
				a.perlinNoise (50 * i, 50 * i, 2, getInt(), true, true, 4, false);
				b.draw (a, null, null, BlendMode.DIFFERENCE);
			}
			b.draw (b, null, null, BlendMode.ADD);
			
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			
		}

		private function mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
		}
	
		override public function render(info:RenderInfo):void 
		{
			f.scaleY = f.scaleX = Math.cos (getTimer () * 0.0005) * 232.5;
			
			c.copyPixels  (b, b.rect, b.rect.topLeft);
			c.applyFilter (c, c.rect, c.rect.topLeft, f);
			info.render( c);
		}
		
		public function getInt () : int { return int.MIN_VALUE + Math.random () * int.MAX_VALUE * 2; }       
	
		
		/**
		 * startDraw.
		 * @param			evt:MouseEvent
		 * @description	
		 **/
		private function startDraw(evt:MouseEvent) : void {
			mx = evt.localX; 
			my = evt.localY; 
		}
		
	}
}


