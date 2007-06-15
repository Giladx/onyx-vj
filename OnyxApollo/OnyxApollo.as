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
	
	import file.*;
	
	import flash.data.*;
	import flash.display.*;
	import flash.geom.Point;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	
	import states.PluginLoadState;
	
	import ui.core.UIManager;

	[SWF(width="1024", height="768", backgroundColor="#141515", frameRate='30', systemChrome='none')]
	public class OnyxApollo extends Sprite {
		
		/**
		 * 	@constructor
		 */
		public function OnyxApollo():void {
			
			// make sure to include the OnyxUI as a source path
			// and OnyxCore as a library path
			// You'll also need to create a project called baseplugins and reference it
			// 
			// You need to create this file as the main builder default, rather than the created OnyxApollo.mxml
			
			var stage:Stage				= this.stage;
			var window:NativeWindow		= stage.window;
			var size:Point				= window.maxSize;
			
			window.width				= size.x;
			window.height				= size.y;
			window.x					= 0;
			window.y					= 0;
			
			// no scale please thanks
			stage.align		= StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality	= StageQuality.LOW;
			
			STAGE = this.stage;
			
			// init
			UIManager.initialize(stage, new ApolloAdapter(),
			
				// to fix the bugs with loading a plugin swf
				new PluginLoadState()
				
			);

		}
	}
}