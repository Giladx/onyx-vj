package onyx.midi {
	import onyx.controls.ControlExecute;
	import onyx.controls.Control;
	
	
	public final class ExecuteBehavior implements IMidiControlBehavior {
		
		/**
		 * 	@private
		 */
		private var control:ControlExecute;
		
		/**
		 * 
		 */
		public function ExecuteBehavior(control:ControlExecute):void {
			this.control = control;
		}
		
		public function setValue(value:int):void {
			control.execute();
		}
	}
}