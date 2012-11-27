/**
 * Copyright Maeda_addevent ( http://wonderfl.net/user/Maeda_addevent )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/r5VZ
 */

package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import frocessing.color.ColorHSV;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import services.remote.*;
	
	public class PenLines extends Patch {

		public var _mySprite:mySprite;
		public var speed:Number=3;
		public var px:Number = 0;
		public var py:Number =0;
		public var px2:Number = 2.5;
		public var py2:Number = 0;
		public var myCol:int=0;
		public var mySet:Number = 1;
		public var myPoint:Array = new Array("p1","p2","p3","p4");
		public var myNum:Number = 0;
		private var dlc:DirectLanConnection = DirectLanConnection.getInstance("PenLines");

		private var _pressure:uint = 10;	
		private var _xyp:uint = 10;	
		private var _x:int = 200;
		private var _y:int = 200;
		private var sprite:Sprite;
		
		public function PenLines() {
		
			sprite = new Sprite();
			
			dlc.addEventListener( DLCEvent.ON_RECEIVED, DataReceived );
			dlc.connect("60000");
			Console.output('PenLines v0.03 from http://wonderfl.net/c/r5VZ');
		}
		
		protected function DataReceived(dataReceived:Object):void
		{
			myNum += 1;
			if (myNum >= 4) myNum = 0;
			// received
			switch ( dataReceived.params.type.toString() ) 
			{ 
				case "xyp":
					_xyp = dataReceived.params.value;
					_x = _xyp / 1048576;
					_y = (_xyp % 1048576) / 1024;
					_pressure = (((_xyp % 1048576) % 1024)/64)+1;
					_draw(_x, _y, _pressure);
					break;
				default: 
					break;
			}
		}
		private function _draw(x:int, y:int, pressure:int):void {
			
			var _color:ColorHSV=new ColorHSV(myCol+=1.5,1);
			//var _myCol:Number=Math.random()*0xFFFFFF;
			_mySprite = new mySprite(int(_color),myPoint[myNum],_pressure);
			_mySprite.x = x;
			_mySprite.y = y;
			
			sprite.addChild(_mySprite);
			
		}
		override public function render(info:RenderInfo):void {
			
			info.render(sprite);
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;

class mySprite extends Sprite {
	public var myFil:BlurFilter=new BlurFilter(2,2,2);
	public var myCol:Number;
	public var _color:uint;
	public var mySpeedY:Number = 0;
	public var mySpeedX:Number = 0;
	public var _myPoint:String;
	public var myIntX:Number;
	public var myIntY:Number;
	
	public function mySprite(color:uint,myPoint:String, size:uint):void {
		_color=color;
		_myPoint = myPoint;
				
		this.graphics.beginFill(int(_color),1);
		this.graphics.drawRect(0,0,size,size);
		this.graphics.endFill();
		
		addEventListener(Event.ENTER_FRAME,xEnter);
	}
	public function xEnter(e:Event):void {
		if (_myPoint == "p1") {
			mySpeedY += 1;
			mySpeedX += 0;
			if (mySpeedY >= 10) mySpeedY = 10;
			if (this.scaleY >= 465) {
				this.alpha -= 0.01;
				if (this.alpha < 0) {
					this.graphics.clear();
					parent.removeChild(this);
					this.removeEventListener(Event.ENTER_FRAME, xEnter);
				}
			}
		} else if (_myPoint == "p2") {
			mySpeedY = 0;
			mySpeedX -= 1;
			if (mySpeedX <= -10) mySpeedX = -10;
			if (this.scaleX <= 0) {
				this.alpha -= 0.01;
				if (this.alpha < 0) {
					this.graphics.clear();
					parent.removeChild(this);
					this.removeEventListener(Event.ENTER_FRAME, xEnter);
				}
			}
		} else if (_myPoint =="p3") {
			mySpeedY -= 1;
			mySpeedX = 0;
			if (mySpeedY <= -10) mySpeedY = -10;
			if (this.scaleY <= 0) {
				this.alpha -= 0.01;
				if (this.alpha < 0) {
					this.graphics.clear();
					parent.removeChild(this);
					this.removeEventListener(Event.ENTER_FRAME, xEnter);
				}
			}
		} else if (_myPoint == "p4") {
			mySpeedY = 0;
			mySpeedX += 1;
			if (mySpeedX >= 10) mySpeedX = 10;
			if (this.scaleX >= 465) {
				this.alpha -= 0.01;
				if (this.alpha < 0) {
					this.graphics.clear();
					parent.removeChild(this);
					this.removeEventListener(Event.ENTER_FRAME, xEnter);
				}
			}
		}
		this.scaleY += mySpeedY;
		this.scaleX += mySpeedX;
		this.rotation += 1;
		
		//        if (this.scaleY>465) || (this.scaleX{
		//            this.alpha -= 0.01;
		//            if (this.alpha < 0) {
		//            this.graphics.clear();
		//            parent.removeChild(this);
		//            this.removeEventListener(Event.ENTER_FRAME, xEnter);
		//            }
		//        }
	}
}