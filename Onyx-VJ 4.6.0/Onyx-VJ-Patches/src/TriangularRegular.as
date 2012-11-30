// forked from walmink's forked from: Triangular kaleidoscope with perlinNoise
// forked from piXelero's Triangular kaleidoscope with perlinNoise
package 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;	
	
	/**
	 * Triangular Kaleidoscope with perlinNoise
	 *
	 * using graphics.drawTriangles()-method 
	 * and uv -coordinates for texture mapping
	 * to create a triangular reflections
	 *      
	 * Petri Leskinen 15.1.2009 Espoo, Finland
	 * http://pixelero.wordpress.com
	 */
	
	public class TriangularRegular extends Patch
	{
		
		public var vertices:Vector.<Number> = new Vector.<Number>(),    //    x,y,z -coordinates
			indices:Vector.<int>  = new Vector.<int>(),    //    triangle mesh
			uvtData:Vector.<Number> = new Vector.<Number>(),
			points:Array;
		
		public var bmd:NeonPerlinStripes;
		public var size:Number = 180;
		
		protected var running:Boolean = false, phase:Number = 0.0;
		
		internal var i:int, j:int, tmp:Number;
		
		internal const HALFSQRT3:Number = 0.866025403784438;
		internal const D120:Number = 120.0 / 180.0 * Math.PI;
		private var sprite:Sprite;
		
		public function TriangularRegular ():void {
			
			
			var po:Object;
			var id:int = 0,xp:Number, yp:Number;
			
			var triangs:Array = [], paths:Array = [], tr:Array;
			var n:int = 3 + DISPLAY_WIDTH / size;
			var m:int = 2+DISPLAY_HEIGHT/size /HALFSQRT3;
			
			var uvIndex:int;
			sprite = new Sprite();
			vertices = new Vector.<Number>();    //    x,y,z -coordinates
			indices = new Vector.<int>();    //    triangle mesh
			uvtData = new Vector.<Number>();
			points = [];
			
			//    fill the stage (with triangles
			for (j = 0; j != m; j++) {
				paths[j] = [];
				
				yp = size*j *HALFSQRT3;
				uvIndex = ((j & 1) == 0) ? 0 : 2;
				
				for (i = 0; i != n; i++) {
					xp =  (i - 0.5 * (j & 1)) * size ;
					po = {     x: xp,
						y: yp,
						id: id++,
							uvIndex: uvIndex };
					
					paths[j].push(po);
					points.push(po);
					
					uvIndex= (uvIndex+2)%3; // repeats the serie 2 1 0 2 1 0 2 1 0
				}
				
				if (j != 0) {
					triangulatePaths(paths[j - 1], paths[j], false, triangs);
				}
			}
			
			for each( tr in triangs) indices.push(tr[0].id, tr[1].id, tr[2].id);
			
			bmd = new NeonPerlinStripes(size, size);
			
		}

		
		//    generates a triangle strip between two arrays of points
		private function triangulatePaths(path0:Array, path1:Array, closed:Boolean=false, triangles:Array =null):Array {
			if (triangles==null) triangles = [];
			var index0:int = 0,index1:int = 0, dist0:Number, dist1:Number;
			
			var po0:* = path0[index0];
			var po1:* = path1[index1];
			
			//    if 'closed' push the first point as last one as well 
			if (closed && path0.length > 1 && po0!=path0[path0.length-1] ) path0.push(po0);
			if (closed && path1.length > 1 && po1!=path1[path1.length-1] ) path1.push(po1);
			
			//    choose the new triangle by a shorter diagonal
			while (index0 < path0.length-1 && index1 < path1.length-1) {
				dist0 = (tmp = po0.x - path1[index1 + 1].x) * tmp + (tmp = po0.y - path1[index1 + 1].y) * tmp;
				dist1 = (tmp = po1.x - path0[index0 + 1].x) * tmp + (tmp = po1.y - path0[index0 + 1].y) * tmp;
				triangles.push( [po0, po1, (dist0 < dist1) ? po1 = path1[++index1] : po0 = path0[++index0] ]);
			}
			
			//    creates a fan of triangles if the other path's already ended
			while (index0 +1 < path0.length) triangles.push( [po0, po1, po0=path0[++index0]]);
			
			while (index1 +1 < path1.length) triangles.push( [po0, po1, po1=path1[++index1]]);
			
			return triangles;
		}
		override public function render(info:RenderInfo):void		
		{		
			bmd.update();
			
			phase += 0.03;
			
			var uvIndices:Array = [ { u: 0.5+0.5*Math.cos(phase-D120), v:0.5+0.5*Math.sin(phase-D120) },
				{ u: 0.5+0.5*Math.cos(phase), v:0.5+0.5*Math.sin(phase) },
				{ u: 0.5+0.5*Math.cos(phase+D120), v:0.5+0.5*Math.sin(phase+D120)  } ];
			
			uvtData = new Vector.<Number>();
			vertices = new Vector.<Number>();
			
			for each(var po:Object in points) {
				uvtData.push(uvIndices[po.uvIndex].u, uvIndices[po.uvIndex].v);
				vertices.push(po.x, po.y);
			}
			
			
			sprite.graphics.clear();
			sprite.graphics.lineStyle(1.0, 0x808080, 1.0); // uncomment to see the grid
			sprite.graphics.beginBitmapFill(
				bmd,
				null,     //    no matrix
				false    //    = repeat
			);
			
			sprite.graphics.drawTriangles(vertices,
				indices,
				uvtData,
				TriangleCulling.NONE);
			
			
			sprite.graphics.endFill();
			info.render(sprite);
		}
		
		
	}
}

//    NeonPerlinStripes:
//    subclass for a modified perlinNoise
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.display.BlendMode;
import flash.geom.Vector3D;
import flash.events.Event;

class NeonPerlinStripes extends BitmapData {
	
	public var offsets1:Array = [new Point(),new Point(),new Point()];
	private var phaseAngle:Number = 0.0;
	
	private static var edge128:ColorTransform = new ColorTransform(-1,-1,-1,1,255,255,255);
	private static var d120:Number = 120/180*Math.PI;
	
	public function NeonPerlinStripes(w:int, h:int) {
		
		super(w,h,true,0x00);
		
		update();
		
	}
	
	public function update(e:Event=null):void { 
		phaseAngle += 0.03;
		var cs:Number = Math.cos(phaseAngle);
		
		offsets1[0].x += 0.03;
		offsets1[0].y += 0.03;
		offsets1[1].y -= cs*0.4;
		offsets1[2].x -= 0.7;
		
		var scale:Number = 1.0;
		perlinNoise(scale*this.width,scale*this.height,3,13,true,true,1+2+4,false,offsets1);
		
		this.draw(this, 
			null, 
			edge128,
			BlendMode.DARKEN );
		
		var fA:Number = 5.0; // 16.0-0.0*cs;
		var fB:Number = 255.0-128.0*fA; // fA*255+fB = 255
		
		this.draw(this,
			null,
			new ColorTransform(fA,fA,fA,1.0,fB,fB,fB), 
			BlendMode.NORMAL );
		
		
		this.draw(this,
			null,
			new ColorTransform(1.0+cs,
				1.0+Math.cos(phaseAngle+d120),
				1.0+Math.cos(phaseAngle-d120)
			), 
			BlendMode.MULTIPLY );
		
		
	}
}


