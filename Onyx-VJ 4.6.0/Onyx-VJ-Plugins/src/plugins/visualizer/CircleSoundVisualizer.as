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
 * Based on code by Okoi
 * 
 */
package plugins.visualizer 
{
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	public final class CircleSoundVisualizer extends Visualizer 
	{
		private var output:BitmapData;
		
		private var _view:Shape;
		
		private var _canvas:BitmapData;
		
		private var _particle:Array;
		private var _step:int;
		
		private var _color:ColorHSV;	
		/**
		 * 	@constructor
		 */
		public function CircleSoundVisualizer():void 
		{
			Console.output("CircleSoundVisualizer, credits to Okoi" );
			_view = new Shape();
			_canvas = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0);
			InitParticle();
			_step = 0;
			
			_color = new ColorHSV();
			
			output = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0 );
		}	
		private function InitParticle() : void
		{
			_particle = new Array();
			for ( var i:int = 0; i < SpectrumAnalyzer.SPECTRUM_LENGTH; i++ )
			{
				var p:Particle = new Particle((i*137.5)%360);
				p.x = DISPLAY_WIDTH / 2;
				p.y = DISPLAY_HEIGHT / 2;
				_particle[_particle.length] = p;
			}
		}
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void 
		{
			var array:Array = SpectrumAnalyzer.getSpectrum(false);
			
			var i:int = 0;
			var arraytotal:Number = 0;
			
			for ( i = 0; i < array.length; i++ )
			{
				arraytotal += array[i];
			}
			
			
			for ( i = 0; i < _particle.length; i++ )
			{
				_particle[i].Update( DISPLAY_WIDTH / 2, DISPLAY_HEIGHT / 2, array[i], i / _particle.length, arraytotal / 512 );
			}
			
			
			_view.graphics.clear();
			for ( i = 0; i < _particle.length; i++ )
			{
				_view.graphics.beginFill(0xFFFFFF, Math.min(_particle[i].alpha, 1) );
				_view.graphics.drawCircle(_particle[i].x, _particle[i].y, 2 + 8*array[i]);
				_view.graphics.endFill();
			}
			
			
			var trans:ColorTransform = new ColorTransform();
			trans.color = _color.value;
			_canvas.draw( _view, null, trans );
			_canvas.applyFilter( _canvas, _canvas.rect, new Point(), new BlurFilter(8,8,3) );
			
			
			_color.h = (_color.h + (arraytotal/512*100)*0.1) % 360;
			
			
			_step++;
			info.render(_canvas);
		}
	}
}
//Particle class
class Particle
{        
	private var _x:Number;
	private var _y:Number;
	public    function get x():Number { return    _x;    }
	public    function set x(val:Number) : void { _x = val;    }
	public    function get y():Number { return    _y;    }
	public    function set y(val:Number) : void { _y = val;    }
	
	private var _angle:Number;
	private var _rotPower:Number;
	public function get rotPower():Number { return    _rotPower;    }
	
	private var _alpha:Number;
	public function get alpha():Number { return    _alpha;    }
	
	public function Particle(angle:Number) 
	{            
		_angle = angle;
		_rotPower = 0;
		_alpha = 0;
	}
	
	public function Update(tx:Number, ty:Number, val:Number, angleRate:Number, tempRate:Number ) : void
	{    
		//_alpha += val;
		_alpha += val*20;
		_alpha *= 0.7;
		_rotPower += val + (tempRate * 3);
		_rotPower *= 0.7;
		
		_angle += _rotPower;
		_angle %= 360;
		var rad:Number = _angle * Math.PI / 180;
		_x = tx + Math.cos( rad ) * (angleRate * 200 + 20);
		_y = ty + Math.sin( rad ) * (angleRate * 200 + 20);
	}
	
}

