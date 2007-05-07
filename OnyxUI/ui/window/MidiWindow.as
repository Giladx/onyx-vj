package ui.window {
	
	/**
	 * 	Midi Window -- for midi learn etc
	 */
	public final class MidiWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var _midiButton:TextButton;

		/**
		 *  @private
		 */
		private var _midiListen:DropDown;
		
		/**
		 * 	@constructor
		 */
		public function MidiWindow():void {
			

			// midi constrols
			_midiButton				= new TextButton(options, 'midi learn');
			_midiListen				= new DropDown(options, MIDI.controls.getControl('listen'));
			
		}
	}
}