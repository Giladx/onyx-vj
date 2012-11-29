/**
 * Copyright shapevent ( http://wonderfl.net/user/shapevent )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/anoG
 */

// forked from shapevent's Sharp Sphere
package {
	
	/*
	Sharp Sphere from http://www.actionsnippet.com
	
	*/
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	public class SharpSphere extends Patch {
		
		
		private var polyNum:int;
		private var verts:Vector.<Number>;
		private var pVerts:Vector.<Number>;
		private var uvts:Vector.<Number>;
		private var indices:Vector.<int>; 
		private var sortedIndices:Vector.<int>;
		private var faces:Array;
		private var m:Matrix3D;
		private var poly:Vector.<Number>;
		private var transPoly:Vector.<Number>;
		private var i:int;
		private var inc:int;
		private var tex:BitmapData;
		private var grad:Shape;
		private var mat:Matrix;
		private var shape:Shape;
		private var persp:PerspectiveProjection;
		private var proj:Matrix3D;
		private var dx:Number;
		private var dy:Number;
		private var mx:Number = 320;
		private var my:Number = 240;
		
		
		public function SharpSphere(){
			
			// init
			x = DISPLAY_WIDTH / 2;
			y = DISPLAY_HEIGHT / 2;
			
			
			polyNum = 3000;
			// standard Vectors for using drawTriangles
			verts = new Vector.<Number>();
			pVerts;
			uvts = new Vector.<Number>();
			indices = new Vector.<int>();
			// needed for z-sorting
			sortedIndices;
			faces = [];
			
			// we'll use this for tranforming points
			// and as the transormation matrix for our render
			m = new Matrix3D();
			
			// plot a poly
			poly;
			poly = Vector.<Number>([ 0, 0, 0,
				10, 0, 0,
				0,10, 0]);
			
			// temp vect for any transformed polygons
			transPoly = new Vector.<Number>();
			
			i;
			inc = 0;
			for (i = 0; i<polyNum; i++){
				m.identity();
				var s:Number = (int(Math.random()*50) == 1) ? 4 + Math.random()*2 : 1 + Math.random() * 2;
				m.appendScale(s, s, 1);
				m.appendRotation(Math.random()*360, Vector3D.X_AXIS);
				m.appendRotation(Math.random()*360, Vector3D.Y_AXIS);
				m.appendRotation(Math.random()*360, Vector3D.Z_AXIS);
				m.appendTranslation(200,0,0);
				
				m.appendRotation(Math.random()*360, Vector3D.X_AXIS);
				m.appendRotation(Math.random()*360, Vector3D.Y_AXIS);
				m.appendRotation(Math.random()*360, Vector3D.Z_AXIS);
				
				m.transformVectors(poly, transPoly);
				
				verts = verts.concat(transPoly);
				faces.push(new Vector3D());
				indices.push(inc++, inc++, inc++);
				uvts.push(Math.random(), Math.random(), 0, Math.random(), Math.random(), 0, Math.random(), Math.random(), 0);
			}
			
			sortedIndices = new Vector.<int>(indices.length, true);
			
			// create texture
			tex = new BitmapData(400,400,false, 0x000000);
			grad = new Shape();
			mat = new Matrix();
			mat.createGradientBox(400,400,0,0,0);
			with (grad.graphics){
				beginGradientFill(GradientType.LINEAR, [0x000000, 0xAA0000, 0xFFFF00], [1, 1, 1], [20, 200, 255], mat);
				drawRect(0,0,400,400);
			}
			tex.draw(grad);
			
			// create background
			mat.createGradientBox(1600,1000,0,-550, -100);
			with (grad.graphics){
				beginGradientFill(GradientType.RADIAL, [0x333333, 0xffffff], [1, 1], [0, 255], mat);
				drawRect(0,0,500,500);
			}
			grad.x = -DISPLAY_WIDTH/2
			grad.y = -DISPLAY_HEIGHT/2;
			addChild(grad);
			
			// triangles will be drawn to this
			shape = Shape(addChild(new Shape()));
			
			// fix all vector lengths
			verts.fixed = true, uvts.fixed = true, indices.fixed = true
			pVerts = new Vector.<Number>(verts.length/3 * 2, true); 
			
			// we need these if we want perspective
			persp = new PerspectiveProjection();
			persp.fieldOfView = 45;
			// projection matrix
			proj = persp.toMatrix3D();
			
			dx = 0, dy = 0;
			addEventListener( MouseEvent.MOUSE_DOWN, onDown );
			addEventListener( MouseEvent.MOUSE_MOVE, onDown );

		}
		private function onDown(e:MouseEvent):void {
			mx = e.localX; 
			my = e.localY; 			
		}

		
		override public function render(info:RenderInfo):void {
			dx += (mx - dx) / 4;
			dy += (my - dy) / 4;
			m.identity();
			m.appendRotation(dy, Vector3D.X_AXIS);
			m.appendRotation(dx, Vector3D.Y_AXIS);
			// push everything back so its not to close
			m.appendTranslation(0,0,800);
			// append the projection matrix at the end
			m.append(proj);
			
			Utils3D.projectVectors(m, verts, pVerts, uvts);
			
			var face:Vector3D;
			inc = 0;
			for (var i:int = 0; i<indices.length; i+=3){
				face = faces[inc];
				face.x = indices[i];
				// it may look odd, but casting to an int 
				// when doing operations inside array sytnax
				// adds a big speed boost
				face.y = indices[int(i + 1)];
				face.z = indices[int(i + 2)];
				var i3:int = i * 3;
				// get the average z position (t value) and store it in the Vector3D w property
				// depending on your model, you may not need to do an average of all 3 values
				face.w = (uvts[int(i3 + 2)] + uvts[int(i3 + 5)] + uvts[int(i3 + 8)]) * 0.333333;
				inc++;
			}
			
			// sort on w, so far this beats all other sorting methods for speed,
			// faster than Vector.sort(), faster than any custom sort method I could find
			//faces.sortOn("w", Array.NUMERIC);
			
			// re-order indices so that faces are drawn in the correct order (back to front);
			inc = 0;
			for each (face in faces){
				sortedIndices[inc++] = face.x;
				sortedIndices[inc++] = face.y;
				sortedIndices[inc++] = face.z;
			}
			
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(tex, null, false, false);
			shape.graphics.drawTriangles(pVerts, sortedIndices, uvts, TriangleCulling.NONE);
			info.render(shape);
		}
		
		
	}
	
}