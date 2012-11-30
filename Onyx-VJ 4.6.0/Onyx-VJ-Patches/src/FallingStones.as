/**
 * Copyright Yukulele ( http://wonderfl.net/user/Yukulele )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/zVDL
 */

// forked from Yukulele's Falling stones
package {
	import Box2D.Common.b2Settings;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import flash.utils.getTimer;

	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class FallingStones extends Patch {
		private var the_world:b2World;
		private var timerOld:int;
		private var time_count:Timer = new Timer(500);
		private var mouseJoint:b2MouseJoint;
		private var mousePVec:b2Vec2 = new b2Vec2();
		private var myBoundaryListener:BoundaryListener = new BoundaryListener();
		private const echelle:Number = 30;
		private var mouseJointGraph:Shape = new Shape;
		public function FallingStones() {
			/*timerOld = getTimer();
			var environment:b2AABB = new b2AABB();
			environment.lowerBound.Set(0-2, -10);
			environment.upperBound.Set(15.5 + 2, 17);
			var gravity:b2Vec2=new b2Vec2(0.0,9.81);
			the_world = new b2World(environment, gravity, false);
			
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			debug_draw.m_sprite=debug_sprite;
			debug_draw.m_drawScale=echelle;
			debug_draw.m_fillAlpha = 0.5;
			debug_draw.m_lineThickness=0;
			debug_draw.m_drawFlags =
				b2DebugDraw.e_jointBit|
				b2DebugDraw.e_shapeBit|
				0;
			
			the_world.SetDebugDraw(debug_draw);
			cree_polygone(
				{
					x:[0, 15, 14, 13, 2, 1],
					y:[5, 5,  3,  4,  4, 3]
				},0.25,10,true)
			
			the_world.SetBoundaryListener(myBoundaryListener);
			time_count.addEventListener(TimerEvent.TIMER, on_time);
			time_count.start();

			addEventListener(MouseEvent.MOUSE_DOWN, createMouse);
			addEventListener(MouseEvent.MOUSE_UP, destroyMouse);*/
		}
		private function on_time(e:Event):void 
		{
			
			var nbrangle:int = Math.floor(3 + Math.random() * 10);// (b2Settings.b2_maxPolygonVertices - 3));
			var rayon:Number = Math.random()+.2;
			var dataspoly:Object={x:[],y:[]};
			for (var i:int = 0; i < nbrangle; i++)
			{
				var dist:Number=2*Math.PI*i/nbrangle;
				var r:Number=rayon*(Math.random())*2+.2;
				dataspoly.x.push( Math.cos(dist)*r);
				dataspoly.y.push(-Math.sin(dist)*r);
			}
			cree_polygone(dataspoly, 7.75, -5);
			
		}
		private function cree_polygone(points:Object, x:Number = 0, y:Number = 0, fixe:Boolean = false):b2Body
		{
			var poly:Array=Triangulator.polygonizeTriangles(Triangulator.triangulatePolygonFromFlatArray(points.x, points.y));
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.position.Set(x, y);
			bodydef.isBullet = true;
			var body:b2Body = the_world.CreateBody(bodydef);
			
			for (var i:int = 0; i < poly.length-1 ; i++)
			{
				var p:Polygon = poly[i];
				var b2poly:b2PolygonDef = new b2PolygonDef();
				b2poly.friction = .3;
				b2poly.restitution = .3;
				if(!fixe)
					b2poly.density = 100;	
				b2poly.vertexCount = p.nVertices;
				
				for (var j:int = 0; j < p.nVertices; j++)
				{
					if (p.x[j] && p.y[j] && b2poly.vertices[j]) b2poly.vertices[j].Set(p.x[j], p.y[j]);
				}
				body.CreateShape(b2poly);
			}
			body.SetMassFromShapes();
			var s:Shape=dessiner_polygone(points);
			body.SetUserData(s);
			positionner(body);
			addChildAt(s,0);
			return body;
		}
		private function dessiner_polygone(points:Object):Shape
		{
			//var bd:BitmapData = new BitmapData(2, 2,true);
			var bd2:BitmapData = new BitmapData(2, 2,true);
			var c1:uint = Math.random() * 0xffffff;
			/*bd.setPixel(0, 0, 0);
			bd.setPixel32(0, 1, c1|0xff000000);
			bd.setPixel32(1, 0, c1|0x88000000);
			bd.setPixel(1, 1, 0);*/
			var s:Shape=new Shape;
			//s.graphics.lineStyle(2);
			//s.graphics.beginFill(Math.random() * 0xffffff,1);
			//s.graphics.lineBitmapStyle(bd,new Matrix(0.9397,0.3420,-0.3420,0.9397),true,true);
			c1 = Math.random() * 0xffffff;
			bd2.setPixel(0, 0, 0);
			bd2.setPixel32(0, 1, c1|0xff000000);
			bd2.setPixel32(1, 0, c1|0x88000000);
			bd2.setPixel(1, 1, 0);
			s.graphics.beginBitmapFill(bd2,new Matrix(0.8,0.1,-0.1,0.8),true,true);
			s.graphics.moveTo(points.x[0]*echelle,points.y[0]*echelle);
			for(var i:int=1; i<points.x.length;i++)
			{
				s.graphics.lineTo(points.x[i]*echelle,points.y[i]*echelle);
			}
			//s.graphics.lineTo(points.x[0]*echelle,points.y[0]*echelle);
			s.graphics.endFill();
			return s;
			
		}
		private var temps:int;
		override public function render(info:RenderInfo):void {
			temps = getTimer() - timerOld;
			timerOld = getTimer();
			//the_world.Step(temps/1000, 10);
			//the_world.Step(stage.frameRate/1000, 10);
			the_world.Step(25/1000, 10);
			
			myBoundaryListener.lastBodys().forEach(function(elm:b2Body, num:int, vect:Vector.<b2Body>):void {
				var joint:b2JointEdge = elm.GetJointList();
				while(joint)
				{
					if (joint.joint == mouseJoint)
						mouseJoint = null;
					the_world.DestroyJoint(joint.joint);
					joint = joint.next;
				}
				removeChild(elm.GetUserData());
				the_world.DestroyBody(elm);
				
			});
			var body:b2Body = the_world.GetBodyList();
			while (body)
			{
				positionner(body);
				body = body.GetNext();
			}
			if (mouseJoint) {
				
				var mouseXWorldPhys:Number=mouseX/echelle;
				var mouseYWorldPhys:Number=mouseY/echelle;
				var p2:b2Vec2=new b2Vec2(mouseXWorldPhys,mouseYWorldPhys);
				mouseJoint.SetTarget(p2);
				mouseJointGraph.graphics.clear();
				var v1:b2Vec2 = mouseJoint.GetAnchor1().Copy();
				var v2:b2Vec2 = mouseJoint.GetAnchor2();
				mouseJointGraph.graphics.lineStyle(3, 0xff0000);
				mouseJointGraph.graphics.moveTo(v1.x * echelle, v1.y * echelle);
				mouseJointGraph.graphics.lineTo(v2.x * echelle, v2.y * echelle);
				/*var cx:Number = (v1.x + v2.x) / 2;
				var cy:Number = (v1.y + v2.y) / 2;
				v1.Subtract(v2);
				var rayon:Number = v1.Length()/2;
				mouseJointGraph.graphics.lineStyle(rayon*echelle/10, 0x00ff00);
				mouseJointGraph.graphics.drawCircle(cx*echelle, cy*echelle,rayon*echelle)*/
				if(mouseJointGraph.parent===null)
					addChild(mouseJointGraph);
			}
			else if(mouseJointGraph.parent===this)
			{
				removeChild(mouseJointGraph);
			}
			info.render(mouseJointGraph);
		}
		public function createMouse(evt:MouseEvent):void {
			var body:b2Body=GetBodyAtMouse();
			if (body) {
				var mouseJointDef:b2MouseJointDef=new b2MouseJointDef  ;
				mouseJointDef.body1=the_world.GetGroundBody();
				mouseJointDef.body2=body;
				mouseJointDef.target.Set(mouseX/echelle, mouseY/echelle);
				mouseJointDef.maxForce=100000;
				mouseJointDef.timeStep=temps/1000;
				mouseJoint=the_world.CreateJoint(mouseJointDef) as b2MouseJoint;
			}
		}
		public function destroyMouse(evt:MouseEvent=null):void {
			if (mouseJoint) {
				the_world.DestroyJoint(mouseJoint);
				mouseJoint=null;
			}
		}
		public function GetBodyAtMouse(includeStatic:Boolean=false):b2Body {
			var mouseXWorldPhys:Number = (mouseX)/echelle;
			var mouseYWorldPhys:Number = (mouseY)/echelle;
			mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
			var k_maxCount:int=10;
			var shapes:Array = new Array();
			var count:int=the_world.Query(aabb,shapes,k_maxCount);
			var body:b2Body=null;
			for (var i:int = 0; i < count; ++i) {
				if (shapes[i].GetBody().IsStatic()==false||includeStatic) {
					var tShape:b2Shape=shapes[i] as b2Shape;
					var inside:Boolean=tShape.TestPoint(tShape.GetBody().GetXForm(),mousePVec);
					if (inside) {
						body=tShape.GetBody();
						break;
					}
				}
			}
			return body;
		}
		private function positionner(body:b2Body):void
		{
			var graphic:* = body.GetUserData();
			if (!(graphic is DisplayObject))
				return;
			var bodyPosition:b2Vec2= body.GetPosition();
			var bodyRotation:Number = body.GetAngle();
			
			graphic.rotation=0;
			var m:Matrix=graphic.transform.matrix;
			
			m.tx = 0;
			m.ty = 0;
			m.rotate(bodyRotation);
			
			m.tx += bodyPosition.x * echelle;
			m.ty += bodyPosition.y * echelle;
			
			graphic.transform.matrix = m;
		}
	}
}
import Box2D.Dynamics.b2BoundaryListener;
import Box2D.Dynamics.b2Body;
import Box2D.Dynamics.b2World;
class BoundaryListener extends b2BoundaryListener
{
	private var bodys:Vector.<b2Body>;
	public function BoundaryListener()
	{
		bodys = new Vector.<b2Body>;
	}
	public override function Violation(body:b2Body):void 
	{
		bodys.push(body);
	}
	public function lastBodys():Vector.<b2Body>
	{
		var bodys2:Vector.<b2Body> = bodys;
		bodys = new Vector.<b2Body>;
		return bodys2;
	}
}

