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
package ui.file {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.asset.air.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;
	import onyx.utils.*;
	import onyx.utils.file.*;
	import onyx.utils.string.*;
	
	import ui.styles.*;

	/**
	 * 
	 */
	public final class AIRThumbnailState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var db:AIRThumbnailDB;
		
		/**
		 * 	@private
		 */
		private var files:Array;
		
		/**
		 * 	@private
		 */
		private var jobs:Array;
		
		/**
		 * 	@private
		 */
		private var path:File;
		
		/**
		 * 	@private
		 */
		private var current:AssetFile;
		
		/**
		 * 	@private
		 */
		private var startTime:int;
		
		/**
		 * 	@private
		 */
		private const display:OutputDisplay	= new OutputDisplay();
		
		/**
		 * 	@constructor
		 */
		public function AIRThumbnailState(path:String, db:AIRThumbnailDB, jobs:Array):void {
			this.path	= new File(path),
			this.db		= db,
			this.files	= files,
			this.jobs	= jobs;
		}
		
		/**
		 * 
		 */
		override public function initialize():void {
			
			// pause everything else
			Display.pause(true);
			
			// test creating a new display
			display.createLayers(5);
			
			// load next
			_nextQueue();
		}
		
		/**
		 * 	@private
		 */
		private function _nextQueue():void {
			
			current = jobs.shift() as AssetFile;
			
			if (current) {
				
				var layer:LayerImplementor		= display.getLayerAt(0) as LayerImplementor;

				switch (current.extension) {
					case 'mp3':
						display.render(null);
						// do nothing
						handler(null);
						break;
					case 'mix':
					case 'onx':
					case 'xml':
						display.addEventListener(DisplayEvent.MIX_LOADED,	mixHandler);
						display.load(current.path, layer, null)
						break;
						
					default:
						layer.addEventListener(LayerEvent.LAYER_LOADED,		handler);
						layer.load(current.path);

						break;
				}
				
			} else {
					
				// remove
				display.removeEventListener(DisplayEvent.MIX_LOADED, mixHandler);
				
				// write the db
				writeBinaryFile(path.resolvePath('.onyx-cache'), db.bytes);
				
				// terminate
				StateManager.removeState(this);

			}
		}
		
		/**
		 * 	@private
		 */
		private function handler(event:Event = null):void {
			
			if (event) {
				var layer:Layer	= event.currentTarget as Layer;
				layer.removeEventListener(LayerEvent.LAYER_LOADED,		handler);
			}
			
			// wait
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, render);
			
			// save start time
			startTime = getTimer();
			
		}
		
		/**
		 * 	@private
		 */
		private function mixHandler(event:Event):void {
			
			// remove listener, add render
			display.removeEventListener(DisplayEvent.MIX_LOADED, mixHandler);
			display.source.fillRect(DISPLAY_RECT, 0);
			
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, render);
			
			// save start time
			startTime = getTimer();
		}
		
		/**
		 * 	@private
		 */
		private function render(event:Event):void {
			
			if (getTimer() - startTime < 125) {
				return;
			}

			// remove
			DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, render);
			
			// render the display
			try {
				display.render(null);
			} catch (e:Error) {
			}
			
			if (display && display.source) {
				
				var matrix:Matrix			= new Matrix();
				var bmp:BitmapData			= new BitmapData(THUMB_WIDTH, THUMB_HEIGHT, false, 0x2e3943);
				bmp.lock();
				
				matrix.scale(THUMB_WIDTH / display.source.width, THUMB_HEIGHT / display.source.height);
	
				// draw the item
				bmp.draw(display.source, matrix, null, null, null, true);
				
				// add the file
				db.addFile(current.name, bmp);
				
				// set data
				current.thumbnail.bitmapData = bmp;
			}

			// kill layers
			for each (var layer:LayerImplementor in display.layers) {
				layer.dispose();
			}
			
			// do next
			_nextQueue();
		}
		
		/**
		 * 
		 */
		override public function terminate():void {
			
			// pause everything else
			Display.pause(false);
			
			// dispose
			display.dispose();
		}
	}
}