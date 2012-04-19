/**
 * Copyright (c) 2003-2011 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 *  
 * Based on fur code by nicoptere (http://en.nicoptere.net/)
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * version 4.0.503 last modified Nov 27th 2011
 * 
 */
package 
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	
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
		private var _size:int = 10;
		//public var alpha:Number = 1;
		public var length:Number = 10;
		public var curliness:Number = 0.05; // 0 > f > 1
		public var color:uint = 0x0FF000;
		private var _canvasBD:BitmapData;
		private var _canvasBMP:Bitmap;
		private var _drawTimer:Timer;
		private var _sourceBD:BitmapData = createDefaultBitmap();
		private var mx:int = 0;
		private var my:int = 0;
		
		public function LayerFur()
		{
			Console.output('LayerFur v 4.0.503 w h',DISPLAY_WIDTH, DISPLAY_HEIGHT);
			Console.output('Credits to nicoptere (http://en.nicoptere.net/)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterInteger( 'size', 'size', 1, 300, 35 )
			);
			size = _size;
			
			_canvasBD = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00FF00FF);
			_canvasBMP = new Bitmap( _canvasBD, "auto", true );
			addChild( _canvasBMP );
			
			this.rootVector = new Vector2();
			this.destination = this.rootVector.clone();
			_drawTimer = new Timer(1, 0);
			_drawTimer.addEventListener( TimerEvent.TIMER, doDraw );
			addEventListener( MouseEvent.MOUSE_DOWN, startDraw );
			addEventListener( MouseEvent.MOUSE_UP, stopDraw );
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			
		}
		
		public function doDraw(evt:TimerEvent):void
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
			//trace("rootVector.x"+ rootVector.x+ " rootVector.y"+ rootVector.y+ " destination.x"+ destination.x+ " destination.y"+ destination.y);
		}
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			if (_layer && frames)
			{
				_sourceBD = frames[delay];
				if ( _sourceBD is IBitmapDrawable )
				{
					if (_canvasBD) 
					{
						_canvasBD.lock();
						doDraw(null);
						if ( nodes )
						{
							if ( nodes.length <= 0 )return;
							
							var tot:int = nodes.length;
							var i:int = 0;
							var t:Number;
							
							var shape:Shape = new Shape();
							mx += Math.random() * _sourceBD.width/2;
							my += Math.random() * _sourceBD.height/2;
							
							if ( mx > DISPLAY_WIDTH ) mx = 0;
							if ( my < 1 ) my = DISPLAY_HEIGHT;
							
							shape.graphics.moveTo( nodes[ 0 ], nodes[ 1 ] );
							for ( i = 0; i < tot; i+=2 )
							{	
								t = (1 - (i / tot ));
								//shape.graphics.lineStyle( size * t, _sourceBD.getPixel(i, 12), alpha * t );
								shape.graphics.lineStyle( size * t, _sourceBD.getPixel(mx, my), alpha * t );
								shape.graphics.lineTo(  nodes[ i ],  nodes[ i + 1 ] );							
							}
							_canvasBD.draw( shape );
							//_canvasBD.draw(shape, new Matrix( 1, 0, 0, 1, DISPLAY_WIDTH >> 1, DISPLAY_HEIGHT >> 1 ) );
						}
						_canvasBD.unlock();
						info.render( _canvasBD);
					}
					
				}
			}
		}	
		private function mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			destination.x = event.localX;
			destination.y = event.localY;
			my = event.localY; 
		}
		
		/**
		 * startDraw.
		 * @param			evt:MouseEvent
		 * @description	
		 **/
		private function startDraw(evt:MouseEvent) : void {
			mx = evt.localX; 
			my = evt.localY; 
			
			_drawTimer.start();
		}
		
		/**
		 * stopDraw.
		 * @param			evt:MouseEvent
		 * @description	
		 **/
		private function stopDraw(evt:MouseEvent) : void {
			//_drawTimer.stop();
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

		public function get size():int
		{
			return _size;
		}

		public function set size(value:int):void
		{
			_size = value;
		}

		
	}
}
import flash.display.BitmapData;
import flash.events.Event;

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
import flash.events.*;
import onyx.events.*;
import flash.display.BitmapData;
import onyx.parameter.Parameter;
import onyx.parameter.Parameters;
import onyx.plugin.*;