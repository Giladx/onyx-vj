/**
 * 25-Line ActionScript Contest Entry
 *
 * Project: Fire
 * Author:  Bruce Jawn   (http://bruce-lab.blogspot.com/)
 * Date:    2009-1-10
 */
package
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class LayerWater extends Patch
	{
		private var mx:Number = 0;
		private var my:Number = 0;
		private var Result:BitmapData;
		private var Buffer:BitmapData;
		private var Burning:BitmapData;
		private var Sourcemap:BitmapData;
		private var canvas:BitmapData;
		private var fire:Sprite;
		private var cnt:int = 0;
		private var points:Array;
		
		public function LayerWater():void
		{
			Console.output('LayerWater');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterLayer('layer', 'layer')
			);			
			Result = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 128);
			Buffer = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 128);
			this.addChild(new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 128)));
			Burning = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x0);
			points = [new Point(0, 0), new Point(0, 0), new Point(0, 0), new Point((Math.random() * 2 - 1) / 3, Math.random() * 3 + 2), new Point(Math.random() * 2 - 1, Math.random() * 6 + 2), new Point(Math.random() * 2 - 1, Math.random() * 6 + 2)];
			fire = new Sprite();
			fire.graphics.beginGradientFill(GradientType.LINEAR, [0, 0xA20000, 0xFFF122, 0xFFFFFF, 0xF8FF1B, 0xC53C05, 0x000000], [0, 1, 1, 1, 1, 1, 1], [0, 64, 132, 186, 220, 250, 255], new Matrix(1.8686010037572895e-17, 0.1556396484375, -0.30517578125, 9.529865119162177e-18, 250, 127.5), SpreadMethod.PAD);
			fire.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x0);
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			addEventListener( MouseEvent.CLICK, mouseMove);
		} 
		/**
		 * 	@private
		 * 	If multiple layers are listening to the same layer, combine the stored frames
		 */
		private static const LAYER_COMBINED:Object	= {};
		
		/**
		 * 	@private
		 */
		private static function register(layer:Layer, patch:LayerWater, addReference:Boolean):Array {
			
			var listener:LayerListener	= LAYER_COMBINED[layer];
			if (!listener) {
				listener = LAYER_COMBINED[layer] = new LayerListener(layer);
			}
			
			if (addReference) {
				listener.addPatch(patch);
			} else {
				listener.removePatch(patch);
			}
			
			return listener.frames;
		}
		
		/**
		 * 	@private
		 */
		private var _layer:Layer;
		
		/**
		 * 	
		 */
		public var delay:int		= 0;
		
		/**
		 * 	@private
		 */
		private var frames:Array;
		
		/**
		 * 
		 */
		public function set layer(value:Layer):void {
			
			if (_layer && value !== _layer) {
				register(_layer, this, false);
			}
			
			frames = register(_layer = value, this, true);
		}
		
		/**
		 * 
		 */
		public function get layer():Layer {
			return _layer;
		}

		override public function dispose():void 
		{
			register(_layer, this, false);
		}
		override public function render(info:RenderInfo):void 
		{
			if ( _layer && frames && frames[delay] ) 
			{

				if ( frames[delay] is IBitmapDrawable )
				{
					Sourcemap = frames[delay];
					Sourcemap.lock();
					canvas.draw(fire);
					//Sourcemap = Result.clone();
					if (++cnt % 10 == 1)
					{
						Sourcemap.fillRect(new Rectangle(Math.random() * DISPLAY_WIDTH, Math.random() * DISPLAY_HEIGHT, 6, 6), 255);
					}
					Result.applyFilter(Sourcemap, Result.rect, new Point(), new ConvolutionFilter(3, 3, [1, 1, 1, 1, 1, 1, 1, 1, 1], 9, 0));
					Result.draw(Result, new Matrix(), null, "add");
					//Result.draw(Buffer, new Matrix(), null, "difference");
					Result.draw(Result, new Matrix(), new ColorTransform(0, 0, 0.9960937, 1, 0, 0, 2, 0));
					Result.merge(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 128), Result.rect, new Point(), 0, 0, 1, 0);
					//event.target.getChildAt(0).bitmapData.applyFilter(canvas, Result.rect, new Point(), new DisplacementMapFilter(Result, new Point(), 4, 4, 32, 32));
					Buffer = Sourcemap;
					for (var i:int = 0; i < 3; i++)
					{
						points[i].offset(points[i + 3].x, points[i + 3].y);
					}
					Burning.perlinNoise(30, 50, 3, 5, false, false, 1, true, [points[0], points[1], points[2]]);
					fire.filters = [new DisplacementMapFilter(Burning, new Point(0, 0), 1, 1, 10, 200, "clamp")];
					Sourcemap.unlock();
					info.source.copyPixels( Sourcemap, DISPLAY_RECT, ONYX_POINT_IDENTITY );
				}
			}
		}
		private function mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
			/*if (Sourcemap is IBitmapDrawable)
			{
				
				Sourcemap.fillRect(new flash.geom.Rectangle(mx - 4, my - 4, 8, 8), 255);
				
			}*/
		}
	} //end of class
} //end of package
import flash.display.BitmapData;
import flash.events.*;

import onyx.events.*;
import onyx.parameter.Parameter;
import onyx.parameter.Parameters;
import onyx.plugin.*;

final class LayerListener {
	
	public const frames:Array		= [];
	
	/**
	 * 	@private
	 */
	private const listeners:Array	= [];
	
	/**
	 * 	@private
	 */
	private var maxDelay:int		= 0;
	
	/**
	 * 	@private
	 */
	private var layer:Layer;
	
	/**
	 * 
	 */
	public function LayerListener(layer:Layer):void {
		this.layer = layer;
	}
	
	/**
	 * 
	 */
	public function addPatch(patch:LayerWater):void {
		
		// add the patch
		listeners.push(patch);
		
		// listen for every render
		layer.addEventListener(LayerEvent.LAYER_RENDER, render);
	}
	
	/**
	 * 	@private
	 */
	private function render(event:Event):void {
		frames.unshift(layer.source.clone());
		
		while (frames.length > maxDelay + 1) {
			var bmp:BitmapData = frames.pop();
			bmp.dispose();
		}
	}
	
	/**
	 * 
	 */
	public function removePatch(patch:LayerWater):void {
		
		listeners.splice(listeners.indexOf(patch), 1);
		
		if (!listeners.length && layer) {
			layer.removeEventListener(LayerEvent.LAYER_RENDER, render);
		}
	}
}
