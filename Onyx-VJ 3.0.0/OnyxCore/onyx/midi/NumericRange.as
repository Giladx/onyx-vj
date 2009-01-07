package onyx.midi {
	
	import onyx.controls.ControlRange;
	
	internal final class NumericRange implements IMidiControlBehavior {
		
		/**
		 * 	@private
		 */
		private var control:ControlRange;
		
		/**
		 * 
		 */
		public function NumericRange(control:ControlRange):void {
			this.control = control;			
		}
		
		/**
		 * 
		 */
		public function setValue(value:int):void {
			var data:Array	= control.data;
			
			control.value = data[int((value / 127) * (data.length - 1))];
		}
	}
}