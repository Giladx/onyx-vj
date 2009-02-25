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
package onyx.jobs {

	[ExcludeSDK]
	
	import flash.events.*;
	import flash.net.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.LayerEvent;
	import onyx.jobs.onx.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class LoadONXJob extends Job {
		
		/**
		 * 	@private
		 * 	The beginning layer to start loading on
		 */
		private var _origin:LayerImplementor;
		
		/**
		 * 	@private
		 * 	The transition to load in
		 */
		private var _transition:Transition;
		
		/**
		 * 	@private
		 */
		private var _display:IDisplay;
		
		/**
		 * 	@private
		 */
		private var layers:Array = [];
		
		/**
		 * 	@constructor
		 */
		public function LoadONXJob(display:IDisplay, layer:LayerImplementor, transition:Transition):void {
			
			_display	= display,
			_origin		= layer,
			_transition = transition;
			
		}
		
		/**
		 * 	
		 */
		override public function initialize(...args):void {
			
			AssetFile.queryFile(args[0], onRead);

		}
		
		/**
		 * 	@private
		 */
		private function onRead(data:String):void {

			try {
				
				const xml:XML				= new XML(data);
				
				const layers:Array		= _display.layers;
				const index:int			= layers.indexOf(_origin);
				const jobs:Array		= [];
				
				// load xml
				_display.loadXML(xml.display);
				
				// loop through layers and apply settings
				for each (var layerXML:XML in xml.display.layers.*) {
					
					var layer:LayerImplementor = (String(layerXML.@index).length > 0) ? layers[int(layerXML.@index)] : layers[index++];
					
					// valid layer, load it
					if (layer) {
						
						var settings:LayerSettings	= new LayerSettings();
						settings.loadFromXML(layerXML[0]);
						
						var job:LayerLoadSettings	= new LayerLoadSettings();
						job.layer					= layer;
						job.settings				= settings;
						
						jobs.push(job);
						
					// break out
					} else {
						break;
					}
				}
				
				// DH: TBD -- load midi stuff into layersettings
				
				// TT:
				// Need to load the MIDI stuff, but after the other stuff gets loaded.
				// This is a hack - there should be some way of calling it
				// exactly when everything about the display is loaded.
				// var _timer:Timer = new Timer(2000,1);
				// _timer.addEventListener(TimerEvent.TIMER, _onTimer);
				//_timer.start();
				
			} catch (e:Error) {
				Console.error(e);
			}

			if (_transition) {
				loadStagger(jobs);
			} else {
				loadImmediately(jobs);
			}

		}
		
		/**
		 * 	@private
		 */
		private function loadImmediately(jobs:Array):void {
			
			for each (var job:LayerLoadSettings in jobs) {
				
				var layer:LayerImplementor	= job.layer;
				var settings:LayerSettings	= job.settings;
	
				layer.addEventListener(LayerEvent.LAYER_LOADED, loadHandler);
				layer.load(settings.path, settings);
				
				// add it to our stack
				layers.push(layer);

			}
		}
		
		/**
		 * 	@private
		 */
		private function loadHandler(event:LayerEvent):void {
			var layer:Layer = event.currentTarget as Layer;
			layer.removeEventListener(LayerEvent.LAYER_LOADED, loadHandler);
			
			var index:int = layers.indexOf(layer);
			if (index >= 0) {
				layers.splice(index, 1);
			}
			
			if (!layers.length) {
				terminate();
			}
		}
		
		/**
		 * 	@private
		 */
		private function loadStagger(jobs:Array):void {
			
			new StaggerONXJob(_transition, jobs);
			
			terminate();
			
		}
		
		/**
		 * 
		 */
		override public function terminate():void {
			
			_origin		= null,
			_transition	= null;
		
			// call chain	
			super.terminate();
		}
	}
}