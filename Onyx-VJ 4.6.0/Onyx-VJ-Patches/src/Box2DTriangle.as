/**
 * Copyright narutohyper ( http://wonderfl.net/user/narutohyper )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/hCEe
 */

package {
	
	import Box2D.Dynamics.b2Body;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.display.DisplayObject;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Box2DTriangle extends Patch {
		
		private var view:View;
		private var count:int;
		private var donut:b2Body;
		private var loaded:Boolean;
		private var bmp:Bitmap;
		
		public function Box2DTriangle():void {
			
			view = new View();
			donut = view.GetWorldBody();
			view.CreateRegularPolygon(3,200 / View.SCALE, 50 / View.SCALE,new Point(240 / View.SCALE, 240/ View.SCALE),donut);
			
			for (var i:uint=0;i<30;i++) {
				view.CreateBeads((Math.random()*60+240) / View.SCALE, (Math.random()*60+240) / View.SCALE);
			}

		}
		override public function render(info:RenderInfo):void		
		{					
			donut.SetXForm(donut.GetPosition(), donut.GetAngle() + 0.01);
			info.render(view);
		}

		
		private function CreateBeads(event:MouseEvent) : void {
			view.CreateBeads(event.localX / View.SCALE, event.localY / View.SCALE);
		}
		
		
	}
	
}

import Box2D.Collision.b2AABB;
import Box2D.Collision.Shapes.b2CircleDef;
import Box2D.Dynamics.b2Body;
import Box2D.Dynamics.b2BodyDef;
import Box2D.Dynamics.b2DebugDraw;
import Box2D.Dynamics.b2World;
import Box2D.Common.Math.b2Vec2;
import Box2D.Collision.Shapes.b2PolygonDef;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.utils.getTimer;
import flash.geom.Point;

internal class View extends Sprite
{
	private var _world:b2World;
	private var _gravity:b2Vec2;
	private var _doSleep:Boolean;
	private var _worldAABB:b2AABB;
	private var _body:b2BodyDef;
	private var _bodyPolygon:b2Body;
	public static var SCALE:int = 100;
	
	public function View()
	{
		
		//	world;
		_worldAABB = new b2AABB();
		_worldAABB.lowerBound.Set( -500.0, -500.0);
		_worldAABB.upperBound.Set( 500.0, 500.0);
		
		_gravity = new b2Vec2(0.0, 6.0);
		_doSleep = true;
		_world = new b2World(_worldAABB, _gravity, _doSleep);
		_body = new b2BodyDef();
		_body.position.Set(0,0);
		
		_bodyPolygon = _world.CreateBody(_body);
		
		addEventListener(Event.ENTER_FRAME, EnterFrame);
	}
	
	public function GetWorldBody() :b2Body
	{
		return _world.CreateBody(_body);
	}
	
	private function EnterFrame(e:Event):void {
		_world.Step(1 / 60, 10);
		
		// Sprite ã®å ´æ‰€ã‚’æ›´æ–°ã™ã‚‹
		
		for (var b:b2Body = _world.GetBodyList(); b; b = b.GetNext()) {
			var sprite:Sprite = b.GetUserData() as Sprite;
			if (sprite){
				sprite.x = b.GetWorldCenter().x * SCALE;
				sprite.y = b.GetWorldCenter().y * SCALE;
				sprite.rotation = b.GetAngle() * 180 / Math.PI;
			}
			// ç”»é¢å¤–ã«å‡ºãŸã‚ªãƒ–ã‚¸ã‚§ã‚¯ãƒˆã‚’å‰Šé™¤ã™ã‚‹
			if (sprite && sprite.y > 600){
				_world.DestroyBody(b);
				removeChild(sprite);
			}
		}
	}
	
