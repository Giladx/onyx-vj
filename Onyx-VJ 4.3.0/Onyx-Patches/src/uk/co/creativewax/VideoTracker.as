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
 * Stewart Hamilton-Arrandale's (http://www.creativewax.co.uk) tutorial in Computer Arts magazine
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 *  
 */
package uk.co.creativewax 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;

	public class VideoTracker extends Sprite
	{
		private var _src:Video;				// the video we are tracking
		private var _bmdNew:BitmapData;		// bitmapdata from the current pass of the video
		private var _bmdOld:BitmapData;		// bitmapdata from the previous pass of the video
		
		private var _point:Point;			// point used for various filters
		private var _pos:Point				// point used to keep track of general motion
		
		private var _matrix:Matrix;			// matrix used to flip the source video
		private var _blur:BlurFilter;		// used to blur the bitmapdata to reduce the information we are checking
		
		public function VideoTracker(src:Video)
		{
			// setup default settings
			_src	= src;
			_point	= new Point();
			_pos	= new Point();
			_bmdNew	= new BitmapData(src.width, src.height, false, 0);
			_bmdOld	= new BitmapData(src.width, src.height, false, 0);
			_blur	= new BlurFilter(5, 5);
			
			// add the new bitmap data to the display in case we want to view it to see whats going on
			addChild(new Bitmap(_bmdNew));
			
			// flip the video input
			setupFlipMatrix();
		}
		
		// track the video
		public function track():void
		{
			_bmdNew.draw(_src, _matrix);								// draw the source video and flip the input with the matrix we setup
			_bmdNew.draw(_bmdOld, null, null, BlendMode.DIFFERENCE);	// draw the old frames video on top with a difference blend mode
			_bmdNew.applyFilter(_bmdNew, _bmdNew.rect, _point, _blur);	// apply a blur filter to soften the areas we are checking
			
			// we now run a threashold over the current bitmapdata so that we can isolate all areas of interest
			// anything over dark grey will be turned to white so we can track it later on
			_bmdNew.threshold(_bmdNew, _bmdNew.rect, _point, '>', 0xFF333333, 0xFFFFFFFF);
			
			// update the old bitmpadata
			_bmdOld.draw(_src, _matrix);
			
			// using the bitmapdata method getColorBoundsRect command we can get the rectangle bounds of
			// a certain colour we are after tracking, in this instance its the white from the threashold
			var bounds:Rectangle	= _bmdNew.getColorBoundsRect(0xFFFFFFFF, 0xFFFFFFFF, true);
			
			// update the position of the general movement, do this by centering it around the
			// middle of the bounds rectangle
			var x:Number	= bounds.x + bounds.width*.5;
			var y:Number	= bounds.y + bounds.height*.5;
			
			// check for zero values, if we get some then dont update the position
			if (x > 0 && y > 0)
			{
				_pos.x = x;
				_pos.y = y;
			}
		}
		
		// setup matrix to flip the source video so that what we track is relative to
		// the users movement to the screen
		private function setupFlipMatrix():void
		{
			_matrix = new Matrix();				// new matrix
			_matrix.translate(-_src.width, 0);		// move left by the width of the source video
			_matrix.scale(-1, 1);					// flip the scaleX
		}
		
		// return a copy of the position point
		public function get pos():Point		{ return _pos.clone(); }
	}
}