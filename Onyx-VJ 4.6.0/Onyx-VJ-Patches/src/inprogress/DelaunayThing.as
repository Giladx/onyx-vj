/**
 * Copyright makc3d ( http://wonderfl.net/user/makc3d )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/mDMA
 */

// forked from termat's Delaunayä¸‰è§’åˆ†å‰²
package inprogress
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;	/**
	 *	Delaunayä¸‰è§’åˆ†å‰²ã‚µãƒ³ãƒ—ãƒ«
	 *
	 * @author termat(http://termat.sakura.ne.jp/)
	 */
	
	public class DelaunayThing extends Patch
	{
		private var list:Vector.<Circle>;
		private var del:Del;
		private var sprite:Sprite;
		private var numNodes:uint=0;
		
		public function DelaunayThing():void {
			sprite = new Sprite();
			sprite.graphics.lineStyle(2,0xaaaaaa);
			sprite.graphics.drawRect(0,0,DISPLAY_WIDTH,DISPLAY_HEIGHT);
			list = new Vector.<Circle>();
			del = new Del(list);
			sprite.addChild(del);
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);

		}
		
		private function onClick(e:MouseEvent):void {
			if(numNodes<6){
				numNodes++;
				addNode(e.localX,e.localY)
			}
		}
		
		private function addNode(x:Number,y:Number):void{
			var vx:Number = Math.random() * 12 - 6;
			if (Math.abs(vx) < 1e-2) vx=1.0;
			var vy:Number = Math.random() * 12 - 6;
			if (Math.abs(vy) < 1e-2) vy=1.0;
			var velo:Number = vx * vx + vy * vy;
			var c:int = Math.floor(Math.random() * 0xffffff);
			var p:Circle = new Circle(x,y,2,c,vx,vy);
			sprite.addChild(p);
			list.push(p);
		}	
	
		override public function render(info:RenderInfo):void 
		{
			if(numNodes<4/*80*/){
				var xx:Number=Math.random()*DISPLAY_WIDTH;
				var yy:Number=Math.random()*DISPLAY_HEIGHT;
				numNodes++;
				addNode(xx,yy);
			}
			for each(var c:Circle in list ) {
				c.update();
			}
			del.update();
			info.render(sprite);
			
		}
	}
	
}

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.MovieClip;
import flash.display.Shader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.utils.ByteArray;

import onyx.plugin.*;

class Circle extends MovieClip {
	private var vx:Number;
	private var vy:Number;
	private var color:uint;
	
	public function Circle(x:int, y:int, r:int, c:uint, vx:int, vy:int) {
		this.vx = vx;
		this.vy = vy;
		this.x = x;
		this.y = y;
		color = c;
		/*graphics.lineStyle(2, color) ;
		graphics.beginFill(c);
		graphics.drawCircle(0, 0, r);
		graphics.endFill();
		this.alpha = 0.5;*/
	}
	
	public function getLineColor():uint {
		return color;
	}
	
	public function update():void {
		var div:Number;
		if (x + vx < 0) {
			div = Math.abs((x + vx)/vx);
			vx *= -1;
			x = x + vx * div;
		}else if (x + vx > DISPLAY_WIDTH) {
			div= Math.abs((x + vx - DISPLAY_WIDTH) / vx);
			vx *= -1;
			x = x + vx * div;
		}else {
			x += vx;
		}
		if (y + vy < 0) {
			div = Math.abs((y + vy)/vy);
			vy *= -1;
			y = y + vy * div;
		}else if (y + vy > DISPLAY_HEIGHT) {
			div= Math.abs((y + vy-DISPLAY_HEIGHT)/vy);
			vy *= -1;
			y = y + vy * div;
		}else {
			y += vy;
		}
	}
}

