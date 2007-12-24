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
	
	import assets.*;
	
	import effects.*;
	
	import filters.*;
	
	import flash.display.Sprite;
	
	import macros.*;
	
	import modules.*;
	import modules.VLC.*;
	import modules.midi.*;
	import modules.render.*;
	import modules.stopmotion.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import transitions.*;
	
	import visualizer.*;
	
	/**
	 * 
	 */
	public class BasePlugins extends Sprite implements IPluginLoader {

		/**
		 * 	Returns an array of plugins for onyx to load
		 */
		public function get plugins():Array {
			return [
			
				// bitmap filters
				// new Plugin('AutoCompose',		AutoCompose,	'AutoCompose'),
				new Plugin('Erode',					Erode,			'Erode'),
				new Plugin('Bounce',				BounceFilter,	'Bounce'),
				new Plugin('Scroller',              ConstantScroll, 'Scroll', new AssetScroll().bitmapData),
                new Plugin('Ray Of Light',			RayOfLight,		'Ray Of Light', new AssetRay().bitmapData),
				new Plugin('Mirror',				MirrorFilter,	'Mirror Filter', new AssetMirror().bitmapData),
				new Plugin('Echo',					EchoFilter,		'Echo Filter', new AssetEcho().bitmapData),
				new Plugin('Keying',				KeyingFilter,	'Keys a color out'),
				new Plugin('Super Trigger',			SuperTrigger,	'Super Trigger'),
				// new Plugin('Generic Tempo',		GenericTempo,	'Generic Tempo'),
				new Plugin('Tempo Blur',			TempoBlur,		'Tempo Blur'),
				new Plugin('Kaliedoscope', 			Kaliedoscope,	'Kaliedoscope', new AssetKalied().bitmapData),
				new Plugin('Pixelate',				Pixelate,		'Pixelate', new AssetPixelate().bitmapData),
				new Plugin('Blur', 					Blur,			'Blur Filter', new AssetBlur().bitmapData),
				new Plugin('Halo', 					Halo,			'Halo Filter', new AssetHalo().bitmapData),
				new Plugin('Noise',					NoiseFilter,	'Noise Filter', new AssetNoise().bitmapData),
				new Plugin('Repeater',				Repeater,		'Repeater Filter', new AssetRepeat().bitmapData),
				new Plugin('Alpha Effect', 			Alpha,			'Randomizes the alpha'),
				new Plugin('Blink Effect', 			Blink,			'Randomizes the visibility'),
				new Plugin('Frame Random', 			FrameRND,		'Randomizes Frame Rates'),
				new Plugin('MoveScale Effect', 		MoverScaler,	'Moves and Scales Object'),
				new Plugin('Threshold Gate', 		ThreshGate,		'Randomly Threshold'),
				new Plugin('Displace',				DisplacementMap,'Displacement Map', new AssetDisplace().bitmapData),
				new Plugin('Slit Scan',				SlitScan,		'Slit Scan', new AssetSlit().bitmapData),
				new Plugin('Invert',				InvertFilter,	'Invert', new AssetInvert().bitmapData),
				new Plugin('Edge Bleed',			EdgeBlend,		'Frame Blend', new AssetEdge().bitmapData),
				new Plugin('Pass Through',			PassThrough,	'Pass Through'),

				// transitions
				new Plugin('Repeater Transition',	RepeaterTransition, 'Repeater Transition'),
				new Plugin('Pixel Transition',		PixelTransition, 'Pixel Transition'),
				new Plugin('Blur Transition',		BlurTransition, 'Blurs the loaded layer'),
				new Plugin('Basic',					BasicVisualizer, 'Visualizer'),
				new Plugin('Circles',				CircleVisualizer, 'CircleVisualizer'),
				new Plugin('SpectrumVisualizer',	SpectrumVisualizer, 'SpectrumVisualizer'),
				
				// Modules
				// new Plugin('VLC',					VLCModule,		'VLC'),
				// new Plugin('Render',				RenderClient,		'RenderClient'),
				new Plugin('Debugger',				Debugger,			'Debugger'),
				new Plugin('Midi',					XMLConnMidi,		'Midi'),

				// Macros
				new Plugin('Framerate Increase',	FrameRateIncrease, 'Framerate Increase'),
				new Plugin('Framerate Decrease',	FrameRateDecrease, 'Framerate Decrease'),
				new Plugin('Echo Display',			EchoDisplay, 'Echo Display'),
				new Plugin('Slow Down Layers',		SlowDown, 'Slow Down Layers'),
				new Plugin('Speed Up Layers',		SpeedUp, 'Speed Up Layers'),
				new Plugin('Buffer Display',		BufferDisplay, 'Buffer Display'),
				new Plugin('Random Blend',			RandomBlend, 'Random Blend'),
				new Plugin('Display Contrast',		DisplayContrast, 'Display Contrast'),
				new Plugin('Random MoveScale',		RandomScaleLoc, 'Random Move/Scale'),
				new Plugin('Random FrameMacro',		RandomFrameMacro, 'Random FrameMacro'),
				new Plugin('ResetAll',				ResetAll, 'ResetAll')
			];
		}
	}
}
