/**
 * Copyright 178ep3 ( http://wonderfl.net/user/178ep3 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/lBZT
 */

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Stockings extends Patch
	{
		private var circle:Circle = new Circle();
		private var bmp:Bitmap;
		private	var mtr:Matrix = new Matrix(1,0,0,1,DISPLAY_WIDTH*0.5,DISPLAY_HEIGHT*0.5);
		private var add:Number = -0.01;
		private var ra:Number = -0.0025;
		public function Stockings()
		{
			bmp = new Bitmap(new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,true,0xffffff));
			
			circle.x = DISPLAY_WIDTH*0.5;
			circle.y = DISPLAY_HEIGHT*0.5;
			
		}
		override public function render(info:RenderInfo):void 
		{
			circle.loop();
			bmp.bitmapData.draw(circle,mtr);
			mtr.a += add;
			mtr.d += add;
			mtr.b -= ra*0.9;
			mtr.c += ra;
			if(mtr.a<-1)add *=-1;
			else if(mtr.a>1)add *=-1;
			if(mtr.b<-1)ra *=-1;
			else if(mtr.b>1)ra *=-1;
			info.render(bmp);
		}
	}
}
import flash.geom.Point;
import flash.display.Shape;

class Circle extends Shape
{
	private var pt:Array = [];
	private var list:Array = [];
	private var len:uint;
	private var _rad:uint = 200;
	
	public function Circle()
	{
		var i:uint=0;
		for(i=0; i<360; i+=30)
		{
			var point:Point = Point.polar(_rad+(Math.random()*(_rad*0.2)-(_rad*0.1)),i*Math.PI/180);
			point.x = int(point.x);
			point.y = int(point.y);
			var pto:ptObject = new ptObject(point);
			pt.push(pto);
		}
		len = pt.length;
		
		list = RoundPolygon(pt);
		graphics.lineStyle(1,0x330000,0.1);
		graphics.moveTo(list[0].x,list[0].y);
		for(i=1; i<list.length-1; i+=2)
		{
			graphics.curveTo(list[i].x,list[i].y,list[i+1].x,list[i+1].y);
		}
		graphics.endFill();
	}
	
	public function loop():void
	{
		list = null;
		var i:uint=0;
		for(i=0; i<len; i++)
		{
			pt[i].loop();
		}
		
		list = RoundPolygon(pt);
		graphics.clear();
		graphics.moveTo(list[0].x,list[0].y);
		graphics.lineStyle(1,0x330000,0.1);
		for(i=1; i<list.length-1; i+=2)
		{
			graphics.curveTo(list[i].x,list[i].y,list[i+1].x,list[i+1].y);
		}
		graphics.endFill();
	}
	
	private function RoundPolygon(ptol:Array):Array
	{
		var pt:Array = ptol.slice();
		pt.push(new Point(pt[0].x,pt[0].y));
		pt.push(new Point(pt[1].x,pt[1].y));
		pt.push(new Point(pt[2].x,pt[2].y));
		
		var list:Array = [];
		for(var i:uint=1; i<pt.length-2; i++)
		{
			var pb:Point = new Point(pt[i].x,pt[i].y);
			var pn:Point = new Point((pt[i].x+pt[i+1].x)/2,(pt[i].y+pt[i+1].y)/2);
			
			list.push(pb);
			list.push(pn);
		}
		
		var p0:Point = list.shift();
		list.push(p0);
		var p1:Point = new Point(list[0].x,list[0].y);
		list.push(p1);
		
		return list
	}
}	

class ptObject extends Point
{
	private var _angle:uint = Math.random()*360;
	private var _rad:uint = Math.random()*5;
	private var _add:uint = Math.random()*10+20;
	
	public function ptObject(pt:Point)
	{
		this.x = pt.x;
		this.y = pt.y;
	}
	
	public function loop():void
	{
		this.x += Math.cos(_angle*Math.PI/180)*0.5;
		this.y += Math.sin(_angle*Math.PI/180)*0.5;
		_angle+=_add;
	}
}
