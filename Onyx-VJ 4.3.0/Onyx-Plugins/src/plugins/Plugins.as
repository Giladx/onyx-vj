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
package plugins {
	
	import onyx.plugin.*;
	
	import plugins.assets.*;
	import plugins.filters.*;
	import plugins.filters.tempo.*;
	import plugins.transitions.*;
	import plugins.visualizer.*;
	import plugins.macros.*;
	import plugins.fonts.*;
	import plugins.modules.*;
	
	final public class Plugins extends PluginLoader {

		public function Plugins():void {
			
			addPlugins(
			
				// modules
				new Plugin('Recorder', 				Recorder, 			'Recorder'),
				new Plugin('Performance', 			PerformanceMonitor, 'Performance'),
				
				// bitmap filters
				new Plugin('Chess',                 ChessFilter,    'Alpha chesstable effect'),
				new Plugin('Erode',					Erode,			'Erode'),
				new Plugin('Bounce',				BounceFilter,	'Bounce'),
				new Plugin('Scroller',              ConstantScroll, 'Scroll', new AssetScroll().bitmapData),
                new Plugin('Ray Of Light',			RayOfLight,		'Ray Of Light', new AssetRay().bitmapData),
				new Plugin('Mirror',				MirrorFilter,	'Mirror Filter', new AssetMirror().bitmapData),
				new Plugin('Echo',					EchoFilter,		'Echo Filter', new AssetEcho().bitmapData),
				new Plugin('EdgeBlend',				EdgeBlend,		'EdgeBlend', new AssetEdge().bitmapData),
				new Plugin('Keying',				KeyingFilter,	'Keys a color out'),
				new Plugin('Kaleidoscope', 			Kaleidoscope,	'Kaleidoscope', new AssetKaleid().bitmapData),
				new Plugin('Pixelate',				Pixelate,		'Pixelate', new AssetPixelate().bitmapData),
				new Plugin('Blur', 					Blur,			'Blur Filter', new AssetBlur().bitmapData),
				new Plugin('Halo', 					Halo,			'Halo Filter', new AssetHalo().bitmapData),
				new Plugin('Noise',					NoiseFilter,	'Noise Filter', new AssetNoise().bitmapData),
				new Plugin('Repeater',				Repeater,		'Repeater Filter', new AssetRepeat().bitmapData),
				new Plugin('Displace',				DisplacementMap,'Displacement Map', new AssetDisplace().bitmapData),
				new Plugin('Slit Scan',				SlitScan,		'Slit Scan', new AssetSlit().bitmapData),
				new Plugin('Invert',				InvertFilter,	'Invert', new AssetInvert().bitmapData),
				new Plugin('Pass Through',			PassThrough,	'Pass Through'),
				new Plugin('Color Filter',			ColorFilter,	'Color Filter'),
				new Plugin('Distort',				Distort,		'Distort'),
				new Plugin('FrameSkip', 			FrameSkip,		'Frame Skip'),	

				// bitmap filters - tempo
				new Plugin('Alpha Effect', 			Alpha,			'Randomizes the alpha'),
				new Plugin('Blink Effect', 			Blink,			'Randomizes the visibility'),
				new Plugin('Toggle Effect', 		Toggle,			'Randomizes the visibility with toggle'),
				new Plugin('Frame Random', 			FrameRND,		'Randomizes Frame Rates'),
				new Plugin('MoveScale Effect', 		MoverScaler,	'Moves and Scales Object'),
				
				// transitions
				new Plugin('Repeater Transition',	RepeaterTransition, 'Repeater Transition'),
				new Plugin('Pixel Transition',		PixelTransition, 'Pixel Transition'),
				new Plugin('Blur Transition',		BlurTransition, 'Blurs the loaded layer'),
				
				// visualizers
				new Plugin('Basic',					BasicVisualizer, 'Visualizer'),
				new Plugin('Smooth',                SmoothVisualizer, 'SmoothVisualizer'),
				new Plugin('Isometric',             IsometricVisualizer, 'IsometricVisualizer'),
				new Plugin('Circles',				CircleVisualizer, 'CircleVisualizer'),
							
				// macros
				new Plugin('Framerate Increase',	FrameRateIncrease, 'Framerate Increase'),
				new Plugin('Framerate Decrease',	FrameRateDecrease, 'Framerate Decrease'),
				new Plugin('Echo Display',			EchoDisplay, 'Echo Display'),
				new Plugin('Slow Down Layers',		SlowDown, 'Slow Down Layers'),
				new Plugin('Speed Up Layers',		SpeedUp, 'Speed Up Layers'),
				new Plugin('Buffer Display',		BufferDisplay, 'Buffer Display'),
				new Plugin('Random Blend',			RandomBlend, 'Random Blend'),
				new Plugin('Random MoveScale',		RandomScaleLoc, 'Random Move/Scale'),
				new Plugin('Random Frame',			RandomFrameMacro, 'Random Frame'),
				new Plugin('Random FrameRate',		RandomFrameRateMacro, 'Random FrameRate'),
				new Plugin('ResetAllFrameRate',		ResetAllFrameRate, 'ResetAllFrameRate'),
				new Plugin('ResetAll',				ResetAll, 'ResetAll'),
				new Plugin('DisplayFadeChopDown',	DisplayFadeChopDown, 'DisplayFadeChopDown'),
				new Plugin('DisplayFadeChopUp',		DisplayFadeChopUp, 'DisplayFadeChopUp'),
				new Plugin('DisplayFadeScreen',		DisplayFadeScreen, 'DisplayFadeScreen'),
				new Plugin('DisplayFadeMultiply',	DisplayFadeMultiply, 'DisplayFadeMultiply'),
				new Plugin('Random 3DDistort',		Random3DDistort, 'Random 3DDistort'),
				new Plugin('Random 3DDistort2',		Random3DDistort2, 'Random 3DDistort2'),
				new Plugin('DisplayFadeBlack',		DisplayFadeBlack, 'Display Fade To Black'),
				
				// fonts
				new Arial(),
				new Impact(),
				new Garamond,
				new TimesNewRoman(),
				new Verdana(),
				new Plague()
				
			);
			
		}
	}
}