import flash.display.DisplayObject;
import Box2D.Common.Math.b2Vec2;
import flash.geom.Matrix;

import flash.geom.Point;

class Triangulator {
	
	public function Triangulator()
	{	
	}
	
	/* give it an array of points (vertexes)
	* returns an array of Triangles
	* */
	public static function triangulatePolygon(v:Array):Array
	{
		var xA:Array = new Array();
		var yA:Array = new Array();
		
		for each(var p:Point in v) {
			xA.push(p.x);
			yA.push(p.y);
		}
		
		return(triangulatePolygonFromFlatArray(xA, yA));
	}
	
	/* give it a list of vertexes as flat arrays
	* returns an array of Triangles
	* */
	public static function triangulatePolygonFromFlatArray(xv:Array, yv:Array):Array
	{
		if (xv.length < 3 || yv.length < 3 || yv.length != xv.length) {
			trace("Please make sure both arrays or of the same length and have at least 3 vertices in them!");
			return null;
		}
		
		var i:int = 0;
		var vNum:int = xv.length;
		
		var buffer:Array = new Array();
		var bufferSize:int = 0;
		var xrem:Array = new Array();
		var yrem:Array = new Array();
		
		for (i = 0; i < vNum; ++i) {
			xrem[i] = xv[i];
			yrem[i] = yv[i];
		}
		
		while (vNum > 3){
			//Find an ear
			var earIndex:int = -1;
			for (i = 0; i < vNum; ++i) {
				if (isEar(i, xrem, yrem)) {
					earIndex = i;
					break;
				}
			}
			
			//If we still haven't found an ear, we're screwed.
			//The user did Something Bad, so return null.
			//This will probably crash their program, since
			//they won't bother to check the return value.
			//At this we shall laugh, heartily and with great gusto.
			if (earIndex == -1) {
				trace('no ear found');
				return null;
			}
			
			//Clip off the ear:
			//  - remove the ear tip from the list
			
			//Opt note: actually creates a new list, maybe
			//this should be done in-place instead.  A linked
			//list would be even better to avoid array-fu.
			--vNum;
			var newx:Array = new Array();
			var newy:Array = new Array();
			var currDest:int = 0;
			for (i = 0; i < vNum; ++i) {
				if (currDest == earIndex) ++currDest;
				newx[i] = xrem[currDest];
				newy[i] = yrem[currDest];
				++currDest;
			}
			
			//  - add the clipped triangle to the triangle list
			var under:int = (earIndex == 0)?(xrem.length - 1):(earIndex - 1);
			var over:int = (earIndex == xrem.length - 1)?0:(earIndex + 1);
			var toAdd:Triangle = new Triangle(xrem[earIndex], yrem[earIndex], xrem[over], yrem[over], xrem[under], yrem[under]);
			buffer[bufferSize] = toAdd;
			++bufferSize;
			
			//  - replace the old list with the new one
			xrem = newx;
			yrem = newy;
		}
		
		var toAddMore:Triangle = new Triangle(xrem[1], yrem[1], xrem[2], yrem[2], xrem[0], yrem[0]);
		buffer[bufferSize] = toAddMore;
		++bufferSize;
		
		var res:Array = new Array();
		for (i = 0; i < bufferSize; i++) {
			res[i] = buffer[i];
		}
		return res;
	}
	
