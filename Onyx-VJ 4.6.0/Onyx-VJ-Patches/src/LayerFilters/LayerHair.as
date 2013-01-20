// Translated and modified by Lucas Swick from Don Relyea's Open Frameworks Hair Particle Drawing Project:
// http://www.donrelyea.com/hair_particle_drawing_OF.htm
// www.donrelyea.com
// July 22 2008

package LayerFilters
{
	
	// Import Adobe classes.
	import com.donrelyea.HairParticle;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * Description goes here.
	 * @class			Hair
	 * @author			
	 * @date			25.11.2008
	 * @version			0.1
	 **/
	public class LayerHair extends Patch {
		
		public static const CLASS_NAME:String = "Hair";
		
		private var _radius:int = 3;
		
		private var _hairs:Array;
		private var _canvasBD:BitmapData;
		private var _count:uint;
		private var _angle:uint;
		
		private var _sourceBD:BitmapData;
		
		/**
		 * Constructor.
		 **/
		public function LayerHair() {
			Console.output('LayerHair');
			Console.output('Credits to Don RELYEA (http://www.donrelyea.com)');
			Console.output('AS3 translation by Lucas SWICK');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterInteger('radius', 'radius', 1, 30, _radius),
				new ParameterExecuteFunction('start', 'start')
			);
			init();
		}
		
		// INITIALIZATION ============================================================================================================
		private function init():void 
		{
			_hairs = [];
			_count = 250;
			_angle = 0;
			
			_canvasBD = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00000000);
			this.addChild( new Bitmap( _canvasBD ));
			
		}

		
		// ACTIONS ===================================================================================================================
				
		/**
		 * generate.
		 * @description	
		 **/
		private function generate(particle:HairParticle) : void 
		{
			if ( _sourceBD )
			{				
				var x:Number = Math.random() * _sourceBD.width;
				var y:Number = Math.random() * _sourceBD.height;
				
				var color:uint = _sourceBD.getPixel(x, y);
				_angle += .2;
				
				particle.activate( Math.random() * 255, Math.random() * _radius, x, y, color, _angle );			
				//particle.activate( Math.random() * 255, Math.random() * 1, x, y, color, _angle );			
			}
		}
		/**
		 * 	
		 */
		public function start():void 
		{
			if (_layer && frames)
			{
				if ( _sourceBD )
				{
					_sourceBD = null;
	
				}
				if ( !_sourceBD )
				{
					_sourceBD = createDefaultBitmap();
					_sourceBD = frames[delay];
				} 
	
				var circle:Sprite = new Circ( _radius );
				
				var i:int;
				for (i = 0; i < _count; i++) {
					var particle:HairParticle = new HairParticle(circle);
					
					generate(particle);
					_hairs.push( particle );
				}
			}
		}
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			if (_layer && frames)
			{
				/*if (_sourceBD)
				{*/
					_sourceBD = frames[delay];
					if (_canvasBD) 
					{
						_canvasBD.lock();
						for each (var particle:HairParticle in _hairs) 
						{
							if (particle.active) 
							{
								particle.draw(_canvasBD);
							} 
							else 
							{
								generate(particle);	
							}
							
						}
						_canvasBD.unlock();
						info.render( _canvasBD);
					}
				//}
			}
		}
		/**
		 * 	@private
		 * 	If multiple layers are listening to the same layer, combine the stored frames
		 */
		private static const LAYER_COMBINED:Object	= {};
		
		/**
		 * 	@private
		 */
		private static function register(layer:Layer, patch:LayerHair, addReference:Boolean):Array {
			
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
		
		override public function dispose():void {
			register(_layer, this, false);
		}				

		public function get radius():int
		{
			return _radius;
		}

		public function set radius(value:int):void
		{
			_radius = value;
		}

	}
}

import flash.display.Sprite;

class Circ extends Sprite
{
	public var realx:int;
	public var realy:int;
	public function Circ( radius:int ):void
	{
		graphics.beginFill( 0xFF4499 );
		graphics.drawCircle( 0, 0, radius );
		graphics.endFill();
	}
}
import onyx.events.*;
import flash.display.BitmapData;
import onyx.parameter.Parameter;
import onyx.parameter.Parameters;
import onyx.plugin.*;

import flash.events.Event;
import LayerFilters.LayerHair;

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
	public function addPatch(patch:LayerHair):void {
		
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
	public function removePatch(patch:LayerHair):void {
		
		listeners.splice(listeners.indexOf(patch), 1);
		
		if (!listeners.length && layer) {
			layer.removeEventListener(LayerEvent.LAYER_RENDER, render);
		}
	}
}
