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
		
		[Embed(source="..\\..\\assets\\flas\\library_as3_cs3.swf", symbol="rect")]
		private var Strb:Class;
		
		private var mc:MovieClip;
		
		public function Strobo() {
			super();
			
			mc = new Strb();
			mc.x = 0;
			mc.y = 0;
			mc.width = 480;
			mc.height = 360;
						
			addChild(mc);
			
			mc.play();
			
			
		}	
		
	}
}

