/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
package onyx.core {
	
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Plugin
	 */
	public class SpectrumAnalyzer {
		
		/**
		 * 	@private
		 */
		private static function _init():void {
			for (var count:int = 0; count < 127; count++) {
				BASE_ANALYSIS[count] = 0;
			}
		}
		
		_init();
		
		/**
		 * 	@private
		 */
		private static const BASE_ANALYSIS:Array		= new Array(127);

		/**
		 * 	@private
		 */
		private static const MAX_PRIORITY:int			= int.MAX_VALUE;
		
		/**
		 * 	@private
		 */
		private static const bytes:ByteArray			= new ByteArray();
		
		/**
		 * 	@private
		 */
		private static var _spectrumNormal:Array;
		
		/**
		 * 	@private
		 */
		private static var _spectrumFFT:Array;
		
		/**
		 * 	Gets the spectrum analysis
		 */
		public static function getSpectrum(useFFT:Boolean = false):Array {
			
			var i:Number, array:Array;
			
			// clear next frame
			STAGE.addEventListener(Event.ENTER_FRAME, _clearSpectrum, false, MAX_PRIORITY);
			
			// use fft?
			if (useFFT) {
				
				// check for already computed spectrum for this frame
				if (!_spectrumFFT) {
					
					i		= 128,
					array	= BASE_ANALYSIS.concat();
					
					// compute
					SoundMixer.computeSpectrum(bytes, true);
					
					// check
					while ( --i > -1 ) {
						
						// move the pointer
						bytes.position = i * 8;
						
						// get amplitude value
						array[i % 127] += (bytes.readFloat() / 2);
						
					}
					
					_spectrumFFT = array;
				}
				
				return _spectrumFFT;
			}

			// check for already computed spectrum for this frame
			if (!_spectrumNormal) {
				
				i		= 128,
				array	= BASE_ANALYSIS.concat();
				
				// compute
				SoundMixer.computeSpectrum(bytes, false);
				
				// check
				while ( --i > -1 ) {
					
					// move the pointer
					bytes.position = i * 8;
					
					// get amplitude value
					array[i % 127] += (bytes.readFloat() / 2);
					
				}
				
				_spectrumNormal = array;
			}
			
			return _spectrumNormal;
		}
		
		/**
		 * 	@private
		 * 	Clears the spectrum
		 */
		private static function _clearSpectrum(event:Event):void {

			// clear the listener
			STAGE.removeEventListener(Event.ENTER_FRAME, _clearSpectrum, false);
			
			// clear the spectrum
			_spectrumFFT	= null;
			_spectrumNormal	= null;
		}
	}
}