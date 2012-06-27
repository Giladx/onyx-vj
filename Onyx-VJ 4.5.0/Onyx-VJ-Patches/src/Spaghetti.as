/**
 * Copyright bradsedito ( http://wonderfl.net/user/bradsedito )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/9NDK
 */

package 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Spaghetti extends Patch 
	{
		public var ChaseList:Array;
		public var lines:int = 18;
		public var lineP:int = 20; 
		public var glowww:GlowFilter;
		public var filter:GlowFilter;
		//public var colorList:Array = [0x0066FF,0x0066FF,0x999999]
		public var colorList:Array = [0x5E4A2F,0xC4AE59,0x775C2B]
		private var spr:Sprite;
		private var timer:Timer;
		public var move:int = 100;
		private var mx:Number = 320;
		private var my:Number = 240;
		
		public function Spaghetti() 
		{
			Console.output('Spaghetti adapted by Bruce LANE (http://www.batchass.fr)');
			spr = new Sprite();
			ChaseList = new Array();
			for (var i:int = 0; i < lines; i++) {
				var List:Array = new Array();
				for (var j:int = 0; j < lineP; j++) {
					var P:ChaseP = new ChaseP();
					List.push(P);
				}
				ChaseList.push(List);
			}
			
			addEventListener( MouseEvent.MOUSE_DOWN, onDown );
			addEventListener( MouseEvent.MOUSE_MOVE, onDown );
			glowww = new GlowFilter( 0x131413,0.8, 6,6, 2,2 ); // 0.5);
			//filter = new GlowFilter( 0x766D30,0.9, 6,6, 2,2 ); // 0.5);
			//filter = new GlowFilter( 0x766D30,0.5 );
			this.filters = [glowww];
			
			timer = new Timer(0);
			timer.addEventListener(TimerEvent.TIMER, loop);
			timer.start();
		}
		private function onDown(e:MouseEvent):void {
			mx = e.localX; 
			my = e.localY; 			
		}	
		
		private function loop(evt:TimerEvent):void {
			var P:ChaseP;
			for (var i:int = 0; i < lines; i++) {
				P = ChaseList[i][0];
				P.x = Math.random() * move - move / 2 + mx;
				P.y = Math.random() * move - move / 2 + my;
			}
			
			timer.delay = Math.random() * 200 + 200;
		}
		override public function render(info:RenderInfo):void 
		{
			spr.graphics.clear();
			for (var i:int = 0; i < lines; i++) {
				var List:Array = ChaseList[i];
				var a1:ChaseP = List[0];
				var a2:ChaseP = List[1];
				
				moveP(a1, a2, 0.02, 0.8);
				
				var p:uint = colorList[i % colorList.length];
				var alh:Number = 0.6;
				var Thick:Number = 4;
				
				for (var j:int = 2; j <lineP ; j++) {
					var a3:ChaseP = List[j - 1];
					var a4:ChaseP = List[j];
					moveP(a3, a4, 0.3, 0.4);
					spr.graphics.lineStyle(Thick, p, alh);
					spr.graphics.moveTo(a3.x, a3.y);
					spr.graphics.lineTo(a4.x, a4.y);
					alh -= 0.03;
					Thick -= 0.3;
				}
			}
			info.render( spr );
		}
		
		public function moveP(p0:ChaseP, p1:ChaseP, num1:Number, num2:Number):void
		{
			var point0:ChaseP = p0;
			var point1:ChaseP = p1;
			var Spring:Number = num1;
			var Dis:Number = num2;
			
			point1.vx += (point0.x - point1.x) * num1;
			point1.vx *= num2;
			point1.x += point1.vx;
			
			point1.vy += (point0.y - point1.y) * num1;
			point1.vy *= num2;
			point1.y += point1.vy;
		}		
	}	
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.utils.Timer;

class ChaseP 
{
	public var x:Number;
	public var y:Number;
	public var vx:Number;
	public var vy:Number;
	public function ChaseP() {
		x = 0;
		y = 0;
		vx = 0;
		vy = 0;
	}
}
