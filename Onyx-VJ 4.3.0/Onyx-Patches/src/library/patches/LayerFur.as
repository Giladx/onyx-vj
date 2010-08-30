package library.patches
{
	import flash.display.*;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * @author nicoptere
	 */
	public class LayerFur extends Patch
	{
		public var rootVector:Vector2;
		public var destination:Vector2;
		
		private var nodes:Vector.<Number>;
		
		static public var density:uint = 1;
		static public var scaleFactor:uint = 1;
		public var segments:int = 5;
		public var size:Number = 1;
		//public var alpha:Number = 1;
		public var length:Number = 10;
		public var curliness:Number = 0.05; // 0 > f > 1
		public var color:uint = 0x0FF000;
		private var _canvasBD:BitmapData;
		private var _sourceBD:BitmapData;
		
		public function LayerFur()
		{
			Console.output('LayerFur');
			Console.output('Credits to nicoptere (http://en.nicoptere.net/)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterLayer('layer', 'layer')
			);
			_canvasBD = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00000000);
			this.addChild( new Bitmap( _canvasBD ));
			this.rootVector = new Vector2();
			this.destination = this.rootVector.clone();
			
		}
		
		public function process():void
		{
			
			nodes = new Vector.<Number>();
			var angle:Number;
			if ( rootVector.x == destination.x && rootVector.y == destination.y )
			{
				angle = Math.PI * 2 * Math.random();
			}else 
			{
				angle = Math.atan2( destination.y - rootVector.y, destination.x - rootVector.x );
			}
			
			var length:Number = length / segments;
			
			nodes.push( rootVector.x, rootVector.y );
			
			var i:int;
			for ( i = 0; i < segments; i++ )
			{
				
				rootVector.x += Math.cos( angle ) * length;
				rootVector.y += Math.sin( angle ) * length;
				angle += ( Math.PI * 2 * curliness ) * ( Math.random() - .5 );
				nodes.push( rootVector.x, rootVector.y );
				
			}
		}
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			if (_layer && frames)
			{
				if (_sourceBD)
				{
					_sourceBD = frames[delay];
					if (_canvasBD) 
					{
						//_canvasBD.lock();
						process();
						if ( nodes.length <= 0 )return;
						
						var tot:int = nodes.length;
						var i:int = 0;
						var t:Number;
						
						var shape:Shape = new Shape();

						shape.graphics.moveTo( nodes[ 0 ], nodes[ 1 ] );
						for ( i = 0; i < tot; i+=2 )
						{	
							
							t = (1 - (i / tot ));
							//shape.graphics.lineStyle( size * t, color, alpha * t );
							shape.graphics.lineStyle( size * t, _sourceBD.getPixel(i, 12), alpha * t );
							shape.graphics.lineTo(  nodes[ i ],  nodes[ i + 1 ] );
							
						}
						_canvasBD.draw(shape);

						
						//_canvasBD.unlock();
						//bitmapData.draw( shape, new Matrix( 1, 0, 0, 1, DISPLAY_WIDTH >> 1, DISPLAY_HEIGHT >> 1 ) );
						info.source.copyPixels(_canvasBD, DISPLAY_RECT, ONYX_POINT_IDENTITY);
						//info.render( _canvasBD);
					}
				}
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
		private static function register(layer:Layer, patch:LayerFur, addReference:Boolean):Array {
			
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
		
	}
}
import flash.display.BitmapData;
import flash.events.Event;

import library.patches.LayerFur;

import onyx.events.LayerEvent;
import onyx.plugin.Layer;

class Vector2
{
	public var x:Number;
	public var y:Number;
	public function Vector2( x:Number = 0, y:Number = 0 )
	{
		this.x = x;
		this.y = y;
	}
	public function clone():Vector2
	{
		return new Vector2( x, y );
	}
}
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
	public function addPatch(patch:LayerFur):void {
		
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
	public function removePatch(patch:LayerFur):void {
		
		listeners.splice(listeners.indexOf(patch), 1);
		
		if (!listeners.length && layer) {
			layer.removeEventListener(LayerEvent.LAYER_RENDER, render);
		}
	}
}
