package onyx.core {
	
	public final class EasingType {
		
		/**
		 * 
		 */
		public var name:String;
		
		/**
		 * 
		 */
		public var fn:Function;
		
		/**
		 * 	@constructor
		 */
		public function EasingType(name:String, fn:Function) {
			this.name = name,
			this.fn = fn;
		}
		
	}
}