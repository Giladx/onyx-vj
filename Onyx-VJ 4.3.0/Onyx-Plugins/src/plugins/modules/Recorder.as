package plugins.modules {
	
	import flash.events.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class Recorder extends Module {
		
		/**
		 * 	@private
		 */
		private const frames:Array		= [];
		
		/**
		 * 	@private
		 */
		private var recording:Boolean		= false;
		
		/**
		 * 
		 */
		public var maxframes:int		= 600;
		
		/**
		 * 	@constructor
		 */
		public function Recorder():void {
			
			// init ui
			super(new ModuleInterfaceOptions(null, 145, 100));
			
			// add parameters
			parameters.addParameters(
				new ParameterInteger('maxframes', 'max frames', 24, 600, maxframes),
				new ParameterBoolean('record', 'record'),
				new ParameterStatus('status', 'status')
			);
			
		}
		
		/**
		 * 
		 */
		public function set record(value:Boolean):void {
			
			this.recording	= value;
			
			// pause?
			Display.pause(!value);
			
			// if it's recording
			if (value) {
				
				// clear all frames
				frames.splice(0, frames.length);
				
				// add listener
				Display.addEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);
				
			} else {
				
				// remove listener
				Display.removeEventListener(DisplayEvent.DISPLAY_RENDER, saveFrame);
				
				// build bytes
				var file:ONRFile		= new ONRFile();
				file.setFrames(frames);
				
				// pause states
				Display.pause(true);
				
				// pause keyboard
				StateManager.pauseStates(ApplicationState.KEYBOARD);
				
				// save
				AssetFile.browseForSave(saveHandler, 'Where do you want to save the file to?', file.toByteArray(), 'onr');
				
			}
			
			// 
			parameters.getParameter('status').value = frames.length + ' frames';
			
		}
		
		/**
		 * 	@private
		 */
		private function saveHandler(... args:Array):void {
			
			// resume states
			Display.pause(false);
			
			// resume
			StateManager.resumeStates(ApplicationState.KEYBOARD);
			
		}
		
		/**
		 * 
		 */
		public function get record():Boolean {
			return recording;
		}
		
		/**
		 * 	@private
		 */
		private function saveFrame(event:Event):void {
			
			// save the frame
			frames.push(Display.source.clone());
			
			// update frames
			parameters.getParameter('status').value = frames.length + ' frames';
			
			if (frames.length >= maxframes) {
				record = false;
			}
			
		}
	}
}