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
		
		public function Strobo() {
			super();
			var shape:Shape;
			shape = new Shape();
			var graphics:Graphics	= shape.graphics;
			graphics.clear();
			graphics.beginFill( 0x00FF00 );
			graphics.drawCircle(100, 100, 40);
			graphics.endFill();
						
			addChild(shape);
		
			
		}	
		
	}
}

