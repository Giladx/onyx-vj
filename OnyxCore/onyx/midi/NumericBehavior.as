package onyx.midi {
	
	import onyx.controls.ControlNumber;
	
	internal final class NumericBehavior implements IMidiControlBehavior {
		
		/**
		 * 	@private
		 */
		private var control:ControlNumber;
		
		/**
		 * 
		 */
		public function NumericBehavior(control:ControlNumber):void {
			this.control = control;
		}
		
		/**
		 * 
		 */
		public function setValue(value:int):void {
			control.value = (control.max - control.min) * (value / 127) + control.min; 
		}
		
	}
}