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
package ui.window {
	
	import onyx.display.*;
	import onyx.time.Sequence;
	import ui.controls.sequence.SequenceTrack;
	import ui.controls.ScrollPane;
	
	/**
	 * 
	 */
	public final class SequenceWindow extends Window {
		
		/**
		 * 	@private
		 * 	The related sequence
		 */
		private var _sequence:Sequence;
		
		/**
		 * 	@private
		 * 	The related display
		 */
		private var _display:Display;
		
		/**
		 * 	@private
		 */
		private var _tracks:Array;
		
		/**
		 * 
		 */
		public function SequenceWindow(reg:WindowRegistration):void {
			
			_sequence	= new Sequence(_display = DISPLAY);
			
			// constructor
			super(reg, 900, 300);
			
			// create initial tracks
			drawTracks();
		}
		
		/**
		 * 	@private
		 */
		private function drawTracks():void {
			
			var len:int = _display.layers.length;
			
			// create a track for each layer
			for each (var layer:Layer in _display.layers) {
				var track:SequenceTrack = new SequenceTrack(layer);
				track.x = 2;
				track.y = layer.index * 36 + 12;
				
				addChild(track);
			}
		}
	}
}