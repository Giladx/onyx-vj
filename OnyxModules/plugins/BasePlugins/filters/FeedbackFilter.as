package filters {
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import onyx.controls.*;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	import onyx.tween.Tween;
	import onyx.tween.easing.*;
	import onyx.tween.TweenProperty;
	
	public final class FeedbackFilter extends Filter implements IBitmapFilter {
		
		public var scale:Number = .99;
		
		public function FeedbackFilter():void {
			super(
				false,
				new ControlNumber('scale',	'scale', .01, 2, .99)
			)
		}
		
		override public function initialize():void {
			new Tween(content, 1000, new TweenProperty('alpha', 0, 1, Sine.easeIn));
		}
		
		public function applyFilter(source:BitmapData, bounds:Rectangle):void {
		}
	}
}