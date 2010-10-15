package peak {
		
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.events.*;
	
	import services.sound.ID;
	
	import symbols.*;
	
	[SWF(width='480', height='360', frameRate='24')]
	final public class Strobo extends SoundSpritePEAK {
		
		[Embed(source="..\\..\\assets\\flas\\library_fl9_as3_cs3.swf", symbol="rect")]
		private var Strb:Class;
		
		private var mc:MovieClip;
		
		private var _period:int = 1000;
		private var _duty:int	= 50;
		
		public function Strobo() {
			
			super();
			
			getParameters().addParameters(
				//new ParameterInteger('period','period [ms]',0,10000,_period,1,100),
				//new ParameterInteger('duty','duty [%]',0,100,_duty,1,1)
			);
			
			mc = new Strb() as MovieClip;
			mc.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			mc.gotoAndStop(mc.totalFrames);
										
			addChild(mc);
			
		}	
				
		public function set period(value:int):void {
			_period = value;
		}
		public function get period():int {
			return _period;
		}
		
		public function set duty(value:int):void {
			_duty = value;
		}
		public function get duty():int {
			return _duty;
		}
		
		// do some peak interaction here
		override public function onPeak(e:Event):void {
			var slevel:int = PluginManager.modules[ID].slevel;
			//Console.output(slevel+"/"+super.level);
			if(slevel>=super.level)
				mc.gotoAndPlay(1);
		}
		
		private function _onEnterFrame(e:Event):void {
			if(mc.currentFrame==mc.totalFrames)
				mc.stop();
		}
		
	}
}

