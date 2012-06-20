/**
 * Copyright nutsu ( http://wonderfl.net/user/nutsu )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/43q7
 */

// forked from nutsu's Bezier fource
/*
Bezier fource.

2ã¤ã®bezieræ›²ç·šã®è¿‘å‚ç‚¹ã¨ã®è·é›¢ã‚’åŠ é€Ÿåº¦ã«ã—ã¦é‹å‹•ã€‚
è¨ˆç®—ã®ã¨ã“ã‚ã¯ã–ã£ãã‚Šãªã®ã§æ³¨æ„ã€‚
ã“ã‚Œè¦‹ãŸã‚‰ãªã‚“ã ã‹ãªã¤ã‹ã—ãã¦ã€ã‚€ã‹ã—ã®ã‚„ã¤ã‚’Wonderflã¸
http://wonderfl.net/code/22347143956fe1042cd37277dc2ef3ba8308cd87
*/
package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import frocessing.display.F5MovieClip2DBmp;	
	[SWF( width=465, height=465, frameRate=60, backgroundColor=0 )]
	public class BezierAccel extends F5MovieClip2DBmp{
		
		private var bezier1:QBezier;
		private var bezier2:QBezier;
		
		private var handle1a:Handle;
		private var handle1b:Handle;
		private var handle1c:Handle;
		private var handle2a:Handle;
		private var handle2b:Handle;
		private var handle2c:Handle;
		private var handlegc:Shape;
		private var now_editting:Boolean = false;
		private var edit_handle:Handle;
		private var stageArea:Rectangle = new Rectangle(0, 0, 465, 465);
		
		private var plots:Array;
		private var N:int = 20;
		
		public function BezierAccel(){
			super(false,0);
			
			plots = [];
			for( var i:int=0; i<N; i++ ){
				plots[i] = new Plot( random( stageArea.width ), random( stageArea.height) );
			}
		}
		
		public function setup():void {
			stroke( 255, 0.2 );
			noFill();
			//
			addChild( handlegc = new Shape() );
			addChild( handle1a = new Handle(startEdit,  75, 120) );
			addChild( handle1b = new Handle(startEdit, 212, 205) );
			addChild( handle1c = new Handle(startEdit, 350, 120) );
			addChild( handle2a = new Handle(startEdit,  75, 305) );
			addChild( handle2b = new Handle(startEdit, 212, 220) );
			addChild( handle2c = new Handle(startEdit, 350, 305) );
			bezier1 = new QBezier( handle1a.x, handle1a.y, handle1b.x, handle1b.y, handle1c.x, handle1c.y );
			bezier2 = new QBezier( handle2a.x, handle2a.y, handle2b.x, handle2b.y, handle2c.x, handle2c.y );
			updateBezier();
		}
		
		private var ct:ColorTransform = new ColorTransform(1, 1, 1, 1, -1, -1, -1);
		
		public function draw():void 
		{
			
			bitmapData.colorTransform( bitmapData.rect, ct );
			
			if ( now_editting )
				updateBezier();
			
			for ( var i:int = 0; i < N; i++ ) {
				var p:Plot  = plots[i];
				var px:Number = p.x;
				var py:Number = p.y;
				var t1:Number = nearestValue( bezier1, px, py );
				var t2:Number = nearestValue( bezier2, px, py );
				var b1x:Number = bezier1.fx(t1);
				var b1y:Number = bezier1.fy(t1);
				var b2x:Number = bezier2.fx(t2);
				var b2y:Number = bezier2.fy(t2);
				var ax:Number = b1x + b2x - 2 * px;
				var ay:Number = b1y + b2y - 2 * py;
				var ad:Number = mag( ax, ay );
				p.x += p.vx += 0.8 * ax / ad;
				p.y += p.vy += 0.8 * ay / ad;
				p.vx *= 0.995;
				p.vy *= 0.995;
				moveTo( b1x, b1y );
				curveTo( p.x, p.y, b2x, b2y );
			}
		}
		
		private function updateBezier():void {
			bezier1.setValues( handle1a.x, handle1a.y, handle1b.x, handle1b.y, handle1c.x, handle1c.y );
			bezier2.setValues( handle2a.x, handle2a.y, handle2b.x, handle2b.y, handle2c.x, handle2c.y );
			handlegc.graphics.clear();
			handlegc.graphics.lineStyle( 0, 0x666666 );
			handlegc.graphics.moveTo( bezier1.x0, bezier1.y0 );
			handlegc.graphics.lineTo( bezier1.cx, bezier1.cy );
			handlegc.graphics.lineTo( bezier1.x1, bezier1.y1 );
			handlegc.graphics.moveTo( bezier2.x0, bezier2.y0 );
			handlegc.graphics.lineTo( bezier2.cx, bezier2.cy );
			handlegc.graphics.lineTo( bezier2.x1, bezier2.y1 );
			handlegc.graphics.lineStyle( 0, 0x666666 );
			handlegc.graphics.moveTo( bezier1.x0, bezier1.y0 );
			handlegc.graphics.curveTo( bezier1.cx, bezier1.cy, bezier1.x1, bezier1.y1 );
			handlegc.graphics.moveTo( bezier2.x0, bezier2.y0 );
			handlegc.graphics.curveTo( bezier2.cx, bezier2.cy, bezier2.x1, bezier2.y1 );
		}
		
		private function startEdit( h:Handle ):void{
			now_editting = true;
			edit_handle = h;
			edit_handle.startDrag(false, stageArea );
		}
		
		public function mouseReleased():void {
			if( edit_handle!=null ){
				edit_handle.stopDrag();
			}
			now_editting = false;
			updateBezier();
		}
		
		private static var ERR_T:Number = 1e-5;
		
		private function nearestValue( b:QBezier, px:Number, py:Number ):Number
		{
			var rslt:Number;
			
			var x0:Number = b.x0 - px;
			var y0:Number = b.y0 - py;
			var cx:Number = b.cx - px;
			var cy:Number = b.cy - py;
			var x1:Number = b.x1 - px;
			var y1:Number = b.y1 - py;
			
			var xx:Number = x0 + x1;
			var yy:Number = y0 + y1;
			var cc:Number = cx*cx + cy*cy;
			
			var A:Number  = 4*( xx*xx + yy*yy + 4*cc - 4*cx*xx - 4*cy*yy );
			var B:Number  = -12*( x0*xx + y0*yy + 2*cc + (-3*x0-x1)*cx + (-3*y0-y1)*cy );
			var C:Number  = 4*( (3*x0+x1-6*cx)*x0 + (3*y0+y1-6*cy)*y0 + 2*cc );
			var D:Number  = -4*(y0*y0-cy*y0+x0*x0-cx*x0);
			
			var TA:Number = 27*A*A*D*D + (4*B*B*B-18*A*B*C)*D + 4*A*C*C*C - B*B*C*C;
			
			
			if( TA>0 ){
				TA = Math.sqrt(TA)/( 6*Math.sqrt(3)*A*A ) - (27*A*A*D - 9*A*B*C + 2*B*B*B )/(54*A*A*A);
				if( TA<0 ){
					TA = -Math.pow(-TA,1/3);
				}else{
					TA = Math.pow(TA,1/3);
				}
				rslt = TA - (3*A*C-B*B)/(9*A*A*TA) - B/(3*A);				
				if ( rslt < 0 ) return 0;
				else if ( rslt > 1 ) return 1;
				else return rslt;
			}else if( TA<0 ){
				var diff:Function = function(t:Number):Number{ return (A*t*t*t + B*t*t + C*t + D); };
				
				var tt0:Number = (-B - Math.sqrt(B*B-3*A*C))/(3*A);
				var tt1:Number = (-B + Math.sqrt(B*B-3*A*C))/(3*A);
				
				var t0:Number = 0;
				var t1:Number = 1.0;
				
				var ot0:Number;
				var ot1:Number;
				var dt:Number;
				
				if( tt0>0 && D<0 ){
					ot0 = 0.0;
					ot1 = tt0;
					t0  = (ot0 + ot1)/2;
					while( Math.abs( dt=A*t0*t0*t0 + B*t0*t0 + C*t0 + D )>ERR_T ){
						if( dt>0 ){
							ot1 = t0;
							t0  = (ot0 + ot1)/2;
						}else{
							ot0 = t0;
							t0  = (ot0 + ot1)/2;
						}
					}
				}
				if( tt1<1.0 && (A+B+C+D)>0 ){
					ot0 = tt1;
					ot1 = 1.0;
					t1  = (ot0 + ot1)/2;
					while( Math.abs( dt=A*t1*t1*t1 + B*t1*t1 + C*t1 + D )>ERR_T ){
						if( dt<0 ){
							ot0 = t1;
							t1  = (ot0 + ot1)/2;
						}else{
							ot1 = t1;
							t1  = (ot0 + ot1)/2;
						}
					}
				}
				var dv0:Number = mag( t0*t0*(x1+x0-2*cx)+t0*(2*cx-2*x0)+x0, t0*t0*(y1+y0-2*cy)+t0*(2*cy-2*y0)+y0 );
				var dv1:Number = mag( t1*t1*(x1+x0-2*cx)+t1*(2*cx-2*x0)+x0, t1*t1*(y1+y0-2*cy)+t1*(2*cy-2*y0)+y0 );
				return ( dv0 < dv1) ? t0 : t1;
			}else{
				return -D/C;
			}
		}
	}
	
}

