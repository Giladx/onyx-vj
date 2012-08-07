/**
 * Copyright hiro_rec ( http://wonderfl.net/user/hiro_rec )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/yA2f
 */

// forked from hiro_rec's flash on 2010-3-24
package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class GridLines extends Patch
	{
		private var map:Map;
		private var bmd:BitmapData;
		private var bmp:Bitmap;
		private var container:Sprite;
		private var matrix:Array = [
			1.0, 0, 0, 0, 0,
			0, 1.1, 0, 0, 0,
			0, 0, 1.8, 0, 0,
			0, 0, 0, 0.45, 0
		];
		
		private var matrixFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
		private var point:Point = new Point();
		
		
		public function GridLines()
		{
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			container = new Sprite();
			g.beginFill(0);    
			g.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			container.addChild(s);
			
			map = new Map( 10, 10);
			
			addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			initializeButtons();
			initializeBG();
			initializeBtmap();
		}
		
		private function initializeBtmap():void
		{
			bmd = new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00000000);
			bmp = new Bitmap();
			bmp.bitmapData = bmd;
			bmp.blendMode = BlendMode.HARDLIGHT;
			container.addChild(bmp);
		}
		
		private function initializeBG():void
		{
			var i:int;
			var px:int = 0;
			var py:int = 0;
			var line:Shape = new Shape();
			
			container.addChild(line);
			line.graphics.lineStyle(0, 0xFFFFFF, 0.075);
			
			for (i = 0; i <= map.cols; i++)
			{
				px = (i + 1) * map.marginH;
				line.graphics.moveTo(px, 0); 
				line.graphics.lineTo(px, DISPLAY_HEIGHT);
			}
			
			for (i = 0; i <= map.rows; i++)
			{
				py = (i + 1) * map.marginV;
				line.graphics.moveTo(0, py); 
				line.graphics.lineTo(DISPLAY_WIDTH, py);
			}
		}
		
		private function initializeButtons():void
		{
			var i:int;
			var button:Button;
			var row:int;
			var col:int;
			
			for (i = 0; i <= map.cols * map.rows; i++)
			{
				col = i % map.cols;
				row = int(i / map.cols);
				
				button = new Button(i, col, row, map.marginH, map.marginV);
				button.x = col * map.marginH;
				button.y = row * map.marginV;
				container.addChild(button);
				
				button.addEventListener(MouseEvent.MOUSE_DOWN, buttonClickHandler);
			}
		}
		
		private function buttonClickHandler(event:MouseEvent):void
		{
			var button:Button = event.currentTarget as Button;
			var index:uint = button.index;
			var col:uint = button.col;
			var row:uint = button.row;
			var line:Line;
			
			for (var i:int = 1; i <= 2; i++)
			{
				line = new Line(map, i, col, row);
				container.addChild(line);
			}
		}
		private function clickHandler(event:MouseEvent):void
		{
			//var index:uint = button.index;
			var col:uint = Math.random() * map.cols;
			var row:uint = Math.random() * map.rows;
			var line:Line;
			
			for (var i:int = 1; i <= 2; i++)
			{
				line = new Line(map, i, col, row);
				container.addChild(line);
			}
		}
		
		override public function render(info:RenderInfo):void    
		{
			bmd.applyFilter(bmd, bmd.rect, point, matrixFilter);
			bmd.applyFilter(bmd, bmd.rect, point, new GlowFilter(0xcc4233, 0.075, 2, 1, 2));
			bmd.applyFilter(bmd, bmd.rect, point, new BlurFilter(1, 1));
			info.render( container );
		}
		
	}
}


import flash.display.Sprite;
import flash.events.MouseEvent;

import onyx.plugin.*;


class Map
{
	private var _cols:uint;
	private var _rows:uint;
	private var _marginH:uint;
	private var _marginV:uint;
	
