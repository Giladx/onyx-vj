/**
 * Copyright gupon ( http://wonderfl.net/user/gupon )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/qt5N
 */

// forked from gupon's Flying Polygons
/*
* gets slow while mouse pressed.
*/
package {
	import __AS3__.vec.Vector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class PyramidParticles extends Patch {
		private const NUM:int = 64;
		private var worldMatrix:Matrix3D;
		private var viewMatrix:Matrix3D;
		private var vertices:Vector.<Number>;
		private var uvtData:Vector.<Number>;
		private var indices:Vector.<int>;
		private var viewport:Shape;
		private var projection:PerspectiveProjection;
		private var pyramids:Vector.<Pyramid>;
		private var texture:BitmapData;
		private var multipler:Number = 1;
		private var count:int = 0;
		private var bmp:Bitmap;
		private var bmpData:BitmapData;
		private var prog:Number = 0;
		private var prevProg:Number = 0;
		private var flag:Boolean;
		
		public function PyramidParticles(){
			
			prevProg = prog;
			
			viewport = new Shape();
			viewport.x = DISPLAY_WIDTH / 2;
			viewport.y = DISPLAY_HEIGHT / 2;
			addChild(viewport);
			
			projection = new PerspectiveProjection();
			projection.fieldOfView = 60;
			projection.focalLength = 300;
			
			createPyramids();
			
			worldMatrix = new Matrix3D();
			viewMatrix = new Matrix3D();
			viewMatrix.appendRotation( 60, Vector3D.X_AXIS );
			viewMatrix.appendTranslation( 0, 0, 400 );
			
			bmpData = new BitmapData( DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0x000000 );
			bmp = new Bitmap( bmpData );
			
			addEventListener( MouseEvent.MOUSE_DOWN, mouseHandler );
			addEventListener( MouseEvent.MOUSE_UP,   mouseHandler );
		}
		
		override public function render(info:RenderInfo):void {
			update();
			rdr();
			
			if( !flag ) prog++;
			var m:Matrix = new Matrix();
			m.translate( DISPLAY_WIDTH/2, DISPLAY_HEIGHT/2 );
			var cmf:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,.95,0]);
			bmpData.applyFilter( bmpData, bmpData.rect, new Point(), cmf );
			bmpData.draw( viewport, m, null, BlendMode.HARDLIGHT );
			
			if( prog - prevProg > 360 ) reset();
			info.render(bmp);
		}
		
		private function update():void{
			movePyramids();
			worldMatrix.appendRotation(  1*multipler, Vector3D.Y_AXIS );
			viewMatrix.appendTranslation( 0, -1*multipler, 0 );
			viewMatrix.appendRotation( -.15*multipler, Vector3D.X_AXIS );
			//worldMatrix.appendRotation( .5*multipler, Vector3D.Z_AXIS ;
		}
		
		private function rdr():void{
			var m:Matrix3D = new Matrix3D();
			m.append( worldMatrix );
			m.append( viewMatrix  );
			m.append( projection.toMatrix3D() );
			
			var projected:Vector.<Number> = new Vector.<Number>();
			Utils3D.projectVectors( m, vertices, projected, uvtData );
			
			viewport.graphics.clear();
			viewport.graphics.lineStyle( 1, HSVtoRGB(prog%360,1,1) );
			//viewport.graphics.beginBitmapFill( texture );
			viewport.graphics.drawTriangles( projected, getSortedIndices(), uvtData );
		}
		
		private function movePyramids():void{
			vertices = new Vector.<Number>();
			for each( var p:Pyramid in pyramids ){
				if (p.vertices) vertices = vertices.concat(p.vertices);
			}
		}
		
		private function createPyramids():void{
			indices = new Vector.<int>();
			uvtData = new Vector.<Number>();
			pyramids = new Vector.<Pyramid>();
			
			for(var i:int=0;i<NUM;i++){
				var p:Pyramid = new Pyramid();
				indices = indices.concat(p.indices);
				uvtData = uvtData.concat(p.uvtData);
				pyramids.push(p);
			}
		}
		
		private function getSortedIndices():Vector.<int>{
			var triangles:Array = [];
			for( var i:int=0;i<indices.length-3;i+=3 ){
				var i1:Number = indices[i  ];
				var i2:Number = indices[i+1];
				var i3:Number = indices[i+2];
				var z:Number = Math.min( uvtData[i1*3+2], uvtData[i2*3+2], uvtData[i3+3] );
				if( z > 0 && z < .01 ){
					triangles.push({ i1:i1, i2:i2, i3:i3, z:z });
				}
			}
			triangles.sortOn( "z", Array.NUMERIC );
			var sortedIndices:Vector.<int> = new Vector.<int>(0,false);
			for each( var t:Object in triangles ) sortedIndices.push( t.i1, t.i2, t.i3 );
			return sortedIndices; 
		}
		
		private function mouseHandler( event:MouseEvent ):void{
			for each( var p:Pyramid in pyramids ){
				if( event.type == MouseEvent.MOUSE_DOWN ){
					p.multipler = .05;
					multipler = .05;
					flag = true;
				} else {
					p.multipler = 1;
					multipler = 1;
					flag = false;
				}
			}
			
			if( event.type == MouseEvent.MOUSE_UP ){
				count++;
				if( count == 3 ) reset();
			}
		}
		
		private function reset():void{
			Pyramid.index = 0;
			viewport.graphics.clear();
			count = 0;
			init();
		}
		
		private function HSVtoRGB( h:Number, s:Number, v:Number ):uint{
			var r:Number, g:Number, b:Number;
			if( s != 0 ){
				h %= 360;
				var hi:uint = h / 60 % 6;
				var f:Number = h / 60 - hi;
				var p:Number = v * ( 1 - s );
				var q:Number = v * ( 1 - f * s );
				var t:Number = v * ( 1 - ( 1 - f ) * s );
				
				switch( hi ){
					case 0: r = v; g = t; b = p; break;
					case 1: r = q; g = v; b = p; break;
					case 2:	r = p; g = v; b = t; break;
					case 3: r = p; g = q; b = v; break;
					case 4: r = t; g = p; b = v; break;
					case 5: r = v; g = p; b = q; break;
				}
			} else r = g = b = v;
			return ( 0xFF * r << 16 ) + ( 0xFF * g << 8 ) + ( 0xFF * b );
		}
	}
}

