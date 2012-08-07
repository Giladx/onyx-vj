/**
 * Copyright Maeda_addevent ( http://wonderfl.net/user/Maeda_addevent )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/4X9D
 */

package {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class ColorfulRotation extends Patch {

		public var _mySprite:mySprite;
		public var myCol:int=0;
		
		private var sprite:Sprite;
		
		public function ColorfulRotation() {
			
			sprite = new Sprite();
			addEventListener( MouseEvent.MOUSE_DOWN, mouseCap );
			addEventListener( MouseEvent.MOUSE_MOVE, mouseCap );
		}
		
		private function mouseCap(event:MouseEvent):void 
		{
			var _color:ColorHSV=new ColorHSV(myCol+=5,0.9);
			_mySprite = new mySprite(int(_color));
			_mySprite.x=event.localX;
			_mySprite.y=event.localY;
			sprite.addChild(_mySprite);
		}	
		override public function render(info:RenderInfo):void  {
			if ( sprite.numChildren > 500 ) 
			{
				sprite.removeChildren( 0, 200 );
			}
			info.render(sprite);
		}
		
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;

import frocessing.color.ColorHSV;

import onyx.core.Console;
import onyx.plugin.*;

class mySprite extends Sprite {
	
	public var radius:Number;
	public var max:Number = 3;
	public var min:Number = -3;
	public var speedX:Number=(Math.random()* (max - min + 1) + min)
	public var speedY:Number=(Math.random()* (max - min + 1) + min)
	public var myColor2:ColorTransform = new ColorTransform();
	
	public function mySprite(color:uint) {
		
		this.graphics.beginFill(int(color),1.5);
		this.graphics.drawRect(0,0,30,45);
		this.graphics.endFill();
		this.addEventListener(Event.ENTER_FRAME,xEnter2,false,0,true);
		
	}
	
	public function xEnter2(e:Event):void {
		radius=this.width/2;
		this.x+=speedX;
		this.y+=speedY;
		this.rotation += 10;
		this.rotationX += 5;
		this.alpha -= 0.001;
		/*Console.output(this.alpha);
		if (this.alpha < 0) {
			this.parent.removeChild(this);
		}*/
		
		if (this.x+radius>DISPLAY_WIDTH) {
			this.x=DISPLAY_WIDTH-radius;
			speedX=- speedX;
		}
		if (this.x-radius<0) {
			this.x=radius;
			speedX=- speedX;
		}
		if (this.y+radius>DISPLAY_HEIGHT) {
			this.y=DISPLAY_HEIGHT-radius;
			speedY=- speedY;
		}
		if (this.y-radius<0) {
			this.y=radius;
			speedY=- speedY;
		}
	}
}