class Del extends Sprite {
	private var list:Vector.<Circle>;
	private var del:Delaunay;
	private var matrix:Matrix=new Matrix();
	private var s:Shader;
	public function Del(l:Vector.<Circle>):void {
		var sdata:Array = [165,1,0,0,0,164,18,0,84,104,114,101,101,80,111,105,110,116,71,114,97,100,105,101,110,116,160,12,110,97,109,101,115,112,97,99,101,0,101,120,112,101,114,105,109,101,110,116,97,108,0,160,12,118,101,110,100,111,114,0,109,97,107,99,0,160,8,118,101,114,115,105,111,110,0,1,0,160,12,100,101,115,99,114,105,112,116,105,111,110,0,67,114,101,97,116,101,115,32,97,32,103,114,97,100,105,101,110,116,32,102,105,108,108,32,117,115,105,110,103,32,116,104,114,101,101,32,115,112,101,99,105,102,105,101,100,32,112,111,105,110,116,115,32,97,110,100,32,99,111,108,111,114,115,46,0,161,1,2,0,0,12,95,79,117,116,67,111,111,114,100,0,161,1,2,0,0,3,112,111,105,110,116,49,0,162,2,109,105,110,86,97,108,117,101,0,0,0,0,0,0,0,0,0,162,2,109,97,120,86,97,108,117,101,0,69,122,0,0,69,122,0,0,162,2,100,101,102,97,117,108,116,86,97,108,117,101,0,0,0,0,0,0,0,0,0,161,1,4,1,0,15,99,111,108,111,114,49,0,162,4,100,101,102,97,117,108,116,86,97,108,117,101,0,63,128,0,0,0,0,0,0,0,0,0,0,63,128,0,0,161,1,2,2,0,12,112,111,105,110,116,50,0,162,2,109,105,110,86,97,108,117,101,0,0,0,0,0,0,0,0,0,162,2,109,97,120,86,97,108,117,101,0,69,122,0,0,69,122,0,0,162,2,100,101,102,97,117,108,116,86,97,108,117,101,0,0,0,0,0,67,72,0,0,161,1,4,3,0,15,99,111,108,111,114,50,0,162,4,100,101,102,97,117,108,116,86,97,108,117,101,0,0,0,0,0,63,128,0,0,0,0,0,0,63,128,0,0,161,1,2,2,0,3,112,111,105,110,116,51,0,162,2,109,105,110,86,97,108,117,101,0,0,0,0,0,0,0,0,0,162,2,109,97,120,86,97,108,117,101,0,69,122,0,0,69,122,0,0,162,2,100,101,102,97,117,108,116,86,97,108,117,101,0,67,72,0,0,0,0,0,0,161,1,4,4,0,15,99,111,108,111,114,51,0,162,4,100,101,102,97,117,108,116,86,97,108,117,101,0,0,0,0,0,0,0,0,0,63,128,0,0,63,128,0,0,161,2,4,5,0,15,100,115,116,0,29,6,0,128,2,0,0,0,2,6,0,128,0,0,128,0,29,6,0,64,0,0,192,0,2,6,0,64,2,0,192,0,29,6,0,32,6,0,0,0,3,6,0,32,6,0,64,0,29,6,0,128,0,0,128,0,2,6,0,128,2,0,128,0,29,6,0,64,2,0,64,0,2,6,0,64,0,0,192,0,29,6,0,16,6,0,0,0,3,6,0,16,6,0,64,0,29,6,0,128,6,0,128,0,2,6,0,128,6,0,192,0,24,6,0,64,6,0,0,0,29,6,0,128,6,0,64,0,29,6,0,64,2,0,128,0,2,6,0,64,0,0,128,0,29,6,0,32,0,0,192,0,2,6,0,32,2,0,64,0,29,6,0,16,6,0,64,0,3,6,0,16,6,0,128,0,29,6,0,64,0,0,128,0,2,6,0,64,2,0,0,0,29,6,0,32,2,0,192,0,2,6,0,32,0,0,192,0,29,7,0,128,6,0,64,0,3,7,0,128,6,0,128,0,29,6,0,64,6,0,192,0,2,6,0,64,7,0,0,0,24,6,0,32,6,0,64,0,29,6,0,64,6,0,128,0,29,6,0,32,2,0,128,0,2,6,0,32,2,0,0,0,29,6,0,16,2,0,64,0,2,6,0,16,0,0,192,0,29,7,0,128,6,0,128,0,3,7,0,128,6,0,192,0,29,6,0,32,2,0,0,0,2,6,0,32,0,0,128,0,29,6,0,16,2,0,192,0,2,6,0,16,2,0,64,0,29,7,0,64,6,0,128,0,3,7,0,64,6,0,192,0,29,6,0,32,7,0,0,0,2,6,0,32,7,0,64,0,24,6,0,16,6,0,128,0,29,6,0,32,6,0,192,0,29,7,0,193,0,0,16,0,29,6,0,16,2,0,0,0,2,6,0,16,0,0,128,0,29,7,0,32,0,0,192,0,2,7,0,32,7,0,64,0,29,7,0,16,6,0,192,0,3,7,0,16,7,0,128,0,29,6,0,16,0,0,128,0,2,6,0,16,7,0,0,0,29,7,0,32,2,0,64,0,2,7,0,32,0,0,192,0,29,8,0,128,6,0,192,0,3,8,0,128,7,0,128,0,29,6,0,16,7,0,192,0,2,6,0,16,8,0,0,0,24,7,0,32,6,0,192,0,29,6,0,16,7,0,128,0,29,7,0,32,2,0,128,0,2,7,0,32,0,0,128,0,29,7,0,16,0,0,192,0,2,7,0,16,7,0,64,0,29,8,0,128,7,0,128,0,3,8,0,128,7,0,192,0,29,7,0,32,0,0,128,0,2,7,0,32,7,0,0,0,29,7,0,16,2,0,192,0,2,7,0,16,0,0,192,0,29,8,0,64,7,0,128,0,3,8,0,64,7,0,192,0,29,7,0,32,8,0,0,0,2,7,0,32,8,0,64,0,24,7,0,16,7,0,128,0,29,7,0,32,7,0,192,0,29,7,0,16,2,0,128,0,2,7,0,16,2,0,0,0,29,8,0,128,2,0,64,0,2,8,0,128,7,0,64,0,29,8,0,64,7,0,192,0,3,8,0,64,8,0,0,0,29,7,0,16,2,0,0,0,2,7,0,16,7,0,0,0,29,8,0,128,2,0,192,0,2,8,0,128,2,0,64,0,29,8,0,32,7,0,192,0,3,8,0,32,8,0,0,0,29,7,0,16,8,0,64,0,2,7,0,16,8,0,128,0,24,8,0,128,7,0,192,0,29,7,0,16,8,0,0,0,29,8,0,243,1,0,27,0,3,8,0,243,7,0,255,0,4,9,0,243,6,0,170,0,3,9,0,243,8,0,27,0,29,8,0,243,3,0,27,0,3,8,0,243,7,0,170,0,4,10,0,243,6,0,85,0,3,10,0,243,8,0,27,0,29,8,0,243,9,0,27,0,1,8,0,243,10,0,27,0,29,9,0,243,4,0,27,0,3,9,0,243,6,0,255,0,4,10,0,243,6,0,0,0,3,10,0,243,9,0,27,0,29,9,0,243,8,0,27,0,1,9,0,243,10,0,27,0,29,5,0,243,9,0,27,0];
		var ba:ByteArray = new ByteArray; for (var i:int = 0; i < sdata.length; i++) ba.writeByte (sdata [i]);
		s = new Shader (ba);
		
		list = l;
		del = new Delaunay(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
	}
	
	public function update():void {
		while(this.numChildren > 0) removeChildAt(this.numChildren - 1);
		del.clear();
		for each(var c:Circle in list) {
			var p:Point = new Point(c.x, c.y);
			del.insert(p);
		}
		var n:Vector.<Point> = del.getNode();
		var e:Vector.<Array> = del.getElem();
		for each(var ee:Array in e) {
			addChild(
				getLines(n[ee[0]], n[ee[1]], n[ee[2]],
					list[ee[0]].getLineColor(),list[ee[1]].getLineColor(),list[ee[2]].getLineColor()));
		}
	}
	
	private function getLines(p0:Point, p1:Point, p2:Point, c0:uint, c1:uint, c2:uint):Shape {
		
		s.data.point1.value = [p0.x, p0.y];
		s.data.point2.value = [p1.x, p1.y];
		s.data.point3.value = [p2.x, p2.y];
		s.data.color1.value = [((c0 & 0xFF0000) >> 16) / 255.0, ((c0 & 0x00FF00) >>  8) / 255.0, (c0 & 255) / 255.0, 1.0];
		s.data.color2.value = [((c1 & 0xFF0000) >> 16) / 255.0, ((c1 & 0x00FF00) >>  8) / 255.0, (c1 & 255) / 255.0, 1.0];
		s.data.color3.value = [((c2 & 0xFF0000) >> 16) / 255.0, ((c2 & 0x00FF00) >>  8) / 255.0, (c2 & 255) / 255.0, 1.0];
		var ret:Shape = new Shape();
		ret.graphics.beginShaderFill (s);
		ret.graphics.moveTo (p0.x, p0.y);
		ret.graphics.lineTo (p1.x, p1.y);
		ret.graphics.lineTo (p2.x, p2.y);
		ret.graphics.endFill ();
		/*ret.graphics.lineStyle(1, 0x444444);
		ret.graphics.moveTo(p0.x, p0.y);
		var tp:Number = Math.min(20 / dist(p0, p1), 1.0);
		ret.graphics.lineGradientStyle(GradientType.LINEAR, [c0,c1], [tp,tp], [0, 255], updateMatrix(p0,p1)); 
		ret.graphics.lineTo(p1.x, p1.y);
		tp = Math.min(20 / dist(p1, p2), 1.0);
		ret.graphics.lineGradientStyle(GradientType.LINEAR, [c1,c2], [tp,tp], [0, 255], updateMatrix(p1,p2)); 
		ret.graphics.lineTo(p2.x, p2.y);
		tp = Math.min(20 / dist(p2, p0), 1.0);
		ret.graphics.lineGradientStyle(GradientType.LINEAR, [c2, c0], [tp, tp], [0, 255], updateMatrix(p2,p0)); 
		ret.graphics.lineTo(p0.x, p0.y);*/
		return ret;
	}
	
	private function dist(p0:Point,p1:Point):Number {
		var xx:Number = p0.x - p1.x;
		var yy:Number = p0.y - p1.y;
		return Math.sqrt(xx*xx+yy*yy);
	}
	
	private function updateMatrix(p0:Point, p1:Point):Matrix {
		matrix.createGradientBox(p1.x - p0.x, p1.y - p0.y, 0, p0.x, p0.y);
		return matrix;
	}
}
import flash.geom.Point;
import flash.geom.Rectangle;

class Delaunay
{
	private var EPS:Number = 1e-16;
	private var rect:Rectangle;
	private var min:Number;
	private var max:Number;
	private var data:Vector.<Point>;
	private var node:Vector.<Point>;
	private var elem:Array;
	private var map:Array;
	private var stack:Array;
	private var boundary:Array;
	private var boundaryID:Array;
	private var ids:int;
	private var bs:int;
	