	public function get cols():uint        { return _cols;    }
	public function get rows():uint        { return _rows;    }
	public function get marginH():uint    { return _marginH; }
	public function get marginV():uint    { return _marginV; }
	
	
	public function Map( _cols:uint, _rows:uint)
	{
		this._cols = _cols;
		this._rows = _rows;
		
		_marginH = DISPLAY_WIDTH / _cols;
		_marginV = DISPLAY_HEIGHT / _rows;
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;
import caurina.transitions.Tweener;


class Line extends Sprite
{
	private var map:Map;
	private var col:uint;
	private var row:uint;
	private var num:uint;
	
	private var points:Array;
	private var _index:int = 0;
	
	private var bmd:BitmapData;
	private var bmp:Bitmap;
	
	private var matrix:Array = [
		1.3, 0, 0, 0, 0,
		0, 1.0, 0, 0, 0,
		0, 0, 1.8, 0, 0,
		0, 0, 0, 0.49, 0
	];
	
	private var matrixFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	private var point:Point = new Point();
	
	
	public function get index():int                { return _index; }
	public function set index(value:int):void    { _index = value; }
	
	
	public function Line(map:Map, num:uint, col:uint, row:uint)
	{
		this.map = map;
		this.col = col;
		this.row = row;
		this.num = num;
		
		filters = [new GlowFilter(0xcc7833, 0.95, 10, 8, 7, 3)];
		
		reset();
		start();
	}
	
	private function reset():void
	{
		_index = 0;
		points = [];
		
		var flag:Boolean = true;
		var r1:uint;
		var r2:uint;
		var r3:uint;
		var r4:uint;
		var h:uint;
		var v:uint;
		var p:Point;
		var tv1:int = num % 2 == 0 ? 1 : -1;
		var b:Boolean= num % 2 == 0 ? true : false;
		var j:int = 0;
		var a:Boolean = false;
		
		while (flag)
		{
			r1 = int(Math.random() * 2);
			r2 = int(Math.random() * 6);
			r3 = int(Math.random() * 10);
			r4 = int(Math.random() * 20);
			
			a = false;
			
			//if (b)
			//{
			if (r1 == 0)
			{
				h++;
				a = true;
			}
			else
			{
				if (r2 == 0)
					v++;
				
				//if (r3 == 0)
				//    v++;
			}
			//}
			
			
			
			p = new Point((col + h * tv1) * map.marginH, (row + v * tv1) * map.marginV)
			points.push(p);
			
			//if (num == 1)
			//    trace(p);
			
			if (h > map.cols || v > map.rows || h < 0 || v < 0)
				flag = false;
		}
	}
	
	private function start():void
	{
		Tweener.addTween(this, {index:points.length, time:1.0, transition:"easeInQuad"});
		
		addEventListener(Event.ENTER_FRAME, render);
	}
	
	private var speed:int = 0;
	public function render(event:Event):void
	{
		graphics.clear();
		
		setPoints();
		
		
	}
	
	private var len:int = Math.random() * 10 + 3;
	
	private function setPoints():void
	{
		var v:Vector.<Point> = new Vector.<Point>();
		
		
		for (var i:uint; i < len; i++)
		{
			var point:Point = points[i + _index];
			
			if (!point)
			{
				removeEventListener(Event.ENTER_FRAME, render);
				return;
			}
			
			v[i] = new Point(point.x, point.y);
		}
		
		drawSpline(v);
	}
	
	private function drawSpline(v:Vector.<Point>):void
	{
		if(v.length < 2)
			return;
		
		v.splice(0, 0, v[0]);
		v.push(v[v.length-1]);
		
		var numSegments:uint = 1;//æ›²ç·šåˆ†å‰²æ•°ï¼ˆè£œå®Œã™ã‚‹æ•°ï¼‰
		
		for(var i:uint=0; i<v.length - 3; i++)
		{
			var p0:Point = v[i];
			var p1:Point = v[i+1];
			var p2:Point = v[i+2];
			var p3:Point = v[i+3];
			splineTo(p0, p1, p2, p3, numSegments);
		}
	}
	
	private function splineTo(p0:Point, p1:Point, p2:Point, p3:Point, numSegments:uint):void
	{
		var weight:Number// = points.length / _index / 20;
		//weight = weight <= 0 ? 1: weight;
		//weight = weight >= 3 ? 3 : weight;
		weight = 1;
		
		graphics.moveTo(p1.x, p1.y);
		graphics.lineStyle(weight, 0xFFFFFF);
		//graphics.lineStyle(1, 0xFFFFFF);
		
		for(var i:uint=0; i<numSegments; i++)
		{
			var t:Number = (i+1)/numSegments;
			graphics.lineTo(catmullRom(p0.x, p1.x, p2.x, p3.x, t), catmullRom(p0.y, p1.y, p2.y, p3.y, t));
		}
	}
	
	public function catmullRom(p0:Number, p1:Number, p2:Number, p3:Number, t:Number):Number
	{
		var v0:Number = (p2 - p0) * 0.5;
		var v1:Number = (p3 - p1) * 0.5;
		
		return (2 * p1 - 2 * p2 + v0 + v1) * t * t * t + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t * t + v0 * t + p1;
	}
}


class Button extends Sprite
{
	private var _index:uint;
	private var _col:uint;
	private var _row:uint;
	private var w:uint;
	private var h:uint;
	
	public function get index():uint    { return _index; }
	public function get col():uint    { return _col;   }
	public function get row():uint    { return _row;   }
	
	
	public function Button(_index:uint, _col:uint, _row:uint, w:uint, h:uint)
	{
		this._index = _index;
		this._col = _col;
		this._row = _row;
		this.w = w;
		this.h = h;
		
		resetColor(0, 0);
		
		//buttonMode = true;
		
		addEventListener(MouseEvent.ROLL_OVER, overHandler);
		addEventListener(MouseEvent.ROLL_OUT, outHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
	}
	
	private function resetColor(c:uint, a:Number):void
	{
		graphics.clear();
		graphics.beginFill(c, a);
		graphics.drawRect(0, 0, w, h);
	}
	
	private function overHandler(event:MouseEvent):void
	{
		//resetColor(0xFFFFFF, 0.3);
	}
	
	private function outHandler(event:MouseEvent):void
	{
		//resetColor(0, 0);
	}
	
	private function downHandler(event:MouseEvent):void
	{
		//resetColor(0x0000FF, 0.3);
	}

}
