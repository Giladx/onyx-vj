package visualizer {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.render.RenderTransform;
	import onyx.sound.SpectrumAnalysis;
	import onyx.sound.SpectrumAnalyzer;
	import onyx.sound.Visualizer;
	import onyx.controls.ControlInt;
	import flash.display.Graphics;

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
			
			var analysis:Array = SpectrumAnalyzer.spectrum.analysis;
			graphics.moveTo(0,100 + (analysis[0] * height));

			for (var count:int = 1; count < analysis.length; count++) {
				graphics.lineTo(count * step, 100 + (analysis[count] * height));
			}
			
			return transform;
		}
		
		override public function dispose():void {
			_shape = null;
		}
	}
}