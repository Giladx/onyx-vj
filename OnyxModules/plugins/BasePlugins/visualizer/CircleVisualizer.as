package visualizer {
	
	import flash.display.*;
	
	import onyx.constants.*;
	import onyx.controls.ControlInt;
	import onyx.core.*;
	import onyx.plugin.*;

	public final class CircleVisualizer extends Visualizer {
		
		public var height:int		= 200;
		private var _shape:Shape	= new Shape();
		
		public function CircleVisualizer():void {
			super(
				new ControlInt('height', 'height', 100, 300, height)
			)
		}
		
		/**
		 * 	Render
		 */
		override public function render():RenderTransform {
			
			var transform:RenderTransform	= RenderTransform.getTransform(_shape);
			var step:Number					= BITMAP_WIDTH / 127;
			var graphics:Graphics			= _shape.graphics;
			
			graphics.clear();
			
			var analysis:Array = SpectrumAnalyzer.getSpectrum(true);
			
			for (var count:int = 0; count < analysis.length; count++) {
				var value:Number	= analysis[count];
				var color:uint		= 0xFFFFFF * value;
				graphics.beginFill(color);
				graphics.drawCircle(count * 2.5, 120, value * 100);
				graphics.endFill();
			}

			return transform;
		}
		
		override public function dispose():void {
			_shape = null;
		}
	}
}