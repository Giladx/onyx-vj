package plugins.visualizer {
	
	import flash.display.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class Lines3DVisualizer extends Visualizer {
		
		public var height:int		= 200;
		private var shape:Shape	= new Shape();
		private var customParameters:Parameters;
		
		public function Lines3DVisualizer():void 
		{
			// create base parameters
			customParameters = new Parameters(this);
			customParameters.addParameters(
				new ParameterInteger('height', 'height', 100, 300, height)
			);
			Console.output('Lines3DVisualizer version 0.0.2');
		}
		
		override public function render(info:RenderInfo):void {
			
			var step:Number					= DISPLAY_WIDTH / 127;
			var graphics:Graphics			= shape.graphics;
			
			graphics.clear();
			graphics.lineStyle(0, 0xFFFFFF);
			
			var analysis:Array				= SpectrumAnalyzer.getSpectrum(false);
			graphics.moveTo(0,100 + (analysis[0] * height));
			
			var len:int = analysis.length;
			
			for (var count:int = 1; count < len; count++) {
				graphics.lineTo(count * step, 100 + (analysis[count] * height));
			}
			
			info.render(shape);
		}
		
		override public function dispose():void {
			shape = null;
		}
	}
}