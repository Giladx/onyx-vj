/**
 * Copyright heroboy ( http://wonderfl.net/user/heroboy )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/68md
 */

// forked from abakane's forked from: Mosaic
// forked from Saqoosha's Mosaic
package
{
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Box2DMosaic extends Patch
	{
		private var view:View;
		public function Box2DMosaic()
		{
			view = new View();	
			addEventListener( MouseEvent.MOUSE_DOWN, onDown );
		}
		override public function render(info:RenderInfo):void		
		{				
			info.render(view);
		}
		private function onDown(e:MouseEvent):void {
			view.mx = e.localX; 
			view.my = e.localY; 

		}
	}
}


import Box2D.Collision.Shapes.b2CircleDef;
import Box2D.Collision.Shapes.b2PolygonDef;
import Box2D.Collision.b2AABB;
import Box2D.Common.Math.b2Vec2;
import Box2D.Dynamics.b2Body;
import Box2D.Dynamics.b2BodyDef;
import Box2D.Dynamics.b2DebugDraw;
import Box2D.Dynamics.b2World;

import EmbeddedAssets.AssetForBox2DImages;

import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.net.URLRequest;
import flash.system.LoaderContext;

import onyx.plugin.*;

class View extends Sprite {
	private static const NUM_CIRCLES:int = 400;
	private static const DEBUG_DRAW:Boolean = false;
	
	private static const TO_PHYSICS_SCALE:Number = 1.0 / 30.0;
	private static const TO_DRAW_SCALE:Number = 1 / TO_PHYSICS_SCALE;
	private static const ITERATIONS:int = 5;
	private static const TIME_STEP:Number = 1.0 / 30.0;
	
	private static const STEP1_SIMULATE:int = 0;
	private static const STEP2_WAIT_FOR_SLEEP:int = 1;
	private static const STEP3_RECONSTRUCTION:int = 2;
	private static const SCALE_DOWN:int = 80;
	
	private var _refImage:BitmapData;
	private var _refImage2:BitmapData;
	private var _world:b2World;
	private var _objects:Array = [];
	private var _frameCount:int = 0;
	private var _maxFrames:int;
	private var _step:int = STEP1_SIMULATE;
	private var _enterFrameHandler:Function;
	
	public var mx:Number = 320;
	public var my:Number = 240;
	
