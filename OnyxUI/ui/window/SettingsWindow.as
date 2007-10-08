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
package ui.window {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.file.*;
	import onyx.jobs.*;
	import onyx.plugin.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.*;
	import ui.styles.*;
	import ui.text.*;

	public final class SettingsWindow extends Window implements IControlObject {

		/**
		 * 	@private
		 */
		private var _buttonXML:TextButton;
		
		/**
		 * 	@private
		 */
		private var _transitionDropDown:DropDown;
		
		/**
		 * 	@private
		 */
		private var _durationSlider:SliderV;
		
		/**
		 * 	@private
		 */
		private var _tempoSlider:SliderV;
				
		/**
		 * 	@private
		 */
		private var _tempoDropDown:DropDown;

		/**
		 * 	Stores current transition plugin to use
		 */		
		private var _transition:ControlPlugin;
		
		/**
		 * 	@private
		 * 	returns controls
		 */
		private var _controls:Controls;
		
		/**
		 * 	@private
		 */
		private var _tapTempo:TempoShape	= new TempoShape();
		
		/**
		 * 	@private
		 */
		private var _releaseTimer:Timer		= new Timer(50);
		
		/**
		 * 	@private
		 */
		private var _samples:Array			= [0];
		
		/**
		 * 	@private
		 */
		private var _line:Object;
		
		/**
		 * 
		 */
		public var duration:int = 2;
		
		/**
		 * 	@constructor
		 */
		public function SettingsWindow(reg:WindowRegistration):void {
			
			var control:Control;

			super(reg, true, 202, 161);
			
			_transition = new ControlPlugin('transition', 'Layer Transition', ControlPlugin.TRANSITIONS, true, false);
			_transition.addEventListener(ControlEvent.CHANGE, _onTransition);
			
			// create transition controls
			_controls = new Controls(this,
				_transition,
				new ControlInt('duration', 'Duration', 1, 20, 3)
			);
			
			var options:UIOptions	= new UIOptions(true, true, null, 60, 10);

			// controls for display
			_buttonXML				= new TextButton(options, 'save mix file');
			
			// transition controls
			_durationSlider			= new SliderV(options, _controls.getControl('duration'));
			_transitionDropDown		= new DropDown(options, _controls.getControl('transition'));

			// tempo controls
			_tempoSlider			= new SliderV(options, TEMPO.controls.getControl('tempo'));
			_tempoDropDown			= new DropDown(options, TEMPO.controls.getControl('snapTempo'));
			
			// add controls
			addChildren(
				new StaticText('GLOBAL TEMPO'),		4,		12,
				new AssetLine(),					4,		20,
				_tempoDropDown,						8,		35,
				_tapTempo,							75,		28,
				new StaticText('TRANSITION'),		4,		68,
				new AssetLine(),					4,		76,
				_transitionDropDown,				8,		90,
				_durationSlider,					75,		90,
				new StaticText('MIX FILE'),			4,		110,
				new AssetLine(),					4,		118,
				_buttonXML,							8,		124
			);

			// xml
			_buttonXML.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);

			// start the timer
			TEMPO.addEventListener(TempoEvent.CLICK, _onTempo);
			
			// tap tempo click
			_tapTempo.addEventListener(MouseEvent.MOUSE_DOWN, _onTempoDown);

		}
		
		/**
		 * 
		 */
		public function get controls():Controls {
			return _controls
		}

		/**
		 * 	@private
		 */
		private function _mouseDown(event:MouseEvent):void {
			
			var display:IDisplay	= AVAILABLE_DISPLAYS[0];
			var text:String			= display.toXML().normalize();
			
			var popup:TextControlPopUp = new TextControlPopUp(this, null, 200, 200, 'Copied to clipboard\n\n' + text);

			// saves breaks
			var arr:Array	= text.split(String.fromCharCode(10));
			text			= arr.join(String.fromCharCode(13,10));
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(text);
			
			File.save('test.mix', bytes, _onFileSaved);
			
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 */
		private function _onFileSaved(query:FileQuery):void {
			trace('saved');
		}
		
		/**
		 * 
		 */
		private function _onTransition(event:ControlEvent):void {

			var plugin:Plugin				= event.value;
			
			if (plugin) {
				var transition:Transition	= plugin.getDefinition() as Transition;
				transition.duration			= duration * 1000;
			}
			
			UILayer.useTransition 			= transition;
		}

		/**
		 * 	@private
		 */
		private function _onTempoDown(event:Event):void {
			
			var time:int = getTimer();
			
			if (time - _samples[_samples.length - 1] > 1000) {
				_samples = [time];
			} else {
				_samples.push(time);
			}
			
			var len:int = _samples.length;
			
			if (len > 2) {

				var total:int	= 0;
	
				for (var count:int = 1; count < len; count++) {
					total += _samples[count] - _samples[count - 1];
				}

				total /= (count - 1);
				TEMPO.tempo = (total / 4);
			} else {
				TEMPO.start();
			}
			
			if (len > 8) {
				_samples.shift();
			}

		}
		
		/**
		 * 	@private
		 */
		private function _onTempo(event:TempoEvent):void {
			if (event.beat % 4 === 0) {
				_tapTempo.transform.colorTransform = (event.beat % 16 == 0) ? TEMPO_BEAT : TEMPO_CLICK;
				_releaseTimer.addEventListener(TimerEvent.TIMER, _onTempoOff);
				_releaseTimer.start();
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onTempoOff(event:TimerEvent):void {
			_tapTempo.transform.colorTransform = DEFAULT;
			_releaseTimer.removeEventListener(TimerEvent.TIMER, _onTempoOff);
			_releaseTimer.stop();
		}
	}
}



import flash.display.Sprite;
import ui.assets.AssetTapTempo;

/**
 * 	Tempo shape
 */
final class TempoShape extends Sprite {
	
	/**
	 * 	@constructor
	 */
	public function TempoShape():void {
		
		addChild(new AssetTapTempo());
		
		super.buttonMode = true;
		
	}
}