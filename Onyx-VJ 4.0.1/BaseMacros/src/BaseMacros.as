/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights rescerved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package {
		
	import macros.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public class BaseMacros extends PluginLoader {

		public function BaseMacros():void {
			this.addPlugins(

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
			)
		}
	}
}
