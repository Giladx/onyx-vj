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
 * Based on CircleArt code by Lucas Swick (http://summitprojectsflashblog.wordpress.com/author/lucasswick/)
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * version 4.0.503 last modified Nov 27th 2011
 * 
 */
package LayerFilters 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class LayerPixelDistortion extends Patch 
	{
		protected var _bitmap:BitmapData;
		protected var _distortion:int = 0;
		protected var _maxDistortion:int = 10;
		protected var _decreasing:Boolean = true;
		private var _canvasBD:BitmapData;
		private var _drawTimer:Timer;
		
		/**
		 * 	@constructor
		 *
		 */
		public function LayerPixelDistortion()
		{
			Console.output('LayerPixelDistortion (from http://wonderfl.net/user/tripu)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterInteger( 'distortion', 'distortion', 1, 300, 35 ),
				new ParameterInteger( 'maxDistortion', 'maxDistortion', 1, 300, 300 )
			);

			init();
		}
		/**
		 * 	@private
		 * 	If multiple layers are listening to the same layer, combine the stored frames
		 */
		private static const LAYER_COMBINED:Object	= {};
		
		/**
		 * 	@private
		 */
		private static function register(layer:Layer, patch:LayerPixelDistortion, addReference:Boolean):Array {
			
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
		
		// INITIALIZATION ============================================================================================================
		private function init():void {
			_drawTimer = new Timer(1000, 0);
			_drawTimer.addEventListener( TimerEvent.TIMER, doDraw );
			_drawTimer.start();
		}

		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			if (_layer && frames) 
			{
				_bitmap = frames[delay];
				if (_bitmap) 
				{
					var bd:BitmapData = _bitmap;
					for (var i:uint = 0; i < _bitmap.width; i ++) 
					{
						for (var j:uint = 0; j < _bitmap.height; j ++) 
						{
							_bitmap.setPixel(i, j, bd.getPixel(Math.random() * _distortion + i - _distortion * 0.5, Math.random() * _distortion + j - _distortion * 0.5));
						}
					}
					
					if (_decreasing) {
						_distortion --;
						if (_distortion < 0) {
							_decreasing = false;
						}
					} else {
						_distortion ++;
						if (_distortion > maxDistortion) {
							_decreasing = true;
						}
					}
					info.render( _bitmap );	
				}
				/*_bitmap = frames[delay];
				if (_canvasBD) {
					info.render( _canvasBD);
				}*/
			}
		} 
		
		override public function dispose():void 
		{
			register(_layer, this, false);
		}		

		/**
		 * doDraw.
		 * @param			evt:TimerEvent
		 * @description	
		 **/
		private function doDraw(evt:TimerEvent) : void 
		{
			if (_layer && frames) {
				_bitmap = frames[delay];

			}
			
			
		}		
		
		public function get maxDistortion():int
		{
			return _maxDistortion;
		}
		
		public function set maxDistortion(value:int):void
		{
			_maxDistortion = value;
		}
		
		public function get distortion():int
		{
			return _distortion;
		}
		
		public function set distortion(value:int):void
		{
			_distortion = value;
		}

		
		
	}// Class
}

import LayerFilters.LayerPixelDistortion;

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
	public function addPatch(patch:LayerPixelDistortion):void {
		
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
	public function removePatch(patch:LayerPixelDistortion):void {
		
		listeners.splice(listeners.indexOf(patch), 1);
		
		if (!listeners.length && layer) {
			layer.removeEventListener(LayerEvent.LAYER_RENDER, render);
		}
	}
}