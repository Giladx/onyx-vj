/** 
 * Copyright (c) 2003-2010, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 * Based on PixelRain code by André Michelle (http://www.andre-michelle.com)
 * Adapted for Onyx-VJ by Bruce LANE (http://www.batchass.fr)
 */
package {
	
	import com.andremichelle.Pixel;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.parameter.*;

	/**
	 * 	Draw bitmaps
	 */
	[SWF(width='320', height='240', frameRate='24')]
	public class LayerPixelRain extends Patch {

		private var _source:BitmapData		= createDefaultBitmap();

		public var delay:int				= 0;
		public var preblur:Number			= 2;
		private var _currentBlur:Number		= 2;
		
		private var _blur:BlurFilter;
		private var _begin:Boolean			= false;
		public var size:int					= 64;
				
		//PixelRain
		private const DAMP: Number = .94;
		private var pixels: Array;
		private var imageData:BitmapData;
		private var _canvasBMP:Bitmap;
		private var blurBitmap: Bitmap ;
		private var output:BitmapData;
		private var blurOut:BitmapData;
		public var sx:Number;
		public var sy:Number;
		public var tx:Number;
		public var ty:Number;
		public var vx:Number;
		public var vy:Number;
		public var dx:Number;
		public var dy:Number;
		public var dd:Number;
		private var intensity:Number;
		private var a:int;
		private var c:uint;
		private const origin:Point = new Point();
		private const blur:BlurFilter = new BlurFilter( 2, 2, 2 );
		private const alphaTrans:ColorTransform = new ColorTransform( 1, 1, 1, 1, 0, 0, 0, -4 );
		private var mx:Number = 50;
		private var my:Number = 50;
		private const w:int = DISPLAY_WIDTH;
		private const h:int = DISPLAY_HEIGHT;
		private var _mDown:Boolean= false;

		/**
		 * 	@constructor
		 */
		public function LayerPixelRain():void 
		{
			Console.output('LayerPixelRain 4.0.628');
			Console.output('Credits to Andre MICHELLE');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			parameters.addParameters(
				new ParameterLayer('layer', 'layer'),
				new ParameterInteger('delay', 'frame delay', 0, 100, 0),
				new ParameterInteger('preblur', 'preblur', 0, 30, 2, 10),	// Amount of Blur
				new ParameterInteger('size', 'size', 5, 200, size)			// Size
			);
			
			imageData = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00FFFFFF);
			_canvasBMP = new Bitmap( imageData, "auto", true );
			addChild( _canvasBMP );
						
			pixels = new Array();
			var ox: int = ( w - imageData.width ) >> 1;
			var oy: int = ( h - imageData.height ) >> 1;
			var x: int;
			for( var y: int = 0 ; y < imageData.height ; y++ )
			{
				for( x = 0 ; x < imageData.width ; x++ )
				{
					pixels.push( new Pixel( x + ox, y + oy, imageData.getPixel32( x, y ) ) );
				}					
			}  
			output = new BitmapData( w, h, true, 0 );
			addChild( new Bitmap( output ) );
			
			blurOut = new BitmapData( w, h, true, 0 );
			
			blurBitmap = new Bitmap( blurOut );
			blurBitmap.blendMode = BlendMode.ADD;
			addChild( blurBitmap );
			addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		/**
		 * 	@private
		 * 	If multiple layers are listening to the same layer, combine the stored frames
		 */
		private static const LAYER_COMBINED:Object	= {};
		
		/**
		 * 	@private
		 */
		private static function register(layer:Layer, patch:LayerPixelRain, addReference:Boolean):Array {
			
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
		 * 	@private
		 */
		private var frames:Array;

		/**
		 * 	@private
		 */
		 private function mouseDown(event:MouseEvent):void {
			_mDown = true;
			addEventListener(MouseEvent.MOUSE_UP, _mouseUp);		 
		} 

		/**
		 * 	@private
		 */
		private function _mouseMove(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
		}

		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			if (_layer && frames) 
			{
				_source = frames[delay];
				// clear
				graphics.clear();
				output.lock();
				blurOut.lock();
				output.fillRect( output.rect, 0x000000 );
				_currentBlur	+= preblur;
				
				if (_currentBlur >= 2) {
					var factor:int = _currentBlur - 2;
					
					_currentBlur = 0;
					//_source.applyFilter(_source, DISPLAY_RECT, ONYX_POINT_IDENTITY, new BlurFilter(factor + 2,factor + 2));
					_source.applyFilter(_source, _source.rect, ONYX_POINT_IDENTITY, new BlurFilter(factor + 2,factor + 2));
				}
	
				_source.draw(this);
				for each( var pixel: Pixel in pixels )
				{
					sx = pixel.sx;
					sy = pixel.sy;
					vx = pixel.vx;
					vy = pixel.vy;
					
					if( _mDown )
					{
						dx = mx - sx;
						dy = my - sy;
						dd = dx * dx + dy * dy;
						
						if( dd < size * size )
						{
							dd = Math.sqrt( dd );
							dd *= 2;
		
							if( dd > 0 )
							{
								vx -= dx / dd;
								vy -= dy / dd;
							}
						}
					}
					
					dx = pixel.tx - sx;
					dy = pixel.ty - sy;
					
					vx += dx * .02;
					vy += dy * .02;
					
					vx *= DAMP;
					vy *= DAMP;
					
					sx += vx;
					sy += vy;
					
					dd = dx * dx + dy * dy;
					
					if( dd > .25 )
					{
						blurOut.setPixel32( sx + .5, sy + .5, pixel.color );
					}
					else
					{
						intensity = ( .25 - dd ) / .25;
						
						c = pixel.color;
						a = ( c >> 24 ) & 0xff;
						
						output.setPixel32( sx + .5, sy + .5, ( c & 0xffffff ) | ( ( a * intensity ) << 24 ) );
					}
					
					pixel.sx = sx;
					pixel.sy = sy;
					pixel.vx = vx;
					pixel.vy = vy;
				}
				
				blurOut.applyFilter( blurOut, blurOut.rect, origin, blur );
				blurOut.colorTransform( blurOut.rect, alphaTrans );
				
				output.unlock();
				blurOut.unlock();
				if ( imageData ) {
					info.render( imageData );
				}
			}
		}
		
		/**
		 * 	@private
		 */
		 private function _mouseUp(event:MouseEvent):void {
			_mDown = false;
			removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		} 
		
		override public function dispose():void 
		{
			_source.dispose();
			_source = null;
			output.dispose();
			output = null;
			blurOut.dispose();
			blurOut = null;
			
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);

			graphics.clear();
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
	public function addPatch(patch:LayerPixelRain):void {
		
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
	public function removePatch(patch:LayerPixelRain):void {
		
		listeners.splice(listeners.indexOf(patch), 1);
		
		if (!listeners.length && layer) {
			layer.removeEventListener(LayerEvent.LAYER_RENDER, render);
		}
	}
}