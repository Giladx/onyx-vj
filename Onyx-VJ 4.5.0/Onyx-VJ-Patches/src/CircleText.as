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
 * Downloaded from http://wonderfl.net/c/pOiZ, a fork from nitoyon's Hello World 2
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * 
 */
package 
{

	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class CircleText extends Patch
	{
		private	var tf:TextField = new TextField();
		private var source:BitmapData; 		
		private var bmp:Bitmap;
		private var sprite:Sprite;
		private var _color:uint = 0x009661;
		private var _backColor:uint = 0xFF9933;
		private var i:int = 0;
		private var j:int = 0;
		private var factor:int = 10;
		private var padLeft:int;
		private var padTop:int;
		private var running:Boolean = false;
		private var sourceBitmap:Bitmap;
		private var _text:String = "JUMBLE\nGROOVE";
		private var _speed:int			= 1;
		private var timer:Timer			 = new Timer(_speed);
		private var _font:Font;
		
		/**
		 * 	@constructor
		 */
		public function CircleText():void 
		{
			Console.output('CircleText');
			Console.output('Credits to nitoyon (http://wonderfl.net/user/nitoyon)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');

			parameters.addParameters(
				new ParameterColor('backColor', 'back circle', _backColor),
				new ParameterColor('color', 'text color', _color),
				new ParameterFont('font', 'font'),
				new ParameterString('text', 'text'),
				new ParameterInteger('speed', 'speed', 1, 1000, _speed),
				new ParameterExecuteFunction('run', 'run')
			)
			tf.text 		= _text;
			tf.textColor 	= color;
			tf.autoSize 	= "left";
			tf.embedFonts 	= true;
			
			font	= PluginManager.createFont('Times New Roman') || PluginManager.fonts[0];

			//transparent background
			bmp = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00000000));
			//orange opaque background bmp = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0xff9933));
			sprite = new Sprite();
			addChild(sprite);
			sprite.addChild(bmp);
			
		}

		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			info.render( sprite );		
		} 
		
		public function run():void
		{
			i = 0;
			j = 0;
			tf.text = _text;
			if ( tf.text.length > 0 && tf.width > 0 )
			{
				var widthFactor:int = DISPLAY_WIDTH / tf.width;
				var heightFactor:int = DISPLAY_HEIGHT / tf.height;
				Console.output('CircleText: widthFactor: ' + widthFactor);
				Console.output('CircleText: heightFactor: ' + heightFactor);

				factor = Math.min( widthFactor, heightFactor );
				Console.output('CircleText: factor: ' + factor);
				padLeft = ( DISPLAY_WIDTH - ( tf.width * factor ) ) / 2 + factor / 2;
				padTop = ( DISPLAY_HEIGHT - ( tf.height * factor ) ) / 2 + factor / 2;
				Console.output('CircleText: targetWidth: ' + padLeft);
				Console.output('CircleText: targetHeight: ' + padTop);
				tf.textColor = color;
				source = new BitmapData(tf.width, tf.height, false, backColor);
				source.draw(tf);
				source.applyFilter(source, source.rect, new Point(), new BlurFilter(2,2));
				source.draw(tf);
				timer.delay = speed;
				timer.addEventListener(TimerEvent.TIMER, _onTimer);
				timer.start();
				running = true;
				Console.output('CircleText: Running');
			}
		}
		/**
		 * 	@private
		 */
		private function _onTimer(event:TimerEvent):void 
		{
			if ( running )
			{
				var sourceBD:BitmapData = bmp.bitmapData;
				var circle:Circle = new Circle( source.getPixel(i, j), factor * .6 );
				circle.realx = i * factor + padLeft; 
				circle.realy = j * factor + padTop;
				
				circle.x = Math.random() * DISPLAY_WIDTH;
				circle.y = Math.random() * DISPLAY_HEIGHT;

				circle.alpha = 0;
				sprite.addChild(circle);
				Tweener.addTween(
					circle, {
						x: circle.realx, y: circle.realy, alpha: 1, time: speed,
						delay: Math.sqrt(i + j) * Math.random()
					}
				);
				
				if ( i++ >= source.width-1 ) 
				{
					i = 0;
					if ( j++ >= source.height-1 ) 
					{
						j = 0;
						running = false;
						Console.output('CircleText: Done');
					}
				}
				sourceBD.draw(circle, null, null, null, null, true);
			}
			else
			{
				timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				timer.stop();
			}
		}
		/**
		 * 	
		 */
		public function set text(value:String):void 
		{
			_text = value;
		}
		
		/**
		 * 	
		 */
		public function get text():String 
		{
			return _text;
		}

		public function set color(value:uint):void 
		{
			_color = value;
		}
		public function get color():uint 
		{
			return _color;
		}
		/**
		 * 	get speed
		 */
		public function get speed():int
		{
			return _speed;
		}
		
		/**
		 * set speed
		 */
		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get backColor():uint
		{
			return _backColor;
		}

		public function set backColor(value:uint):void
		{
			_backColor = value;
		}
		/**
		 * 	
		 */
		public function set font(value:Font):void {
			_font = value;
			
			if (value) {
				
				var format:TextFormat = tf.defaultTextFormat;
				format.font = value.fontName;
				
				tf.defaultTextFormat = format;
				tf.setTextFormat(format);
			}
		}
		
		/**
		 * 	
		 */
		public function get font():Font {
			return _font;
		}
	}
}

