/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
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
package onyx.jobs {

	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.jobs.onx.LayerLoadSettings;
	import onyx.plugin.*;
	
	public final class LoadONXJob extends Job implements IDisposable {
		
		/**
		 * 	@private
		 * 	The beginning layer to start loading on
		 */
		private var _origin:ILayer
		
		/**
		 * 	@private
		 * 	The transition to load in
		 */
		private var _transition:Transition;
		
		/**
		 * 	@constructor
		 */
		public function LoadONXJob(layer:ILayer, transition:Transition):void {
			
			_origin = layer;
			_transition = transition;
			
		}
		
		/**
		 * 	
		 */
		override public function initialize(...args):void {
			var path:String = args[0];
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,						_onURLHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onURLHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,				_onURLHandler);
			urlLoader.load(new URLRequest(path));
		}
		
		/**
		 * 	@private
		 */
		private function _onURLHandler(event:Event):void {
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE,						_onURLHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onURLHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,				_onURLHandler);
			
			// error
			if (event is ErrorEvent) {
				
				Console.error(new Error((event as ErrorEvent).text));
				
			// success
			} else {
				
				try {
					
					var xml:XML				= new XML(loader.data);
					
					var display:IDisplay	= _origin.display;
					var layers:Array		= display.layers;
					var index:int			= layers.indexOf(_origin);
					var jobs:Array			= [];
					
					// load xml
					display.loadXML(xml.display);
					
					// loop through layers and apply settings
					for each (var layerXML:XML in xml.display.layers.*) {
						
						var layer:ILayer				= layers[index++];
						
						// valid layer, load it
						if (layer) {
							
							var settings:LayerSettings	= new LayerSettings();
							settings.loadFromXML(layerXML);
							
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
					_loadStagger(jobs);
				} else {
					_loadImmediately(jobs);
				}

				
			}
		}
		
		/**
		 * 
		 */
		private function _loadImmediately(jobs:Array):void {
			
			for each (var job:LayerLoadSettings in jobs) {
				
				var layer:ILayer			= job.layer;
				var settings:LayerSettings	= job.settings;
	
				layer.load(settings.path, settings);

			}
			
			dispose();
		}
		
		/**
		 * 
		 */
		private function _loadStagger(jobs:Array):void {
			
			new StaggerONXJob(_transition, jobs);
			dispose();
		}
		
		/**
		 * 	Dispose
		 */
		public function dispose():void {
			_origin		= null,
			_transition	= null;
		}
	}
}