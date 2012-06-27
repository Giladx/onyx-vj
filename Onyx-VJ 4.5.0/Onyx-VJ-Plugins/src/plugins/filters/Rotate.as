package plugins.filters {
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class Rotate extends Filter implements IBitmapFilter {
		
		private var rot:Number				= 0;
		public var rotate:Boolean			= true;
		public var rotspeed:Number			= 0.007;
		private var _boostSpeed:Number		= 0.0;
		private var previousTime:Number     = 0.0;
		private var _boostDelay:int    	 	= 10;
		
		/**
		 * 	@constructor
		 */
		public function Rotate():void {
			
			parameters.addParameters(
				new ParameterBoolean('rotate', 'rotate'),
				new ParameterNumber('rotspeed', 'rotspd', -1, 1, 0.007, 1000),
				new ParameterInteger('boostDelay', 'boostDelay', 3, 5000, 10, 100),
				new ParameterNumber('boostSpeed', 'boostSpeed', -1, 1, 0.0, 1000)
			);
		}
		
		public function applyFilter(source:BitmapData):void {
			
			var time:int = getTimer();
			var dt:Number = time - previousTime;
			
			if ( dt > boostDelay )
			{
				rot += boostSpeed;
				previousTime = time;
			}
			
			if (rotate) {
				rot += rotspeed;
			}
			content.rotation = rot ;		
		}

		public function get boostSpeed():Number
		{
			return _boostSpeed;
		}

		public function set boostSpeed(value:Number):void
		{
			_boostSpeed = value;
		}

		public function get boostDelay():int
		{
			return _boostDelay;
		}

		public function set boostDelay(value:int):void
		{
			_boostDelay = value;
		}

		
	}
}