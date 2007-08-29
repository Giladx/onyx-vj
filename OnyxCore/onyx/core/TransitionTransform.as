package onyx.core {
	
	import onyx.plugin.Transition;
	import onyx.content.IContent;
	
	/**
	 * 	This is a class that allows for the crossfader to use any transition
	 * 
	 * 	@see onyx.plugin.Transition
	 */
	public final class TransitionTransform extends Object {
		
		/**
		 * 	Transition
		 */
		public var transition:Transition;
		
		/**
		 * 	Ratio
		 */
		public var ratio:Number;
		
		/**
		 * 	@constructor
		 */
		public function TransitionTransform(transition:Transition, ratio:Number):void {
			this.transition = transition,
			this.ratio		= ratio;
		}
	}
}