	public function Delaunay(x:Number, y:Number, w:Number, h:Number ):void {
		rect= new Rectangle(x, y, w, h);
		min = Math.min(x,y,x+w,y+h);
		max = Math.max(x,y,x+w,y+h);
		data=new Vector.<Point>();
		node=new Vector.<Point>();
		elem=new Array();
		map=new Array();
		stack=new Array();
		boundary=new Array();
		boundaryID=new Array();
		node.push(new Point(-1.23,-0.5));
		node.push(new Point(2.23,-0.5));
		node.push(new Point(0.5,2.5));
		elem.push(new Array(0,1,2));
		map.push(new Array(-1,-1,-1));
		ids=0;
		bs=1;
	}
	
	public function clear():void {
		data=new Vector.<Point>();
		node=new Vector.<Point>();
		elem=new Array();
		map=new Array();
		stack=new Array();
		boundary=new Array();
		boundaryID=new Array();
		node.push(new Point(-1.23,-0.5));
		node.push(new Point(2.23,-0.5));
		node.push(new Point(0.5,2.5));
		elem.push(new Array(0,1,2));
		map.push(new Array( -1, -1, -1));
		ids=0;
		bs=1;
	}
	
	private function getTriangleById():Array {
		var et:Array=new Array();
		var id:int=0;
		for(var i:int=0;i<elem.length;i++){
			if(!checkBounds(i)){
				et.push(-1);
			}else if(!checkBoundaryState(i)){
				et.push(-1);
			}else{
				et.push(id++);
			}
		}
		var ee:Array=new Array();
		for(i=0;i<et.length;i++){
			var e:Array=this.elem[i];
			if(et[i]!=-1){
				ee.push(new Array(e[0]-3,e[1]-3,e[2]-3));
			}
		}
		return ee;
	}
	private function getTriangleMapById():Array {
		var et:Array=new Array();
		var id:int=0;
		for(var i:int=0;i<elem.length;i++){
			if(!checkBounds(i)){
				et.push(-1);
			}else if(!this.checkBoundaryState(i)){
				et.push(-1);
			}else{
				et.push(id++);
			}
		}
		var ee:Array=new Array();
		var tp:Array=new Array();
		for(i=0;i<et.length;i++){
			var m:Array=map[i];
			if(et[i]!=-1){
				for(var j:int=0;j<m.length;j++){
					if(m[j]==-1){
						tp[j]=-1;
					}else{
						tp[j]=et[m[j]];
					}
				}
				ee.push(new Array(tp[0],tp[1],tp[2]));
			}
		}
		return ee;
	}
	
