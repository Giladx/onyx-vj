package visualizer {
	
	import flash.display.*;
	
	import onyx.constants.*;
	import onyx.controls.ControlInt;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;

	public final class BasicVisualizer extends Visualizer {
		
		public var height:int		= 200;
		private var _shape:Shape	= new Shape();
		
		public function BasicVisualizer():void {
			super(
				new ControlInt('height', 'height', 100, 300, height)
			)
		}
		
		override public function render():RenderTransform {
			
			var transform:RenderTransform	= RenderTransform.getTransform(_shape);
			var step:Number					= BITMAP_WIDTH / 127;
			var graphics:Graphics			= _shape.graphics;
			
			graphics.clear();
			graphics.lineStyle(0, 0xFFFFFF);
			
			var analysis:Array = SpectrumAnalyzer.getSpectrum(false);
			graphics.moveTo(0,100 + (analysis[0] * height));

			var len:int = analysis.length;

			for (var count:int = 1; count < len; count++) {
				graphics.lineTo(count * step, 100 + (analysis[count] * height));
			}
			
			return transform;
		}
		
		override public function dispose():void {
			_shape = null;
		}
	}
}