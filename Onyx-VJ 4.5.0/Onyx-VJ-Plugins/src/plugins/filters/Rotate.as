package plugins.filters {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class Rotate extends Filter implements IBitmapFilter {
		
		private var rot:Number				= 0;
		public var rotate:Boolean			= true;
		public var rotspeed:Number			= 0.007;
		
		/**
		 * 	@constructor
		 */
		public function Rotate():void {
			
			parameters.addParameters(
				new ParameterBoolean('rotate', 'rotate'),
				new ParameterNumber('rotspeed', 'rotspd', -1, 1, 0.007, 1000)
			);
		}
		
		public function applyFilter(source:BitmapData):void {
			
			if (rotate) {
				rot += rotspeed;
			}
			content.rotation = rot ;		
		}
		
	}
}