	private function isLeft(a:Point,b:Point,p:Point):Number{
		var v0:Number=(a.y-p.y)*(b.x-p.x);
		var v1:Number=(a.x-p.x)*(b.y-p.y);
		if(Math.abs(v1-v0)<this.EPS){
			return 0;
		}else{
			return (v1-v0);
		}
	}
	
	public function getLocation(id:int, p:Point):int {
		var e:Array=elem[id];
		for(var i:int=0;i<e.length;i++){
			var a:Point=node[e[i]];
			var b:Point=node[e[(i+1)%3]];
			if(isLeft(a,b,p)<0){
				var n:int=map[id][i];
				if(n==-1){
					return -1;
				}
				return getLocation(n,p);
			}
		}
		return id;
	}
	
	private function checkBoundaryState(id:int):Boolean {
		if(bs>1){
			if(!checkBounds(id))return false;
		}
		var e:Array=elem[id];
		for (var i:int = 0; i < e.length; i++) {
			if(typeof boundaryID[e[i]]=="undefined")continue;
			var b0:int = boundaryID[e[i]];
			if(typeof boundaryID[e[(i + 1) % 3]]=="undefined")continue;
			var b1:int = boundaryID[e[(i + 1) % 3]];
			if (b0 - b1 == 0) {
				if(typeof boundary[e[(i + 1) % 3]]=="undefined")continue;
				var v0:int = boundary[e[(i + 1) % 3]];
				if(v0==e[i]){
					return false;
				}
			}
		}
		return true;
	}
	
