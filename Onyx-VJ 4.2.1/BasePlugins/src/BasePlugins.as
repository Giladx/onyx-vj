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
 */
package {
	
	import onyx.plugin.*;
	
	import plugins.assets.*;
	//import plugins.effects.*;
	import plugins.filters.*;
	import plugins.transitions.*;
	import plugins.visualizer.*;
	
	/**
	 * 
	 */
	final public class BasePlugins extends PluginLoader {
		
		/**
		 * 
		 */
		public function BasePlugins():void {
			
			addPlugins(
				
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
				new Plugin('ChromaKey', 			ChromaKey,		'Chroma Key'),	
				
				// transitions
				new Plugin('Repeater Transition',	RepeaterTransition, 'Repeater Transition'),
				new Plugin('Pixel Transition',		PixelTransition, 'Pixel Transition'),
				new Plugin('Blur Transition',		BlurTransition, 'Blurs the loaded layer'),
				
				// visualizers
				new Plugin('Basic',					BasicVisualizer, 'Visualizer'),
				new Plugin('Radar',					RadarVisualizer, 'RadarVisualizer'),
				new Plugin('Smooth',				SmoothVisualizer, 'SmoothVisualizer'),
				new Plugin('Isometric',				IsometricVisualizer, 'IsometricVisualizer'),
				new Plugin('Circles',				CircleVisualizer, 'CircleVisualizer')
			);
			
		}
	}
}
