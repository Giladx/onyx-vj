package effects {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.events.TempoEvent;
	import onyx.plugin.TempoFilter;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	import onyx.utils.math.*;

	public final class MoverScaler extends TempoFilter {
		
		public var mindelay:Number	= .4;
		public var maxdelay:Number	= 1;
		public var scaleMin:Number	= 1;
		public var scaleMax:Number	= 1.8;
		
		public function MoverScaler():void {

			super(
				true,
				null,
				new ControlNumber('mindelay',	'Min Delay', .1, 50, .4),
				new ControlNumber('maxdelay',	'Min Delay', .1, 50, 1),
				new ControlNumber('scaleMin', 'scale min', 1, 4, 1),
				new ControlNumber('scaleMax', 'scale max', 1, 4, 1.8)
			);
			
		}
		
		/**
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			
			if (event is TimerEvent) {
				delay = (((maxdelay - mindelay) * random()) + mindelay) * 1000;
			}
			
			var scale:Number	= ((scaleMax - scaleMin) * random()) + scaleMin;
			var ratio:Number	= (scale - 1);
			var x:int			= ratio * (-BITMAP_WIDTH) * random();
			var y:int			= ratio * (-BITMAP_HEIGHT) * random();
			
			new Tween(
				content, 
				max(delay * random(), 32),
				new TweenProperty('x', content.x, x),
				new TweenProperty('y', content.y, y),
				new TweenProperty('scaleX', content.scaleX, scale),
				new TweenProperty('scaleY', content.scaleY, scale)
			);
			
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			super.dispose();
		}
	}
}