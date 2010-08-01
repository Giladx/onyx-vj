package peak {
	
	import events.VLIGHTEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	import module.VLIGHTModuleItem;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import symbols.*;
	
	import vlight.*;
	
	[SWF(width='480', height='360', frameRate='24')]
	final public class Strobo extends VLSpritePEAK {
		
		[Embed(source="..\\..\\assets\\flas\\library_fl9_as3_cs3.swf", symbol="rect")]
		private var Strb:Class;
		
		private var mc:MovieClip;
		
		public function Strobo() {
			super();
			
			// select channel to sync strobo to
			//getParameters().addParameters(
			//	new ParameterXXXXX('bass', 'bass', 8, 100, 30)
			//);
			
			mc = new Strb() as MovieClip;
			mc.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			mc.stop();
			
			/*mc.x = 0;
			mc.y = 0;
			mc.width = 480;
			mc.height = 360;
			mc.play();*/
							
			addChild(mc);
			
		}	
		
		// do some peak interaction here
		override public function onPeak(e:Event):void {
			var level:int = PluginManager.modules["VLIGHT"].getLevel();
			if(level>=super.silence){
				//Console.output("level "+level);
				mc.gotoAndPlay(1);
			}
				
		}
		
		private function _onEnterFrame(e:Event):void {
			if(mc.currentFrame==mc.totalFrames)
				mc.stop();
		}
		
	}
}

