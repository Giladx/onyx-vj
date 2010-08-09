/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * plug-in for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * based on Aerodynamic Cursor 2.0 by Edik Ruzga (http://wonderwhy-er.deviantart.com)
 */
package library.patches 
{
	import com.edikruzga.ParticleBase2;
	
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	[SWF(width='320', height='240', frameRate='24', backgroundColor='#FFFFFF')]
	public class Aerodynamic extends Patch 
	{
		private var BallBitmaps:Array = [];
		private var b:Ball = new Ball();
		private var m:Matrix = new Matrix();
	
		private var lastBmp:Bitmap = new Bitmap();
		private var originalWidth:Number = b.width;
		private var originalHeight:Number = b.height;
		private var torad:Number = Math.PI/180;
		private var fade:Number=0.1;
		private var p1:Number=0.9;
		private var p2:Number=0.5;
		private var p3:Number=0.1;
		private var p4:Number=0.9;
		private var generate2:Number=5;
		private var generate:Number=10;
		private var mx:int;
		private var my:int;
		private var mlx:int;
		private var mly:int;
		private var msx:Number=0;
		private var msy:Number=0;
		
		private var ct:ColorTransform = new ColorTransform(1,1,1,0.9);
		
		private var dax:Number = 0;
		private var day:Number = 0;
		private var dp:Point = new Point();
		private var viewPort:BitmapData = new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,true,0);
		private var ps:Vector.<ParticleBase2> = new Vector.<ParticleBase2>();
		
		/**
		 * 	@constructor
		 */
		public function Aerodynamic():void 
		{
			Console.output('Aerodynamic');
			Console.output('Edik Ruzga (http://wonderwhy-er.deviantart.com)');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			/*parameters.addParameters(
				new ParameterInteger( 'octaves', 'octaves', 1, 10, _octaves )

			)*/ 
			lastBmp.x=0;
			lastBmp.width=0;
			for(var i:uint=1;i<originalWidth;i++){
				var isc:Number = i;
				for(var j:uint=0;j<361;j++){
					
					var bmd:BitmapData = new BitmapData(Math.ceil(isc),Math.ceil(isc),true,0);
					//b.scaleX=b.scaleY = i/(1.5*(originalWidth);
					//b.x = b.width
					//b.y = 
					m = new Matrix();
					m.a = m.d = isc/originalWidth;
					m.rotate(j*torad);
					m.tx=bmd.width*0.5;
					m.ty=bmd.height*0.5;
					//m. = j;
					bmd.draw(b,m);
					BallBitmaps[(i-1)*360+j]=bmd;
				}
				//var bmp:Bitmap = new Bitmap(bmd);
				//bmp.x = lastBmp.x+lastBmp.height;
				//lastBmp=bmp;
				//addChild(bmp);
			}
			//Mouse.hide();
			//var grad:Number = Math.PI/180;
			addChildAt(new Bitmap(viewPort),0);
			
			addEventListener( InteractionEvent.MOUSE_DOWN, move );
			addEventListener( InteractionEvent.MOUSE_MOVE, mouseMove );
		}	
		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void {
			
		 
			var dx:Number=mx-mlx;
			var dy:Number=my-mly;
			
			ct.alphaMultiplier=fade;
			dax=msx;
			day=msy;
			msx=msx*p1+(dx)*(1-p1);
			msy=msy*p1+(dy)*(1-p1);
			
			dax = msx-dax;
			day = msy-day;
			var ll:Number = Math.sqrt(dax*dax+day*day);
			for(var j:uint=0;j<generate2;j++){
				var m:Number = Math.random();
				ps.push(new ParticleBase2(mx-dx*m,my-dy*m,
					-dax*p2+Math.max(p4,Math.round(dax)*p3)*(Math.random()-0.5),
					-day*p2+Math.max(p4,Math.round(day)*p3)*(Math.random()-0.5),
					originalWidth-2));
			}
			mlx=mx;
			mly=my;
			var l:uint=ps.length;
			viewPort.colorTransform(viewPort.rect,ct);
			//viewPort.fillRect(viewPort.rect,0);
			for(var i:uint=0;i<l;i++){
				var p:ParticleBase2 = ps[i];
				p.t-=0.5;
				var ang:Number = 180+Math.round(Math.atan2(p.dy,p.dx)/torad);
				var bmd:BitmapData = BallBitmaps[Math.round(p.t)*360+ang];
				//p.a+=p.da;//angle of movemen is changed
				//p.da+=Math.random()*2-1;// direction change speed is randoly changed
				//p.d+=1.5*(Math.random()-0.5);// speed is changed
				//p.x+=Math.cos(grad*p.a)*p.d;//coordinate is changed
				//p.y+=Math.sin(grad*p.a)*p.d;
				p.x+=p.dx;
				p.y+=p.dy;
				dp.x=p.x-bmd.width*0.5;
				dp.y=p.y-bmd.width*0.5;
				viewPort.copyPixels(bmd,bmd.rect,dp,null,null,true);
				if(p.t<1){
					ps.splice(i,1);
					i--;l--;
				}
			}
			info.source.copyPixels(viewPort, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
	
		private function move(e:InteractionEvent):void
		{
			mx = e.localX;
			my = e.localY;
			var dx:Number = mx-mlx;
			var dy:Number = my-mly;
			for(var j:uint=0;j<generate;j++){
				var m:Number = Math.random();
				ps.push(new ParticleBase2(mx-dx*m,my-dy*m,
					-dax*p2+Math.max(p4,Math.round(dax)*p3)*(Math.random()-0.5),
					-day*p2+Math.max(p4,Math.round(day)*p3)*(Math.random()-0.5),
					originalWidth-2));
			}
		}
		private function mouseMove(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}
 }
}
import flash.display.Sprite;
import flash.filters.GlowFilter;

class Ball extends Sprite
{
	public var realx:int;
	public var realy:int;
	public function Ball():void
	{
		graphics.beginFill(0xFF00FF);
		graphics.drawCircle(0, 0, 3);
		graphics.endFill();		
	}
}