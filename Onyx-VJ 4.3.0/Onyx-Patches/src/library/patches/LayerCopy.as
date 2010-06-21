/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package library.patches {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	final public class LayerCopy extends Patch {
		
		/**
		 * 	@private
		 * 	If multiple layers are listening to the same layer, combine the stored frames
		 */
		private static const LAYER_COMBINED:Object	= {};
		
		/**
		 * 	@private
		 */
		private static function register(layer:Layer, patch:LayerCopy, addReference:Boolean):Array {
			
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
		 * 	@constructor
		 */
		public function LayerCopy():void {
			
			 parameters.addParameters(
			 	new ParameterLayer('layer', 'layer'),
			 	new ParameterInteger('delay', 'frame delay', 0, 100, 0)
			 );
			 
		}
		
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
		
		/**
		 * 	Render, called from Onyx
		 */
		override public function render(info:RenderInfo):void {
			
			if (_layer && frames) {
				var bmp:BitmapData = frames[delay];
				
				if (bmp) {
					info.render(bmp);
				}
			}
		}
		
		/**
		 * 	Dispose, called from onyx
		 */
		override public function dispose():void {
			register(_layer, this, false);
		}
	}
}

import flash.events.*;

import onyx.events.*;
import flash.display.BitmapData;
import onyx.parameter.Parameter;
import onyx.parameter.Parameters;
import onyx.plugin.*;

import library.patches.LayerCopy;

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
	public function addPatch(patch:LayerCopy):void {
		
		patch.getParameters().getParameter('delay').addEventListener(ParameterEvent.CHANGE, calculateMax);
		
		// add the patch
		listeners.push(patch);
		
		// calculate max
		calculateMax();
		
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
	 * 	@private
	 */
	private function calculateMax(event:ParameterEvent = null):void {
		
		if (event) {
			var param:Parameter	= event.currentTarget as Parameter;
			
			// set the delay cause it hasn't been set yet
			param.parent.getTarget()[param.name] = event.value;
		}
		
		maxDelay = 0;
		for each (var patch:LayerCopy in listeners) {
			maxDelay = Math.max(patch.delay, maxDelay);
		}
		
	}
	
	/**
	 * 
	 */
	public function removePatch(patch:LayerCopy):void {
		
		listeners.splice(listeners.indexOf(patch), 1);
		
		patch.getParameters().getParameter('delay').addEventListener(ParameterEvent.CHANGE, calculateMax);
		
		if (!listeners.length && layer) {
			layer.removeEventListener(LayerEvent.LAYER_RENDER, render);
		}
	}
}