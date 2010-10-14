package FFT {
		
	import core.ID;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import symbols.*;
	
	[SWF(width='480', height='360', frameRate='24')]
	final public class Monitor extends SoundSpriteFFT {
		
		//private var text:TextField;
		private var tArrayL:Array = new Array();
		private var tArrayR:Array = new Array();
		
		private var bytes:ByteArray;
		private var bytesL:ByteArray = new ByteArray();
		private var bytesR:ByteArray = new ByteArray();
		
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
					tArrayL.push(text);
					addChild(text);
					// RIGHT
					text = new TextField();
					text.text = 'RR';
					text.width = 29;
					text.x = i*29+5;
					text.y = j*11 + 185;
					text.defaultTextFormat = format;
					tArrayR.push(text);
					addChild(text);
				}
			}			
		}	
		
		// do some peak interaction here
		override public function onSound(e:Event):void {
			bytesL = PluginManager.modules[ID].bytesL;
			bytesR = PluginManager.modules[ID].bytesR;
				for(var i:int=0; i<16*16; i++) {
					(tArrayL[i] as TextField).text = bytesL.readFloat().toString();//toFixed(2);
					(tArrayR[i] as TextField).text = bytesR.readFloat().toString();//toFixed(2);
				}
			
		}
		
		private function onEnterFrame():void {

		}
		
	}
}

