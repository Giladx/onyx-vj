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
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 	Basic Text Control with Typewriter functionality
	 */
	final public class BasicText extends Patch {

		/**
		 * 	@private
		 */
		private const label:TextField	= new TextField();

		/**
		 * 	@private
		 */
		private var _size:int			= 40;

		private var _speed:int			= 60;

		/**
		 * 	@private
		 */
		private var tempText:String		= '';

		/**
		 * 	@private
		 */
		private var timer:Timer			 = new Timer(_speed);;
		
		/**
		 * 	@private
		 */
		private var typeIndex:int			= 0;
		
		/**
		 * 	@private
		 */
		private var _font:Font;
		
		private var _showPreview:Boolean = true;
		
		/**
		 * 	@private
		 */
		public function get speed():int
		{
			return _speed;
		}

		/**
		 * @private
		 */
		public function set speed(value:int):void
		{
			_speed = value;
		}

		/**
		 * 	@constructor
		 */
		public function BasicText():void {
			
			parameters.addParameters(
				new ParameterFont('font', 'font'),
				new ParameterString('text', 'text'),
				new ParameterColor('color', 'color'),
				new ParameterInteger('size', 'size', 8, 100, 30),
				new ParameterInteger('speed', 'speed', 8, 1000, _speed),
				new ParameterExecuteFunction('start', 'typewriter'),
				new ParameterBoolean('dropShadow', 'shadow'),
				new ParameterBoolean('showPreview', 'show preview')
			);

			label.autoSize 			= TextFieldAutoSize.LEFT,
			label.selectable		= false,
			label.embedFonts		= true,
			label.textColor			= 0xFFFFFF;

			font	= PluginManager.createFont('Impact') || PluginManager.fonts[0],
			size	= _size;
			
			addChild(label);
		}
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {
			var source:BitmapData = info.source;
			source.draw(label, info.matrix, null, null, null, true);
		}
		
		/**
		 * 
		 */
		public function set dropShadow(value:Boolean):void {
			super.filters = (value) ? [new DropShadowFilter(4)] : [];
		}
		
		public function get dropShadow():Boolean {
			return super.filters.length > 0;
		}
		
		/**
		 * 	
		 */
		public function start():void {
			timer.delay = speed;
			timer.addEventListener(TimerEvent.TIMER, _onTimer);
			timer.start();
			
			typeIndex = 0;
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:TimerEvent):void {
			label.text = tempText.substr(0, ++typeIndex);
			if (typeIndex >= tempText.length) {
				timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				timer.stop();
			}
		}
		
		/**
		 * 	
		 */
		public function set text(value:String):void {
			tempText = value;
			if (showPreview) label.text = value;
		}
		
		/**
		 * 	
		 */
		public function get text():String {
			return tempText;
		}
		
		/**
		 * 	
		 */
		public function set color(value:uint):void {
			label.textColor = value;
		}
		
		/**
		 * 	
		 */
		public function get color():uint {
			return label.textColor;
		}
		
		/**
		 * 	
		 */
		public function set size(value:int):void {
			_size = value;
			
			var format:TextFormat = label.defaultTextFormat;
			format.size = value;
			
			label.defaultTextFormat = format;
			label.setTextFormat(format);
		}

		/**
		 * 	
		 */
		public function get size():int{
			return _size;
		}
		
		/**
		 * 	
		 */
		public function set font(value:Font):void {
			_font = value;
			
			if (value) {
				
				var format:TextFormat = label.defaultTextFormat;
				format.font = value.fontName;
				
				label.defaultTextFormat = format;
				label.setTextFormat(format);
			}
		}
		
		/**
		 * 	
		 */
		public function get font():Font {
			return _font;
		}
		
		/**
		 * 	
		 */
		override public function dispose():void {
			if (timer) timer.removeEventListener(TimerEvent.TIMER, _onTimer);
		}

		/**
		 * 	@private
		 */
		public function get showPreview():Boolean
		{
			return _showPreview;
		}

		/**
		 * @private
		 */
		public function set showPreview(value:Boolean):void
		{
			_showPreview = value;
			if ( _showPreview ) label.text = text else label.text = "";
		}

	}
}
