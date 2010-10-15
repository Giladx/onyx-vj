package FFT {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import services.sound.*;
	
	import symbols.*;

	[SWF(width='480', height='360', frameRate='24')]
	final public class Monitor extends SoundSpriteFFT {
		
		//private var text:TextField;
		private var tArray:Array = new Array(new Array(),new Array());
		
		private var floatL:Array = new Array();
		private var floatR:Array = new Array();
	
		public function Monitor() {
			super();
				
			for(var j:int=0; j<16; j++) {
				for(var i:int=0; i<16; i++) {
					var format:TextFormat = new TextFormat();
					format.font = "Terminal";
					format.color = 0xFF0000;
					format.size = 8;
					// LEFT
					var text:TextField = new TextField();
					text.text = 'LL';
					text.width = 29;
					text.x = i*29+5;
					text.y = j*11;
					text.defaultTextFormat = format;
					text.transform.colorTransform = new ColorTransform();
					tArray[0].push(text);
					addChild(text);
					// RIGHT
					text = new TextField();
					text.text = 'RR';
					text.width = 29;
					text.x = i*29+5;
					text.y = j*11 + 185;
					text.defaultTextFormat = format;
					text.transform.colorTransform = new ColorTransform();
					tArray[1].push(text);
					addChild(text);
				}
			}			
		}	
		
		// do some peak interaction here
		override public function onPeak(l:Array,r:Array):void {
			//var ba:ByteArray = mod.bytes;
			//mod.averageFFT(mod.floatL,bands,'lin');
			//floatR = mod.averageFFT(mod.floatR,bands,'lin');
			//for(var j:int=0;j<2;j++) {
				for(var i:int=0; i<256; i++) {
					//var f:Number = ba.readFloat();
					(tArray[0][i] as TextField).text = l[i].toString();
					(tArray[1][i] as TextField).text = r[i].toString();
				}
			//}
		}
		
		private function onEnterFrame():void {
		}
		
	}
}

