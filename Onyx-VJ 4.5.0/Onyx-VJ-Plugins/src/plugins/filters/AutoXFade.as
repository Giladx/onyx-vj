package plugins.filters {
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.Tween;
	import onyx.tween.TweenProperty;
	
	/**
	 * 
	 */
	public final class AutoXFade extends Filter implements IBitmapFilter {
		

		/**
		 * 	@private
		 */
		private var _delay:int					= 500;
		
		/**
		 * 	@constructor
		 */
		public function AutoXFade():void {
			
			parameters.addParameters(
				new ParameterInteger('delay', 'delay', 1, 5000, 500),
				new ParameterExecuteFunction('xFade','xFade')
			);
			
		}
		public function xFade():void {
			const property:TweenProperty = (Display.channelMix > .5) ? new TweenProperty('channelMix', Display.channelMix, 0) : new TweenProperty('channelMix', Display.channelMix, 1);					
			new Tween( Display, delay, property );
		}
		
		public function set delay(value:int):void {
			_delay = value;
			
		}
		
		public function get delay():int {
			return _delay;
		}
		
		
		public function applyFilter(source:BitmapData):void {
			
			
			
		}
		

		
		/**
		 * 
		 */
		override public function dispose():void {
			
		}
	}
}
