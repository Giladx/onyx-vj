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
package plugins.visualizer {
	
	import flash.display.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public final class BasicVisualizer extends Visualizer {
		
		public var height:int		= 200;
		private var shape:Shape	= new Shape();
		private var customParameters:Parameters;
		
		public function BasicVisualizer():void 
		{
			// create base parameters
			customParameters = new Parameters(this);
			customParameters.addParameters(
				new ParameterInteger('height', 'height', 100, 300, height)
			);
			Console.output('BasicVisualizer version 0.0.2');
		}
		
		override public function render(info:RenderInfo):void {
			
			var step:Number					= DISPLAY_WIDTH / 127;
			var graphics:Graphics			= shape.graphics;
			
			graphics.clear();
			graphics.lineStyle(0, 0xFFFFFF);
			
			var analysis:Array				= SpectrumAnalyzer.getSpectrum(false);
			graphics.moveTo(0,100 + (analysis[0] * height));

			var len:int = analysis.length;

			for (var count:int = 1; count < len; count++) {
				graphics.lineTo(count * step, 100 + (analysis[count] * height));
			}
			
			info.render(shape);
		}
		
		override public function dispose():void {
			shape = null;
		}
	}
}