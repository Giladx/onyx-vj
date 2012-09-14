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
package ui.states {

	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;
	import onyx.ui.*;
	import onyx.utils.*;
	
	import ui.core.UserInterfaceAPI;
	import ui.macros.*;
	import ui.window.*;

	import plugins.assets.*;
	import plugins.effects.*;
	import plugins.filters.*;
	import plugins.transitions.*;
	import plugins.visualizer.*;

	import macros.*;
	
	use namespace onyx_ns;

	/**
	 * 	State that loads external plugins and registers them
	 */	
	public final class InitializationState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var filters:Array;
		
		/**
		 * 	Initializes
		 */
		override public function initialize():void {
			
			// output
			Console.output('\n*  INITIALIZING PLUGINS  *\n');
			
			// register default plugins that are UI related
			Onyx.registerPlugin([
				new Plugin('SelectLayer0',			SelectLayer0, 'Selects Layer 0'),
				new Plugin('SelectLayer1',			SelectLayer1, 'Selects Layer 1'),
				new Plugin('SelectLayer2',			SelectLayer2, 'Selects Layer 2'),
				/*new Plugin('SelectLayer3',			SelectLayer3, 'Selects Layer 3'),
				new Plugin('SelectLayer4',			SelectLayer4, 'Selects Layer 4'),*/
				new Plugin('SelectLayerNext',		SelectLayerNext, 'Selects Next Layer'),
				new Plugin('SelectLayerPrevious',	SelectLayerPrevious, 'Selects Previous Layer'),
				new Plugin('SelectPage0',			SelectPage0, 'Selects Basic Control'),
				new Plugin('SelectPage1',			SelectPage1, 'Selects Filters'),
				new Plugin('SelectPage2',			SelectPage2, 'Selects Custom Tab'),
				new Plugin('MuteLayer0',			MuteLayer0, 'Mutes Layer 1'),
				new Plugin('MuteLayer1',			MuteLayer1, 'Mutes Layer 2'),
				new Plugin('MuteLayer2',			MuteLayer2, 'Mutes Layer 3'),
				/*new Plugin('MuteLayer3',			MuteLayer3, 'Mutes Layer 4'),
				new Plugin('MuteLayer4',			MuteLayer4, 'Mutes Layer 5'),*/
				new Plugin('CycleBlendUp',			CycleBlendModeUp,	'Cycles BlendMode Up'),
				new Plugin('CycleBlendDown',		CycleBlendModeDown,	'Cycle BlendMode Down'),
				new Plugin('ResetLayer',			ResetLayer,			'Resets a Layer'),
				new Plugin('ToggleTransition',		ToggleTransition,	'Toggles the cross fader')]
			);
			//Bruce: External Macros from BaseMacros
			Onyx.registerPlugin([
				// Macros
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
				new Plugin('DisplayFadeBlack',		DisplayFadeBlack, 'Display Fade To Black')
			]);
			//Bruce: External Plug-ins from BasePlugins
			Onyx.registerPlugin([
				// bitmap filters
				new Plugin('Chess',                 ChessFilter,    'Alpha chesstable effect'),
				new Plugin('Erode',					Erode,			'Erode'),
				new Plugin('Bounce',				BounceFilter,	'Bounce'),
				new Plugin('Scroller',              ConstantScroll, 'Scroll', new AssetScroll().bitmapData),
				new Plugin('Ray Of Light',			RayOfLight,		'Ray Of Light', new AssetRay().bitmapData),
				new Plugin('Mirror',				MirrorFilter,	'Mirror Filter', new AssetMirror().bitmapData),
				new Plugin('Echo',					EchoFilter,		'Echo Filter', new AssetEcho().bitmapData),
				new Plugin('Keying',				KeyingFilter,	'Keys a color out'),
				new Plugin('Kaliedoscope', 			Kaliedoscope,	'Kaliedoscope', new AssetKalied().bitmapData),
				new Plugin('GLFilter', 				GLFilter,		'GLFilter'),
				new Plugin('Pixelate',				Pixelate,		'Pixelate', new AssetPixelate().bitmapData),
				new Plugin('Blur', 					Blur,			'Blur Filter', new AssetBlur().bitmapData),
				new Plugin('Halo', 					Halo,			'Halo Filter', new AssetHalo().bitmapData),
				new Plugin('Noise',					NoiseFilter,	'Noise Filter', new AssetNoise().bitmapData),
				new Plugin('Repeater',				Repeater,		'Repeater Filter', new AssetRepeat().bitmapData),
				new Plugin('Alpha Effect', 			Alpha,			'Randomizes the alpha'),
				new Plugin('Blink Effect', 			Blink,			'Randomizes the visibility'),
				new Plugin('Frame Random', 			FrameRND,		'Randomizes Frame Rates'),
				new Plugin('MoveScale Effect', 		MoverScaler,	'Moves and Scales Object'),
				new Plugin('Displace',				DisplacementMap,'Displacement Map', new AssetDisplace().bitmapData),
				new Plugin('Slit Scan',				SlitScan,		'Slit Scan', new AssetSlit().bitmapData),
				new Plugin('Invert',				InvertFilter,	'Invert', new AssetInvert().bitmapData),
				new Plugin('Pass Through',			PassThrough,	'Pass Through'),
				new Plugin('Halftone Filter',		HalftoneFilter,	'Halftone Filter'),
				new Plugin('Distort',				Distort,		'Distort'),
				new Plugin('FrameSkip', 			FrameSkip,		'Frame Skip'),	
				
				// transitions
				new Plugin('Repeater Transition',	RepeaterTransition, 'Repeater Transition'),
				new Plugin('Pixel Transition',		PixelTransition, 'Pixel Transition'),
				new Plugin('Blur Transition',		BlurTransition, 'Blurs the loaded layer'),
				
				// visualizers
				new Plugin('Basic',					BasicVisualizer, 'Visualizer'),
				new Plugin('Circles',				CircleVisualizer, 'CircleVisualizer'),
				new Plugin('SmoothVisualizer',		SmoothVisualizer, 'SmoothVisualizer')
			]);
			
			// kill this state
			StateManager.removeState(this);
		}
		
		/**
		 *  @private
		 */
		private function queueNext(event:Event):void {
			
			// remove the listener
			DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, queueNext);
			
			// grab the last file
			//currentFile = filters.pop() as File;
			
			// there's a file left
			/*if (currentFile) {
				
				switch (currentFile.extension) {
					
					// actionscript plugin
					case 'swf':
				
						var loader:Loader	= new Loader();
						var info:LoaderInfo	= loader.contentLoaderInfo;
						
						info.addEventListener(Event.COMPLETE,			pluginLoaded);
						info.addEventListener(IOErrorEvent.IO_ERROR,	pluginLoaded);
						
						// read the bytes
						loader.loadBytes(readBinaryFile(currentFile),	INSECURE_CONTEXT);
						
						break;
						
					// pixel blender
					case 'pbj':
					
						var bytes:ByteArray		= readBinaryFile(currentFile);
						var shader:Shader		= new Shader(bytes);
						var data:ShaderData		= shader.data;
						var input:ShaderInput	= null;
						var valid:Boolean		= true;
						
						// check to see we only have one input source, if it's multiple, it should be a transition
						// trace('---------------' + data.name, currentFile.name);
						for (var i:Object in data) {
							
							if (data[i] is ShaderInput) {
							
								if (input !== null) {
									valid = false;	
								}
								
								input = data[i];
							}
						}
						
						// only allow single input pixel blender filters
						if (valid) {
							
							var plugin:Plugin = new Plugin(shader.data.name.toUpperCase(), PixelBlenderFilter, shader.data.description, null);
							plugin.registerData('bytes', bytes);
							plugin.registerData('bitmap', true);
							
							// register the filter
							PluginManager.registerFilter(plugin);

						}

						// wait a frame to load the next one
						DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, queueNext);
					
						break;

				}
				
				// output to the screen
				Console.output(currentFile.name.replace(currentFile.type, '').toUpperCase());
				
			} else {
				
				// kill state
				// wait a second before terminating
				StateManager.removeState(this);
			}*/
				StateManager.removeState(this);
		}
		
		/**
		 * 	@private
		 */
		private function pluginLoaded(event:Event):void {
			var info:LoaderInfo	= event.currentTarget as LoaderInfo;
			
			// remove listeners
			info.removeEventListener(Event.COMPLETE,		pluginLoaded);
			info.removeEventListener(IOErrorEvent.IO_ERROR,	pluginLoaded);
			
			// initialize the plugin
			if (!(event is ErrorEvent)) {
				
				const loader:PluginLoader = info.content as PluginLoader;
				
				if (loader) {
					
					Onyx.registerPlugin(loader.getPlugins(), info);
					
				}
			}
			
			// unload
			info.loader.unload();
			
			// wait a frame to load the next one
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, queueNext);
		}
		
		/**
		 * 	@private
		 */
		/*private function filter(file:File):Boolean {
			return (file.extension === 'swf' || file.extension === 'pbj') && (file.name.indexOf('-disabled') === -1 && file.nativePath.indexOf('.svn') === -1);
		}*/
	}
}