	public function CreateRegularPolygon( num:int, radiusIn:Number, radiusWidth:Number,center:Point, b2body:b2Body = null ) : b2Body {
		if ( b2body == null ) {
			b2body = _world.CreateBody(_body);
		}
		var divisionAngle:Number = 360 / num;
		
		var baseSp:Sprite=new Sprite()
		
		
		for ( var a:int = 0; a < num; a ++ ) {
			//	è¨ˆç®—ã®ãŸã‚ã®tmp
			var angle:Number = divisionAngle * a * Math.PI / 180 ;
			var radiusOut:Number = radiusIn + radiusWidth;
			
			//	åˆæœŸï¾Žï¾Ÿï½²ï¾ï¾„
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			
			var rI:Point = new Point(cos * radiusIn, sin * radiusIn);
			var rO:Point = new Point(cos * radiusOut, sin * radiusOut);
			
			//	N æ¬¡ã®ï¾Žï¾Ÿï½²ï¾ï¾„
			var angleN:Number = divisionAngle * (a+1) * Math.PI / 180  ;
			var cosN:Number = Math.cos(angleN);
			var sinN:Number = Math.sin(angleN);
			
			var rIN:Point = new Point(cosN * radiusIn, sinN * radiusIn);
			var rON:Point = new Point(cosN * radiusOut, sinN * radiusOut);
			
			var poly:b2PolygonDef = new b2PolygonDef();
			
			poly.vertexCount = 4;
			poly.vertices[0].Set(rI.x, rI.y);
			poly.vertices[1].Set(rO.x, rO.y);
			poly.vertices[2].Set(rON.x, rON.y);
			poly.vertices[3].Set(rIN.x, rIN.y );
			
			baseSp.graphics.beginFill(0x669966)
			baseSp.graphics.moveTo(rI.x*SCALE, rI.y*SCALE)
			baseSp.graphics.lineTo(rO.x*SCALE, rO.y*SCALE)
			baseSp.graphics.lineTo(rON.x*SCALE, rON.y*SCALE)
			baseSp.graphics.lineTo(rIN.x*SCALE, rIN.y*SCALE)
			baseSp.graphics.endFill();
			
			//poly.density = 1;
			//poly.restitution = 0.4;
			//poly.friction = 0.1;
			
			poly.density = 0;
			poly.restitution = 0;
			poly.friction = 0;
			
			
			b2body.CreateShape(poly);
			
		}
		b2body.m_userData = new Sprite();
		b2body.GetUserData().addChild(baseSp);
		b2body.SetXForm(new b2Vec2(center.x, center.y),0)
		
		addChild(b2body.GetUserData());
		
		return b2body;
	}
	
	
	//-----------------------------------------------------------
	//ãƒ“ãƒ¼ã‚ºã‚’ä½œæˆã™ã‚‹
	//-----------------------------------------------------------
	public function CreateBeads( x:Number, y:Number):void {
		var b2body:b2Body = _world.CreateBody(_body);
		
		var radius:Number=(Math.random() * 5 + 10)
		
		var beads:*
		var beadsSp:Sprite=new Sprite()
		beadsSp.graphics.beginFill(0xFFFFFF * Math.random()); 
		
		switch (Math.round(Math.random()*3)) {
			case 0:
				beads= new b2PolygonDef(); 
				beads.SetAsBox(radius / SCALE, radius / SCALE); 
				beadsSp.graphics.drawRect(-radius,-radius,radius*2,radius*2)
				break;
			
			case 1:
				beads = new b2CircleDef();
				beads.radius = radius / SCALE;
				beadsSp.graphics.drawCircle(0,0,radius)
				break;
			
			default:
				beads= new b2PolygonDef(); 
				beads.SetAsBox(radius / SCALE, radius / SCALE); 
				var vertexCount:uint=3;
				
				beads.vertexCount = vertexCount;
				
				// åº•è¾ºã®åŠåˆ†ã®é•·ã•ã¨é«˜ã•ã‚’è¨­å®š  
				var h:Number=Math.tan(60 * Math.PI / 180) * radius;
				
				// è§’ã®æ•°ã‚’è¨­å®šã—ã¦é ‚ç‚¹ã®ä½ç½®ã‚’è¨­å®šã™ã‚‹  
				beads.vertices[0].Set(-1 * radius / SCALE, -1 * h / 2 / SCALE);
				beads.vertices[1].Set(radius / SCALE, -1 * h / 2 / SCALE);
				beads.vertices[2].Set(0, h / 2 / SCALE);
				
				beadsSp.graphics.moveTo(-1 * radius, -1 * h / 2);  
				beadsSp.graphics.lineTo(radius, -1 * h / 2);	
				beadsSp.graphics.lineTo(0, h / 2);	
				beadsSp.graphics.endFill();
				break;
		}

		beads.density = 6;
		beads.restitution = 0;
		beads.friction = 0;
		
		b2body.CreateShape(beads);
		b2body.SetXForm(new b2Vec2(x ,y), 0);
		
		b2body.m_userData = new Sprite();
		b2body.GetUserData().x = b2body.GetWorldCenter().x;
		b2body.GetUserData().y = b2body.GetWorldCenter().y;
		
		b2body.GetUserData().addChild( beadsSp );
		addChild(b2body.GetUserData());
		b2body.SetMassFromShapes();
	}
}

