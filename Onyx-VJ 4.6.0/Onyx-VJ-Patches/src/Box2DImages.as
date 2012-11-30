/**
 * Copyright kotobuki ( http://wonderfl.net/user/kotobuki )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/2S7Y
 */

// forked from kotobuki's Coins (Gainer version)
// forked from miyaoka's Coins
// http://www.youtube.com/watch?v=qiezMYHiul0
package 
{
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class Box2DImages extends Patch
	{
		private var view:View;
		
		public function Box2DImages()
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
			view.addCoin();
		}
	}
}

import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;

import EmbeddedAssets.AssetForBox2DImages;

import caurina.transitions.Tweener;

import flash.display.*;
import flash.events.*;
import flash.filters.*;
import flash.geom.*;
import flash.utils.Timer;

import onyx.core.*;
import onyx.parameter.*;
import onyx.plugin.*;

class View extends Sprite {
	public var mx:Number = 320;
	public var my:Number = 240;

	private var imgs:Array = [];
	private var radiuses:Array = [
		10, 11, 11.75, 10.5, 11.3, 13.25
	];
	private var densities:Array = [
		2.066947313, 6.488961867, 7.980747225, 7.699105335, 7.038588188, 6.345800508
	];
	private var coinsThreshold:int = 20;
	private var coins:Array = [];
	
	private static const DRAW_SCALE:Number = 100;
	private var world:b2World;

	public function View() {
		
		/*var g:Graphics = graphics;
		g.beginFill(0xdddddd);
		g.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
		
		var date:String = new Date().valueOf().toString();*/
		var bmd:BitmapData = new AssetForBox2DImages();
		var bmp:Bitmap = new Bitmap(bmd);
		imgs[0] = bmp;
		init();
	}
	private function init():void 
	{
		//world
		var worldAABB:b2AABB = new b2AABB();
		worldAABB.lowerBound.Set(-100, -100);
		worldAABB.upperBound.Set(100, 100);
		var gravity:b2Vec2 = new b2Vec2(0, 10);
		world = new b2World(worldAABB, gravity, true);
		
		//wall
		makeWall();
		
		//evts
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		
		var timer:Timer = new Timer(100);
		addEventListener(MouseEvent.MOUSE_DOWN, function ():void 
		{
			addCoin();
			timer.reset();
			timer.start();
			addEventListener(MouseEvent.MOUSE_UP, function ():void 
			{
				timer.stop();
			});
		});
		timer.addEventListener(TimerEvent.TIMER, function ():void 
		{
			addCoin();
		});
	}
	
	public function addCoin():void 
	{
		var i:int = Math.floor(Math.random() * radiuses.length);
		addCircle(
			mx, my, 
			radiuses[i] * 4, 
			densities[i], 
			imgs[0] as Bitmap );
			//imgs[Math.random() < 0.5 ? i * 2 : i * 2 + 1] as Bitmap );
	}

	private function makeWall():void {
		
		var bd:b2BodyDef = new b2BodyDef();
		bd.position.Set(0, 0);
		
		var wall:b2Body = world.CreateBody(bd);
		
		var w:Number = DISPLAY_WIDTH / DRAW_SCALE;
		var h:Number = DISPLAY_HEIGHT / DRAW_SCALE;
		var wallSize:Number = 50 / DRAW_SCALE;
		
		var sd:b2PolygonDef = new b2PolygonDef();
		sd.filter.categoryBits = parseInt("010",2);
		
		//top
		sd.SetAsOrientedBox(w / 2 + wallSize * 2, wallSize, new b2Vec2(w / 2, -wallSize - h/2));
		wall.CreateShape(sd);
		//bottom
		sd.SetAsOrientedBox(w / 2 + wallSize * 2, wallSize, new b2Vec2(w / 2,  h + wallSize));
		wall.CreateShape(sd);
		//left
		sd.SetAsOrientedBox(wallSize, h, new b2Vec2(-wallSize, h / 2));
		wall.CreateShape(sd);
		//right
		sd.SetAsOrientedBox(wallSize, h, new b2Vec2(w + wallSize,  h / 2));
		wall.CreateShape(sd);
		
	}
	
	
	private function enterFrameHandler(event:Event):void {
		for (var b:b2Body = world.GetBodyList(); b; b = b.GetNext()) {
			if (b.GetUserData() is Sprite) {
				if (b.GetWorldCenter().y *DRAW_SCALE > 500)
				{
					removeChild(b.GetUserData());
					world.DestroyBody(b);
				}
				else
				{
					b.GetUserData().x = b.GetWorldCenter().x * DRAW_SCALE;
					b.GetUserData().y = b.GetWorldCenter().y * DRAW_SCALE;
					b.GetUserData().rotation = b.GetAngle() * 180 / Math.PI;
				}
			}
		}
		if (coinsThreshold < coins.length)
		{
			var coinsLeft:int = coinsThreshold * Math.random() * 0.5;
			coinsThreshold = Math.random() * 10 + 20;
			while(coinsLeft < coins.length)
			{
				var b1:b2Body = coins.shift() as b2Body;
				var sp:b2Shape = b1.GetShapeList();
				var f:b2FilterData = new b2FilterData();
				
				f.maskBits = parseInt("001",2);
				sp.SetFilterData(f);
				world.Refilter(sp);
			}
		}
		
		world.Step(1 / 24, 10);
	}
	
	private function addCircle(posX:Number , posY:Number, radius:Number, density:Number, bmpSource:Bitmap):void 
	{
		//body def
		var bd:b2BodyDef = new b2BodyDef();
		bd.position.Set(posX / DRAW_SCALE, posY / DRAW_SCALE);
		
		//shape def
		var sd:b2CircleDef = new b2CircleDef();
		sd.radius = radius / DRAW_SCALE;
		sd.density = density;
		sd.restitution = 0.5;
		
		var bmp:Bitmap = new Bitmap(bmpSource.bitmapData.clone());
		bmp.smoothing = true;
		//img
		bmp.width = 
			bmp.height = radius * 2;
		bmp.x = 
			bmp.y = -radius;
		
		//body
		var body:b2Body = world.CreateBody(bd);
		body.CreateShape(sd);
		body.SetMassFromShapes();
		var num:Number = Math.random() - 0.5;
		body.SetAngularVelocity(num * Math.PI*2 * 10);
		body.SetLinearVelocity(new b2Vec2(num * 10, -Math.random() * 2 - 5));
		
		body.m_userData = new Sprite();
		body.GetUserData().x = body.GetWorldCenter().x * DRAW_SCALE;
		body.GetUserData().y = body.GetWorldCenter().y * DRAW_SCALE;
		body.GetUserData().addChild(bmp);
		
		coins.push(body);
		addChild(body.GetUserData());
	}
}