class QBezier {
	public var x0:Number, y0:Number, cx:Number, cy:Number, x1:Number, y1:Number;
	public function QBezier( x0:Number, y0:Number, cx:Number, cy:Number, x1:Number, y1:Number ) {
		setValues( x0, y0, cx, cy, x1, y1 );
	}
	public function setValues( x0:Number, y0:Number, cx:Number, cy:Number, x1:Number, y1:Number ):void {
		this.x0 = x0; this.y0 = y0;
		this.cx = cx; this.cy = cy;
		this.x1 = x1; this.y1 = y1; 
	}
	public function fx( t:Number ):Number {
		return x0*(1-t)*(1-t) + 2*cx*t*(1-t) + x1*t*t;
	}
	public function fy( t:Number ):Number {
		return y0*(1-t)*(1-t) + 2*cy*t*(1-t) + y1*t*t;
	}
}

class Plot {
	public var x:Number, y:Number, vx:Number, vy:Number;
	public function Plot( x:Number, y:Number ) {
		this.x = x; this.y = y;
		vx = vy = 0;
	}
}

import flash.events.MouseEvent;
import flash.display.Sprite;

class Handle extends Sprite{
	private var callback:Function;
	public function Handle( mousedowncallback:Function, x:Number, y:Number ) {
		this.x = x;
		this.y = y;
		callback = mousedowncallback;
		graphics.beginFill( 0xFFFFFF );
		graphics.drawCircle( 0, 0, 4 );
		graphics.endFill();
		buttonMode = true;
		addEventListener( MouseEvent.MOUSE_DOWN, mousedown );
	}
	private function mousedown(e:MouseEvent):void {
		callback.apply( null, [this] );
	}
}

