/** 
 * Copyright (c) 2003-2007, www.onyx-vj.com
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
 */
 package {
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.controls.*;
	import onyx.core.*;

	/**
	 * 	Basic Text Control with Typewriter functionality
	 */
	public class BasicText extends Sprite implements IControlObject {
		
		/**
		 * 	@private
		 */
		private var _controls:Controls;

		/**
		 * 	@private
		 */
		private var _label:TextField;

		/**
		 * 	@private
		 */
		private var _font:Font;

		/**
		 * 	@private
		 */
		private var _size:int			= 24;

		/**
		 * 	@private
		 */
		private var _text:String		= '';

		/**
		 * 	@private
		 */
		private var _timer:Timer		= new Timer(120);
		
		/**
		 * 	@private
		 */
		private var _index:int			= 0;
		
		/**
		 * 	@constructor
		 */
		public function BasicText():void {
			
			_controls	= new Controls(this,
				new ControlFont('font', 'font'),
				new ControlString('text', 'text'),
				new ControlColor('color', 'color'),
				new ControlInt('size', 'size', 8, 100, 30),
				new ControlExecute('start', 'typewriter')
			);
			
			_label				= new TextField();
			
			_label.autoSize 	= TextFieldAutoSize.LEFT,
			_label.selectable	= false,
			_label.embedFonts	= true,
			_label.textColor	= 0xFFFFFF;

			font				= Onyx.fonts[0];
			
			addChild(_label);
		}
		
		/**
		 * 
		 */
		public function start():void {
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
			
			_index = 0;
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:TimerEvent):void {
			_label.text = _text.substr(0, ++_index);
			
			if (_index >= _text.length) {
				_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				_timer.stop();
			}
		}
		
		/**
		 * 	
		 */
		public function set text(value:String):void {
			if (_timer.running) {
				_text = value;
			} else {
				_text = _label.text = value;
			}
		}
		
		/**
		 * 	
		 */
		public function get text():String {
			return _text;
		}
		
		/**
		 * 	
		 */
		public function set color(value:uint):void {
			_label.textColor = value;
		}
		
		/**
		 * 	
		 */
		public function get color():uint {
			return _label.textColor;
		}
		
		/**
		 * 	
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	
		 */
		public function set size(value:int):void {
			_size = value;
			
			var format:TextFormat = _label.defaultTextFormat;
			format.size = value;
			
			_label.defaultTextFormat = format;
			_label.setTextFormat(format);
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
			
			var format:TextFormat = _label.defaultTextFormat;
			format.font = value.fontName;
			
			_label.defaultTextFormat = format;
			_label.setTextFormat(format);
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
		public function dispose():void {
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
		}
	}
}