import __AS3__.vec.Vector;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix3D;
import flash.geom.Utils3D;
import flash.geom.Vector3D;

class Pyramid extends Sprite{
	public static var index:int = 0;
	private static const SPD_RANGE:Number = 10;
	private var vectors:Vector.<Vector3D>;
	public var localMatrix:Matrix3D;
	public var rotateMatrix:Matrix3D;
	public var radius:Number = Math.random()*50 + 25;
	public var vertices:Vector.<Number>;
	public var indices:Vector.<int>;
	public var uvtData:Vector.<Number>;
	public var speedX:Number = (Math.random()*SPD_RANGE - SPD_RANGE/2);
	public var speedY:Number = (Math.random()*SPD_RANGE - SPD_RANGE/2)*0;
	public var speedZ:Number = (Math.random()*SPD_RANGE - SPD_RANGE/2);
	public var speedRX:Number = (Math.random()*SPD_RANGE - SPD_RANGE/2);
	public var speedRY:Number = (Math.random()*SPD_RANGE - SPD_RANGE/2);
	public var speedRZ:Number = (Math.random()*SPD_RANGE - SPD_RANGE/2);
	public var multipler:Number = 1;
	
	public function Pyramid(){
		localMatrix = new Matrix3D();
		rotateMatrix = new Matrix3D();
		createMesh();
		index += 6;
		
		addEventListener( Event.ENTER_FRAME, enterFrame );
	}
	
	private function enterFrame( event:Event ):void{
		applyTranslation();
	}
	
	private function createMesh():void{
		vectors = new Vector.<Vector3D>();
		indices = new Vector.<int>();
		uvtData = new Vector.<Number>();
		
		for(var i:int=0;i<6;i++){
			var vector:Vector3D = new Vector3D();
			switch(i){
				case 0:
					vector.x = 0;
					vector.y = radius / Math.SQRT2;
					vector.z = 0;
					break;
				case 1:
					vector.x = -radius/2;
					vector.y = 0;
					vector.z = -radius/2;
					break;
				
				case 2:
					vector.x = radius/2;
					vector.y = 0;
					vector.z = -radius/2;
					break;
				
				case 3:
					vector.x = radius/2;
					vector.y = 0;
					vector.z = radius/2;
					break;
				
				case 4:
					vector.x = -radius/2;
					vector.y = 0;
					vector.z = radius/2;
					break;
				
				case 5:
					vector.x = 0;
					vector.y = -radius / Math.SQRT2;
					vector.z = 0;
					break;
			}
			vectors.push( vector );
			uvtData.push( 1, 1, 1 );
		}
		indices.push( index + 0, index + 1, index + 2,
			index + 0, index + 2, index + 3,
			index + 0, index + 3, index + 4,
			index + 0, index + 4, index + 1,
			index + 5, index + 2, index + 1,
			index + 5, index + 1, index + 4,
			index + 5, index + 4, index + 3,
			index + 5, index + 3, index + 2);
	}
	
	public function applyTranslation():void{
		var m:Number = multipler;
		vertices = new Vector.<Number>();
		localMatrix.appendTranslation(speedX*m, speedY*m, speedZ*m);
		rotateMatrix.appendRotation( speedRX*m, Vector3D.X_AXIS );
		rotateMatrix.appendRotation( speedRY*m, Vector3D.Y_AXIS ); 
		rotateMatrix.appendRotation( speedRZ*m, Vector3D.Z_AXIS );
		for each( var vector:Vector3D in vectors ){
			vector = Utils3D.projectVector( rotateMatrix, vector );
			vector = Utils3D.projectVector( localMatrix, vector );
			vertices.push( vector.x, vector.y, vector.z );
		}
	}
}
