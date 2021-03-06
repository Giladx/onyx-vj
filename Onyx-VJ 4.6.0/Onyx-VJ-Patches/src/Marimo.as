/**
 * Copyright nutsu ( http://wonderfl.net/user/nutsu )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/mHSL
 */

// forked from tail_y's Marimo

package {
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import frocessing.geom.FGradientMatrix;
	import frocessing.math.FMath;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class Marimo extends Patch {
			
		public static const SPHERE_R:Number = 40;		
		
		public static const PARTICLE_NUM_RATE:uint = 40;	
		public static const PARTICLE_STEP:uint = 4;	
		public static const PARTICLE_V:uint = 8*PARTICLE_STEP;	
		public static const GRAVITY:Number = 0.8;		
		public static const RANDOM_RATE:Number = 0.8;		
		public static const COLOR_RANDOM_RATE:Number = 0.3;		
		
		public static const GROUND_Y:Number = 400;	
		public static const SHADOW_W:Number = 150;	
		public static const GROUND_H:Number = 30;	
		
		private var _marimoX:Number;	
		private var _marimoY:Number;
		private var _display2:Sprite;
		
		public static const COLOR_TIP_TOP:Number     = 0x77cc44;		// æ??å??ä??é??
		public static const COLOR_TIP_BOTTOM:Number  = 0x339900;		// æ??å??ä??é??
		public static const COLOR_BACE_TOP:Number    = 0x116600;		// æ??ä??ä??é??
		public static const COLOR_BACE_BOTTOM:Number = 0x003300;		// æ??ä??ä??é??
		
		private var g:Graphics;
		private var gmtx:FGradientMatrix;
		private var furalphas:Array = [1,0];
		private var furratios:Array = [0,255];
		private var furs:Array;
		private var offsetX:Number;
		private var offsetY:Number;
		private var targetX:Number;
		private var targetY:Number;
		private var draw_gravity:Number;
		
		private var eyeX1:Number = SPHERE_R / 2;
		private var eyeX2:Number = -eyeX1;
		private var eyeY:Number = -SPHERE_R/4;
		private var eyeR:Number = 6;
		private var mx:int = 320;
		private var my:int = 240;
		
		public function Marimo() {
					
			_marimoX = DISPLAY_WIDTH/2;	
			_marimoY = DISPLAY_HEIGHT/2 - 50;
			//
			_display2 = new Sprite();
			//addChild(_display2);
			
			//matrix for gradient
			gmtx = new FGradientMatrix();
			
			// graphics
			g = _display2.graphics;
			g.lineStyle();
			
			// 
			makeFurs();
			offsetX = targetX = 0;
			offsetY = targetY = 0;
			addEventListener( MouseEvent.MOUSE_MOVE, mouse );
			addEventListener( MouseEvent.MOUSE_DOWN, mouse);
		}
		private function mouse(event:MouseEvent):void {
			mx = event.localX; 
			my = event.localY; 
		}		
		private function makeFurs():void
		{			
			furs = [];
			// æ??
			for (var xri:uint = 0; xri < PARTICLE_NUM_RATE; xri++){	// zã??å??ã??è??ç??ã??ã??ã??å??ã??ã??æ??å??ã??æ??ç??
				var xAngle:Number = Math.PI*xri / PARTICLE_NUM_RATE;	// ã??ã?ªã??ä??å??ç??ã??ã??ã??ã??ã?ªã??è??é??ã??ã??xæ??å??ã??å??ã??ã??è??åº?
				var z:Number = Math.cos(xAngle) * SPHERE_R;				// ã??ã??ã??ã??ã??ã??ã??é??ã??ã??å??ç??Z
				var r:Number = Math.sin(xAngle) * SPHERE_R;				// ã??ã??æ??ã??ã??æ??é??ã??å??å??
				
				// zæ??å??ã??å??ã??ã??é??ã??å??å??ä??ã??ã??ã??ç??ã??æ??ã??å??å??ã??æ??ï??=å??å??ã??æ??ï??ã??å??ã??å?ºã??ã??ã??æ??æ??ã??ä??ã??ã??ã??ã??ã??æ??ç?ºã??ã??ã?ªã??ã??
				// ï??å??å??ã??ã??ã??ã??ã??ã??ã??ã??ã??æ??æ??ã??æ?ªã??ã??ã??ã??ã??ã??ã??zå??è??ã??ã??ã??ã??ã??ã??ã??ã??ã??ï??
				var particleRateZ:int = PARTICLE_NUM_RATE * 2 * r / SPHERE_R;
				
				for (var zri:uint = 0; zri < particleRateZ; zri++){	// zæ??å??é??ã??å??ã??ã??ã??æ??è??å??ã??ã??æ??ç??
					var zAngle:Number = Math.PI*zri*2 / particleRateZ;	// ã??ã?ªã??ä??å??ç??ã??ã??ã??ã??ã?ªã??è??é??ã??ã??zæ??å??ã??å??ã??ã??è??åº?
					var x:Number = Math.cos(zAngle) * r;	// ã??ã??ã??ã??ã??ã??ã??é??ã??ã??å??ç??X
					var y:Number = Math.sin(zAngle) * r;	// ã??ã??ã??ã??ã??ã??ã??é??ã??ã??å??ç??Y
					var vx:Number = PARTICLE_V * x / SPHERE_R;	// ã??ã??ã??ã??ã??ã??ã??é??åº?X
					var vy:Number = PARTICLE_V * y / SPHERE_R;	// ã??ã??ã??ã??ã??ã??ã??é??åº?Y
					// æ??å??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ï??æ??æ??ã??ã??å??å??æ??å??ã??ã??ã??ã??ã??ã??ã??ã?ªã??ã??ã??ã??ã?ªã??ã??ã??ã??ã??ã??é??å??ã?ªã??ã??ã??ã??ã??ï??
					vx += (PARTICLE_V * RANDOM_RATE) * (0.5 - Math.random());
					vy += (PARTICLE_V * RANDOM_RATE) * (0.5 - Math.random());
					
					// è??ã??æ?ºã??ã??ã??ä??ä??ã??ä??ç??ã??ã??æ??æ??ã??ã??ã??å??å??ã??è??ã??æ?ºå??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??å??ã??ã??ã??ã??ã??
					var yColorRate:Number = ((SPHERE_R + y)/ 2 / SPHERE_R) + COLOR_RANDOM_RATE * (0.5 - Math.random());
					var color0:Number = mixColor(COLOR_BACE_TOP, COLOR_BACE_BOTTOM, yColorRate);
					var color1:Number = mixColor(COLOR_TIP_TOP, COLOR_TIP_BOTTOM, yColorRate);
					
					// æ??
					if( FMath.dist(x,y,eyeX1,eyeY)<eyeR || FMath.dist(x,y,eyeX2,eyeY)<eyeR )continue;
					
					var fur:FurInfo = new FurInfo();
					fur.x = _marimoX + x;
					fur.y = _marimoY + y;
					fur.vx = vx;
					fur.vy = vy;
					fur.colors = [color0, color1];
					furs.push( fur );
				}
			}
			eyeX1 += _marimoX;
			eyeX2 += _marimoX;
			eyeY  += _marimoY;
		}
		
		override public function render(info:RenderInfo):void 
		{
			g.clear();
			
			targetX = (mx - _marimoX);
			targetY = (my - _marimoY) / 2;
			var ax:Number = ( targetX - offsetX );
			var ay:Number = ( targetY - offsetY );
			var gr:Number = FMath.constrain( GRAVITY -  ay / 30, -GRAVITY, 1.5 * GRAVITY );
			offsetX  += ax * 0.2;
			offsetY  += ay * 0.2;
			draw_gravity = GRAVITY * gr * PARTICLE_STEP * PARTICLE_STEP; 
			
			ax = FMath.constrain( ax, -PARTICLE_V/5, PARTICLE_V/5 );
			
			// å??
			var ss:Number = ( mouseY + 100 )/ 465;
			gmtx.identity();
			gmtx.scale( SHADOW_W*ss, GROUND_H*ss );
			gmtx.translate( _marimoX+offsetX, GROUND_Y );
			g.beginGradientFill(GradientType.RADIAL, [0x000000, 0x000000], [0.3, 0.0], [60, 255], gmtx);
			g.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			g.endFill();
			
			// æ??ä??
			g.beginFill(COLOR_BACE_BOTTOM);
			g.drawCircle(_marimoX+offsetX, _marimoY+offsetY, SPHERE_R);
			g.endFill();
			
			gmtx.createRadial( eyeX1+offsetX, eyeY+offsetY, eyeR, -Math.PI*0.25 );
			g.beginGradientFill( "radial", [0xffffff,0],[1,1],[0,127],gmtx, "pad", "rgb", 0.6 );
			g.drawCircle( eyeX1+offsetX, eyeY+offsetY, eyeR );
			g.endFill();
			gmtx.createRadial( eyeX2+offsetX, eyeY+offsetY, eyeR, -Math.PI*0.75 );
			g.beginGradientFill( "radial", [0xffffff,0],[1,1],[0,127],gmtx, "pad", "rgb", 0.6 );
			g.drawCircle( eyeX2+offsetX, eyeY+offsetY, eyeR );
			g.endFill();
			
			var len:int = furs.length;
			for ( var i:int = 0; i < len; i++ )
			{
				var fur:FurInfo = furs[i];
				drawFur( fur.x+offsetX, fur.y+offsetY, fur.vx-ax, fur.vy, fur.colors );
			}
			info.render( _display2 );
		}
		
		// æ??ã??æ??ã??
		private function drawFur(x:Number, y:Number, vx:Number, vy:Number, colors:Array):void {
			var x0:Number = x + vx * 0.75;
			var y0:Number = y + vy * 0.75;
			var x1:Number = x + vx;
			var y1:Number = y + vy + draw_gravity;
			var d:Number  = Math.sqrt( vx * vx + vy * vy ) / 1.5;
			gmtx.createLinear( x, y, x1, y1 );
			g.beginGradientFill( "linear", colors, furalphas, furratios, gmtx );
			g.moveTo( x, y );
			g.curveTo( x0, y0, x1, y1 );
			vx /= d;
			vy /= d;
			g.curveTo( x0+vy, y0-vx, x+vy, y-vx );
			g.endFill();
		}
		
		// ï??ã??ã??è??ã??æ??å??ã??ã??å??å??ã??æ??ã??ã??è??ã??è??ã??ï??rate=0ã?ªã??color0ï??ã??ï??ã??ã??ã??ã??ã?ªã??è??é??å??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ã??ä??ã??ã??ã??ï??
		private function mixColor(color0:uint, color1:uint, rate:Number):uint{
			if (rate <= 0) return color0;
			if (rate >= 1) return color1;
			var r:uint = (color0>>16) * (1-rate) 
				+ (color1>>16) * rate;
			var g:uint = ((color0 & 0x00ff00 ) >>8) * (1-rate) 
				+ ((color1 & 0x00ff00 ) >>8) * rate;
			var b:uint = (color0 & 0xff) * (1-rate) 
				+ (color1 & 0xff) * rate;
			return (r << 16) | (g << 8) | (b);
		}
		
	}
}

class FurInfo {
	public var x:Number;
	public var y:Number;
	public var vx:Number;
	public var vy:Number;
	public var colors:Array;
	public function FurInfo() {
		
	}
}