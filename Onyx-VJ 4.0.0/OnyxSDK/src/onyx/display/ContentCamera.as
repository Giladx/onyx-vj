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
package onyx.display {
	
	import flash.media.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class ContentCamera extends ContentBase {
		
		/**
		 * 	@private
		 */
		private static const MODES:Object	= {
			DEFAULT: new CameraMode(320, 240, 24)
		};
		
		/**
		 * 
		 */
		public static function toXML():XML {
			var xml:XML	= <cameras />;
			for (var i:String in MODES) {
				var mode:CameraMode = MODES[i];
				xml.appendChild(
					<camera>
						<name>{i}</name>
						<width>{mode.width}</width>
						<height>{mode.height}</height>
						<fps>{mode.fps}</fps>
					</camera>
				)
			}
			return xml;
		}
		
		/**
		 * 
		 */
		public static function loadXML(xml:XML):void {
			for each (var node:XML in xml.camera) {
				var name:String		= node.name;
				var mode:CameraMode = MODES[name];
				if (mode) {
					mode.width		= node.width;
					mode.height		= node.height;
					mode.fps		= node.fps;
				} else {
					MODES[name]		= new CameraMode(node.width, node.height, node.fps); 
				}
			}
		}
		
		/**
		 * 	@private
		 * 	The video to attach the camera to
		 */
		private var _video:Video;
		
		/**
		 * 	@private
		 * 	The number of frames to save
		 */
		public var save:int				= 0;
		
		/**
		 * 	@private
		 * 	The frames we've saved
		 */
		private var _frames:Array		= [];
		
		/**
		 * 	@private
		 */
		private var _currentFrame:int	= 0;
		
		/**
		 * 
		 */
		private var _camera:Camera;
		
		/**
		 * 	@constructor
		 */
		public function ContentCamera(layer:LayerImplementor, path:String, camera:Camera):void {
			
			if (camera) {			

				// create camera
				_camera	= camera;
				
				var mode:CameraMode	= MODES[_camera.name] || MODES.DEFAULT;
				
				_camera.setMode(mode.width, mode.height, mode.fps, false);
				
				_video	= new Video(mode.width, mode.height);
				_video.attachCamera(_camera);
				_video.smoothing	= true;
			}
				
			// continue
			super(layer, path, _video, mode ? mode.width : DISPLAY_WIDTH,  mode ? mode.height : DISPLAY_HEIGHT);
				
		}
		
		/**
		 * 
		 */
		override public function get time():Number {
			return 0;
		}
		
		/**
		 * 
		 */
		override public function set time(value:Number):void {
			// _currentFrame = value * _frames.length;
		}
		
		/**
		 * 
		 */
		override public function set framerate(value:Number):void {
		}
		
		/**
		 * 	Disposes
		 */
		override public function dispose():void {
			
			super.dispose();
			
			if (_video) {
				_video.attachCamera(null);
			}
			_video		= null,
			_camera		= null;
		}
		
	}
}