	/* takes: array of Triangles 
	* returns: array of Polygons
	* */
	public static function polygonizeTriangles(triangulated:Array):Array
	{
		var polys:Array;
		var polyIndex:int = 0;
		
		var i:int = 0;
		
		if (triangulated == null){
			return null;
		} else {
			polys = new Array();
			var covered:Array = new Array();
			for (i = 0; i < triangulated.length; i++) {
				covered[i] = false;
			}
			
			var notDone:Boolean = true;
			
			while(notDone){
				var currTri:int = -1;
				for (i = 0; i < triangulated.length; i++) {
					if (covered[i]) continue;
					currTri = i;
					break;
				}
				if (currTri == -1){
					notDone = false;
				} else{
					var poly:Polygon = new Polygon(triangulated[currTri].x, triangulated[currTri].y);
					covered[currTri] = true;
					for (i = 0; i < triangulated.length; i++) {
						if (covered[i]) continue;
						var newP:Polygon = poly.add(triangulated[i]);
						if (newP == null) continue;
						if (newP.isConvex()){
							poly = newP;
							covered[i] = true;
						}
					}
				}
				polys[polyIndex] = poly;
				polyIndex++;
			}
		}
		
		var ret:Array = new Array();
		for (i = 0; i < polyIndex; i++) {
			ret[i] = polys[i];
		}
		return ret;
	}
	
