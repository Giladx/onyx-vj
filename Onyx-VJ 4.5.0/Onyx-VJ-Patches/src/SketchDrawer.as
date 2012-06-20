/**
 * Copyright Marc.Pelland ( http://wonderfl.net/user/Marc.Pelland )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/hEPu
 */

// forked from lattan's ç·´ç¿’ã€€from SketchSample7
// forked from nutsu's SketchSample7
// forked from nutsu's SketchSample6
// forked from nutsu's SketchSample5
// forked from nutsu's SketchSample4
// forked from nutsu's SketchSample3
// forked from nutsu's SketchSample2
// forked from nutsu's SketchSample1
// forked from nutsu's PaintSample
package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import frocessing.color.ColorRGB;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class SketchDrawer extends Patch
	{
		private var sd:SD;
		private var sprite:Sprite;
		
		public function SketchDrawer() 
		{
			Console.output('SketchDrawer v 0.0.1');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			sd = new SD();
			
			sprite = new Sprite();
			//addChild(sprite);
			sprite.addChild(sd);
			sd.setup();
		}	
		
		override public function render(info:RenderInfo):void 
		{			
			sd.draw();
			info.render( sprite );		
		}
	}
}
import frocessing.display.F5MovieClip2DBmp;
import frocessing.geom.FGradientMatrix;

import onyx.core.*;
import onyx.parameter.*;
import onyx.plugin.*;	

class SD extends F5MovieClip2DBmp
{
	//ã‚°ãƒ©ãƒ‡ãƒ¼ã‚·ãƒ§ãƒ³ç”¨ã®å¤‰æ•°
	private var mtx:FGradientMatrix;
	private var colors:Array;
	private var alphas:Array;
	private var ratios:Array;
	//ç·šã®æ•°
	private var n:int;
	private var brushs:Array;
	
	public function setup():void
	{
		//ã‚­ãƒ£ãƒ³ãƒã‚¹ã®ã‚µã‚¤ã‚ºæŒ‡å®š
		size( DISPLAY_WIDTH, DISPLAY_HEIGHT );
		//èƒŒæ™¯ã®æç”»
		//background( 0 );
		//HSV
		colorMode( HSV, 1 );
		//åˆæœŸåŒ–
		n = 1;
		brushs = [];
		for ( var i:int = 0; i < n; i++ ) {
			var o:BrushState = new BrushState();
			o.vx = o.vy = 0.0;
			o.xx = mouseX;
			o.yy = mouseY;
			o.ac = 0.2; //random( 0.7, 0.80 );
			o.de = 0.56;
			o.wd = random( 0.13, 0.46 );
			o.px0 = [o.xx, o.xx, o.xx];
			o.py0 = [o.yy, o.yy, o.yy];
			o.px1 = [o.xx, o.xx, o.xx];
			o.py1 = [o.yy, o.yy, o.yy];
			brushs[i] = o;
		}
		//ã‚°ãƒ©ãƒ‡ãƒ¼ã‚·ãƒ§ãƒ³ç”¨ã®å¤‰æ•°
		mtx = new FGradientMatrix();
		colors = [0, 0];
		alphas = [1.0,1.0];
		ratios = [0,255];
	}
	
	public function draw():void
	{
		/*if ( isMousePressed )
			background( 0 );*/
		//æç”»
		drawing( 320,240);// mouseX, mouseY );
	}
	
	private function drawing( x:Number, y:Number ):void
	{
		colors[0] = colors[1];
		colors[1] = color( random(0.95, 1), random(0.2, 1), random(0.3, 1) );
		
		for ( var i:int = 0; i < n; i++ ) {
			var brush:BrushState = brushs[i];
			
			with( brush ){
				var px:Number = xx;
				var py:Number = yy;
				//åŠ é€Ÿåº¦é‹å‹•
				xx += vx += ( x - xx ) * ac;
				yy += vy += ( y - yy ) * ac;
				
				//æ–°ã—ã„æç”»åº§æ¨™
				var x0:Number  = px + vy*wd;
				var y0:Number  = py - vx*wd;
				var x1:Number  = px - vy*wd;
				var y1:Number  = py + vx*wd;
				
				//ã‚°ãƒ©ãƒ‡ãƒ¼ã‚·ãƒ§ãƒ³å½¢çŠ¶æŒ‡å®š
				mtx.createLinear( px0[1], py0[1], px0[2], py0[2] );
				
				//æç”»
				noStroke();
				beginGradientFill( "linear", colors, alphas, ratios, mtx );
				beginShape();
				curveVertex( px0[0], py0[0] );
				curveVertex( px0[1], py0[1] );
				curveVertex( px0[2], py0[2] );
				curveVertex( x0, y0 );
				vertex( px1[2], py1[2] );
				curveVertex( x1, y1 );
				curveVertex( px1[2], py1[2] );
				curveVertex( px1[1], py1[1] );
				curveVertex( px1[0], py1[0] );
				endShape();
				endFill();
				//ãƒœãƒ¼ãƒ€ãƒ¼ã®æç”»
				stroke( 0, 0.1 );
				noFill();
				curve( px0[0], py0[0], px0[1], py0[1], px0[2], py0[2], x0, y0 );
				curve( px1[0], py1[0], px1[1], py1[1], px1[2], py1[2], x1, y1 );
				
				//æç”»åº§æ¨™
				px0.shift(); px0.push( x0 ); 
				py0.shift(); py0.push( y0 ); 
				px1.shift(); px1.push( x1 ); 
				py1.shift(); py1.push( y1 ); 
				
				//æ¸›è¡°å‡¦ç†
				vx *= de;
				vy *= de;
			}
		}
	}
}


class BrushState {
	//åŠ é€Ÿåº¦é‹å‹•ã®å¤‰æ•°
	public var xx:Number;
	public var yy:Number;
	public var vx:Number;
	public var vy:Number;
	public var ac:Number;
	public var de:Number;
	//ç·šå¹…ã®ä¿‚æ•°
	public var wd:Number;
	//æç”»åº§æ¨™
	public var px0:Array;
	public var py0:Array;
	public var px1:Array;
	public var py1:Array;
	public function BrushState(){}
}