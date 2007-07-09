package renderer {
	
	import flash.display.*;
	import flash.geom.Matrix;
	
	import onyx.constants.*;
	import onyx.display.*;
	import onyx.plugin.Renderer;
	import onyx.utils.math.*;
	
	/**
	 * 
	 */
	public final class ScrollRender extends Renderer {
		
		/**
		 * 
		 */
		override public function initialize():void {
			
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
		}
		
		/**
		 * 	Renders the Display
		 */
		override public function render(source:BitmapData, layers:Array):void {
			
			var length:int = layers.length - 1;
			var matrix:Matrix	= new Matrix();

			// loop through layers and render			
			for (var count:int = length; count >= 0; count--) {

				matrix.tx = random() * BITMAP_WIDTH;
				matrix.ty = random() * BITMAP_HEIGHT;

				var layer:ILayer	= layers[count];

				// render the layer
				layer.render();

				if (layer.visible && layer.rendered) {
					
					source.draw(layer.rendered, matrix, null, layer.blendMode);
					
				}
			}
			
		}
	}
}