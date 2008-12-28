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
package ui.window {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.asset.AssetQuery;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.jobs.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.*;
	import ui.states.*;
	import ui.styles.*;
	import ui.text.*;

	/**
	 * 
	 */
	public final class SettingsWindow extends Window implements IParameterObject {
        
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
		 * 	@private
		 * 	returns controls
		 */
		private const parameters:Parameters	= new Parameters(this as IParameterObject,
			new ParameterPlugin('transition', 'Layer Transition', PluginManager.transitions, true),
			new ParameterInteger('duration', 'Duration', 1, 20, 3)
		);
		
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
		 * 
		 */
		public var duration:int = 2;
		
		/**
		 * 	@constructor
		 */
		public function SettingsWindow(reg:WindowRegistration):void {
			
			super(reg, true, 306, 184);

			init();
		}
		
		/**
		 * 	@private
		 */
		private function init():void {
			
			var options:UIOptions	= new UIOptions(true, true, null, 60, 12);

			// controls for display
			_buttonXML				= new TextButton(options, 'save mix file'),
			
			// transition controls
			_durationSlider			= Factory.getNewInstance(SliderV);
			_durationSlider.initialize(parameters.getParameter('duration'), options);
			_transitionDropDown		= Factory.getNewInstance(DropDown) as DropDown;
			_transitionDropDown.initialize(parameters.getParameter('transition'), options);

			// tempo controls
			_tempoSlider			= Factory.getNewInstance(SliderV);
			_tempoSlider.initialize(
				Tempo.getParameter('delay'), options
			);
			_tempoDropDown			= Factory.getNewInstance(DropDown);
			_tempoDropDown.initialize(Tempo.getParameter('snapTempo'), options);
			
			
			// add controls
			addChildren(
				_tempoDropDown,						8,		40,
				_tapTempo,							75,		33,
				_transitionDropDown,				8,		95,
				_durationSlider,					75,		95,
				_buttonXML,							8,		129
			);
			
			
			var bg:AssetWindow	= super.getBackground() as AssetWindow;
			
			// draw things onto the background
			if (bg) {
				var source:BitmapData	= bg.bitmapData;
				source.fillRect(new Rectangle(4, 25, 299, 1), 0xFF445463);
				source.fillRect(new Rectangle(4, 81, 299, 1), 0xFF445463);
				source.fillRect(new Rectangle(4, 123, 299, 1), 0xFF445463);
				
				var label:StaticText		= new StaticText();
				
				label.text	= 'GLOBAL TEMPO';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 17));
				
				label.text	= 'TRANSITION';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 73));
				
				label.text	= 'MIX FILE';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 115));
			}
                        
			// xml
			_buttonXML.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			// start the timer
			Tempo.addEventListener(TempoEvent.CLICK, _onTempo);
			
			// tap tempo click
			_tapTempo.addEventListener(MouseEvent.MOUSE_DOWN, _onTempoDown);
		}
		
		/**
		 * 
		 */
		public function getParameters():Parameters {
			return parameters
		}
                
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			switch (event.currentTarget) {
				case _buttonXML:
					saveMix();
					break;
			}
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 */
		private function saveMix():void {
			
			StateManager.loadState(new SaveMixState());

		}
		        
		/**
		 * 	@private
		 */
		private function _onFileSaved(query:AssetQuery):void {
			Console.output(query.path + ' saved.');
		}
		
		/**
		 * 
		 */
		public function set transition(t:Transition):void {
			if (t) {
				t.duration				= duration * 1000;
			}
			Browser.useTransition	= t;
		}
		
		/**
		 * 
		 */
		public function get transition():Transition {
			return Browser.useTransition;
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
				Tempo.delay = (total / 4);
			} else {
				Tempo.start();
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