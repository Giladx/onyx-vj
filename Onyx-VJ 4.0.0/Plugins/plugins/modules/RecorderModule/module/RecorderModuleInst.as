package module {
	
	import flash.events.Event;
	
	import onyx.asset.*;
	import onyx.core.ONRFile;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	public final class RecorderModuleInst extends Module {
		
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
		public function RecorderModuleInst():void {
			
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
				
				// save
				OnyxFile.browseForSave(saveHandler, 'Where do you want to save the file to?', file.toByteArray(), 'onr');
				
			}
			
			// 
			parameters.getParameter('status').value = frames.length + ' frames';
			
		}
		
		/**
		 * 	@private
		 */
		private function saveHandler(... args:Array):void {
			
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