	private function edge(elemId:int, targetId:int, mp:Array ):int {
		var j:Array=mp[elemId];
		for(var i:int=0;i<j.length;i++){
			if(j[i]==targetId)return i;
		}
		return -1;
	}
	
	private function isSwap(aId:int , bId:int, cId:int, pId:int):Boolean {
		var x13:Number=node[aId].x-node[cId].x;
		var y13:Number=node[aId].y-node[cId].y;
		var x23:Number=node[bId].x-node[cId].x;
		var y23:Number=node[bId].y-node[cId].y;
		var x1p:Number=node[aId].x-node[pId].x;
		var y1p:Number=node[aId].y-node[pId].y;
		var x2p:Number=node[bId].x-node[pId].x;
		var y2p:Number=node[bId].y-node[pId].y;
		var cosa:Number=x13*x23+y13*y23;
		var cosb:Number=x2p*x1p+y1p*y2p;
		if(cosa>=0&&cosb>=0){
			return false;
		}else if(cosa<0&&cosb<0){
			return true;
		}else{
			var sina:Number=x13*y23-x23*y13;
			var sinb:Number=x2p*y1p-x1p*y2p;
			if((sina*cosb+sinb*cosa)<0){
				return true;
			}else{
				return false;
			}
		}
	}
	
	public function getNode():Vector.<Point> {
		return data;
	}
	
	public function getElem():Vector.<Array> {
		var ret:Vector.<Array> = new Vector.<Array>();
		for each(var e:Array in elem) {
			if(e[0]<3||e[1]<3||e[2]<3){
				continue;
			}else{
				ret.push(new Array(e[0]-3, e[1]-3, e[2]-3));
			}
		}
		return ret;
	}
	
	private function normalize(x:Number, y:Number):Point {
		var xx:Number = (x - min) / (max - min);
		var yy:Number = (y - min) / (max - min);
		return new Point(xx,yy);
	}
	
	private function checkBounds(id:int):Boolean {
		var e:Array=elem[id];
		if(e[0]<3||e[1]<3||e[2]<3){
			return false;
		}else{
			return true;
		}
	}
	
