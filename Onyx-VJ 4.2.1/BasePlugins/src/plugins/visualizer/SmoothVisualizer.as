/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
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
 */
package plugins.visualizer {
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.ParameterColor;
	import onyx.parameter.ParameterInteger;
	import onyx.plugin.*;

	public final class SmoothVisualizer extends Visualizer {
		
		private const shape:Shape	= new Shape();
		private var _sprite:Sprite	= new Sprite();
		
		private var _spectrum:Array ;
		private var _spectrumLength:uint= 512 ;
		private var _spectrumBuffer:uint = 8; 
		public var spectrumBlur:uint = 8; 
		public var startColor:uint		= 0xFF440A;
		public var endColor:uint		= 0x2D0C0A;
		private var _bf:BlurFilter;
		
		private var _source:BitmapData 	= createDefaultBitmap();
		private var _xoffset:int 		= 50;
		private var _seed:Number ;
		
		public var height:int		= 200;
		private var step:Number = 1;//DISPLAY_WIDTH / 260;
		
		/**
		 * 	@constructor
		 */
		public function SmoothVisualizer():void {
			/*TODO: find the new way for that:
			parameters.addParameters(
				new ParameterInteger('spectrumBlur', 'spectrumBlur', 0, 50, spectrumBlur),
				new ParameterInteger('height', 'height', 100, 300, height),
				//new ParameterInteger('spectrumGain', 'spectrumGain', -1000, 1000, spectrumGain),
				new ParameterColor('startColor', 'startColor')
			);*/
			
			_spectrum= SpectrumAnalyzer.getSpectrum(false);
			_bandsInit() ;
			_bf = new BlurFilter(spectrumBlur, spectrumBlur, 1);
		}
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {
			
			var graphics:Graphics			= _sprite.graphics;
			
			graphics.clear();
			
			_spectrum= SpectrumAnalyzer.getSpectrum(false);
			
			var i :int=  -1 ;
			while( ++i < _spectrum.length )
			{
				_drawBandAt( i, 0, 100 + (_spectrum[i] * height), 0, _spectrum[i] ) ;
			} 
			_bf.blurX = spectrumBlur;
			_bf.blurY = spectrumBlur;
			_seed = Math.floor( Math.random() * 100 );
			_source.applyFilter( _source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _bf );
			_source.draw( _sprite );
			
			info.render( _source );

		}
		private function _bandsInit():void {
			var i:int= -1 ;
			while(++i< _spectrumLength )
			{
				var band:Sprite= new Sprite() ;
				band.x = _xoffset + ( i * step ); 
				band.y = 100 ;
				_sprite.addChild( band );
				
				var level:Shape= new Shape() ;
				band.addChild(level) ;
			}
		}
		
		private function _drawBandAt( index:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void {
			var band :Sprite= Sprite( _sprite.getChildAt(index) ) ;
			var level :Shape= Shape( band.getChildAt(0) );
			
			level.graphics.clear() ;
			level.graphics.lineStyle( 0, startColor + ( y1*30 ), 1 ) ;
			level.graphics.moveTo( x1, y1 ) ;
			level.graphics.lineTo( x2, y2 ) ;
		}
		
	}
}
