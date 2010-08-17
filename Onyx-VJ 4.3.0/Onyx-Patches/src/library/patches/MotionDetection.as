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

package library.patches
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	
	import fr.batchass.Circle;
	
	import onyx.plugin.*;
	
	import uk.co.creativewax.VideoTracker;
	
	public class MotionDetection extends Sprite
	{
		private var _camera:Camera;								// camera class for webcam capture
		private var _video:Video;								// video class for displaying the camera class
		private var _tracking:VideoTracker;						// motion tracking class
		
		private var _tracker:Circle	= new Circle( 0x00AAAA,10 );		// tracker pointer for visual position update
		private var _pos:Point			= new Point();			// current position of motion detection
		
		private var _w:uint				= 320;					// width of camera/video source
		private var _h:uint				= 240;					// height of camera/video source
		private var _ratioX:Number;								// ratio of stage width over the video width
		private var _ratioY:Number;								// ratio of stage height over the video height
		
		public function MotionDetection()
		{
			// setup
			setup();
			resize();
			
			// loop
			addEventListener(Event.ENTER_FRAME, loop);
			
			// add VideoTracker class to the screen to visually see the movement in the video
			addChild(_tracking);
			
			// add tracker to the screen if you want to visually see
			// where the position of the motion tracking is
			addChild(_tracker);
		}
		
		// main setup
		private function setup():void
		{
			// setup camera
			_camera	= Camera.getCamera();
			_camera.setMode(_w, _h, 15);
			
			// setup video and attach the camera
			_video	= new Video(_w, _h);
			_video.attachCamera(_camera);
			
			// setup the tracking class with the video as the source
			_tracking	= new VideoTracker(_video);
		}
		
		// update motion detection and render all elements
		private function loop(e:Event):void
		{
			// update tracking
			_tracking.track();
			
			_pos	= _tracking.pos;	// update current position
			_pos.x	*= _ratioX;			// update the positions by the ratio we have set
			_pos.y	*= _ratioY;
			
			// update tracker
			_tracker.x	+= (_pos.x - _tracker.x) * .1;
		}
		
		// resize and reflow elements when the stage resizes
		private function resize(e:Event=null):void
		{
			_ratioX		= DISPLAY_WIDTH/_w;	// update x / y ratios
			_ratioY		= DISPLAY_HEIGHT/_h;
			_tracker.y	= DISPLAY_HEIGHT*.5;	// update tracker y position
		}
		
	}
}