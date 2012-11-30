/**
 * Copyright weBBBBB ( http://wonderfl.net/user/weBBBBB )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/N2sL
 */

package 
{
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Box2DCircles extends Patch
	{
		private var view:View;
		
		public function Box2DCircles()
		{
			view = new View();	
		}
		override public function render(info:RenderInfo):void		
		{				
			info.render(view);
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

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.external.ExternalInterface;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.utils.Timer;
import flash.utils.getTimer;

import onyx.core.*;
import onyx.display.*;
import onyx.events.*;
import onyx.parameter.*;
import onyx.plugin.*;

internal class View extends Sprite
{

	private var m_world:b2World;
	private var m_scale:Number = 30;
	private var bodyDef:b2BodyDef;
	public function View()
	{
		
		// *1ãƒ¯ãƒ¼ãƒ«ãƒ‰ã®å®šç¾©-----------------------------------------------------------------
		var worldAABB:b2AABB = new b2AABB();
		worldAABB.lowerBound.Set(-100.0,-100.0);
		worldAABB.upperBound.Set(100.0,100.0);
		var gravity:b2Vec2 = new b2Vec2(0.0,10.0);
		var doSleep:Boolean = true;
		m_world = new b2World(worldAABB,gravity,doSleep);
		//2*åœ°é¢ã®è¨­å®š----------------------------------------------------------------------
		var body:b2Body;
		var bodyDef:b2BodyDef;
		var boxDef:b2PolygonDef;
		var circleDef:b2CircleDef;
		
		var insWidth:Number = 0;
		var insHeight:Number = DISPLAY_HEIGHT / m_scale;
		
		var floorWidth:Number = DISPLAY_WIDTH / m_scale;
		var floorHeight:Number = 3;
		
		bodyDef = new b2BodyDef();
		bodyDef.position.Set(insWidth,insHeight + floorHeight);
		
		boxDef = new b2PolygonDef();
		boxDef.SetAsBox(floorWidth,floorHeight);
		boxDef.friction = 0.3;
		boxDef.density = 0;
		
		body = m_world.CreateBody(bodyDef);
		body.CreateShape(boxDef);
		body.SetMassFromShapes();
		
		var timer:Timer = new Timer(100);
		timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
		timer.start();	
		addEventListener(Event.ENTER_FRAME, EnterFrame);
	}

	
	private function EnterFrame(e:Event):void {
		var m_iterations:int = 20;
		var m_timeStep:Number = 3.0 / 60.0;//ã“ã“ã§ã¯ãƒ•ãƒ¬ãƒ¼ãƒ ãƒ¬ãƒ¼ãƒˆã‚’è¨­å®šã—ã¦ã„ã¾ã™ã€‚
		m_world.Step(m_timeStep,m_iterations);
		
		for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next)
		{
			if (bb.m_userData is Sprite)
			{
				bb.m_userData.x = bb.GetPosition().x * 30;
				bb.m_userData.y = bb.GetPosition().y * 30;
				bb.m_userData.rotation = bb.GetAngle() * (180 / Math.PI);
			}
		}
	}

	private function onTimerHandler(event:Event):void
	{
		
		//*1ã‚¿ã‚¤ãƒžãƒ¼ã¨ENTER_FRAMEã®è¨­å®š-----------------------------------------------------
		var body:b2Body;
		var userData:Sprite = new Sprite();
		var graphics:Graphics = userData.graphics;
		graphics.beginFill(Math.random() * 16777216,1);
		
		
		bodyDef = new b2BodyDef();
		bodyDef.position.Set(Math.random() * DISPLAY_WIDTH / m_scale, -1);
		var rX:Number = 1;
		var rY:Number = 1;
		//2*ãƒ©ãƒ³ãƒ€ãƒ ã§ã‚ªãƒ–ã‚¸ã‚§ã‚¯ãƒˆã‚’å‘¼ã³å‡ºã™------------------------------------------------
		if (Math.random() < 0.33)
		{
			var boxDef:b2PolygonDef = new b2PolygonDef();
			boxDef.SetAsBox(rX, rY);
			boxDef.density = 1.0;
			boxDef.friction = 0.5;
			boxDef.restitution = 0.2;
			
			graphics.drawRect( -rX / 2, -rY / 2, rX,rY);
			graphics.endFill();
			
			bodyDef.userData = userData;
			bodyDef.userData.width = rX * 2 * 30;
			bodyDef.userData.height = rY * 2 * 30;
			body = m_world.CreateBody(bodyDef);
			body.CreateShape(boxDef);
		}
		if(Math.random() < 0.66)
		{
			var circleDef:b2CircleDef = new b2CircleDef();
			circleDef.radius = rX;
			circleDef.density = 1.0;
			circleDef.friction  = 0.5;
			circleDef.restitution = 0.2;
			
			graphics.drawCircle(0,0,rX);
			graphics.endFill();
			
			bodyDef.userData = userData;
			bodyDef.userData.width = rX * 2 * 30;
			bodyDef.userData.height = rY * 2 * 30;
			body = m_world.CreateBody(bodyDef);
			body.CreateShape(circleDef);
		}
		else
		{
			var radius:Number = rX;
			var triangle_h:Number = Math.tan(60 * Math.PI / 180) * radius;
			
			var tryangleDef:b2PolygonDef = new b2PolygonDef();
			tryangleDef.vertexCount = 3;
			tryangleDef.vertices[0].Set(-1 * radius, -1 * triangle_h / 2);
			tryangleDef.vertices[1].Set(radius, -1  * triangle_h /2);
			tryangleDef.vertices[2].Set(0, triangle_h / 2);
			tryangleDef.density = 1.0;
			tryangleDef.friction = 0.5;
			tryangleDef.restitution = 0.2;
			
			graphics.moveTo(-1 * radius, -1 * triangle_h / 2);
			graphics.lineTo(radius, -1 * triangle_h / 2);
			graphics.lineTo(0,triangle_h / 2);
			graphics.endFill();
			
			bodyDef.userData = userData;
			bodyDef.userData.width = rX * 2 * 30;
			bodyDef.userData.height = rY * 2 * 30;
			body = m_world.CreateBody(bodyDef);
			body.CreateShape(tryangleDef);
		}
		//3*å®Œäº†å‡¦ç†-------------------------------------------------------------------------
		body.SetMassFromShapes();
		addChild(bodyDef.userData);
	}
}