	//Checks if vertex i is the tip of an ear
	/*
	* */
	public static function isEar(i:int, xv:Array, yv:Array):Boolean
	{
		var dx0:Number, dy0:Number, dx1:Number, dy1:Number;
		dx0 = dy0 = dx1 = dy1 = 0;
		if (i >= xv.length || i < 0 || xv.length < 3) {
			return false;
		}
		var upper:int = i + 1;
		var lower:int = i - 1;
		if (i == 0){
			dx0 = xv[0] - xv[xv.length - 1];
			dy0 = yv[0] - yv[yv.length - 1];
			dx1 = xv[1] - xv[0];
			dy1 = yv[1] - yv[0];
			lower = xv.length - 1;
		} else if (i == xv.length - 1) {
			dx0 = xv[i] - xv[i - 1];
			dy0 = yv[i] - yv[i - 1];
			dx1 = xv[0] - xv[i];
			dy1 = yv[0] - yv[i];
			upper = 0;
		} else{
			dx0 = xv[i] - xv[i - 1];
			dy0 = yv[i] - yv[i - 1];
			dx1 = xv[i + 1] - xv[i];
			dy1 = yv[i + 1] - yv[i];
		}
		
		var cross:Number = (dx0*dy1)-(dx1*dy0);
		if (cross > 0) return false;
		var myTri:Triangle = new Triangle(xv[i], yv[i], xv[upper], yv[upper], xv[lower], yv[lower]);
		
		for (var j:int = 0; j < xv.length; ++j) {
			if (!(j == i || j == lower || j == upper)) {
				if (myTri.isInside(xv[j], yv[j])) return false;
			}
		}
		return true;
	}	
}
class Triangle {
	
	public var x:Array = new Array();
	public var y:Array = new Array();
	
	public function Triangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number) {
		
		var dx1:Number = x2-x1;
		var dx2:Number = x3-x1;
		var dy1:Number = y2-y1;
		var dy2:Number = y3-y1;
		var cross:Number = (dx1*dy2)-(dx2*dy1);
		var ccw:Boolean = (cross>0);
		if (ccw){
			x[0] = x1; x[1] = x2; x[2] = x3;
			y[0] = y1; y[1] = y2; y[2] = y3;
		} else{
			x[0] = x1; x[1] = x3; x[2] = x2;
			y[0] = y1; y[1] = y3; y[2] = y2;
		}			
	}
	
	public function isInside(_x:Number, _y:Number):Boolean{
		var vx2:Number = _x - x[0]; var vy2:Number = _y - y[0];
		var vx1:Number = x[1] - x[0]; var vy1:Number = y[1] - y[0];
		var vx0:Number = x[2] - x[0]; var vy0:Number = y[2] - y[0];
		
		var dot00:Number = vx0 * vx0 + vy0 * vy0;
		var dot01:Number = vx0 * vx1 + vy0 * vy1;
		var dot02:Number = vx0 * vx2 + vy0 * vy2;
		var dot11:Number = vx1 * vx1 + vy1 * vy1;
		var dot12:Number = vx1 * vx2 + vy1 * vy2;
		var invDenom:Number = 1.0 / (dot00 * dot11 - dot01 * dot01);
		var u:Number = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v:Number = (dot00 * dot12 - dot01 * dot02) * invDenom;
		
		return ((u > 0) && (v > 0) && (u + v < 1));
	}		
}

