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
package onyx.controls {
	
	import onyx.constants.*;
	import onyx.content.*;

	[ExcludeClass]

	/**
	 * 	Stores property names for layers
	 */
	public final class LayerProperties extends Controls {

		// stores controls
		public var alpha:Control		=	new ControlNumber(
												'alpha',				'alpha',	0,	1,	1
											);
		public var blendMode:Control	=	new ControlBlend('blendMode', 'blendmode');
		public var brightness:Control	=	new ControlNumber(
												'brightness',			'bright',		-1,		1,		0
											);
		public var contrast:Control		= 	new ControlNumber(
												'contrast',				'contrast',		-1,		2,		0
											);
		public var rotation:Control		= 	new ControlNumber(
												'rotation',				'rotation',		-3.6,	3.6,	0
											);
		public var saturation:Control	= 	new ControlNumber(
												'saturation',			'saturation',	0,		2,		1
											);
		public var threshold:Control	= 	new ControlInt(
												'threshold',			'threshold',	0,		100,	0
											);
		public var tint:Control			= 	new ControlNumber(
												'tint',					'tint',			0,		1,		0
											);
		public var scaleX:Control		= 	new ControlNumber(
												'scaleX',				'scaleX',		-5,		5,		1
											);
		public var scaleY:Control		= 	new ControlNumber(
												'scaleY',				'scaleY',		-5,		5,		1
											);
		public var x:Control			= 	new ControlInt (
												'x',					'x',	-5000,	5000,	0
											);
		public var y:Control			=	new ControlInt(
												'y',					'y',	-5000,	5000,	0
											);
		public var anchorX:Control		= 	new ControlInt(
												'anchorX',				'anchorX',	-640,	640,	0
											);
		public var anchorY:Control		=	new ControlInt(
												'anchorY',				'anchorY',	-480,	480,	0
											);
		public var framerate:Control	=	new ControlFrameRate(
												'framerate',			'play rate'
											);
		public var loopStart:Control	=	new ControlNumber(
												'loopStart',			'loop',			0,		1,	0
											);
		public var loopEnd:Control		=	new ControlNumber(
												'loopEnd',				'end',			0,		1,	1
											);
		public var time:Control			=	new ControlNumber(
												'time',					null,			0,		1,	0
											);
		public var color:Control		=	new ControlColor(
												'color', 				'color'
											);
											
		public var position:Control		=	new ControlProxy(
												'position', 'x:y',
												x, y,
												{ invert: true }
											);

		public var scale:Control		=	new ControlProxy(
												'scale', 'scale',
												scaleX, scaleY,
												{ multiplier: 100, invert: true }
											);
											
		public var anchor:Control		=	new ControlProxy(
												'anchor', 'anchor',
												anchorX, anchorY,
												{ invert: true }
											);											
		public var visible:ControlBoolean	=	new ControlBoolean('visible', 'visible', 1);
													
		/**
		 * 	@constructor
		 */
		public function LayerProperties(content:IContent):void {
			
			super(
			
				content,
				
				// add controls
				alpha,
				blendMode,
				brightness,
				contrast,
				rotation,
				saturation,
				threshold,
				scale,
				position,
				framerate,
				loopStart,
				loopEnd,
				time,
				tint,
				color,
				visible,
				anchor
			);
		}
		
		/**
		 * 
		 */
		override public function toXML(nodeName:String='controls', ...excludeControls):XML {
			return super.toXML('properties');
		}

	}
}