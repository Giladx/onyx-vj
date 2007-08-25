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
	
	import effects.*;
	
	import filters.*;
	
	import flash.display.Sprite;
	
	import modules.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import renderer.*;
	
	import transitions.*;
	
	import visualizer.*;
	
	public class BasePlugins extends Sprite implements IPluginLoader {

		/**
		 * 	Returns an array of plugins for onyx to load
		 */
		public function get plugins():Array {
			return [
				new Plugin('Mirror Filter', MirrorFilter, 'Mirror Filter'),
				new Plugin(
						'Echo Filter',
						EchoFilter,
						'Echo Filter\nSimple Feedback Echo Filter\n' +
						'Echo Alpha: Alpha of the feedback\n' +
						'Echo Blend: BlendMode of the feedback\n' +
						'Mix Alpha:  Alpha or original mix\n' +
						'Mix Blend: BlendMode of original mix\n' +
						'Scroll: Scrolls the bitmap\n' +
						'Frame Delay: # of frames to skip'
				),
				new Plugin('Debugger',				Debugger,		'Debugger'),
				new Plugin('Scroll Render',			ScrollRender,	'Scroll Render'),
				new Plugin('Tempo Blur',			TempoBlur,		'Tempo Blur'),
				new Plugin('Kaliedoscope', 			Kaliedoscope,	'Kaliedoscope'),
				new Plugin('Pixelate',				Pixelate,		'Pixelate'),
				new Plugin('Blur Filter', 			Blur,			'Blur Filter'),
				new Plugin('Halo Filter', 			Halo,			'Halo Filter'),
				new Plugin('Noise Filter',			NoiseFilter,	'Noise Filter'),
				new Plugin('Repeater Filter',		Repeater,		'Repeater Filter'),
				new Plugin('Alpha Effect', 			Alpha,			'Randomizes the alpha'),
				new Plugin('Blink Effect', 			Blink,			'Randomizes the visibility'),
				new Plugin('Frame Random', 			FrameRND,		'Randomizes Frame Rates'),
				new Plugin('MoveScale Effect', 		MoverScaler,	'Moves and Scales Object'),
				new Plugin('Threshold Gate', 		ThreshGate,		'Randomly Threshold'),
				new Plugin('Displace Filter',		DisplacementMap,'Displacement Map'),
				new Plugin('Slit Scan',				SlitScan,		'Slit Scan'),
//				new Plugin('Matrix Effect',			MatrixEffect,	'Matrix Effect'),
//				new Plugin('Bleed Filter',			PasteFilter,	'Bleed Filter'),
				new Plugin('Repeater Transition',	RepeaterTransition, 'Repeater Transition'),
				new Plugin('Pixel Transition',		PixelTransition, 'Pixel Transition'),
				new Plugin('Blur Transition',		BlurTransition, 'Blurs the loaded layer'),
				new Plugin('Basic',					BasicVisualizer, 'Visualizer'),
				new Plugin('Circles',				CircleVisualizer, 'CircleVisualizer'),
				new Plugin('SpectrumVisualizer',	SpectrumVisualizer, 'SpectrumVisualizer'),
//				new Plugin('Burst Echo',			BurstEcho,		'Burst Echo'),
				new Plugin('Invert',				InvertFilter,	'Invert'),
//				new Plugin('Loop Scroll',			LoopScroll,		'Loop Scroll Filter'),
//				new Plugin('Displace',				DisplaceFilter,	'Displace Filter')
//				new Plugin('Convolve Filter', 		ConvolveFilter,	'Convolve')
			];
		}
	}
}
