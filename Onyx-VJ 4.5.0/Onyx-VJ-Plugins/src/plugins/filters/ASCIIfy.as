/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights rescerved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package plugins.filters {
	
	import flash.display.*;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.ByteArray;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	public final class ASCIIfy extends Filter implements IBitmapFilter {
		
		private var _source:BitmapData = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT);
		private var _sourceA:BitmapData = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT);
		private var asciifyInstance:AsciiEngine;
		
		public function ASCIIfy():void {
			
		}
		
		override public function initialize():void {
			
			var textFormat:TextFormat=new TextFormat();
			textFormat.font="Courier";
			textFormat.size=14;
			textFormat.leading=-9;
			textFormat.color=0xffffFF;

			asciifyInstance = new AsciiEngine(textFormat,8);
			
		}
		
		
		public function applyFilter(bitmapData:BitmapData):void {
			
			//Console.output(bitmapData.rect);
			//take the bitmapData stream and make a copy into _source
			//_source.draw(bitmapData);
			
						
			//bitmapData.copyPixels( _source, BITMAP_RECT, POINT, _mask, POINT, false );
			var text:TextField = asciifyInstance.render(bitmapData);
			_source.fillRect(DISPLAY_RECT,0xFF000000);
			_source.draw(text);
			bitmapData.copyPixels(_source,DISPLAY_RECT,new Point(),_sourceA,new Point());
			
		}
		
		override public function dispose():void {
			if (_source) {
				_source.dispose();
				_source = null;
			}
			super.dispose();
		}
	}
}


import flash.display.*;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.DisplacementMapFilter;
import flash.filters.GlowFilter;
import flash.geom.*;
import flash.text.*;
import flash.utils.ByteArray;

import onyx.plugin.*;

class AsciiEngine {
	
	private var _font:Font;
	private var _bd:BitmapData;
	private var _tfield:TextField;
	
	private var _tformat:TextFormat;
	private var _tformatSample:TextFormat;
	private var _picW:uint;
	private var _picH:uint;
	private var _pixels:Array;
	private var _charsX:uint;
	private var _pixelSize:Number;
	private var _colors:Array;
	private var _chars:Array;
	private var _matrix:Matrix;
	private var _targetClip:BitmapData;
	private var _negative:Boolean;
	
	public function AsciiEngine(tformat:TextFormat, pixelSize:Number=8, negative:Boolean=false) {
		
		_tformat=tformat;
		_negative=negative;
		
		initFormats();
		sampleChars();
		
		_pixelSize=pixelSize;
		
		var initw:Number=480;// DISPLAY_WIDTH;
		var inith:Number=360;// DISPLAY_HEIGHT;
				
		_picW=initw/_pixelSize;
		_picH=inith/_pixelSize;
		
		_matrix=new Matrix();
		_matrix.scale(1/_pixelSize, 1/_pixelSize);
		
		_tfield=new TextField();
		_tfield.width=10;
		_tfield.height=10;
		_tfield.multiline=true;
		_tfield.wordWrap=false;
		_tfield.selectable=false;
		_tfield.antiAliasType=AntiAliasType.NORMAL;
		
		_tfield.embedFonts=true;
		_tfield.text="";
		_tfield.defaultTextFormat=_tformat;
		_tfield.mouseEnabled=false;
		
	}
	
	
	public function render(bd:BitmapData):TextField {
		
		_tfield.text="";
		var output:String="";
		
		var i:uint;
		var j:uint;
		
		_bd=new BitmapData(_picW, _picH);
		_bd.draw(bd, _matrix);
		
		_pixels=new Array();
		
		for (i=0; i<_picH; i++) {
			var row:Array=new Array();
			for (j=0; j<_picW; j++) {
				var sampledColor:Number=_bd.getPixel(j, i);
				if(_negative) sampledColor=0xffffff-sampledColor;
				row.push(sampledColor);
			}
			_pixels.push(row);
		}
		
		for (i=0; i<_picH; i++) {
			for (j=0; j<_picW; j++) {
				var color:Number=_pixels[i][j];
				var rgb:Object=hex2rgb(color);
				var avg:Number=rgb.r+rgb.g+rgb.b;
				output+=getCharFromColor(avg);
				
			}
			output+="\r\n";
			
		}
		
		_tfield.appendText(output);
		//_tfield.autoSize="left";
		
		return _tfield;
		
	}
	
	private function initFormats():void {
		
		_tformatSample=new TextFormat();
		_tformatSample.font=_tformat.font;
		_tformatSample.size=_tformat.size;
		_tformatSample.color=0;
	}
	private function sampleChars():void {
		_colors=[];
		_chars=[];
		
		var i:uint;
		var c:uint=0;
		
		var mini:uint=32;
		var maxi:uint=256;
		
		for (i=mini; i<maxi; i++) {
			_colors.push(c);
			c+=3;
		}
		for (i=mini; i<maxi; i++) {
			
			var cc:String=String.fromCharCode(i);
			_chars.push({char:cc, darkness:getDarkness(cc)});
			_chars.sortOn("darkness", Array.NUMERIC | Array.DESCENDING);
			
		}
	}
	private function getDarkness(char):uint {
		var i:uint;
		var j:uint;
		
		var tf:TextField=new TextField();
		tf.defaultTextFormat=_tformatSample;
		tf.text=char;
		tf.embedFonts=true;
		tf.autoSize="left";
		
		var w:uint=tf.width;
		var h:uint=tf.height;
		
		var bd:BitmapData=new BitmapData(w, h);
		bd.draw(tf);
		
		var darkness:uint=0;
		
		for (i=0; i<h; i++) {
			for (j=0; j<w; j++) {
				var col=bd.getPixel(j, i);
				if (col<0x333333) {
					darkness++;
				}
			}
		}
		return darkness;
	}
	
	private function hex2rgb(hex:Number):Object {
		var r:Number;
		var g:Number;
		var b:Number;
		r = (0xFF0000 & hex) >> 16;
		g = (0x00FF00 & hex) >> 8;
		b = (0x0000FF & hex);
		return {r:r,g:g,b:b};
	}
	private function getCharFromColor(arg:uint):String {
		var i:uint=0;
		for each (var col in _colors) {
			if (arg<=col) {
				return _chars[i].char;
			}
			i++;
		}
		return " ";
	}
}
