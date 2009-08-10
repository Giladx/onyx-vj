/**
 * Copyright (c) 2003-2009 "Onyx-VJ Team" which is comprised of:
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
 * Written for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * version 4.0.510 last modified August 10, 2009
 * 
 */package plugins.visualizer {
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.parameter.*;

	public final class SmoothVisualizer extends Visualizer {
		private var _sprite:Sprite	= new Sprite();

		private var _spectrum:SoundSpectrum ;
		private var _spectrumLength:uint= 150 ;
		private var _spectrumBuffer:uint = 8; 
		public var spectrumBlur:uint = 8; 
		public var spectrumGain:Number = -100; 
		public var startColor:uint		= 0xFF440A;
		public var endColor:uint		= 0x2D0C0A;
		private var _fourrierTransform:Boolean= false ;
		private var _bf:BlurFilter;
		private var _source:BitmapData 	= createDefaultBitmap();
		private var _xoffset:int 		= 50;
		private var _seed:Number ;
		
		/**
		 * 	@constructor
		 */
		public function SmoothVisualizer():void {
			parameters.addParameters( 
				new ParameterInteger('spectrumBlur', 'spectrumBlur', 0, 50, spectrumBlur),
				new ParameterInteger('spectrumGain', 'spectrumGain', -1000, 1000, spectrumGain),
				new ParameterColor('startColor', 'startColor')
			);
			_spectrum= new SoundSpectrum( _spectrumLength, _spectrumBuffer ) ;
			_bandsInit() ;
			_bf = new BlurFilter(spectrumBlur, spectrumBlur, 1);
		}
		
		/**
			var step:Number					= DISPLAY_WIDTH / 127;
			var graphics:Graphics			= shape.graphics;
			graphics.clear();
			var analysis:Array = SpectrumAnalyzer.getSpectrum(true);
			for (var count:int = 0; count < analysis.length; count++) {
				var value:Number	= analysis[count];
				var color:uint		= 0xFFFFFF * value;
				graphics.beginFill(color);
				graphics.drawCircle(count * 2.5, 120, value * 100);
				graphics.endFill();
			}
			
			info.render(shape);		 */
		override public function render(info:RenderInfo):void {
			var graphics:Graphics			= _sprite.graphics;
			graphics.clear();
			 _spectrum.readFloat(_fourrierTransform ) ;
			var left :Array= _spectrum.average( SoundSpectrumChannel.LEFT, spectrumGain ) ;
			var right :Array= _spectrum.average( SoundSpectrumChannel.RIGHT, spectrumGain ) ;
			var i :int=  -1 ;
			while( ++i < _spectrum.length )
			{
				var offset :Number= _fourrierTransform? 0 : -50 ;
				_drawBandAt( i, 0, left[i]+offset, 0, right[i]+offset ) ;
			} 
			_bf.blurX = spectrumBlur;
			_bf.blurY = spectrumBlur;
			_seed = Math.floor(Math.random() * 100);
			_source.applyFilter(_source, DISPLAY_RECT, ONYX_POINT_IDENTITY, _bf);
			_source.draw(_sprite);
			info.render(_source);
		}
		private function _bandsInit():void {
			var i:int= -1 ;
			while(++i< _spectrumLength )
			{
				var band:Sprite= new Sprite() ;
				band.x = _xoffset + i; 
				band.y = 100 ;
				_sprite.addChild( band );

				var level:Shape= new Shape() ;
				band.addChild(level) ;
			}
		}

		private function _drawBandAt( index:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void {
			var band :Sprite= Sprite( _sprite.getChildAt(index) ) ;
			var level :Shape= Shape( band.getChildAt(0) );
			//
			level.graphics.clear() ;
			level.graphics.lineStyle( 0, startColor, 1 ) ;
			level.graphics.moveTo( x1, y1 ) ;
			level.graphics.lineTo( x2, y2 ) ;
		}
		
	}
}
import flash.utils.* ;
import flash.media.* ;
final class SoundSpectrum
{
	public static const LENGTH_MAX :uint= 32 ;
	private var _bytes :ByteArray ;
	private var _floats :Array ;
	private var _length :uint= 16 ;
	private var _resolution :uint= 17 ;

	public function SoundSpectrum( length:uint=16, bufferLength:uint=4 ):void {
		_floats= new Array() ;
		var max :Number= restrict( 1, bufferLength, SoundSpectrum.LENGTH_MAX ) ;
		while(_floats.length< max ) _floats.push(_getZeroArray(512) ) ;
		//
		this.length= length ;
	}
	public function restrict( min:Number=0, value:Number=0, max:Number=1 ):Number{
		return Math.max( value, Math.min(value,max) ) ;
	}
	public function get length():uint {
		return _length ;
	}
	public function set length( n:uint ):void {
		_length= restrict( 16, n, SoundSpectrum.LENGTH_MAX ) ;
		_resolution= Math.ceil(_length/256)+1 ;
	}
	public function get bufferLength():uint {
		return _floats.length ;
	}
	public function set bufferLength( n:uint ):void {
		n= restrict( 1, n, SoundSpectrum.LENGTH_MAX ) ;
		if( n> this.bufferLength ) _floats.length= n ;
		else while(_floats.length< n ) _floats.push(_getZeroArray(512) ) ;
	}
	public function average( channel:String, gain:Number=1 ):Array {
		//if( SoundSpectrumChannel.invalidate(channel) ) throwError( 'invalid channel', this ) ;
		//
		var buffer :Array= _getTransformBuffer( gain, channel ) ;
		var total :Number= 0, index:int= -1, time:int= -1 ;
		//
		var floats :Array= [] ;
		while(++index< this.length )
		{
			total= 0 ; time= -1 ;
			//
			while(++time< buffer.length ) total+= buffer[time][index] ;
			floats.push( total/=buffer.length ) ;
		}
		return floats ;
	}
	public function last( channel:String, gain:Number=1 ):Array {
		//if( SoundSpectrumChannel.invalidate(channel) ) throwError( 'invalid channel', this ) ;
		//
		return _getTransformFloatsAt( 0, channel, gain ) ;
	}
	public function max( channel:String, gain:Number=1 ):Array {
		//if( SoundSpectrumChannel.invalidate(channel) ) throwError( 'invalid channel', this ) ;
		//
		var buffer :Array= _getTransformBuffer(gain,channel) ;
		var max :Number= 0, value:Number= 0, factor:Number= 1 ;
		var abs :Number= 0, index:int= -1, time:int= -1 ;
		//
		var floats :Array= [] ;
		while(++index< this.length )
		{
			max= 0 ; time= -1 ;
			//
			while(++time< buffer.length )
			{
				value= buffer[time][index] ;
				abs= Math.abs(value) ;
				//
				if( abs > max )
				{
					max= abs ;
					factor= value>0? 1 : -1 ;
				}
			}
			floats.push( max*factor ) ;
		}
		return floats ;
	}
	public function readFloat( transform:Boolean=true ):void {
		_bytes= new ByteArray() ;
		SoundMixer.computeSpectrum( _bytes, transform, _resolution ) ;
		//
		var a :Array= [] ;
		while( a.length< 512 ) a.push(_bytes.readFloat() ) ;
		//
		_floats.unshift(a) ;
		_floats.pop() ;
	}
	private function _getTransformFloatsAt( time:uint, channel:String, gain:Number ):Array {
		var buffer :Array= _floats[time] ;
		var position :uint= 0 ;
		var index :int= -1 ;
		var offset :uint= (256/_length) ;
		var value :Number= 0 ;
		//
		var floats :Array= [] ;
		switch(channel)
		{
			case 'left' :
			while(++index< _length ){
				position= Math.ceil(index*offset) ;
				value= buffer[position] ;
				floats.push( value*gain ) ;
			}
			//
			case  'right' :
			while(++index< _length ){
				position= Math.ceil(index*offset)+256 ;
				value= buffer[position] ;
				floats.push( value*gain ) ;
			}
			return floats ;
			//
			case 'join' :
			while(++index< _length ){
				position= Math.ceil(index*offset) ;
				value= buffer[position]*.5 + buffer[position+256]*.5 ;
				floats.push( value*gain ) ;
			}
			return floats ;
		}
		return floats ;
	}
	private function _getTransformBuffer( gain:Number, channel:String ):Array {
		var buffer :Array= [] ;
		var time :int= -1 ;
		var max :uint= this.bufferLength ;
		//
		while(++time < max ) buffer.push(_getTransformFloatsAt(time,channel,gain) ) ;
		return buffer ;
	}
	private function _getZeroArray( length:uint ):Array {
		var a :Array= [] ;
		while( a.length< 512 ) a.push(0) ;
		return a ;
	}
}
final class SoundSpectrumChannel
{
	public static const LEFT:String= 'left' ;
	public static const RIGHT:String= 'right' ;
	public static const JOIN:String= 'join' ;

	public static function invalidate( channel:String ):Boolean {
		switch( channel.toLowerCase() ){
			case SoundSpectrumChannel.LEFT : return false ;
			case SoundSpectrumChannel.RIGHT: return false ;
			case SoundSpectrumChannel.JOIN : return false ;
		}
		return true ;
	}
}