	public function View(){
		

		var mat:Matrix = new Matrix();
		mat.scale(1/SCALE_DOWN,1/SCALE_DOWN);
		_refImage = new AssetForBox2DImages();
		_refImage2 = new BitmapData(_refImage.width/SCALE_DOWN,_refImage.height/SCALE_DOWN,false,0);
		_refImage2.draw(_refImage,mat); 
		var worldAABB:b2AABB = new b2AABB();
		worldAABB.lowerBound.Set(-1000.0, -1000.0);
		worldAABB.upperBound.Set(1000.0, 1000.0);
		_world = new b2World(worldAABB, new b2Vec2(0.0, 10.0), true);
		_world.SetWarmStarting(true);
		
		_buildStaticBox(DISPLAY_WIDTH*0.5-DISPLAY_WIDTH/4, DISPLAY_HEIGHT*0.5, 10, 1000);
		_buildStaticBox(DISPLAY_WIDTH*0.5+DISPLAY_WIDTH/4, DISPLAY_HEIGHT*0.5, 10, 1000);
		_buildStaticBox(DISPLAY_WIDTH*0.5, DISPLAY_HEIGHT-100, 1000, 10);
/*		_buildStaticBox(100, DISPLAY_HEIGHT*0.5, 10, 1000);
		_buildStaticBox(365, DISPLAY_HEIGHT*0.5, 10, 1000);
		_buildStaticBox(DISPLAY_HEIGHT*0.5, 365, 1000, 10);*/
		
		if (DEBUG_DRAW) {
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.m_sprite = this;
			dbgDraw.m_drawScale = 30.0;
			dbgDraw.m_fillAlpha = 0.0;
			dbgDraw.m_lineThickness = 1.0;
			dbgDraw.m_drawFlags = 0xFFFFFFFF;
			_world.SetDebugDraw(dbgDraw);
		}
		
		_enterFrameHandler = _step1;
		
		addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);
	}
	
	
	private function _buildStaticBox(centerX:Number, centerY:Number, width:Number, height:Number):b2Body
	{
		var bodyDef:b2BodyDef = new b2BodyDef();
		bodyDef.position.Set(centerX * TO_PHYSICS_SCALE, centerY * TO_PHYSICS_SCALE);
		
		var boxDef:b2PolygonDef = new b2PolygonDef();
		boxDef.SetAsBox(width * TO_PHYSICS_SCALE / 2, height * TO_PHYSICS_SCALE / 2);
		boxDef.friction = 0.3;
		boxDef.density = 0;
		
		var body:b2Body = _world.CreateBody(bodyDef);
		body.CreateShape(boxDef);
		body.SetMassFromShapes();
		
		return body;
	}
	
	
	private function _buildDynamicCircle(centerX:Number, centerY:Number, radius:Number, graphic:DisplayObject = null):b2Body
	{
		var bodyDef:b2BodyDef = new b2BodyDef();
		bodyDef.position.Set(centerX * TO_PHYSICS_SCALE, centerY * TO_PHYSICS_SCALE);
		
		var circleDef:b2CircleDef = new b2CircleDef();
		circleDef.radius = radius * TO_PHYSICS_SCALE;
		circleDef.density = 1.0;
		circleDef.friction = 0.5;
		circleDef.restitution = 0.3;
		
		var body:b2Body = _world.CreateBody(bodyDef);
		body.CreateShape(circleDef);
		body.SetMassFromShapes();
		
		return body;
	}
	
	
	private function _onEnterFrame(event:Event):void {
		if (_enterFrameHandler is Function) {
			_enterFrameHandler();
		}
	}
	
	
	private function _step1():void {
		if (_frameCount % 2 == 0) {
			var px:Number = DISPLAY_WIDTH*0.5;
			var py:Number = -20;
			var r:Number = Math.random()*Math.random()*7 + 6;
			var b:b2Body = _buildDynamicCircle(px, py, r);
			var v:Number = (Math.random() - 0.5)*5;
			b.ApplyImpulse(new b2Vec2(v, 0), new b2Vec2());
			var sp:Recorder = new Recorder();
			sp.frameOffset = _frameCount;
			b.SetUserData(sp);
			_objects.push({
				px: px,
				py: py,
				r: r,
				v: v,
				b: b,
				sp: sp
			});
			addChild(sp);
			if (_objects.length == NUM_CIRCLES) {
				_step = STEP2_WAIT_FOR_SLEEP;
				_enterFrameHandler = _step2;
				_maxFrames = _frameCount;
				_frameCount = 0;
			}
		}
		_step2();
	}
	
	
	private function _step2():void {
		_world.Step(TIME_STEP, ITERATIONS);
		if (DEBUG_DRAW && _frameCount % 30 == 0) {
			_world.DrawDebugData();
		}
		
		for (var bb:b2Body = _world.GetBodyList(); bb; bb = bb.GetNext()){
			var rec:Recorder = bb.GetUserData() as Recorder;
			if (rec) {
				var pos:b2Vec2 = bb.GetPosition();
				rec.save(pos.x * TO_DRAW_SCALE, pos.y * TO_DRAW_SCALE);
			}
		}
		_frameCount++;
		
		if (_step == View.STEP2_WAIT_FOR_SLEEP && _frameCount > 300) {
			_enterFrameHandler = null;
			_step = STEP3_RECONSTRUCTION;
			graphics.clear();
			var n:int = _objects.length;
			for (var i:int = 0; i < n; ++i) {
				var info:Object = _objects[i];
				var b:b2Body = info.b;
				var p:b2Vec2 = b.GetPosition();
				var dx:Number = p.x * TO_DRAW_SCALE;
				var dy:Number = p.y * TO_DRAW_SCALE;
				var c:uint = _refImage.getPixel(dx/DISPLAY_WIDTH*_refImage.width, dy/DISPLAY_HEIGHT*_refImage.height);
				var sp:Recorder = info.sp;
				sp.draw(c, info.r);
				_objects[i] = sp;
			}
			_maxFrames += _frameCount;
			_frameCount = 0;

			var n:int = numChildren;
			while (n--) {
				removeChildAt(n);
			}
			_frameCount = 0;
			_enterFrameHandler = _step3;
		}
		else
		{
			for (i=0;i<_objects.length;++i)
			{
				info = _objects[i];
				b = info.b;
				sp = info.sp;
				p = b.GetPosition();
				dx = sp.x;
				dy = sp.y;
				var xx:Number = dx/DISPLAY_WIDTH * _refImage2.width;
				var yy:Number = dy/DISPLAY_HEIGHT * _refImage2.height;
				if (xx >= _refImage2.width) xx = _refImage2.width-1;
				if (yy >= _refImage2.height) yy = _refImage2.height-1;
				c = _refImage2.getPixel(xx,yy);
				sp.draw(c,info.r);
			}
			
		}
		
	}

	private function _step3():void {
		var n:int = _objects.length;
		for (var i:int = 0; i < n; ++i) {
			var sp:Recorder = _objects[i];
			if (sp.frameOffset <= _frameCount) {
				if (!sp.parent) {
					addChild(sp);
				}
				sp.restore(_frameCount - sp.frameOffset);
			}
		}
		_frameCount++;
	}
	
	
}


import flash.display.Sprite;


class Recorder extends Sprite 
{


	public var frameOffset:int = 0;
	private var _px:Vector.<Number>;
	private var _py:Vector.<Number>;
	
	
	public function Recorder() {
		_px = new Vector.<Number>();
		_py = new Vector.<Number>();
	}
	
	
	public function save(rx:Number = NaN, ry:Number = NaN):void {
		if (isNaN(rx)) {
			_px.push(x); 
			_py.push(y);
		} else {
			_px.push(rx);
			_py.push(ry);
			this.x = rx;
			this.y = ry;
		}
	}
	
	
	public function restore(frame:int):void {
		if (frame < _px.length) {
			x = _px[frame];
			y = _py[frame];
		}
	}
	
	
	public function draw(color:uint, radius:Number):void {
		graphics.clear();
		graphics.beginFill(color);
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();
	}
}