class Polygon {
	public var nVertices:int;
	public var x:Array = new Array();
	public var y:Array = new Array();
	
	public function Polygon(_x:Array, _y:Array = null)
	{
		if(_y == null) {
			_y = _x.y;
			_x = _x.x;
		}
		
		nVertices = _x.length;
		
		for (var i:int = 0; i < nVertices; ++i) {
			x[i] = _x[i];
			y[i] = _y[i];
		}
	}
	
	public function set(p:Polygon):void
	{
		nVertices = p.nVertices;
		x = new Array();
		y = new Array();
		for (var i:int = 0; i < nVertices; ++i) {
			x[i] = p.x[i];
			y[i] = p.y[i];
		}
	}
	
	/*
	* Assuming the polygon is simple, checks
	* if it is convex.
	*/
	public function isConvex():Boolean
	{
		var isPositive:Boolean = false;
		for (var i:int = 0; i < nVertices; ++i) {
			var lower:int = (i == 0)?(nVertices - 1):(i - 1);
			var middle:int = i;
			var upper:int = (i == nVertices - 1)?(0):(i + 1);
			var dx0:Number = x[middle] - x[lower];
			var dy0:Number = y[middle] - y[lower];
			var dx1:Number = x[upper]-x[middle];
			var dy1:Number = y[upper]-y[middle];
			var cross:Number = dx0 * dy1 - dx1 * dy0;
			//Cross product should have same sign
			//for each vertex if poly is convex.
			var newIsP:Boolean = (cross>0)?true:false;
			if (i == 0) {
				isPositive = newIsP;
			} else if (isPositive != newIsP){
				return false;
			}
		}
		return true;
	}
	
	/*
	* Tries to add a triangle to the polygon.
	* Returns null if it can't connect properly.
	* Assumes bitwise equality of join vertices.
	*/
	public function add(t:Triangle):Polygon
	{
		//First, find vertices that connect
		var firstP:int = -1; 
		var firstT:int = -1;
		var secondP:int = -1; 
		var secondT:int = -1;
		
		var i:int = 0;
		
		for (i = 0; i < nVertices; i++) {
			if (t.x[0] == this.x[i] && t.y[0] == this.y[i]){
				if (firstP == -1){
					firstP = i; firstT = 0;
				} else{
					secondP = i; secondT = 0;
				}
			} else if (t.x[1] == this.x[i] && t.y[1] == this.y[i]) {
				if (firstP == -1){
					firstP = i; firstT = 1;
				} else{
					secondP = i; secondT = 1;
				}
			} else if (t.x[2] == this.x[i] && t.y[2] == this.y[i]){
				if (firstP == -1){
					firstP = i; firstT = 2;
				} else{
					secondP = i; secondT = 2;
				}
			} else {
				//println(t.x[0]+" "+t.y[0]+" "+t.x[1]+" "+t.y[1]+" "+t.x[2]+" "+t.y[2]);
				//println(x[0]+" "+y[0]+" "+x[1]+" "+y[1]);
			}
		}
		
		//Fix ordering if first should be last vertex of poly
		if (firstP == 0 && secondP == nVertices - 1) {
			firstP = nVertices-1;
			secondP = 0;
		}
		
		//Didn't find it
		if (secondP == -1) return null;
		
		//Find tip index on triangle
		var tipT:int = 0;
		if (tipT == firstT || tipT == secondT) tipT = 1;
		if (tipT == firstT || tipT == secondT) tipT = 2;
		
		var newx:Array = new Array();
		var newy:Array = new Array();
		var currOut:int = 0;
		
		for (i = 0; i < nVertices; i++) {
			newx[currOut] = x[i];
			newy[currOut] = y[i];
			if (i == firstP){
				++currOut;
				newx[currOut] = t.x[tipT];
				newy[currOut] = t.y[tipT];
			}
			++currOut;
		}
		return new Polygon(newx, newy);
	}
	public function toString():String
	{
		var string:String = "\n[Polygon:";
		for (var i:int = 0; i < this.nVertices; i++)
		{
			string += "\n ["+this.x[i]+"\t"+this.y[i]+"],";
		}
		return string+"]";
	}
}