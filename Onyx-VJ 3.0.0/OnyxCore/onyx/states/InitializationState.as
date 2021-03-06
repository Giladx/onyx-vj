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
package onyx.states {

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.file.*;
	import onyx.file.filters.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;

	/**
	 * 	State that loads external plugins and registers them
	 */	
	public final class InitializationState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var path:String;
		
		/**
		 * 	@private
		 */
		private var _filtersToLoad:Array	= [];

		/**
		 * 	@private
		 */
		private var _timer:Timer;
		
		/**
		 * 
		 */
		public function InitializationState(path:String):void {
			this.path = path;
			super();
		}
		
		/**
		 * 	Initializes
		 */
		override public function initialize():void {
			
			// dispatch a start event
			Onyx.instance.dispatchEvent(new ApplicationEvent(ApplicationEvent.ONYX_STARTUP_START));
			
			// output to console
			Console.output('LOADING PLUG-INS: ' + path + '... \n');
			
			// query directory
			File.query(
				path,
				_loadExternalPlugins,
				new PluginFilter()
			);
		}
		
		/**
		 * 	@private
		 * 	Initializes the external filter loading
		 */
		private function _loadExternalPlugins(list:FolderList):void {
			
			// if there are plugins to load ...
			if (list) {
				
				for each (var file:File in list.files) {
					
					var swfloader:Loader	= new Loader();
					var info:LoaderInfo		= swfloader.contentLoaderInfo;
					info.addEventListener(Event.COMPLETE,						_onFilterLoaded);
					info.addEventListener(IOErrorEvent.IO_ERROR,				_onFilterLoaded);
					info.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onFilterLoaded);
					
					swfloader.load(new URLRequest(file.path));

					_filtersToLoad.push(swfloader.loaderInfo);
					
					Console.output('LOADING ' + String(file.path).toUpperCase());
				}
			
			// otherwise start initializing
			} else {
				
				_initialize();
				
			}
		}
		
		/**
		 * 	@private
		 * 	When a filter is loaded
		 */
		private function _onFilterLoaded(event:Event):void {
			
			var info:LoaderInfo = event.currentTarget as LoaderInfo;

			// clear references
			info.removeEventListener(Event.COMPLETE,					_onFilterLoaded);
			info.removeEventListener(IOErrorEvent.IO_ERROR,				_onFilterLoaded);
			info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onFilterLoaded);
			
			// remove the loader
			_filtersToLoad.splice(_filtersToLoad.indexOf(info), 1);

			// if valid swf
			if (event is ErrorEvent) {
				Console.output((event as ErrorEvent).text);
			} else {
				
				var loader:IPluginLoader = info.content as IPluginLoader;
				
				if (loader) {
					
					var plugins:Array = loader.plugins;
				
					for each (var plugin:Object in plugins) {
						Onyx.registerPlugin(plugin);
					}
				}
			}
			
			// no more filters to load
			if (_filtersToLoad.length === 0) {
				_initialize();
			}
		}
		
		/**
		 * 	@private
		 * 	Begin initialization timer
		 */
		private function _initialize():void {
			
			Console.output('INITIALIZING ...');
			
			// sort plugins
			var field:String = 'name';
			Filter._filters.sortOn(field);
			Transition._transitions.sortOn(field);
			Macro._macros.sortOn(field);
			Visualizer._visualizers.sortOn(field);

			// pause for a bit
			_timer = new Timer(1500);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _endState);
		}
		
		/**
		 * 	@private
		 * 	Ends the timer
		 */
		private function _endState(event:TimerEvent):void {
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _endState);
			_timer = null;
			
			// end the state
			StateManager.removeState(this);
		}
		
		/**
		 * 	Terminates the state
		 */
		override public function terminate():void {

			_filtersToLoad = null;

			// we're done initializing
			Onyx.instance.dispatchEvent(new ApplicationEvent(ApplicationEvent.ONYX_STARTUP_END));

		}
	}
}