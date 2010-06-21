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
package library.patches {
	
	import library.patches.cursor.Cursor;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	public final class ScreenShare extends Patch {

		/**
		 * 
		 */		
		private const matrix:Matrix	= new Matrix();

		/**
		 * 	@private
		 */
		override public function render(info:RenderInfo):void {
			
			var source:BitmapData	= info.source;
			
			matrix.a				= 1;
			matrix.b				= 0;
			matrix.c				= 0;
			matrix.d				= 1;
			matrix.tx				= -(DISPLAY_STAGE.mouseX - (DISPLAY_WIDTH / 2));
			matrix.ty				= -(DISPLAY_STAGE.mouseY - (DISPLAY_HEIGHT / 2));
			
			// concatenate the control matrix
			matrix.concat(info.matrix);
			
			// draw stage
			source.draw(DISPLAY_STAGE, matrix, null, null, null, true);
			
		}
	}
}