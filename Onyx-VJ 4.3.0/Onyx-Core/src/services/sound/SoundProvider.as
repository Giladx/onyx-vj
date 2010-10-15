package services.sound
{
	import flash.display.Stage;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.ui.Keyboard;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	
	public class SoundProvider extends EventDispatcher {
		
		public static const instance:SoundProvider = new SoundProvider();
		
		public var mic:Microphone;
		public var soundRecording:ByteArray;
		
		protected var soundOutput:Sound;
		protected var soundOutputCh:SoundChannel;
		
		public var bytes:ByteArray;
		public var floatLR:Array;
		
		public var slevel:Number;
		
		private var _level:Number;
		
		public function SoundProvider() {
			
			// check unique
			if(instance)
				throw new Error('');
			
			_level			= 1;
			
			bytes 			= new ByteArray();
			floatLR 		= new Array(new Array(),new Array());
			
			soundRecording 	= new ByteArray();
			
			SoundMixer.bufferTime=0;
			
		}
		
		public static function getInstance():SoundProvider {
			return instance;
		}
		
		public function activate():void {
			mic.addEventListener(SampleDataEvent.SAMPLE_DATA, gotMicData);
		} 
		public function deactivate():void {
			mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, gotMicData);
		}
		
		public function level():void {
			if(soundOutputCh)
				soundOutputCh.soundTransform = new SoundTransform(_level,0);
		}
					
		private function gotMicData(micData:SampleDataEvent):void {
			soundRecording.clear();
			soundRecording.writeBytes(micData.data);
			soundRecording.position = 0;
			
			soundOutput = new Sound();
			soundOutput.addEventListener(SampleDataEvent.SAMPLE_DATA, playSound);
			soundOutputCh = soundOutput.play();
			soundOutputCh.soundTransform = new SoundTransform(_level,0);
			
		}
		
		private function playSound(soundOutput:SampleDataEvent):void {			
			
			if (!soundRecording.bytesAvailable > 0)
				return;
			for (var i:int = 0; i < 8192; i++) {
				var sample:Number = 0;
				if (soundRecording.bytesAvailable > 0)
					sample = soundRecording.readFloat();
				soundOutput.data.writeFloat(sample); 
				soundOutput.data.writeFloat(sample);
			}   
			
			
			this.soundOutput.removeEventListener(SampleDataEvent.SAMPLE_DATA, playSound);
			this.soundOutput = null;
			
			// FFT, waveform, both
			bytes.clear();
			SoundMixer.computeSpectrum( bytes, true, 0 );
			for(var j:int=0; j<1; j++) {
				for(i=0; i<256; i++)
					floatLR[j][i] = bytes.readFloat();
			}
			floatLR[1] = floatLR[0]; // duplicate L channel for speed
			
			slevel = mic.activityLevel;
					
			instance.dispatchEvent(new SoundEvent(SoundEvent.SOUND,floatLR));

		}
		
		
		// TODO
		// http://code.compartmental.net/2007/03/21/fft-averages/
		// HP: input is always 256 bands per channel 
		public function averageFFT(bandsIn:Array,nOut:int,type:String):Array {
			
			var bandsOut:Array 	= new Array;
			var nIn:int 		= bandsIn.length;
			var avgWidth:int 	= nIn/nOut;
			
			for(var i:int=0; i<nOut; i++) {
				var avg:Number = 0;
				var j:int;
				for(j=0; j<avgWidth;j++) {
					var offset:int = j + i*avgWidth;
					if (offset<nIn)
						avg += bandsIn[offset];
					else 
						break;
				}
				avg /= j;
				bandsOut[i] = avg;
			}	
			return bandsOut;
		}	
	}
}