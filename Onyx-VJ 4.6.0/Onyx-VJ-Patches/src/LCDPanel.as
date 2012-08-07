/**
 * Copyright umhr ( http://wonderfl.net/user/umhr )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/yA2U
 */

	
package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class LCDPanel extends Patch
	{
		private var _panelList:Vector.<Shape> = new Vector.<Shape>();
		private var _panels:Sprite = new Sprite();
		private var mx:int = 320;
		private var my:int = 240;
		private var sprite:Sprite;

		public function LCDPanel() 
		{
			_panels = new Panel();
			sprite = new Sprite();
			sprite.addChild(_panels);
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			addEventListener( MouseEvent.MOUSE_MOVE, mouseDown );
		}	
		private function mouseDown(event:MouseEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}
		
		override public function render(info:RenderInfo):void  
		{
			var rY:Number = (mx - DISPLAY_WIDTH * 0.5) * 0.1;
			var rX:Number = -(my - DISPLAY_HEIGHT * 0.5) * 0.1;
			/*_panels.rotationX = rX * 0.05 + _panels.rotationX * 0.95;
			_panels.rotationY = rY * 0.05 + _panels.rotationY * 0.95;*/
			sprite.rotationX = rX * 0.05 + _panels.rotationX * 0.95;
			sprite.rotationY = rY * 0.05 + _panels.rotationY * 0.95;
			
			info.render(sprite);
		}
	}
}

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

import onyx.plugin.*;

/**
 * ...
 * @author umhr
 */
class Panel extends Sprite 
{
	private var _mx:int = 320;
	private var _my:int = 240;
	
	public function Panel() 
	{
		
		var n:int = 2;
		for (var i:int = 0; i < n; i++) 
		{
			var panel:Shape = getPanel(i);
			panel.x = DISPLAY_WIDTH*0.5;
			panel.y = DISPLAY_HEIGHT*0.5;		
			panel.z = 50 * i;
			addChild(panel);
		}
		
	}
	
	private function getPanel(index:int):Shape {
		
		var panel:Shape = new Shape();
		panel.graphics.beginFill(0xFF0000, 0.5);
		
		var size:int = 20;
		
		var n:int = 400 / size;
		for (var i:int = 0; i < n; i++) 
		{
			var m:int = 400 / size;
			for (var j:int = 0; j < m; j++) 
			{
				if ((i % 2 + j +index) % 2 == 1) {
					continue;
				}
				panel.graphics.drawRect(size * j - 200, size * i - 200, size, size);
			}
		}
		
		panel.graphics.endFill();
		return panel;
	}

	public function get mx():int
	{
		return _mx;
	}

	public function set mx(value:int):void
	{
		_mx = value;
	}

	public function get my():int
	{
		return _my;
	}

	public function set my(value:int):void
	{
		_my = value;
	}


}