	public function insert(pos:Point):Boolean {
		if (!rect.containsPoint(pos)) return false;
		var p:Point=normalize(pos.x,pos.y);
		ids = getLocation(ids, p);
		if(ids==-1){
			ids=0;
			return false;
		}else {
			if (checkBoundaryState(ids)) {
				data.push(pos);
				node.push(p);
				process(ids, node.length - 1);
				return true;
			}else {
				return false;
			}
		}
	}
	
	public function addBoundary(arg:Array,isClose:Boolean):void {
		var sz:int= node.length;
		for(var i:int=0;i<arg.length;i++){
			var p:Point=normalize(arg[i].x,arg[i].y);
			ids=getLocation(ids,p);
			if(ids==-1){
				ids=0;
				continue;
			}
			if(checkBoundaryState(ids)){
				data.push(arg[i]);
				node.push(p);
				if(i>0){
					boundary[sz+i-1]=sz+i;
					boundaryID[sz+i-1]=bs;
				}
				process(ids,node.length-1);
			}
		}
		if(isClose){
			boundary[node.length-1]=sz;
			boundaryID[node.length-1]=bs;
		}
		bs++;
	}
	
	private function isBoundary(nodeId0:int , nodeId1:int):Boolean {
		var p:int=boundary[nodeId0];
		if(!(typeof boundary[nodeId0]=="undefined")&&p==nodeId1)return true;
		p=boundary[nodeId1];
		if(!(typeof boundary[nodeId1]=="undefined")&&p==nodeId0){
			return true;
		}else{
			return false;
		}	
	}
	
	private function process(elemId:int, nodeId:int):void {
		var nn:int=elem.length;
		var em:Array=elem[elemId];
		var te:Array=new Array(em[0],em[1],em[2]);
		var e0:Array=new Array(nodeId,em[0],em[1]);
		var e1:Array=new Array(nodeId,em[1],em[2]);
		var e2:Array=new Array(nodeId,em[2],em[0]);
		em[0]=e0[0];em[1]=e0[1];em[2]=e0[2];
		elem.push(e1);
		elem.push(e2);
		var jm:Array=map[elemId];
		var tmp:Array=new Array(jm[0],jm[1],jm[2]);
		var j0:Array=new Array(nn+1,jm[0],nn);
		var j1:Array=new Array(elemId,jm[1],nn+1);
		var j2:Array=new Array(nn,jm[2],elemId);
		jm[0]=j0[0];jm[1]=j0[1];jm[2]=j0[2];
		map.push(j1);
		map.push(j2);
		if(tmp[0]!=-1){
			if(!isBoundary(te[0],te[1]))stack.push(elemId);
		}
		if(tmp[1]!=-1){
			var ix:int=edge(tmp[1],elemId,map);
			map[tmp[1]][ix]=nn;
			if(!isBoundary(te[1],te[2]))stack.push(nn);
		}
		if(tmp[2]!=-1){
			ix=edge(tmp[2],elemId,map);
			map[tmp[2]][ix]=nn+1;
			if(!isBoundary(te[2],te[0]))stack.push(nn+1);
		}
		while (stack.length > 0) {
			var il:int=stack.pop();
			var ir:int=map[il][1];
			var ierl:int=edge(ir,il,map);
			var iera:int=(ierl+1)%3;
			var ierb:int=(iera+1)%3;
			var iv1:int=elem[ir][ierl];
			var iv2:int=elem[ir][iera];
			var iv3:int=elem[ir][ierb];
			if(isSwap(iv1,iv2,iv3,nodeId)){
				var ja:int=map[ir][iera];
				var jb:int=map[ir][ierb];
				var jc:int=map[il][2];
				elem[il][2]=iv3;
				map[il][1]=ja;
				map[il][2]=ir;
				var picElem:Array=elem[ir];
				picElem[0]=nodeId;picElem[1]=iv3;picElem[2]=iv1;
				picElem=map[ir];
				picElem[0]=il;picElem[1]=jb;picElem[2]=jc;
				if(ja!=-1){
					ix=edge(ja,ir,map);
					map[ja][ix]=il;
					if(!isBoundary(iv2,iv3))stack.push(il);
				}
				if(jb!=-1){
					if(!isBoundary(iv3,iv1))stack.push(ir);
				}
				if(jc!=-1){
					ix=edge(jc,il,this.map);
					map[jc][ix]=ir;
				}
			}
		}
	}
}