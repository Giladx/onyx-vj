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
 * version 4.0.503 last modified March 6th 2009
 */
package library.patches 
{

	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class CircleText extends Patch
	{
		private	var tf:TextField = new TextField();
		private const source:BitmapData	= createDefaultBitmap(); 		
		private var _color:uint;
		private var i:int = 0;
		private var j:int = 0;
		private var mx:Number = 0;
		private var my:Number = 0;
		private var lastX:Number = 0;
		private var lastY:Number = 0;
		private var running:Boolean = true;
		/**
		 * 	@constructor
		 */
		public function CircleText():void 
		{
			Console.output('CircleText');
			Console.output('Credits to nitoyon');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			_color = 0xFF44FF;
			parameters.addParameters(
				new ParameterColor('color', 'color'),
				new ParameterExecuteFunction('run', 'run'),
				new ParameterExecuteFunction('clear', 'clear')
			)
			addEventListener( InteractionEvent.MOUSE_MOVE, mouseMove );
			tf.textColor = 0xFF0000;
			tf.text = "Batchass \nintermediaire!!!";
			tf.autoSize = "left";
			
			//source = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT, false, 0xff9933);
			source.draw(tf);
			source.applyFilter(source, source.rect, new Point(), new BlurFilter());
			source.draw(tf);
			addChild(tf);

		}

		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			var sourceBD:BitmapData = info.source;
			//var circle:Circle = new Circle(sourceBD.getPixel(i, j));
			var circle:Circle = new Circle(source.getPixel(i, j));
			circle.realx = i * 10; circle.realy = j * 10;
			circle.x = circle.realx + Math.random() * 300 - 150;
			circle.y = circle.realy + Math.random() * 300 - 150;
			circle.alpha = 0;
			addChild(circle);
			Tweener.addTween(
				circle, {
					x: circle.realx, y: circle.realy, alpha: 1, time: 1,
					delay: Math.sqrt(i + j) * Math.random()
				}
			);

			lastX = mx;
			lastY = my;
			if ( i++ >= DISPLAY_WIDTH ) 
			{
				i = 0;
				if ( j++ >DISPLAY_HEIGHT ) running = false;
			}
			sourceBD.draw(circle, info.matrix, null, null, null, true);
			
			info.source.copyPixels( sourceBD, DISPLAY_RECT, ONYX_POINT_IDENTITY );
		} 
		public function set color(value:uint):void 
		{
			_color = value;
		}
		public function get color():uint 
		{
			return _color;
		}
		private function mouseMove(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}
		public function run():void 
		{
			running = true;
		}
		public function clear():void 
		{
			graphics.clear();
		}
	}
}


import flash.display.Sprite;
import caurina.transitions.Tweener;
import flash.filters.GlowFilter;

class Circle extends Sprite{
	public var realx:int;
	public var realy:int;
	public function Circle(color:uint):void{
		graphics.beginFill(color);
		graphics.drawCircle(0, 0, 6);
		graphics.endFill();
		mouseEnabled = true;
		
		var self:Circle = this;
		addEventListener("mouseOver", function(e:*):void{
			self.parent.addChild(self);
			
			filters = [new GlowFilter(0xffffff, .5)];
			Tweener.addTween(self, {
				x: realx + Math.random() * 40 - 20,
				y: realy + Math.random() * 40 - 20,
				time: .5,
				onComplete: function():void{
					Tweener.addTween(self, {
						x: self.realx, y: self.realy, time: .5,
						transition: 'easeOutSine',
						onComplete: function():void{
							filters = [];
						}
					});
				}
			});
		});
	}
}
